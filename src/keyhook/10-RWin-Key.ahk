#If
/*
;;; ============================================================================
;;; 同時に打鍵する配列だが、
;;; 真に同時に打鍵する配列ではないとき
;;; ============================================================================

#If (( mod_key[window_title, "_rwin"] 
		and !( true_mod_key[window_title, "_rwin"] ) ))
    RWin::
            onKeyDown("_rwin")

    return


;;; ============================================================================
;;; 真に同時に打鍵する配列のとき
;;; ============================================================================

#If ( true_mod_key[window_title, "_rwin"] )
	RWin up::
		;; up を取り除く
	    key_up("rwin", PF_Count())
	    return


	RWin::
		;; 真に同時に打鍵するキーのリスト
		key_down("rwin", PF_Count(), true_mod_key[window_title, "_rwin"])
	    return
*/

#If ( mod_key[window_title, "_rwin"] )

    RWin::


        onKeyDown("_rwin")

	return



#If ( true_mod_key[window_title, "_rwin"] )
    RWin & sc002::
    RWin & sc003::
    RWin & sc004::
    RWin & sc005::
    RWin & sc006::
    RWin & sc007::
    RWin & sc008::
    RWin & sc009::
    RWin & sc00A::
    RWin & sc00B::
    RWin & sc00C::
    RWin & sc00D::
    RWin & sc07D::
    RWin & sc010::
    RWin & sc011::
    RWin & sc012::
    RWin & sc013::
    RWin & sc014::
    RWin & sc015::
    RWin & sc016::
    RWin & sc017::
    RWin & sc018::
    RWin & sc019::
    RWin & sc01A::
    RWin & sc01B::
    RWin & sc01E::
    RWin & sc01F::
    RWin & sc020::
    RWin & sc021::
    RWin & sc022::
    RWin & sc023::
    RWin & sc024::
    RWin & sc025::
    RWin & sc026::
    RWin & sc027::
    RWin & sc028::
    RWin & sc02B::
    RWin & sc02C::
    RWin & sc02D::
    RWin & sc02E::
    RWin & sc02F::
    RWin & sc030::
    RWin & sc031::
    RWin & sc032::
    RWin & sc033::
    RWin & sc034::
    RWin & sc035::
    RWin & sc073::

        onKeyDown("_rwin")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))

    return



;;; ============================================================================
;;; ---------------- [RWin] を 同時打鍵のキーとして使用する
;;; ============================================================================

#If ( !( mod_key[window_title, "_rwin"] )
	and ( get_state_of_modifier_and_key( A_ThisHotkey ) ) )

    RWin & sc002::
    RWin & sc003::
    RWin & sc004::
    RWin & sc005::
    RWin & sc006::
    RWin & sc007::
    RWin & sc008::
    RWin & sc009::
    RWin & sc00A::
    RWin & sc00B::
    RWin & sc00C::
    RWin & sc00D::
    RWin & sc07D::
    RWin & sc010::
    RWin & sc011::
    RWin & sc012::
    RWin & sc013::
    RWin & sc014::
    RWin & sc015::
    RWin & sc016::
    RWin & sc017::
    RWin & sc018::
    RWin & sc019::
    RWin & sc01A::
    RWin & sc01B::
    RWin & sc01E::
    RWin & sc01F::
    RWin & sc020::
    RWin & sc021::
    RWin & sc022::
    RWin & sc023::
    RWin & sc024::
    RWin & sc025::
    RWin & sc026::
    RWin & sc027::
    RWin & sc028::
    RWin & sc02B::
    RWin & sc02C::
    RWin & sc02D::
    RWin & sc02E::
    RWin & sc02F::
    RWin & sc030::
    RWin & sc031::
    RWin & sc032::
    RWin & sc033::
    RWin & sc034::
    RWin & sc035::
    RWin & sc073::


		GoTo, subroutine_multiple_keys

	return


