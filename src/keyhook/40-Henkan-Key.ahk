#If
/*
;;; ============================================================================
;;; 同時に打鍵する配列だが、
;;; 真に同時に打鍵する配列ではないとき
;;; ============================================================================

#If (( mod_key[window_title, "_henkan"] 
		and !( true_mod_key[window_title, "_henkan"] ) ))
    sc079::

            onKeyDown("_henkan")

    return

;;; ============================================================================
;;; 真に同時に打鍵する配列のとき
;;; ============================================================================

#If ( true_mod_key[window_title, "_henkan"] )
	sc079 up::
		;; up を取り除く
	    key_up("henkan", PF_Count())
	    return


	sc079::
		;; 真に同時に打鍵するキーのリスト
		key_down("henkan", PF_Count(), true_mod_key[window_title, "_henkan"])
	    return
*/
;;; ============================================================================
;;; ---------------- 文字キーのように [変換] を使用する
;;; ============================================================================

#If ( mod_key[window_title, "_henkan"] )

    sc079::
        onKeyDown("_henkan")
    return



;;; ============================================================================
;;; ---------------- [変換] + [文字] を使用する
;;; ============================================================================

#If ( true_mod_key[window_title, "_henkan"] )
    sc079 up::
        onKeyDown("_henkan")
    return

    sc079::return

    sc079 & sc002::
    sc079 & sc003::
    sc079 & sc004::
    sc079 & sc005::
    sc079 & sc006::
    sc079 & sc007::
    sc079 & sc008::
    sc079 & sc009::
    sc079 & sc00A::
    sc079 & sc00B::
    sc079 & sc00C::
    sc079 & sc00D::
    sc079 & sc07D::
    sc079 & sc010::
    sc079 & sc011::
    sc079 & sc012::
    sc079 & sc013::
    sc079 & sc014::
    sc079 & sc015::
    sc079 & sc016::
    sc079 & sc017::
    sc079 & sc018::
    sc079 & sc019::
    sc079 & sc01A::
    sc079 & sc01B::
    sc079 & sc01E::
    sc079 & sc01F::
    sc079 & sc020::
    sc079 & sc021::
    sc079 & sc022::
    sc079 & sc023::
    sc079 & sc024::
    sc079 & sc025::
    sc079 & sc026::
    sc079 & sc027::
    sc079 & sc028::
    sc079 & sc02B::
    sc079 & sc02C::
    sc079 & sc02D::
    sc079 & sc02E::
    sc079 & sc02F::
    sc079 & sc030::
    sc079 & sc031::
    sc079 & sc032::
    sc079 & sc033::
    sc079 & sc034::
    sc079 & sc035::
    sc079 & sc073::

        onKeyDown("_henkan")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))
    return


;;; ============================================================================
;;; ---------------- [変換] + [文字] を使用する
;;; ============================================================================

#If (!( mod_key[window_title, "_henkan"] )
	and ( muhenkan_henkan_results_of_KCmb[window_title, "_henkan"] ))

    sc079 & sc002::
    sc079 & sc003::
    sc079 & sc004::
    sc079 & sc005::
    sc079 & sc006::
    sc079 & sc007::
    sc079 & sc008::
    sc079 & sc009::
    sc079 & sc00A::
    sc079 & sc00B::
    sc079 & sc00C::
    sc079 & sc00D::
    sc079 & sc07D::
    sc079 & sc010::
    sc079 & sc011::
    sc079 & sc012::
    sc079 & sc013::
    sc079 & sc014::
    sc079 & sc015::
    sc079 & sc016::
    sc079 & sc017::
    sc079 & sc018::
    sc079 & sc019::
    sc079 & sc01A::
    sc079 & sc01B::
    sc079 & sc01E::
    sc079 & sc01F::
    sc079 & sc020::
    sc079 & sc021::
    sc079 & sc022::
    sc079 & sc023::
    sc079 & sc024::
    sc079 & sc025::
    sc079 & sc026::
    sc079 & sc027::
    sc079 & sc028::
    sc079 & sc02B::
    sc079 & sc02C::
    sc079 & sc02D::
    sc079 & sc02E::
    sc079 & sc02F::
    sc079 & sc030::
    sc079 & sc031::
    sc079 & sc032::
    sc079 & sc033::
    sc079 & sc034::
    sc079 & sc035::
    sc079 & sc073::
        send( get_modified_keys_pressed_down()
				. muhenkan_henkan_results_of_KCmb[window_title, "_henkan" . "_" . get_last_sc_key( A_ThisHotkey )] )

    return
