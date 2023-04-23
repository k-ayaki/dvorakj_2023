#If
/*
;;; ============================================================================
;;; 同時に打鍵する配列だが、
;;; 真に同時に打鍵する配列ではないとき
;;; ============================================================================

#If (( mod_key[window_title, "_lalt"] 
		and !( true_mod_key[window_title, "_lalt"] ) ))
    LAlt::
            onKeyDown("_lalt")

    return


;;; ============================================================================
;;; 真に同時に打鍵する配列のとき
;;; ============================================================================

#If ( true_mod_key[window_title, "_lalt"] )
	LAlt up::
		;; up を取り除く
	    key_up("lalt", PF_Count())
	    return


	LAlt::
		;; 真に同時に打鍵するキーのリスト
		key_down("lalt", PF_Count(), true_mod_key[window_title, "_lalt"])
	    return
*/

#If ( mod_key[window_title, "_lalt"] )
    LAlt::

        onKeyDown("_lalt")

	return


#If ( true_mod_key[window_title, "_lalt"] )
    LAlt & sc002::
    LAlt & sc003::
    LAlt & sc004::
    LAlt & sc005::
    LAlt & sc006::
    LAlt & sc007::
    LAlt & sc008::
    LAlt & sc009::
    LAlt & sc00A::
    LAlt & sc00B::
    LAlt & sc00C::
    LAlt & sc00D::
    LAlt & sc07D::
    LAlt & sc010::
    LAlt & sc011::
    LAlt & sc012::
    LAlt & sc013::
    LAlt & sc014::
    LAlt & sc015::
    LAlt & sc016::
    LAlt & sc017::
    LAlt & sc018::
    LAlt & sc019::
    LAlt & sc01A::
    LAlt & sc01B::
    LAlt & sc01E::
    LAlt & sc01F::
    LAlt & sc020::
    LAlt & sc021::
    LAlt & sc022::
    LAlt & sc023::
    LAlt & sc024::
    LAlt & sc025::
    LAlt & sc026::
    LAlt & sc027::
    LAlt & sc028::
    LAlt & sc02B::
    LAlt & sc02C::
    LAlt & sc02D::
    LAlt & sc02E::
    LAlt & sc02F::
    LAlt & sc030::
    LAlt & sc031::
    LAlt & sc032::
    LAlt & sc033::
    LAlt & sc034::
    LAlt & sc035::
    LAlt & sc073::

        onKeyDown("_lalt")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))

    return



;;; ============================================================================
;;; ---------------- [LAlt] を 同時打鍵のキーとして使用する
;;; ============================================================================


#If ( !( mod_key[window_title, "_lalt"] )
	and ( get_state_of_modifier_and_key( A_ThisHotkey ) ) )

    LAlt & sc002::
    LAlt & sc003::
    LAlt & sc004::
    LAlt & sc005::
    LAlt & sc006::
    LAlt & sc007::
    LAlt & sc008::
    LAlt & sc009::
    LAlt & sc00A::
    LAlt & sc00B::
    LAlt & sc00C::
    LAlt & sc00D::
    LAlt & sc07D::
    LAlt & sc010::
    LAlt & sc011::
    LAlt & sc012::
    LAlt & sc013::
    LAlt & sc014::
    LAlt & sc015::
    LAlt & sc016::
    LAlt & sc017::
    LAlt & sc018::
    LAlt & sc019::
    LAlt & sc01A::
    LAlt & sc01B::
    LAlt & sc01E::
    LAlt & sc01F::
    LAlt & sc020::
    LAlt & sc021::
    LAlt & sc022::
    LAlt & sc023::
    LAlt & sc024::
    LAlt & sc025::
    LAlt & sc026::
    LAlt & sc027::
    LAlt & sc028::
    LAlt & sc02B::
    LAlt & sc02C::
    LAlt & sc02D::
    LAlt & sc02E::
    LAlt & sc02F::
    LAlt & sc030::
    LAlt & sc031::
    LAlt & sc032::
    LAlt & sc033::
    LAlt & sc034::
    LAlt & sc035::
    LAlt & sc073::


		GoTo, subroutine_multiple_keys

	return
