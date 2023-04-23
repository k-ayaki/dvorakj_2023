#If
/*
;;; ============================================================================
;;; 同時に打鍵する配列だが、
;;; 真に同時に打鍵する配列ではないとき
;;; ============================================================================

#If (( mod_key[window_title, "_tab"] 
		and !( true_mod_key[window_title, "_tab"] ) ))
    sc00F::
            onKeyDown("_tab")

    return


;;; ============================================================================
;;; 真に同時に打鍵する配列のとき
;;; ============================================================================

#If ( true_mod_key[window_title, "_tab"] )
	sc00F up::
		;; up を取り除く
	    key_up("tab", PF_Count())
	    return


	sc00F::
		;; 真に同時に打鍵するキーのリスト
		key_down("tab", PF_Count(), true_mod_key[window_title, "_tab"])
	    return
*/

;;; ============================================================================
;;; ---------------- [Tab] を 同時打鍵のキーとして使用する
;;; ============================================================================

#If ( mod_key[window_title, "_tab"] )
    sc00F::

        onKeyDown("_tab")

	return


#If ( true_mod_key[window_title, "_tab"] )
    sc00F & sc002::
    sc00F & sc003::
    sc00F & sc004::
    sc00F & sc005::
    sc00F & sc006::
    sc00F & sc007::
    sc00F & sc008::
    sc00F & sc009::
    sc00F & sc00A::
    sc00F & sc00B::
    sc00F & sc00C::
    sc00F & sc00D::
    sc00F & sc07D::
    sc00F & sc010::
    sc00F & sc011::
    sc00F & sc012::
    sc00F & sc013::
    sc00F & sc014::
    sc00F & sc015::
    sc00F & sc016::
    sc00F & sc017::
    sc00F & sc018::
    sc00F & sc019::
    sc00F & sc01A::
    sc00F & sc01B::
    sc00F & sc01E::
    sc00F & sc01F::
    sc00F & sc020::
    sc00F & sc021::
    sc00F & sc022::
    sc00F & sc023::
    sc00F & sc024::
    sc00F & sc025::
    sc00F & sc026::
    sc00F & sc027::
    sc00F & sc028::
    sc00F & sc02B::
    sc00F & sc02C::
    sc00F & sc02D::
    sc00F & sc02E::
    sc00F & sc02F::
    sc00F & sc030::
    sc00F & sc031::
    sc00F & sc032::
    sc00F & sc033::
    sc00F & sc034::
    sc00F & sc035::
    sc00F & sc073::

        onKeyDown("_tab")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))

    return



