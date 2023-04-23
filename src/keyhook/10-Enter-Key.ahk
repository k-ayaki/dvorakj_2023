;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"
#If
/*
;;; ============================================================================
;;; 同時に打鍵する配列だが、
;;; 真に同時に打鍵する配列ではないとき
;;; ============================================================================

#If (( mod_key[window_title, "_enter"] 
		and !( true_mod_key[window_title, "_enter"] ) ))
    sc01C::
            onKeyDown("_enter")

    return


;;; ============================================================================
;;; 真に同時に打鍵する配列のとき
;;; ============================================================================

#If ( true_mod_key[window_title, "_enter"] )
	sc01C up::
		;; up を取り除く
	    key_up("enter", PF_Count())
	    return


	sc01C::
		;; 真に同時に打鍵するキーのリスト
		key_down("enter", PF_Count(), true_mod_key[window_title, "_enter"])
	    return
*/


;;; ============================================================================
;;; 順に打鍵する配列で、直前のキーストロークを取り除く
;;; ============================================================================

#If ( !( mod_key[window_title, "_enter"] ) )

    *sc01C::
        send( remove_sequential_strokes( get_modified_keys_pressed_down() . "{enter}" ) )
    return


/*
 * 2011-02-15 : 2011-02-01時点の処理に戻した
 */


#If ( mod_key[window_title, "_enter"] )

    sc01C::
        onKeyDown("_enter")
    return


#If ( true_mod_key[window_title, "_enter"] )

    sc01C & sc002::
    sc01C & sc003::
    sc01C & sc004::
    sc01C & sc005::
    sc01C & sc006::
    sc01C & sc007::
    sc01C & sc008::
    sc01C & sc009::
    sc01C & sc00A::
    sc01C & sc00B::
    sc01C & sc00C::
    sc01C & sc00D::
    sc01C & sc07D::
    sc01C & sc010::
    sc01C & sc011::
    sc01C & sc012::
    sc01C & sc013::
    sc01C & sc014::
    sc01C & sc015::
    sc01C & sc016::
    sc01C & sc017::
    sc01C & sc018::
    sc01C & sc019::
    sc01C & sc01A::
    sc01C & sc01B::
    sc01C & sc01E::
    sc01C & sc01F::
    sc01C & sc020::
    sc01C & sc021::
    sc01C & sc022::
    sc01C & sc023::
    sc01C & sc024::
    sc01C & sc025::
    sc01C & sc026::
    sc01C & sc027::
    sc01C & sc028::
    sc01C & sc02B::
    sc01C & sc02C::
    sc01C & sc02D::
    sc01C & sc02E::
    sc01C & sc02F::
    sc01C & sc030::
    sc01C & sc031::
    sc01C & sc032::
    sc01C & sc033::
    sc01C & sc034::
    sc01C & sc035::
    sc01C & sc073::
        onKeyDown("_enter")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))

    return

