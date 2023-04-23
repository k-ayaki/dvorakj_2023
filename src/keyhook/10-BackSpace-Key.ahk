#If
/*
;;; ============================================================================
;;; 同時に打鍵する配列だが、
;;; 真に同時に打鍵する配列ではないとき
;;; ============================================================================

#If (( mod_key[window_title, "_backspace"] 
		and !( true_mod_key[window_title, "_backspace"] ) ))
    sc00E::
            onKeyDown("_backspace")

    return


;;; ============================================================================
;;; 真に同時に打鍵する配列のとき
;;; ============================================================================

#If ( true_mod_key[window_title, "_backspace"] )
	sc00E up::
		;; up を取り除く
	    key_up("backspace", PF_Count())
	    return


	sc00E::
		;; 真に同時に打鍵するキーのリスト
		key_down("backspace", PF_Count(), true_mod_key[window_title, "_backspace"])
	    return
*/


;;; ============================================================================
;;; 順に打鍵する配列で、直前のキーストロークを取り除く
;;; ============================================================================

#If ( !( mod_key[window_title, "_backspace"] ) )
    *sc00E::
    	;; >^BS だけでは RCtrl と BS で不具合が生じるので、{blind}を付加する
    	;; また、^bs でも、RCtrl と BS で不具合が生じてしまうので、同様に処理する
    	option := ("ja" = Get_languege_name()) ? "{blind}" : get_modified_keys_pressed_down()
        send( remove_sequential_strokes( option . "{backspace}" ) )
    return


/*
 * 2011-02-15 : 2011-02-01時点の処理に戻した
 */


#If ( mod_key[window_title, "_backspace"] )

    sc00E::
        onKeyDown("_backspace")
    return


#If ( true_mod_key[window_title, "_backspace"] )

    sc00E & sc002::
    sc00E & sc003::
    sc00E & sc004::
    sc00E & sc005::
    sc00E & sc006::
    sc00E & sc007::
    sc00E & sc008::
    sc00E & sc009::
    sc00E & sc00A::
    sc00E & sc00B::
    sc00E & sc00C::
    sc00E & sc00D::
    sc00E & sc07D::
    sc00E & sc010::
    sc00E & sc011::
    sc00E & sc012::
    sc00E & sc013::
    sc00E & sc014::
    sc00E & sc015::
    sc00E & sc016::
    sc00E & sc017::
    sc00E & sc018::
    sc00E & sc019::
    sc00E & sc01A::
    sc00E & sc01B::
    sc00E & sc01E::
    sc00E & sc01F::
    sc00E & sc020::
    sc00E & sc021::
    sc00E & sc022::
    sc00E & sc023::
    sc00E & sc024::
    sc00E & sc025::
    sc00E & sc026::
    sc00E & sc027::
    sc00E & sc028::
    sc00E & sc02B::
    sc00E & sc02C::
    sc00E & sc02D::
    sc00E & sc02E::
    sc00E & sc02F::
    sc00E & sc030::
    sc00E & sc031::
    sc00E & sc032::
    sc00E & sc033::
    sc00E & sc034::
    sc00E & sc035::
    sc00E & sc073::

        onKeyDown("_backspace")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))

    return

