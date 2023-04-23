;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"
;; last updated: 2012-07-17 23:56:21

read_and_set_keyboard_layout( p_filename
                            , ByRef r_mod_key
                            , ByRef r_true_mod_key
                            , ByRef r_max_num_of_each_key
                            , ByRef r_results_of_KCmb ) {

; save_to(print_key_windowname_output(get_key_windowname_output(conv_from_table_to_lines(read_keyboard_layout( p_filename ))))
; , "z:\test.l")

    return set_keyboard_layout( conv_from_table_to_lines( read_keyboard_layout( p_filename )
															, "Get_scancode_from_table_main"
															, p_filename )
                              , r_mod_key
                              , r_true_mod_key
                              , r_max_num_of_each_key
                              , r_results_of_KCmb )
}


save_to(str, to){
    if not (A_IsCompiled) {
        file := FileOpen(to, 0x01)
        file.Write(str)
        file.Close()
        return to
    }

    return False
}

; key
; window-name
; output
get_key_windowname_output(str){
    arr := Array()
    Loop, Parse, str, `n, `r
    {
        RegExMatch(A_LoopField, "S)^(.+)\t(.+)\t(.+)$", match_)
        window_name := match_1
        key := match_2
        output := match_3
        
        ; (key (window-name1 output1)
        ;      (window-name2 output2))
        arr.append(Array(key, Array(window_name, output)))
    }
    
    return arr
}

print_key_windowname_output(arr){
    tmp := ""
    for i, v in arr {
        tmp .= "(""" . v[1] . """ (""" . v[2, 1] . """ """ . v[2, 2]"""))`n"
    }

    return "'(" . tmp . ")"
}


read_keyboard_layout(p_filename) {
    ;; 設定ファイルを読み込む
    FileRead, str, % p_filename

    if (ErrorLevel = 1) {
        msgbox_option( 0, "設定ファイルの検索"
                        , "以下のファイルを読み込めません"
                        , ""
                        , p_filename)

        return "error"
    }

    if not ( RegExMatch(str, "S)`r`n"))
    {
        msgbox_option( 0, "設定ファイルに誤りがあります"
                        , "改行コードに誤りがあります"
                        , ""
                        , "設定ファイル名: " 
                        , get_filename_without_extension( p_filename )
                        , ""
                        , "改行コードを CR や LF に設定しているならば"
                        , "CRLF に変更して下さい")


        return remove_comment_out(str)
    }


    ;; コメントアウトを除去する
    return remove_comment_out(str)
}


conv_from_table_to_lines( str, func_name, p_filename="" )
{
    ;; いずれ、lexical analyser と parser の処理として書き換えたい

    if ( str = "error" ) {
        return str
    }
    

    ;; 組み合わせるキーの別名を設定する
    substitution_input := Array()
    substitution_input.append(Array("apps", "appskey"))
    substitution_input.append(Array("29", "zenkaku"))
    substitution_input.append(Array("-", "_"))
    substitution_input.append(Array("（", "("))
    substitution_input.append(Array("）", ")"))

    substitution_output := Array()


    ;; 各キーの設定を保存する配列
    a_setting := Array()


    ;; ファイルの一番目のオプションを読み込む
    first_option := read_str_first_option(str)
    ;; unicode 文字で出力するか否かの設定を読み取る
    unicode_mode := set_unicode_mode( first_option )

    ;; 「順に」打鍵しない限り、
    ;; 同時打鍵用の丸括弧をキーストロークの設定の前後に強制的に付加する
    add_open_paren := ( RegExMatch( first_option, "S)(逐次|順)") ) ? 0
                   : 1


    ;; 以下、[] で囲まれた表を一行形式の設定へと変換する
    ;; ただし、-raw[] という設定については、[] で囲まれた部分をそのままにしておく
    StartingPos := 1
    while ( StartingPos ) {
        RegExMatch(str, "misS)^([^`n]*?)(\[+)(\d*)$`r`n(.+?)`r`n[\s\t]*\]$", $, StartingPos )

        ;; 改行を取り除き
        ;; 前後の空白を削除する
        option_status := Trim( RegExReplace( $1, "S)(`r`n|`n)", "" ) )

        ;; 設定表を、初めのキーストロークのものとするか
        ;; 通常は、c->a の a の側を設定表内で設定するが、
        ;; この設定を有効にすると c の側を設定表内で設定する
        first_mode := ($2 = "[[") ? True
                    : False

        window_title := Trim( $3 )

        keys := Trim( $4 )


        if ( option_status = "-raw" ) { ; 設定をそのまま登録する
            Loop, Parse, keys,`r, `n
                a_setting.append( Trim( A_LoopField ) )
        } else if ( ( option_status = "-option" ) ; オプションを設定するとき
            or ( option_status = "-option-input" ) ) {

            ;; 一行ずつ処理する
            Loop, Parse, keys, `r, `n
            {
                ;; 何かしらの設定が記述されているとき
                if ( Trim(A_LoopField) ) {
                    ;; | の前後の文字列を取得する
                    RegExMatch( Trim(A_LoopField), "S)(.+?)\s*\|\s*(.+?)$", input_)

                    ;; 設定を追加する
                    substitution_input.append(Array(input_1, input_2))
                }
            }
        } else if ( option_status = "-option-output" ) { ; 出力する文字列を置換する
            Loop, Parse, keys,`r, `n
            {
                if ( Trim( A_LoopField ) ) {
                    RegExMatch(A_LoopField, "misS)^(.+?)\s*\|\s*(.+?)$", $ )
                    search_text := Trim( $1 )
                    replace_text := Trim( $2 )

                    ;; 置換対象の文字列と置換後の文字列を登録する
                    substitution_output.append(Array(search_text, replace_text))
                }
            }
        } else {
            ;; comma の数を初期化する
            comma_num := 0
            option_status_arr := Array()

            ;; window title をかならず指定する
            if ( window_title = "" ) {
                window_title := "all"
            }

            ;; エラー処理のために
            ;; 元のオプションを保存しておく
            raw_option_status := option_status

            ;; オプションを展開する
            if ( option_status != "" ) {
                ;; <-1E-2F 5> のように
                ;; < > 内の前半に繰り返すキーストロークが、後半に繰り返す回数が記述されているときには
                ;; その設定をすべて展開する
                option_status := iterate_str(option_status)

                ;; オプションの文字列を置き換える
                for i, v in substitution_input.reverse() {
                    option_status := string_replace(option_status, v[1], v[2],  ,  True)
                }



                ;; オプションを option_status_arr にそれぞれ格納する
                Loop, Parse, option_status, `,
                {
                    comma_num := A_Index

                    pre_input_key := Trim( A_LoopField )
                    if ( pre_input_key ) {

                        ;; "+" が入力キーの設定に含まれるとき
                        if ( get_string_pos( pre_input_key, "+" ) > -1 ) {
                            pre_input_key := string_replace( pre_input_key, "+", "_TRUE")
                        }


                        option_error := False

                        Loop, Parse, pre_input_key
                        {
                            ;; -option-input に不正な文字があるときは
                            ;; 当該 -option-input の設定を無視する
                            if (Asc(A_LoopField) > 255) {
                                option_error := True
                            }
                        } until (option_error)

                        if ( option_error = False ) {
                            option_status_arr.append( pre_input_key )
                        }
                    }
                } until (option_error)

                ;; -option-input が正しく展開されないときには
                ;; 次の読み込み処理に移る
                if (option_error) {
                    msgbox_option( 0, "設定ファイルに誤りがあります"
                                    , "以下の設定が誤っているため、該当箇所を読み込みません"
                                    , ""
                                    , "ファイル名:"
                                    , p_filename
                                    , ""
                                    , "設定:`t`t" raw_option_status
                                    , "展開後の設定:`t" pre_input_key)

                    Break
                }

                ;; comma の数が設定数と同一のとき、
                ;; つまり -1E, -10, となっているときは
                ;; 何も指定していない設定を追加する
                if ( comma_num > option_status_arr.len()) {
                    option_status_arr.append( "" )
                }
            }

            ;; 以上で、option の設定をすべて展開した

            ;; 以下、キーの設定表内部を展開する

            ;; 出力する文字列を置き換える
            for i, v in substitution_output.reverse() {
                keys := string_replace(keys, v[1], v[2],  , True)
            }

            ;; unicode_mode が有効ならば、unicode 出力用の変換処理を行う
            ;; それ以外ならば、通常の変換処理を行う
            keys := conv_str_for_sending( keys, unicode_mode )
            
            ;; Emacs の orgtbl-mode で作成した表形式でも
            ;; キーボード配列の設定として認めるようにする
            keys := conv_from_orgtbl_style_to_dvorakj_style(keys)


            Loop, Parse, keys,`r, `n
            {
                line := A_Index
                
                Loop, Parse, A_LoopField,|
                {
                    ;; @@@ を | に置き換え、
                    ;; 設定項目の前後の空白を除去する
                    item := Trim( RegExReplace( A_LoopField, "S)@{3}", "|", "", -1) )

                    ;; 設定項目に何も記載されていなければ処理しない
                    if (item = "" ) {
                        continue
                    }
                    
                    
                    ;; 表の各項目に対応するスキャンコードを取得する
                    sc_hex := %func_name%(line, A_Index )

                    ;; 表の各段につき、既定の項目数を超えたときには
                    ;; 一つ下の段を処理する
                    if (sc_hex = 0) {
                        Break
                    }
                    

                    ;; option_status に何かしら記述されているとき
                    if ( option_status_arr.len() ) {
                        for index, value in option_status_arr {
                            ;; line = 5 : 5行目の設定のとき
                            ;; first_mode: 各設定の冒頭に [[ と記載されているとき
                            new_setting := (line = 5) ? to_HotKey_name(value)
                                        :  (first_mode) ? "_sc" . sc_hex .  to_HotKey_name(value)
                                        :               to_HotKey_name(value) . "_sc" . sc_hex
                            


                            ;; 同時に打鍵する配列のときには
                            ;; それぞれの option を () で一括りにする
                            ;; ただし、組み合わせるキーに何も指定していないときをのぞく
                            if (value = "") {
                                ;; -1E, のように、comma が設定数と同数以上ならば、丸括弧を追加しない
                                new_setting := new_setting
                            }
                            else if ( add_open_paren ) {
                                new_setting := "(" . new_setting . ")"
                            } else if ( get_string_pos( new_setting, "(", "R") > get_string_pos( new_setting, ")", "R") ) {
                              ;; 最後の閉じ括弧よりも最後の開き括弧が後に続いているとき
                              ;; 閉じ括弧を末尾に追加する
                                new_setting .= ")"
                            }


                                ;; キーの設定が一つのときには
                                ;; 両側の括弧を取り除く
                            if ((line = 5) and (1 = Get_number_of_keys(new_setting))) {
                                new_setting := Trim(new_setting, "()")
                            }

                            ;; ウィンドウ名、キーストローク、出力する文字列を格納する
                            a_setting.append(window_title "`t" sort_all_simul_KCmb( new_setting ) . "`t" . item)
                        }
                    } else {
                        if (line = 5) {
                            Break
                        }
                        
                        
                        new_setting := "_sc" . sc_hex
                        ;; ウィンドウ名、キーストローク、出力する文字列を格納する
                        a_setting.append(window_title "`t" new_setting . "`t" . item)
                    }
                }
            }
        }

        ;; StartingPos から検索して、 ] のみの段落があるときには
        ;; FoundPos にその位置情報を格納する
        FoundPos := RegExMatch(str, "misS)^[\s\t]*\]$", "", StartingPos)

        ;; StartingPos から検索して、 ] のみの段落が存在しないときには
        ;; StartingPos を 0 にする
        ;; これによって、次回の検索を中止する
        StartingPos := ( FoundPos ) ? FoundPos + 1
                    : 0
    }

    return a_setting.join("`r`n")
}




conv_from_orgtbl_style_to_dvorakj_style(keys){
    ;; orgtbl-mode の表形式かどうかを判定する
    ;; 判定するポイントは
    ;;  1. `|-' で始まり
    ;;  2. `-|' で終わり
    ;;  3. その間の文字が `-' と `+' のみで構成されているかどうか
    
    regexp_pattern := "mS)^\|-[\-\+]+?-\|$(?:`r`n)?"
    
    if (regexmatch(Trim(keys), regexp_pattern)){
        ;; |------+----+------| といった行を取り除く
        keys := RegExReplace(Trim(keys), regexp_pattern,"")
        ;; それ以外の行については冒頭の | を取り除く
        keys := RegExReplace(Trim(keys), "m)^\|","")
        ;; 表示
        return keys
    }



    return keys
}


set_keyboard_layout( p_str
                   , ByRef r_mod_key
                   , ByRef r_true_mod_key
                   , ByRef r_max_num_of_each_key
                   , ByRef r_results_of_KCmb ) {
    if ( p_str = "error") {
        return p_str
    }
    
    Loop, parse, p_str, `r, `n
    {
        if ( RegExMatch(A_LoopField, "S)(.+?)\t(.+?)\t(.+)", tmp_) ) {
            window_title := Trim(tmp_1)
            input_key := Trim(tmp_2)
            output_key := Trim(tmp_3)

            if ( r_results_of_KCmb.HasKey( window_title ) ) {
                
            } else {
                r_results_of_KCmb[window_title] := Object()
                r_max_num_of_each_key[window_title] := Object()
            }

            ;;; 文字列としてのキーの情報を、配列のそれへと変換する
            arr_keys := conv_string_to_array_for_setting_of_keyboard( input_key )

            ;;; 真に同時打鍵用のキーをすべて記憶する
            r_true_mod_key[window_title] := set_true_mark_of_each_key( r_true_mod_key[window_title]
                                                                        , arr_keys )


            ;; キーの情報に含まれている TRUE という文字列を取り除く : (_sc023_TRUEsc012) => (_sc023_sc012)
            ;; その後、生成した文字列をソートし直す : (_sc023_sc012) => (_sc012_sc023)
            input_key := sort_all_simul_KCmb( string_replace(input_key, "TRUE", "") )
            ;;; 再び、文字列としてのキーの情報を、配列のそれへと変換する
            arr_keys := conv_string_to_array_for_setting_of_keyboard( input_key )


            ;;; キーの情報を格納する
            r_results_of_KCmb[window_title].insert( input_key
                                                    , set_object_of_KCmb( arr_keys, output_key ) )


            ;;; 各キー毎の同時打鍵の最大数を記憶する
            r_max_num_of_each_key[window_title] := set_max_num_of_each_key(r_max_num_of_each_key[window_title]
                                                                    , arr_keys )


            ;;; 同時打鍵用のキーをすべて記憶する
            r_mod_key[window_title] := set_mark_of_each_key( r_mod_key[window_title]
                                                            , arr_keys )
        }
    }

    return True
}


read_str_first_option( str ) {
    Loop, Parse, str, `n, `r
    {
         line_text := trim(A_LoopField)
    } until (line_text != "")

    return line_text
}


to_HotKey_name( p_str )
; _XX を _sc0XX へと自動的に書き換える
; _XXX を _scXXX へと自動的に書き換える
{
    arr := Array()

    Loop, Parse, p_str, _
    {
        if (A_LoopField) {
            IfInString, A_LoopField, True
            {
                true_option := "TRUE"
                StringReplace, keyname, A_LoopField, TRUE, , All
            }
            else
            {
                true_option := ""
                keyname := Trim(A_LoopField)
            }

            % ( keyname = "esc" )            ? arr.append("_" . true_option . keyname)
            : ( keyname = "tab" )            ? arr.append("_" . true_option . keyname)
            : ( StrLen(keyname) = 2 )        ? arr.append("_" . true_option . "sc0" . keyname)
            : ( StrLen(keyname) = 3 )        ? arr.append("_" . true_option . "sc" . keyname)
            : ( RegExMatch(keyname, "^\(") ) ? arr.append(keyname)
            : ( RegExMatch(keyname, "^\)") ) ? arr.append(keyname)
            : arr.append("_" . true_option . keyname)
        }
    }

    return % arr.join("")
}


Get_number_of_keys( keys )
{
    StringReplace, keys, keys, (, , All
    StringReplace, keys, keys, ), , All

    i := 0
    ;; keys を "_" 毎に分割する
    Loop, Parse, keys, _
    {
        if ( A_LoopField ) {
            i += 1
        }
    }

    return i
}

;; 同時に打鍵する配列
Set_number_and_keyname( KCmb
                        , i
                        , keyname )
{
    Loop, % i
    {
        if ( KCmb[A_Index, "_" . keyname] = "" ) {
            KCmb[A_Index, "_" . keyname] := True
        }
    }
    
    return KCmb
}

set_unicode_mode( status ) {
    return % ( RegExMatch(status, "(そのまま|直接)") ) ? True
           :                                             False
}

Get_scancode_from_table_main(row, column)
{
    global is_US_keyboard

    if ( row = 1 )
    {
        if ( column = 14 )
            return 0
        else
        {
            sc_hex := ( column = 1 )   ? "002"
                   :  ( column = 2 )   ? "003"
                   :  ( column = 3 )   ? "004"
                   :  ( column = 4 )   ? "005"
                   :  ( column = 5 )   ? "006"
                   :  ( column = 6 )   ? "007"
                   :  ( column = 7 )   ? "008"
                   :  ( column = 8 )   ? "009"
                   :  ( column = 9 )   ? "00A"
                   :  ( column = 10 )  ? "00B"
                   :  ( column = 11 )  ? "00C"
                   :  ( column = 12 )  ? "00D"
                   :  ( is_US_keyboard ) ? "02B"
                   :                     "07D"
        }
    }
    else
    if ( row = 2 )
    {
        if ( column = 13 )
            return 0
        else
        {
            sc_hex := ( column = 1 )  ? "010"
                   :  ( column = 2 )  ? "011"
                   :  ( column = 3 )  ? "012"
                   :  ( column = 4 )  ? "013"
                   :  ( column = 5 )  ? "014"
                   :  ( column = 6 )  ? "015"
                   :  ( column = 7 )  ? "016"
                   :  ( column = 8 )  ? "017"
                   :  ( column = 9 )  ? "018"
                   :  ( column = 10 ) ? "019"
                   :  ( column = 11 ) ? "01A"
                   :                    "01B"
        }
    }
    else
    if ( row = 3 )
    {
        if ( column = 13 )
            return 0
        else
        {
            sc_hex := ( column = 1 )   ? "01E"
                   :  ( column = 2 )   ? "01F"
                   :  ( column = 3 )   ? "020"
                   :  ( column = 4 )   ? "021"
                   :  ( column = 5 )   ? "022"
                   :  ( column = 6 )   ? "023"
                   :  ( column = 7 )   ? "024"
                   :  ( column = 8 )   ? "025"
                   :  ( column = 9 )   ? "026"
                   :  ( column = 10 )  ? "027"
                   :  ( column = 11 )  ? "028"
                   :  ( is_US_keyboard ) ? "029"
                   :                     "02B"
        }
    }
    else
    if ( row = 4 )
    {
        if ( column = 13 )
            return 0
        else
        {
            sc_hex := ( column = 1 )  ? "02C"
                   :  ( column = 2 )  ? "02D"
                   :  ( column = 3 )  ? "02E"
                   :  ( column = 4 )  ? "02F"
                   :  ( column = 5 )  ? "030"
                   :  ( column = 6 )  ? "031"
                   :  ( column = 7 )  ? "032"
                   :  ( column = 8 )  ? "033"
                   :  ( column = 9 )  ? "034"
                   :  ( column = 10 ) ? "035"
                   :                    "073"
        }
    }

    return sc_hex
}



;;; キーストロークと出力情報をひもづける
;;; [all_keystrokes
;;;                     [1st 
;;;                         [0  1st-output]
;;;                         [2nd    
;;;                                 [0  2nd-output]]]]

set_object_of_KCmb( p_arr, output ) {
    obj_tmp := Object("0", output)

    for index, value in p_arr.reverse() {
        obj_tmp := Object(value, obj_tmp)
    }

    return obj_tmp
}

;;; キーストロークから出力情報を割り出す
get_value_of_KCmb( p_obj, p_arr ) {
    obj_tmp := p_obj.clone()

    for index, value in p_arr {
        obj_tmp := obj_tmp[value]
    }

    return obj_tmp["0"]
}

;;; キーストロークから出力情報を割り出す（文字列版）
;;; 文字列を配列に変換し、キーストロークから出力情報を割り出す
;;; 値を返せば、それが出力情報
;;; 何も返さなければ、設定無し
get_value_of_KCmb_by_str( p_obj, p_str ) {
    if ( IsObject( p_obj[p_str] ) ) {
        return get_value_of_KCmb( p_obj[p_str]
                                , conv_string_to_array_for_setting_of_keyboard( p_str ) )
    }
    
    return
}



;;; さらに入力を受け付けるか
;;; True なら受け付ける
;;; False なら終了する
get_state_KCmb_with_str( p_obj, p_str ) {
    ;; 文字列を配列に変換する
    arr := conv_string_to_array_for_setting_of_keyboard( p_str )

    for key, value in p_obj {
        ;; キーの先頭に p_str の文字列が存在するとき
        if ( get_string_pos( key, p_str) = 0 ) {
            p_obj := value

            for in_index, in_value in arr {
                p_obj := p_obj[in_value]
            }

            ;; 格納している設定数を計算する
            for i, v in p_obj {
                sum := i
            } until ( ( sum > 1 ) )


            ;; 設定数が 2 以上のとき
            if ( sum > 1 ) {
                return True
            }
            
            ;; 設定数が 1 のとき
            if ( sum = 1 ) {
                if ( p_obj.HasKey("0") ) { ; 該当する設定が最終的な出力情報のとき
                    return False
                }
                
                return True
            }
        }
    }

    return False
}



set_max_num_of_each_key(p_max_num_of_each_key, p_arr)
;;; 各キーの最大同時打鍵数を設定する
{
    for index, value in p_arr {
        ;; はじめが ( のとき
        if ( get_string_pos( value, "(" ) = 0 ) {
            StringReplace, value, value, (
            StringReplace, value, value, )

            ;; 同時打鍵のキー
            arr_keys := conv_string_to_array_for_setting_of_keyboard( value )
            ;; キーの数
            num := arr_keys.len()

            for i,v in arr_keys {
                ;;; 何も値が格納されていないとき
                if ( p_max_num_of_each_key[v] = "" ) {
                    p_max_num_of_each_key[v] := num
                } else if ( num > p_max_num_of_each_key[v] ) { ; 数値を更新するとき
                    p_max_num_of_each_key[v] := num
                }
            }
        }
/*
        else
        if ( RegExMatch(value, "_.{3}.+01$")) ; _muhenkan01 や _space01
        {
            ;; 同時打鍵のキー
            arr_keys := conv_string_to_array_for_setting_of_keyboard( p_arr.join("") )
            ;; キーの数
            num := arr_keys.len()

            for i,v in arr_keys {
                ;;; 何も値が格納されていないとき
                if ( p_max_num_of_each_key[v] = "" ) {
                    p_max_num_of_each_key[v] := num
                } else if ( num > p_max_num_of_each_key[v] ) { ; 数値を更新するとき
                    p_max_num_of_each_key[v] := num
                }
            }
        }
*/
    }

    return p_max_num_of_each_key
}



;;; キーの情報をまとめた文字列を配列に変換する
;;;
;;; たとえば、"(_23_31)_32(_shift_35)_29" を
;;; [1] (_23_31)
;;; [2] _32
;;; [3] (_shift_35)
;;; [4] _29
;;; に変換する
conv_string_to_array_for_setting_of_keyboard( p_str ) {
    arr := Array()

    Loop, {
        ;; はじめが ( のとき
        if ( get_string_pos( p_str, "(" ) = 0 ) {
            pos_start_paren := get_string_pos( p_str, "(")
            pos_end_paren := get_string_pos( p_str, ")")

            pos_the_key := pos_end_paren - pos_start_paren + 1
        } else {
            pos_start_underscore := get_string_pos( p_str, "_", "L1" )
            pos_end_underscore := get_string_pos( p_str, "_", "L2" )

            pos_start_paren := get_string_pos( p_str, "(")


            ;; (_ と並んでいるとき
            if (( pos_start_paren > -1 )
                and ( pos_start_paren < pos_end_underscore)) {

                pos_the_key := pos_start_paren - pos_start_underscore
            ;; _ が丸括弧よりも前にくるとき
            } else {
                pos_the_key := pos_end_underscore - pos_start_underscore
            }
        }

        if ( pos_the_key = -1 ) {
            the_key := p_str
        } else if ( pos_the_key = 0 ) {
            break
        } else {
            the_key := get_string( p_str , pos_the_key)
            p_str :=   get_string( p_str, pos_the_key
                                  , True )
        }


        arr.append( the_key )

    } until ( ( pos_the_key = -1 )
             or ( pos_the_key = 0 ) ) ; 最後のキーまで辿り終えたとき

    return arr
}


;;: 使用するキーを個別に格納する
set_mark_of_each_key( p_obj, p_arr_keys ) {
    if ( IsObject(p_obj) = False ) {
        p_obj := Object()
    }

    for index, value in p_arr_keys {
        ;; はじめが ( のとき
        if ( get_string_pos( value, "(" ) = 0 ) {
            StringReplace, value, value, (
            StringReplace, value, value, )

            arr_keys := conv_string_to_array_for_setting_of_keyboard( value )

            for i,v in arr_keys {
                if ( p_obj[v] = "" ) {
                    p_obj[v] := True
                }
            }
        } else {
            if ( p_obj[value] = "" ) {
                p_obj[value] := True
            }
        }
    }

    return p_obj
}



set_true_mark_of_each_key( p_obj, p_arr_keys ) {
    if ( IsObject(p_obj) = False ) {
        p_obj := Object()
    }

    for index, value in p_arr_keys {
        ;; はじめが ( のとき
        if ( get_string_pos( value, "(" ) = 0 ) {
            StringReplace, value, value, (
            StringReplace, value, value, )

            arr_keys := conv_string_to_array_for_setting_of_keyboard( value )

            for i,v in arr_keys {
                if ( get_string_pos( v, "TRUE" ) > -1 ) {
                    StringReplace, v, v, TRUE
                    p_obj[v] := True
                }
            }
        } else {
            if ( get_string_pos( value, "TRUE" ) > -1 ) {
                StringReplace, value, value, TRUE
                p_obj[value] := True
            }
        }
    }

    return p_obj
}



;;; () 内の入力キーの情報を並び替える
sort_simul_KCmb( p_str ) {
    ;; はじめが ( のとき
    if ( get_string_pos( p_str, "(" ) = 0 ) {
        StringReplace, p_str, p_str, (
        StringReplace, p_str, p_str, )

        original := p_str 

        p_str := "(" conv_string_to_array_for_setting_of_keyboard( p_str ).sort().join("") ")"
    }

    return p_str
}


sort_all_simul_KCmb( p_str )
;;; 入力するキーから構成される文字列を並び替える
;;; 文字列を配列に変換してから並び替える
{
    arr_keys := conv_string_to_array_for_setting_of_keyboard( p_str )
    for index, value in arr_keys {
        arr_keys[index] := sort_simul_KCmb( value )
    }

    return arr_keys.join("")
}
