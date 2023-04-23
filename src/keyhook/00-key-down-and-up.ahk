#If
;;; キーαを押し下げたときの時間を αt_down とし、そのキーを押し上げたときの時間を αt_up とする
;;; （ただし、αt_down と αt_up の単位はともにミリ秒）
;;; そして、αt_diff = αt_up - αt_down とする

;;;  basic_time := αt_diff * ( proportion / 100 ) とする
;;; （ただし、proportion は1から100までの任意の整数）

;;; basic_time 以前に押し下げられたキーで、かつまだ押し上げられていないキーが存在すれば、
;;; キーαとともに出力処理を行う
;;; 他方、そのようなキーが存在しなければ
;;; キーαのみ出力処理を行う

;;; 以下のページの "Posted by yama at 2010年04月26日 20:48" を参照のこと
;;; やまぶき Ver. 4.2.0リリース: やまぶき作ってます
;;; http://yamakey.seesaa.net/article/147080328.html#comment


;; AppsKey up:: のように、キーの押し上げを検出するようにすると、
;; そのホットキーを使用しないよう、#if で場合分けをしたとしても、
;; キーの押し上げの動作を常に監視するようになってしまう


#if (true_mod_key[window_title, "num"])

sc002 up:: ; 1
sc003 up:: ; 2
sc004 up:: ; 3
sc005 up:: ; 4
sc006 up:: ; 5
sc007 up:: ; 6
sc008 up:: ; 7
sc009 up:: ; 8
sc00A up:: ; 9
sc00B up:: ; 0
sc00C up:: ; -
sc00D up:: ; {^}
sc07D up:: ; \ と |
sc010 up:: ; q
sc011 up:: ; w
sc012 up:: ; e
sc013 up:: ; r
sc014 up:: ; t
sc015 up:: ; y
sc016 up:: ; u
sc017 up:: ; i
sc018 up:: ; o
sc019 up:: ; p
sc01A up:: ; @
sc01B up:: ; [
sc01E up:: ; a
sc01F up:: ; s
sc020 up:: ; d
sc021 up:: ; f
sc022 up:: ; g
sc023 up:: ; h
sc024 up:: ; j
sc025 up:: ; k
sc026 up:: ; l
sc027 up:: ; ;
sc028 up:: ; :
sc02B up:: ; ]
sc02C up:: ; z
sc02D up:: ; x
sc02E up:: ; c
sc02F up:: ; v
sc030 up:: ; b
sc031 up:: ; n
sc032 up:: ; m
sc033 up:: ; ,
sc034 up:: ; .
sc035 up:: ; /
sc073 up:: ; \ と _
	;; up を取り除く
    key_up(Trim(A_ThisHotkey, " up"), Pf_Count(), true_mod_key[window_title, "_" . Trim(A_ThisHotkey, " up")])

    return


/*
AppsKey up::
	;; up を取り除く
    key_up(Trim(A_ThisHotkey, " up"), Pf_Count(), true_mod_key[window_title, "_" . Trim(A_ThisHotkey, " up")])
    return
*/


sc002:: ; 1
sc003:: ; 2
sc004:: ; 3
sc005:: ; 4
sc006:: ; 5
sc007:: ; 6
sc008:: ; 7
sc009:: ; 8
sc00A:: ; 9
sc00B:: ; 0
sc00C:: ; -
sc00D:: ; {^}
sc07D:: ; \ と |
sc010:: ; q
sc011:: ; w
sc012:: ; e
sc013:: ; r
sc014:: ; t
sc015:: ; y
sc016:: ; u
sc017:: ; i
sc018:: ; o
sc019:: ; p
sc01A:: ; @
sc01B:: ; [
sc01E:: ; a
sc01F:: ; s
sc020:: ; d
sc021:: ; f
sc022:: ; g
sc023:: ; h
sc024:: ; j
sc025:: ; k
sc026:: ; l
sc027:: ; ;
sc028:: ; :
sc02B:: ; ]
sc02C:: ; z
sc02D:: ; x
sc02E:: ; c
sc02F:: ; v
sc030:: ; b
sc031:: ; n
sc032:: ; m
sc033:: ; ,
sc034:: ; .
sc035:: ; /
sc073:: ; \ と _
    if (A_IsCompiled == "") {    
		g_debug00[0] := g_debug00[1]
		g_debug00[1] := g_debug00[2]
		g_debug00[2] := g_debug00[3]
		g_debug00[3] := g_debug00[4]
		g_debug00[4] := PF_Count()
	}
	;; 真に同時に打鍵するキーのリスト
	key_down(A_ThisHotkey, Pf_Count(), true_mod_key[window_title, "_" . A_ThisHotkey])
    return

/*
AppsKey::
	;; 真に同時に打鍵するキーのリスト
	key_down(A_ThisHotkey, Pf_Count(), true_mod_key[window_title, "_" . A_ThisHotkey])
    return
*/

is_stored(p_key_list, p_key_name) {
	; [1]: キー名
	; [2]: キーを押し下げた時間
	; [3]: 当該キーを以前出力したことがあるかどうか

	for i, v in p_key_list {
		if ( v[1] = p_key_name ) {
			return True
		}
	}

	return False
}


get_time_key_down(p_key_list, p_key_name) {
	; [1]: キー名
	; [2]: キーを押し下げた時間
	; [3]: 当該キーを以前出力したことがあるかどうか

	; キー名の部分が添字のとき
	if p_key_name is digit
	{
		return p_key_list[p_key_name, 2]
	}


	for i, v in p_key_list {
		if ( v[1] = p_key_name ) {
			return v[2]
		}
	}

	return False
}

get_keyname_key_down(p_key_list, p_i) {
	; [1]: キー名
	; [2]: キーを押し下げた時間
	; [3]: 当該キーを以前出力したことがあるかどうか

	return p_key_list[p_i, 1]
}

is_key_used(p_key_list, p_i) {
	; [1]: キー名
	; [2]: キーを押し下げた時間
	; [3]: 当該キーを以前出力したことがあるかどうか

	already_used := p_key_list[p_i, 3]

	if (already_used)
		return True
	else
		return False
}


get_order_in_keys(p_key_list, p_key_name) {
	; [1]: キー名
	; [2]: キーを押し下げた時間
	; [3]: 当該キーを以前出力したことがあるかどうか

	for i, v in p_key_list {
		if ( v[1] = p_key_name ) {
			return i
		}
	}

	return False
}



key_down(p_key, p_time, is_TRUE_key) {
    global key_stack
	global lang_mode

	;; 同時に打鍵したと割合で判定する
	global proportion_mode

	;; キー・リピートを開始するまでの時間
	global key_repeat_delay

	;; キーを最後に押し下げ/上げた時間
	global last_key_event_time

	if (proportion_mode) {
		;; 今回押し下げられたキーが、キーのスタックに既に格納されていないときに限り、
		if not ( is_stored(key_stack, p_key) )
		{
			;; キーを最後に押し下げ/上げた時間を更新する
			last_key_event_time := Pf_Count()

			;; キーのスタックを更新する
			key_stack.append(Array(p_key, p_time))
		}
		else
		if (key_repeat_delay < (Pf_Count() - last_key_event_time) )
		{
			;; ストックされているキーを順に出力し、
			for i, v in key_stack {
				;; 同時に打鍵したと判定したキーに、
				;; キー名と押し下げた時間しか記録されていないとき
				if not ( is_key_used(key_stack, i) ) {
					;; 同時打鍵で当該キーを使用したことを記録しておく
					key_stack[i].append(True)
				}

			    onKeyDown( "_" . get_keyname_key_down(key_stack, i), lang_mode )
			}
		}
	}
	else
	{
		if (is_TRUE_key)
		{
			;; 今回押し下げられたキーが、キーのスタックに既に格納されていないときに限り、
			if not ( is_stored(key_stack, p_key))
			{
				;; キーを最後に押し下げ/上げた時間を更新する
				last_key_event_time := Pf_Count()

				;; キーのスタックを更新する
				key_stack.append(Array(p_key, p_time))
			}
			else
			if (key_repeat_delay < (Pf_Count() - last_key_event_time) )
			{
				;; ストックされているキーを順に出力し、
				for i, v in key_stack {
					;; 同時に打鍵したと判定したキーに、
					;; キー名と押し下げた時間しか記録されていないとき
					if not ( is_key_used(key_stack, i) ) {
						;; 同時打鍵で当該キーを使用したことを記録しておく
						key_stack[i].append(True)
					}

				    onKeyDown( "_" . get_keyname_key_down(key_stack, i), lang_mode )
				}
			}
		}
		else ; 真に同時に打鍵するキーではないとき
		{
			;; キーを最後に押し下げ/上げた時間を更新する
			last_key_event_time := Pf_Count()

			;; ストックされているキーを順に出力し、
			for i, v in key_stack {
				;; 同時に打鍵したと判定したキーに、
				;; キー名と押し下げた時間しか記録されていないとき
				if not ( is_key_used(key_stack, i) ) {
					;; 同時打鍵で当該キーを使用したことを記録しておく
					key_stack[i].append(True)
				}

			    onKeyDown( "_" . get_keyname_key_down(key_stack, i), lang_mode )
			}


			;; それから今回押し下げられたキーを出力する
		    onKeyDown( "_" . p_key, lang_mode )
		}
	}


    return key_stack
}


key_up(p_key, p_time, is_TRUE_key=False) {
    global key_stack
	global lang_mode

	;; キー・リピートを開始するまでの時間
	global key_repeat_delay

	;; キーを最後に押し下げ/上げた時間
	global last_key_event_time

	;; 同時に打鍵したと割合で判定する
	;; global proportion_mode
	global proportion_of_simultaneous_keydown_events

	;; 最後に押し上げたキー
	static prev_key_up


	;; キーを最後に押し下げ/上げた時間を更新する
	last_key_event_time := PF_Count()

	the_key_down_i := False

	;; 押し上げたキーが何番目に押し下げられていたかを取得する
	order_in_keys := get_order_in_keys(key_stack, p_key)

	; 今回押し上げたキーが、キーのリスト内に無いとき
	if (order_in_keys = 0) {
		; 処理を停止する
		return
	}

	;; 押し下げた時間を取得する
	time_key_down := get_time_key_down(key_stack, order_in_keys)


	;; 押し下げた時間を取得できなかったとき
	if ( time_key_down = False) {
		w_tickcount := PF_Count()
		tooltip,% w_tickcount "`nerror: the key " . p_key . "is not found."
	}
	else
	{
		;; どれほどの時間キーを押し下げていたかを計算する
		;; 押し上げた時間 (p_time) と押し下げた時間 (time_key_down) の差分をとる
		the_key_down_up_diff := p_time - time_key_down

	    ;; 同時に打鍵したかどうかを判定するための
	    ;; 基準時を設定する
	    basic_time := Ceil( the_key_down_up_diff * ( proportion_of_simultaneous_keydown_events / 100 ) )
	                    + time_key_down
	}


	;; 同時に打鍵するキーとして、
	;; 現在押し下げているキーすべてを利用すると
	;; 推定する
	last_key_on_simultaneousness := key_stack.len()

	;; 基準時以前に押し下げられたキーを「同時に打鍵するキー」として記憶しておく
	Loop, % key_stack.len()
	{
		; prev_key_up[2]: 直前に押し上げたキーの時間
		; その情報が残っているとき
		if (prev_key_up[2]) {
			;; 基準時を超過しているとき
			if ( basic_time <= prev_key_up[2] ) {
				; 直前に押し上げたキーの情報をクリアする
				prev_key_up := Array()
			}
		}
		else
		{
			;; 基準時を超過しているとき
			if ( basic_time < get_time_key_down(key_stack, A_Index) ) {
				run_out := True

				;; 今回押し上げたキーが真に同時に打鍵するキーのとき
				if (is_TRUE_key) {
					;; 今回押し上げたキーの情報を記憶しておく
					prev_key_up := Array(p_key, p_time)

					;; 押し上げたキーの情報を削除する
					key_stack.delete(order_in_keys)

					;; 何も出力せずに終了する
					return
				}
				else
				{
					prev_key_up := Array()
				}
			}
			else 
			{
				last_key_on_simultaneousness := A_Index
			}
		}
	} until ( run_out )


	;; 今回押し上げたキーが、「同時に打鍵するキー」として以前使用されたならば
	;; 何も出力しない
	if not ( is_key_used(key_stack, order_in_keys) ) {
		;; 直前に出力しなかったキーを出力するとき
		if (prev_key_up[2]) {
		    onKeyDown( "_" . prev_key_up[1], lang_mode )
			prev_key_up := Array()
		}

		Loop, % last_key_on_simultaneousness {
			;; 同時に打鍵したと判定したキーに、
			;; キー名と押し下げた時間しか記録されていないとき
			if not ( is_key_used(key_stack, A_Index) ) {
				;; 同時打鍵で当該キーを使用したことを記録しておく
				key_stack[A_Index].append(True)
			}

		    onKeyDown( "_" . get_keyname_key_down(key_stack, A_Index), lang_mode )
		}
	}

	key_stack.delete(order_in_keys)

    return key_stack
}

/*
Conv_from_scancode_to_key_of_qwerty( scancode ) {
    StringReplace, scancode, scancode, sc002, [1], All
    StringReplace, scancode, scancode, sc003, [2], All
    StringReplace, scancode, scancode, sc004, [3], All
    StringReplace, scancode, scancode, sc005, [4], All
    StringReplace, scancode, scancode, sc006, [5], All
    StringReplace, scancode, scancode, sc007, [6], All
    StringReplace, scancode, scancode, sc008, [7], All
    StringReplace, scancode, scancode, sc009, [8], All
    StringReplace, scancode, scancode, sc00A, [9], All
    StringReplace, scancode, scancode, sc00B, [0], All
    StringReplace, scancode, scancode, sc00C, [-], All
    StringReplace, scancode, scancode, sc00D, [^], All
    StringReplace, scancode, scancode, sc07D, [\|], All
    StringReplace, scancode, scancode, sc010, [Q], All
    StringReplace, scancode, scancode, sc011, [W], All
    StringReplace, scancode, scancode, sc012, [E], All
    StringReplace, scancode, scancode, sc013, [R], All
    StringReplace, scancode, scancode, sc014, [T], All
    StringReplace, scancode, scancode, sc015, [Y], All
    StringReplace, scancode, scancode, sc016, [U], All
    StringReplace, scancode, scancode, sc017, [I], All
    StringReplace, scancode, scancode, sc018, [O], All
    StringReplace, scancode, scancode, sc019, [P], All
    StringReplace, scancode, scancode, sc01A, [@], All
    StringReplace, scancode, scancode, sc01B, [[], All
    StringReplace, scancode, scancode, sc01E, [A], All
    StringReplace, scancode, scancode, sc01F, [S], All
    StringReplace, scancode, scancode, sc020, [D], All
    StringReplace, scancode, scancode, sc021, [F], All
    StringReplace, scancode, scancode, sc022, [G], All
    StringReplace, scancode, scancode, sc023, [H], All
    StringReplace, scancode, scancode, sc024, [J], All
    StringReplace, scancode, scancode, sc025, [K], All
    StringReplace, scancode, scancode, sc026, [L], All
    StringReplace, scancode, scancode, sc027, [`;], All
    StringReplace, scancode, scancode, sc028, [:], All
    StringReplace, scancode, scancode, sc02B, []], All
    StringReplace, scancode, scancode, sc02C, [Z], All
    StringReplace, scancode, scancode, sc02D, [X], All
    StringReplace, scancode, scancode, sc02E, [C], All
    StringReplace, scancode, scancode, sc02F, [V], All
    StringReplace, scancode, scancode, sc030, [B], All
    StringReplace, scancode, scancode, sc031, [N], All
    StringReplace, scancode, scancode, sc032, [M], All
    StringReplace, scancode, scancode, sc033, [`,], All
    StringReplace, scancode, scancode, sc034, [.], All
    StringReplace, scancode, scancode, sc035, [/], All
    StringReplace, scancode, scancode, sc073, [\_], All

    return scancode
}

show_current_key_stack(key_stack) {
    total_key := ""
    for i,v in key_stack {
        total_key .= Conv_from_scancode_to_key_of_qwerty( v[1] ) "`t" v[2] . "`n"
    }

    tooltip,% "total: " key_stack.len() "`n"
			. total_key
            , % A_ScreenWidth - 100
            , % A_ScreenHeight - 300
            ,2
}
*/