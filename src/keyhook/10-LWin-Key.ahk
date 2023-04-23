#If
/*
;;; ============================================================================
;;; 同時に打鍵する配列だが、
;;; 真に同時に打鍵する配列ではないとき
;;; ============================================================================

#If (( mod_key[window_title, "_lwin"] 
		and !( true_mod_key[window_title, "_lwin"] ) ))
    LWin::
            onKeyDown("_lwin")

    return


;;; ============================================================================
;;; 真に同時に打鍵する配列のとき
;;; ============================================================================

#If ( true_mod_key[window_title, "_lwin"] )
	LWin up::
		;; up を取り除く
	    key_up("lwin", PF_Count())
	    return


	LWin::
		;; 真に同時に打鍵するキーのリスト
		key_down("lwin", PF_Count(), true_mod_key[window_title, "_lwin"])
	    return
*/

#If ( mod_key[window_title, "_lwin"] )

    LWin::
        onKeyDown("_lwin")
	return



#If ( true_mod_key[window_title, "_lwin"] )
    LWin & sc002::
    LWin & sc003::
    LWin & sc004::
    LWin & sc005::
    LWin & sc006::
    LWin & sc007::
    LWin & sc008::
    LWin & sc009::
    LWin & sc00A::
    LWin & sc00B::
    LWin & sc00C::
    LWin & sc00D::
    LWin & sc07D::
    LWin & sc010::
    LWin & sc011::
    LWin & sc012::
    LWin & sc013::
    LWin & sc014::
    LWin & sc015::
    LWin & sc016::
    LWin & sc017::
    LWin & sc018::
    LWin & sc019::
    LWin & sc01A::
    LWin & sc01B::
    LWin & sc01E::
    LWin & sc01F::
    LWin & sc020::
    LWin & sc021::
    LWin & sc022::
    LWin & sc023::
    LWin & sc024::
    LWin & sc025::
    LWin & sc026::
    LWin & sc027::
    LWin & sc028::
    LWin & sc02B::
    LWin & sc02C::
    LWin & sc02D::
    LWin & sc02E::
    LWin & sc02F::
    LWin & sc030::
    LWin & sc031::
    LWin & sc032::
    LWin & sc033::
    LWin & sc034::
    LWin & sc035::
    LWin & sc073::

        onKeyDown("_lwin")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))

    return



;;; ============================================================================
;;; ---------------- [LWin] を 同時打鍵のキーとして使用する
;;; ============================================================================


#If ( !( mod_key[window_title, "_lwin"] ) 
	and ( get_state_of_modifier_and_key( A_ThisHotkey ) ) )

    LWin & sc002::
    LWin & sc003::
    LWin & sc004::
    LWin & sc005::
    LWin & sc006::
    LWin & sc007::
    LWin & sc008::
    LWin & sc009::
    LWin & sc00A::
    LWin & sc00B::
    LWin & sc00C::
    LWin & sc00D::
    LWin & sc07D::
    LWin & sc010::
    LWin & sc011::
    LWin & sc012::
    LWin & sc013::
    LWin & sc014::
    LWin & sc015::
    LWin & sc016::
    LWin & sc017::
    LWin & sc018::
    LWin & sc019::
    LWin & sc01A::
    LWin & sc01B::
    LWin & sc01E::
    LWin & sc01F::
    LWin & sc020::
    LWin & sc021::
    LWin & sc022::
    LWin & sc023::
    LWin & sc024::
    LWin & sc025::
    LWin & sc026::
    LWin & sc027::
    LWin & sc028::
    LWin & sc02B::
    LWin & sc02C::
    LWin & sc02D::
    LWin & sc02E::
    LWin & sc02F::
    LWin & sc030::
    LWin & sc031::
    LWin & sc032::
    LWin & sc033::
    LWin & sc034::
    LWin & sc035::
    LWin & sc073::

		GoTo, subroutine_multiple_keys

	return

