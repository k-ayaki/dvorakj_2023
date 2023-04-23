#If
/*
;;; ============================================================================
;;; 同時に打鍵する配列だが、
;;; 真に同時に打鍵する配列ではないとき
;;; ============================================================================

#If (( mod_key[window_title, "_ralt"] 
		and !( true_mod_key[window_title, "_ralt"] ) ))
    ralt::
            onKeyDown("_ralt")

    return


;;; ============================================================================
;;; 真に同時に打鍵する配列のとき
;;; ============================================================================

#If ( true_mod_key[window_title, "_ralt"] )
	ralt up::
		;; up を取り除く
	    key_up("ralt", PF_Count())
	    return


	ralt::
		;; 真に同時に打鍵するキーのリスト
		key_down("ralt", PF_Count(), true_mod_key[window_title, "_ralt"])
	    return
*/

#If ( mod_key[window_title, "_ralt"] )

    RAlt::


        onKeyDown("_ralt")

	return



#If ( true_mod_key[window_title, "_ralt"] )
    RAlt & sc002::
    RAlt & sc003::
    RAlt & sc004::
    RAlt & sc005::
    RAlt & sc006::
    RAlt & sc007::
    RAlt & sc008::
    RAlt & sc009::
    RAlt & sc00A::
    RAlt & sc00B::
    RAlt & sc00C::
    RAlt & sc00D::
    RAlt & sc07D::
    RAlt & sc010::
    RAlt & sc011::
    RAlt & sc012::
    RAlt & sc013::
    RAlt & sc014::
    RAlt & sc015::
    RAlt & sc016::
    RAlt & sc017::
    RAlt & sc018::
    RAlt & sc019::
    RAlt & sc01A::
    RAlt & sc01B::
    RAlt & sc01E::
    RAlt & sc01F::
    RAlt & sc020::
    RAlt & sc021::
    RAlt & sc022::
    RAlt & sc023::
    RAlt & sc024::
    RAlt & sc025::
    RAlt & sc026::
    RAlt & sc027::
    RAlt & sc028::
    RAlt & sc02B::
    RAlt & sc02C::
    RAlt & sc02D::
    RAlt & sc02E::
    RAlt & sc02F::
    RAlt & sc030::
    RAlt & sc031::
    RAlt & sc032::
    RAlt & sc033::
    RAlt & sc034::
    RAlt & sc035::
    RAlt & sc073::

        onKeyDown("_ralt")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))

    return




;;; ============================================================================
;;; ---------------- [RAlt] を 同時打鍵のキーとして使用する
;;; ============================================================================

#If ( !( mod_key[window_title, "_ralt"] )
	and ( get_state_of_modifier_and_key( A_ThisHotkey ) ) )

    RAlt & sc002::
    RAlt & sc003::
    RAlt & sc004::
    RAlt & sc005::
    RAlt & sc006::
    RAlt & sc007::
    RAlt & sc008::
    RAlt & sc009::
    RAlt & sc00A::
    RAlt & sc00B::
    RAlt & sc00C::
    RAlt & sc00D::
    RAlt & sc07D::
    RAlt & sc010::
    RAlt & sc011::
    RAlt & sc012::
    RAlt & sc013::
    RAlt & sc014::
    RAlt & sc015::
    RAlt & sc016::
    RAlt & sc017::
    RAlt & sc018::
    RAlt & sc019::
    RAlt & sc01A::
    RAlt & sc01B::
    RAlt & sc01E::
    RAlt & sc01F::
    RAlt & sc020::
    RAlt & sc021::
    RAlt & sc022::
    RAlt & sc023::
    RAlt & sc024::
    RAlt & sc025::
    RAlt & sc026::
    RAlt & sc027::
    RAlt & sc028::
    RAlt & sc02B::
    RAlt & sc02C::
    RAlt & sc02D::
    RAlt & sc02E::
    RAlt & sc02F::
    RAlt & sc030::
    RAlt & sc031::
    RAlt & sc032::
    RAlt & sc033::
    RAlt & sc034::
    RAlt & sc035::
    RAlt & sc073::


		GoTo, subroutine_multiple_keys

	return

