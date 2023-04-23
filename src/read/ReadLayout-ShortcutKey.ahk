read_layout_of_shortcutkey( path_layout_file ) {
	global

	results_of_shortcutkey_KCmb := Array()

    return set_keyboard_layout5( conv_from_table_to_lines5( read_keyboard_layout( get_file_full_path( path_layout_file ) ) )
                               , results_of_shortcutkey_KCmb )
}


conv_from_table_to_lines5( str ) {
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


        ;; 以下、[] で囲まれた表を一行形式の設定へと変換する
        ;; ただし、-raw[] という設定については、[] で囲まれた部分をそのままにしておく
        StartingPos := 1
        while ( StartingPos ) {
            RegExMatch(str, "mis)^([^`n]*?)\[(.*?)$`r`n(.+?)`r`n[\s\t]*\]$", $, StartingPos )

            ;; 改行を取り除き
            ;; 前後の空白を削除する
            option_status := Trim( RegExReplace( $1, "(`r`n|`n)", "" ) )
            window_title := Trim( $2 )
            keys := $3


            ;; オプションを設定するとき
			if ( option_status = "_option_output" ) { ; 出力する文字列を置換する
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
				if ( window_title = "" ) {
					window_title := "all"
				}

                ;; 以下、キーの設定表内部を設定する

                ;; 出力する文字列を置き換える
                for i, v in substitution_output.reverse() {
                    keys := string_replace(keys, v[1], v[2], , True)
                }

                ;; unicode_mode が有効ならば、unicode 出力用の変換処理を行う
                ;; それ以外ならば、通常の変換処理を行う
                keys := conv_str_for_sending( keys, unicode_mode )

                ;; 各キーの設定を保存するオブジェクト
                tmp_str_arr := Array()

                key_pos_starting := 0



                Loop, Parse, keys,`r, `n
                {
					if ( Trim(A_LoopField) ){
						RegExMatch(Trim(A_LoopField), "m)^(.+?)\|(.+)$", key_ )
						input_key  := Trim(key_1)
						output_key := Trim(key_2)

						tmp_str_arr.append(input_key . "`t" . output_key)
					}
                }

                ;; tmp_all_str に設定内容を一行ずつ追加する
                for index,each_setting in tmp_str_arr {
                    tmp_all_str .= ( index = 1) ? window_title . "`t" .  each_setting . "`r`n"
								: 								 "`t" .  each_setting . "`r`n"
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



set_keyboard_layout5( p_str
                    , ByRef r_results_of_KCmb ) {
    if ( p_str = "error") {
        return p_str
    } else {

	    Loop, parse, p_str, `n, `r
		{
	        If (RegExMatch(A_LoopField, "^(.*?)\t(.*?)\t(.*?)$", s_)) {
	            ;; s_1: ウィンドウ名
				if ( Trim( s_1 ) ) {
		            window_title := Trim( s_1 )
				}

	            ;; s_2: キーの組み合わせ
				input_key := store_key_strokes( Trim( s_2 ) )

	            ;; s_3: 出力する文字やキー
				output_key := Trim( s_3 )


				;; [window_title
				;;		[intput_key	output_key]
				;;		[intput_key	output_key]]


				window_title_stored := False

				for index,value in r_results_of_KCmb {
					;; window_title が登録されているとき
					if ( value.first() = window_title ) {
						value.append(input_key, output_key)

						window_title_stored := True
					}
				} until ( window_title_stored )


				if ( window_title_stored = False ) {
					r_results_of_KCmb.append( Array(window_title, input_key, output_key) )
				}
			}
		}
	}

     return True
}






store_key_strokes( keys ) {
	obj_tmp := Array()

	keys := RegExReplace(to_symbol_for_modifier(keys), "([#!\^\+]+)\s+", "$1")

	Loop, Parse, keys, %A_Space%
	{
		if ( Trim(A_LoopField) ) {
			obj_tmp.append( sort_modifier( Trim(A_LoopField)))
		}
	}

	return obj_tmp
}


