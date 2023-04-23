#If
/*
;;; ============================================================================
;;; 同時に打鍵する配列だが、
;;; 真に同時に打鍵する配列ではないとき
;;; ============================================================================

#If (( mod_key[window_title, "_muhenkan"] 
		and !( true_mod_key[window_title, "_muhenkan"] ) ))
    sc07B::

            onKeyDown("_muhenkan")

    return

;;; ============================================================================
;;; 真に同時に打鍵する配列のとき
;;; ============================================================================

#If ( true_mod_key[window_title, "_muhenkan"] )
	sc07B up::
		;; up を取り除く
	    key_up("muhenkan", PF_Count())
	    return


	sc07B::
		;; 真に同時に打鍵するキーのリスト
		key_down("muhenkan", PF_Count(), true_mod_key[window_title, "_muhenkan"])
	    return
*/
;;; ============================================================================
;;; ---------------- 文字キーのように [無変換] を使用する
;;; ============================================================================

#If ( mod_key[window_title, "_muhenkan"] )
    sc07B::
        onKeyDown("_muhenkan")

    return


;;; ============================================================================
;;; ---------------- [無変換] + [文字] を使用する
;;; ============================================================================

#If ( true_mod_key[window_title, "_muhenkan"] )
    sc07B up::
        onKeyDown("_muhenkan")
    return

    sc07B::return

    sc07B & sc002::
    sc07B & sc003::
    sc07B & sc004::
    sc07B & sc005::
    sc07B & sc006::
    sc07B & sc007::
    sc07B & sc008::
    sc07B & sc009::
    sc07B & sc00A::
    sc07B & sc00B::
    sc07B & sc00C::
    sc07B & sc00D::
    sc07B & sc07D::
    sc07B & sc010::
    sc07B & sc011::
    sc07B & sc012::
    sc07B & sc013::
    sc07B & sc014::
    sc07B & sc015::
    sc07B & sc016::
    sc07B & sc017::
    sc07B & sc018::
    sc07B & sc019::
    sc07B & sc01A::
    sc07B & sc01B::
    sc07B & sc01E::
    sc07B & sc01F::
    sc07B & sc020::
    sc07B & sc021::
    sc07B & sc022::
    sc07B & sc023::
    sc07B & sc024::
    sc07B & sc025::
    sc07B & sc026::
    sc07B & sc027::
    sc07B & sc028::
    sc07B & sc02B::
    sc07B & sc02C::
    sc07B & sc02D::
    sc07B & sc02E::
    sc07B & sc02F::
    sc07B & sc030::
    sc07B & sc031::
    sc07B & sc032::
    sc07B & sc033::
    sc07B & sc034::
    sc07B & sc035::
    sc07B & sc073::

        onKeyDown("_muhenkan")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))
    return


;;; ============================================================================
;;; ---------------- [無変換] + [文字] を使用する
;;; ============================================================================

#If (!( mod_key[window_title, "_muhenkan"] )
    and ( muhenkan_henkan_results_of_KCmb[window_title, "_muhenkan"] ))


    sc07B & sc002::
    sc07B & sc003::
    sc07B & sc004::
    sc07B & sc005::
    sc07B & sc006::
    sc07B & sc007::
    sc07B & sc008::
    sc07B & sc009::
    sc07B & sc00A::
    sc07B & sc00B::
    sc07B & sc00C::
    sc07B & sc00D::
    sc07B & sc07D::
    sc07B & sc010::
    sc07B & sc011::
    sc07B & sc012::
    sc07B & sc013::
    sc07B & sc014::
    sc07B & sc015::
    sc07B & sc016::
    sc07B & sc017::
    sc07B & sc018::
    sc07B & sc019::
    sc07B & sc01A::
    sc07B & sc01B::
    sc07B & sc01E::
    sc07B & sc01F::
    sc07B & sc020::
    sc07B & sc021::
    sc07B & sc022::
    sc07B & sc023::
    sc07B & sc024::
    sc07B & sc025::
    sc07B & sc026::
    sc07B & sc027::
    sc07B & sc028::
    sc07B & sc02B::
    sc07B & sc02C::
    sc07B & sc02D::
    sc07B & sc02E::
    sc07B & sc02F::
    sc07B & sc030::
    sc07B & sc031::
    sc07B & sc032::
    sc07B & sc033::
    sc07B & sc034::
    sc07B & sc035::
    sc07B & sc073::
        send( get_modified_keys_pressed_down()
				. muhenkan_henkan_results_of_KCmb[window_title, "_muhenkan" . "_" . get_last_sc_key( A_ThisHotkey )] )

    return
