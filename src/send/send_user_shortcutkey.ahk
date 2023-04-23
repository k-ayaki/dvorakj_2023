send_user_shortcutkey( p_this_key ) {
	global results_of_shortcutkey_KCmb
	static tmp_KCmb

	if ( IsObject( tmp_KCmb ) ) {
		tmp_KCmb.append( sort_modifier( conv_from_scancode_to_key_in_qwerty(p_this_key) ) )
	} else {
		tmp_KCmb := Array( sort_modifier( conv_from_scancode_to_key_in_qwerty(p_this_key) ) )
	}


	for index,value in results_of_shortcutkey_KCmb {
		window_title := value.first()

		if ( window_title != "all" ) {
	        IfInString, %window_title%, 0x
	        {
	            window_title := "ahk_id " . window_title
	        } else {
	            window_title := "ahk_class " . window_title
	        }

		    IfWinActive, %window_title%
		    {
				remain_key_strokes := search_and_send_keystrokes( value.rest(), tmp_KCmb )
			}
		}
	}


	;; 「該当する設定にしたがいキーを出力し」ていないとき
	if ( 2 > remain_key_strokes ) {

		for index,value in results_of_shortcutkey_KCmb {
			window_title := value.first()

			if ( window_title = "all" ) {
				remain_key_strokes := search_and_send_keystrokes( value.rest(), tmp_KCmb )
			}
		}

		;; 該当する設定が何ら見つからなかったとき
		if ( remain_key_strokes = 0 ) {
			key_num := tmp_KCmb.len()
			tmp_KCmb := Array().clear ; 初期化する

			if ( key_num > 1 ) { ; 二回目以後の入力のとき
				;; 最新のキーストロークだけを判定し直す
				remain_key_strokes := send_user_shortcutkey( p_this_key )
			}
		}
	}

	return % ( remain_key_strokes ) ? True
			:							False
}



search_and_send_keystrokes( p_a, p_KCmb ) {
	;; value.rest() とすることで
	;; 入力するキーと出力するキーの設定のみを取り出す
	for index,value in p_a {
		;; input の設定を確認する
		if (( index = 1 ) or (mod(index, 2) = 1) ) {

			;; 入力したキーバインド通りの設定が見つかるかどうかを判定する
			match := False

			;; 設定済みのキーストロークの回数よりも
			;; 入力したキーストロークの回数が少ないときに限り
			;; 判定処理を行う
			if ( value.len() >= p_KCmb.len() ) {

				;; キーストロークを一つずつ照合する
				Loop,% value.len() {

					;; 修飾キーを一定の順序に並び替える
					setting_key := value[A_Index]
					this_key := p_KCmb[A_Index]

					if ( setting_key = this_key ) {
						match := True
						match_in_patches := True
					} else {
						match := False
					}
				} until ( match = False )
			}



			;; 設定どおりのキーバインドがすべて入力されたとき
			if ( match ) {
				match_all := True
				str := p_a[index + 1]
			}
		}
	} until ( match_all )

	;; 設定どおりのキーバインドが見つかったとき
	if ( match_all ) {
		remain_key_strokes := 2
		send( outputChar(str) )
	} else if ( match_in_patches ) { ; 設定の前半部分と入力されたキーストロークが一致したとき
		remain_key_strokes := 1
	} else { ; どの設定にもキーストロークが一致しなかったとき
		remain_key_strokes := 0
	}

	return remain_key_strokes
}




conv_from_scancode_to_key_in_qwerty(p_this_key) {
    ;; {sc01E} のように、スキャンコードでキー配列を設定しているときには
    ;; QWERTY 配列(OADG 109A)用の文字へと置き換える

	;; 1 段目
    StringReplace, p_this_key, p_this_key, {sc002}, 1, All
    StringReplace, p_this_key, p_this_key, {sc003}, 2, All
    StringReplace, p_this_key, p_this_key, {sc004}, 3, All
    StringReplace, p_this_key, p_this_key, {sc005}, 4, All
    StringReplace, p_this_key, p_this_key, {sc006}, 5, All
    StringReplace, p_this_key, p_this_key, {sc007}, 6, All
    StringReplace, p_this_key, p_this_key, {sc008}, 7, All
    StringReplace, p_this_key, p_this_key, {sc009}, 8, All
    StringReplace, p_this_key, p_this_key, {sc00A}, 9, All
    StringReplace, p_this_key, p_this_key, {sc00B}, 0, All
    StringReplace, p_this_key, p_this_key, {sc00C}, -, All
    StringReplace, p_this_key, p_this_key, {sc00D}, {^}, All
    StringReplace, p_this_key, p_this_key, {sc07D}, \, All

	;; 2 段目
    StringReplace, p_this_key, p_this_key, {sc010}, q, All
    StringReplace, p_this_key, p_this_key, {sc011}, w, All
    StringReplace, p_this_key, p_this_key, {sc012}, e, All
    StringReplace, p_this_key, p_this_key, {sc013}, r, All
    StringReplace, p_this_key, p_this_key, {sc014}, t, All
    StringReplace, p_this_key, p_this_key, {sc015}, y, All
    StringReplace, p_this_key, p_this_key, {sc016}, u, All
    StringReplace, p_this_key, p_this_key, {sc017}, i, All
    StringReplace, p_this_key, p_this_key, {sc018}, o, All
    StringReplace, p_this_key, p_this_key, {sc019}, p, All
    StringReplace, p_this_key, p_this_key, {sc01A}, @, All
    StringReplace, p_this_key, p_this_key, {sc01B}, [, All

	;; 3 段目
    StringReplace, p_this_key, p_this_key, {sc01E}, a, All
    StringReplace, p_this_key, p_this_key, {sc01F}, s, All
    StringReplace, p_this_key, p_this_key, {sc020}, d, All
    StringReplace, p_this_key, p_this_key, {sc021}, f, All
    StringReplace, p_this_key, p_this_key, {sc022}, g, All
    StringReplace, p_this_key, p_this_key, {sc023}, h, All
    StringReplace, p_this_key, p_this_key, {sc024}, j, All
    StringReplace, p_this_key, p_this_key, {sc025}, k, All
    StringReplace, p_this_key, p_this_key, {sc026}, l, All
    StringReplace, p_this_key, p_this_key, {sc027}, `;, All
    StringReplace, p_this_key, p_this_key, {sc028}, :, All
    StringReplace, p_this_key, p_this_key, {sc02B}, ], All

	;; 4 段目
    StringReplace, p_this_key, p_this_key, {sc02C}, z, All
    StringReplace, p_this_key, p_this_key, {sc02D}, x, All
    StringReplace, p_this_key, p_this_key, {sc02E}, c, All
    StringReplace, p_this_key, p_this_key, {sc02F}, v, All
    StringReplace, p_this_key, p_this_key, {sc030}, b, All
    StringReplace, p_this_key, p_this_key, {sc031}, n, All
    StringReplace, p_this_key, p_this_key, {sc032}, m, All
    StringReplace, p_this_key, p_this_key, {sc033}, ,, All
    StringReplace, p_this_key, p_this_key, {sc034}, ., All
    StringReplace, p_this_key, p_this_key, {sc035}, /, All
    StringReplace, p_this_key, p_this_key, {sc073}, \, All


	return p_this_key
}
