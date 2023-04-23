#If
/*
;;; ============================================================================
;;; 同時に打鍵する配列だが、
;;; 真に同時に打鍵する配列ではないとき
;;; ============================================================================

#If (( mod_key[window_title, "_esc"] 
		and !( true_mod_key[window_title, "_esc"] ) ))
    sc001::
            onKeyDown("_esc")

    return


;;; ============================================================================
;;; 真に同時に打鍵する配列のとき
;;; ============================================================================

#If ( true_mod_key[window_title, "_esc"] )
	sc001 up::
		;; up を取り除く
	    key_up("esc", PF_Count())
	    return


	sc001::
		;; 真に同時に打鍵するキーのリスト
		key_down("esc", PF_Count(), true_mod_key[window_title, "_esc"])
	    return

*/

/*
 * 2011-02-15 : 2011-02-01時点の処理に戻した
 */

#If ( mod_key[window_title, "_esc"] )
    sc001::
        onKeyDown("_esc")
    return


#If ( true_mod_key[window_title, "_esc"] )
    sc001 & sc002::
    sc001 & sc003::
    sc001 & sc004::
    sc001 & sc005::
    sc001 & sc006::
    sc001 & sc007::
    sc001 & sc008::
    sc001 & sc009::
    sc001 & sc00A::
    sc001 & sc00B::
    sc001 & sc00C::
    sc001 & sc00D::
    sc001 & sc07D::
    sc001 & sc010::
    sc001 & sc011::
    sc001 & sc012::
    sc001 & sc013::
    sc001 & sc014::
    sc001 & sc015::
    sc001 & sc016::
    sc001 & sc017::
    sc001 & sc018::
    sc001 & sc019::
    sc001 & sc01A::
    sc001 & sc01B::
    sc001 & sc01E::
    sc001 & sc01F::
    sc001 & sc020::
    sc001 & sc021::
    sc001 & sc022::
    sc001 & sc023::
    sc001 & sc024::
    sc001 & sc025::
    sc001 & sc026::
    sc001 & sc027::
    sc001 & sc028::
    sc001 & sc02B::
    sc001 & sc02C::
    sc001 & sc02D::
    sc001 & sc02E::
    sc001 & sc02F::
    sc001 & sc030::
    sc001 & sc031::
    sc001 & sc032::
    sc001 & sc033::
    sc001 & sc034::
    sc001 & sc035::
    sc001 & sc073::
        onKeyDown("_esc")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))
    return
