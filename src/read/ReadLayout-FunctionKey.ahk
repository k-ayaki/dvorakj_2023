read_layout_of_function_key( path_layout_file ) {
	global

	function_key_results_of_KCmb := Object()
    return set_keyboard_layout3( conv_from_table_to_lines3( read_keyboard_layout( get_file_full_path( path_layout_file ) ), path_layout_file )
                              , function_key_results_of_KCmb )
}


conv_from_table_to_lines3( str, p_filename="" ) {
    if ( str = "error" ) {
        return str
    } else {
        ;; 組み合わせるキーの別名を設定する
		substitution_input := Array()
		substitution_input.append(Array("29", "zenkaku"))
		substitution_input.append(Array("-", "_"))
		substitution_input.append(Array("（", "("))
		substitution_input.append(Array("）", ")"))

        substitution_output := Array()

        ;; キーの設定すべて
        tmp_all_str := ""

        ;; ファイルの一行目を読み込む
        first_option := read_str_first_option(str)
        ;; unicode 文字で出力するか否かの設定を読み取る
        unicode_mode := set_unicode_mode( first_option )

        ;; 「順に」打鍵しない限り、
        ;; 同時打鍵用の丸括弧をキーストロークの設定の前後に強制的に付加する
        add_open_paren := ( RegExMatch( first_option, "(逐次|順)") ) ? 0
                       : 1

        ;; 以下、[] で囲まれた表を一行形式の設定へと変換する
        ;; ただし、-raw[] という設定については、[] で囲まれた部分をそのままにしておく
        StartingPos := 1
        while ( StartingPos ) {
            RegExMatch(str, "mis)^([^`n]*?)\[(\d*)$`r`n(.+?)`r`n[\s\t]*\]$", $, StartingPos )

            ;; 改行を取り除き
            ;; 前後の空白を削除する
            option_status := Trim( RegExReplace( $1, "(`r`n|`n)", "" ) )
            skip_keys := $2
            keys := $3


            if ( option_status ) {
                ;; オプションの文字列を置き換える
                for i, v in substitution_input.reverse() {
                    option_status := string_replace(option_status, v[1], v[2], , True)
                }
            }


            ;; オプションを設定するとき
            if ( ( option_status = "_option" )
                or ( option_status = "_option_input" ) ) {

                ;; 一行ずつ処理する
                Loop, Parse, keys, `r, `n
                {
                    ;; 何かしらの設定が記述されているとき
                    if ( Trim(A_LoopField) ) {
                        ;; | の前後の文字列を取得する
                        RegExMatch( Trim(A_LoopField), "(.+?)\s*\|\s*(.+?)$", input_)

                        ;; 設定を追加する
						substitution_input.append(Array(input_1, input_2))
                    }
                }
            } else if ( option_status = "_option_output" ) { ; 出力する文字列を置換する
                Loop, Parse, keys,`r, `n
                {
                    if ( Trim( A_LoopField ) ) {
                        RegExMatch(A_LoopField, "mis)^(.+?)\s*\|\s*(.+?)$", $ )
                        search_text := Trim( $1 )
                        replace_text := Trim( $2 )

						;; 置換対象の文字列と置換後の文字列を登録する
						substitution_output.append(Array(search_text, replace_text))
                    }
                }
            } else if ( option_status = "_raw" ) { ; 設定をそのまま登録する
                Loop, Parse, keys,`r, `n
                    tmp_all_str .= Trim( A_LoopField ) . "`r`n"
            } else {
                option_status_arr := Array()

                if ( option_status != "" ) {
                    ;; <-1E-2F 5> のように
                    ;; < > 内の前半に繰り返すキーストロークが、後半に繰り返す回数が記述されているときには
                    ;; その設定をすべて展開する
                    option_status := iterate_str(option_status)

                    ;; キーボード配列のキーの設定を左からいくつ飛ばすか
                    key_pos_starting := ( skip_keys ) ? skip_keys - 1
                                     :  0

                    ;; オプションの設定にカンマがあるときは
                    ;; カンマで区切ったオプションを個別に option_status_arr に格納する
                    ;; カンマが一つもないときも同様
                    Loop, Parse, option_status, `,
                    {
                        if ( Trim( A_LoopField ) ) {
							pre_input_key := Trim( A_LoopField )
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
                }

                ;; 以上で、option の設定をすべて展開した

                ;; 以下、キーの設定表内部を設定する

                ;; 出力する文字列を置き換える
                for i, v in substitution_output.reverse() {
                    keys := string_replace(keys, v[1], v[2], , Tr<)
                }

                ;; unicode_mode が有効ならば、unicode 出力用の変換処理を行う
                ;; それ以外ならば、通常の変換処理を行う
                keys := conv_str_for_sending( keys, unicode_mode )

                
                ;; Emacs の orgtbl-mode で作成した表形式でも
                ;; キーボード配列の設定として認めるようにする
                keys := conv_from_orgtbl_style_to_dvorakj_style(keys)

                ;; 各キーの設定を保存するオブジェクト
                tmp_str_arr := Array()

                key_pos_starting := ( skip_keys ) ? skip_keys - 1
                                 :  0


                Loop, Parse, keys,`r, `n
                {
                    line := A_Index

                    Loop, Parse, A_LoopField,|
                    {
                        ;; @@@ を | に置き換え、
                        ;; 設定項目の前後の空白を除去する
                        item := Trim( RegExReplace( A_LoopField, "@{3}", "|", "", -1) )

                        ;; 設定項目に何かしら記載されているときに設定をする
                        if (item != "" ) {
                            ;; 表の各項目に対応するスキャンコードを取得する

                            sc_hex := Get_scancode_from_table_function_key(line, A_Index + key_pos_starting )

                            ;; 表の各段につき、既定の項目数を超えたときには
                            ;; 一つ下の段を処理する
                            if (sc_hex = 0) {
                                Break
                            } else {
                                tmp_str_arr.append("_sc" . sc_hex . "`t" . item)
                            }
                        }
                    }
                }

                ;; tmp_all_str に設定内容を一行ずつ追加する
                if ( option_status_arr.len() ) {
                    for index1,each_option in option_status_arr {


                        ;; 同時に打鍵する配列のときには
                        ;; それぞれの option を () で一括りにするため
                        ;; それぞれの option の冒頭に ( を付加する
                        if ( add_open_paren ) {
                            each_option := "(" . each_option
                        }

                        ;; 最後の閉じ括弧よりも最後の開き括弧が後に続いているときは
                        ;; 閉じ括弧を末尾に追加する
                        StringGetPos, last_open_paren_pos, each_option, (, R,
                        StringGetPos, last_close_paren_pos, each_option, ), R,
                        add_close_paren := ( last_open_paren_pos > last_close_paren_pos) ? 1
                                        : 0

                        ;; option 付きの第一番目の設定では
                        ;; option_keys[tab]this_key[tab]output
                        ;; それ以外なら
                        ;; [tab]this_key[tab]output
                        if ( add_close_paren ) {
                            for index2,each_key in tmp_str_arr {
                                tmp_all_str .= ( index2 = 1 ) ? each_option . "`t"
                                                                    . RegExReplace(each_key, "`t", ")`t") . "`r`n"
                                            :                    "`t" RegExReplace(each_key, "`t", ")`t") . "`r`n"
                            }
                        } else {
                            for index2,each_key in tmp_str_arr {
                                tmp_all_str .= ( index2 = 1 ) ? each_option . "`t"
                                                                    . each_key . "`r`n"
                                            :                    "`t" each_key . "`r`n"
                            }
                        }
                    }
                } else {
                    for index,each_key in tmp_str_arr {
                        tmp_all_str .=  each_key . "`r`n"
                    }
                }
            }

            ;; StartingPos から検索して、 ] のみの段落があるときには
            ;; FoundPos にその位置情報を格納する
            FoundPos := RegExMatch(str, "mis)^[\s\t]*\]$", "", StartingPos)

            ;; StartingPos から検索して、 ] のみの段落が存在しないときには
            ;; StartingPos を 0 にする
            ;; これによって、次回の検索を中止する
            StartingPos := ( FoundPos ) ? FoundPos + 1
                        : 0
        }
    }

    return tmp_all_str
}


Get_scancode_from_table_function_key(row, column)
{
    if ( column = 5 ) {
        return 0
    } else if ( row = 1 ) {
        sc_hex := ( column = 1 ) ? "03B"
               :  ( column = 2 ) ? "03C"
               :  ( column = 3 ) ? "03D"
                                 : "03E"
    } else if ( row = 2 ) {
        sc_hex := ( column = 1 ) ? "03F"
               :  ( column = 2 ) ? "040"
               :  ( column = 3 ) ? "041"
                                 : "042"
    } else if ( row = 3 ) {
        sc_hex := ( column = 1 ) ? "043"
               :  ( column = 2 ) ? "044"
               :  ( column = 3 ) ? "057"
                                 : "058"
    }

    return sc_hex
}


set_keyboard_layout3( p_str
                    , ByRef r_results_of_KCmb ) {
    if ( p_str = "error") {
        return p_str
    } else {
        s_simul_index := 0
        option_keys := ""

        Loop, parse, p_str, `r, `n
        {
            a_set_of_keys := ""

            if ( RegExMatch(A_LoopField, "m)^(.+?)\t(.+?)\t(.+?)$", item) ) { ; option_keys[tab]this_key[tab]output
                option_keys := item1
				StringReplace, option_keys, option_keys, (, , All

				r_results_of_KCmb[option_keys] := True

                a_set_of_keys := option_keys . item2
                output_str := item3
            } else if ( RegExMatch(A_LoopField, "m)^\t(.+?)\t(.+?)$", item) ) { ; [tab]this_key[tab]output
                a_set_of_keys := option_keys . item1
                output_str := item2
            } else if ( RegExMatch(A_LoopField, "m)^(.+?)\t(.+?)$", item) ) { ; this_key[tab]output
                a_set_of_keys := item1
                output_str := item2
            }


			StringReplace, a_set_of_keys, a_set_of_keys, ), , All

            if ( a_set_of_keys ) {
				r_results_of_KCmb[a_set_of_keys] := output_str
            }
        }

        return True
    }
}


