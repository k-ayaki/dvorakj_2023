;;; ホットキーどおりユーザーがキーを物理的に打鍵したとき、
;;; すなわち、他のソフトウェアからキーが送信されていないときに限り
;;; ホットキーの処理をすすめる
;;; #if (get_state_of_modifier_and_key( param ) )



get_state_of_modifier_and_key( p_set_key ) {
	global release_key_hook_on_pressing_down_modifier

	;; 修飾キーを押し下げているときに
	;; キーフックを解除するか？
	if ( release_key_hook_on_pressing_down_modifier ) {
		return False
	} else {
		;; Ctrl & sc035 -> ^sc035
		StringReplace, p_set_key, p_set_key, Ctrl%A_Space%&%A_Space%, ^, All
		StringReplace, p_set_key, p_set_key, Alt%A_Space%&%A_Space%, !, All
		StringReplace, p_set_key, p_set_key, LWin%A_Space%&%A_Space%, #, All
		StringReplace, p_set_key, p_set_key, RWin%A_Space%&%A_Space%, #, All

	    return, % ( ( get_state_of_modifier( p_set_key ) )
	                and ( get_state_of_key( p_set_key ) ) )
	}
}


get_state_of_key( p_set_key ) {
    return, GetKeyState( get_key_without_modifier( p_set_key ), "P")
}


get_state_of_modifier( p_set_key ) {
    all_state := Array()

    ;; ホットキーの設定から修飾キーの設定を読み取る
    for index,key_name in get_modifier( p_set_key )
    {
        ;; 修飾キーすべての状態を調べあげるとき
        if ( key_name = "all") {
            if ( ( GetKeyState("shift", "P") )
                or ( GetKeyState("alt", "P") )
                or ( GetKeyState("rwin", "P") )
                or ( GetKeyState("lwin", "P") )
                or ( GetKeyState("ctrl", "P") ) ) {

                all_state[index] := True
            } else {
                all_state[index] := False
            }
        } else if ( key_name = "win") {
            all_state[index] := ( GetKeyState("lwin", "P") ) or ( GetKeyState("rwin", "P") )
        } else {
            all_state[index] := GetKeyState(key_name, "P")
        }
    }

    ;; 物理的に押し下げられていないキーがあれば False
    ;; すべて押し下げられていれば True
    return, % all_state.indexOf(False) ? False
           :                             True
}


get_modifier( p_keys ) {
    keys := Array()

    RegExMatch(p_keys, "[\^\!\+\*#]+", modifier)

    Loop, Parse, modifier
    {
        if ( A_LoopField ) {
            if (A_LoopField = "^") {
                keys.append("ctrl")
            } else if (A_LoopField = "+") {
                keys.append("shift")
            } else if (A_LoopField = "!") {
                keys.append("alt")
            } else if (A_LoopField = "#") {
                keys.append("win")
            } else {
                keys.append("all")
            }
        }
    }

    return keys
}


get_key_without_modifier( p_keys ) {
    RegExMatch(p_keys, "[\^\!\+\*#]+(.+)", key_without_modifier)
    return key_without_modifier1
}
