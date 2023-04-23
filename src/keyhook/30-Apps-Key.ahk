#If
/*
;;; ============================================================================
;;; 同時に打鍵する配列だが、
;;; 真に同時に打鍵する配列ではないとき
;;; ============================================================================

#If (( mod_key[window_title, "_" . A_ThisHotkey] 
		and !( true_mod_key[window_title, "_" . A_ThisHotkey] ) ))
    AppsKey::
            onKeyDown("_appskey")

    return

;;; ============================================================================
;;; 真に同時に打鍵する配列のとき
;;; ============================================================================

	key_down_and_up.ahk に移した
*/

/*
 * 2011-02-15 : 2011-02-01時点の処理に戻した
 */


#If ( mod_key[window_title, "_" . A_ThisHotkey] )
    AppsKey::
            onKeyDown("_appskey")

    return

#If ( true_mod_key[window_title, "_appskey"] )

    AppsKey & sc002::
    AppsKey & sc003::
    AppsKey & sc004::
    AppsKey & sc005::
    AppsKey & sc006::
    AppsKey & sc007::
    AppsKey & sc008::
    AppsKey & sc009::
    AppsKey & sc00A::
    AppsKey & sc00B::
    AppsKey & sc00C::
    AppsKey & sc00D::
    AppsKey & sc07D::
    AppsKey & sc010::
    AppsKey & sc011::
    AppsKey & sc012::
    AppsKey & sc013::
    AppsKey & sc014::
    AppsKey & sc015::
    AppsKey & sc016::
    AppsKey & sc017::
    AppsKey & sc018::
    AppsKey & sc019::
    AppsKey & sc01A::
    AppsKey & sc01B::
    AppsKey & sc01E::
    AppsKey & sc01F::
    AppsKey & sc020::
    AppsKey & sc021::
    AppsKey & sc022::
    AppsKey & sc023::
    AppsKey & sc024::
    AppsKey & sc025::
    AppsKey & sc026::
    AppsKey & sc027::
    AppsKey & sc028::
    AppsKey & sc02B::
    AppsKey & sc02C::
    AppsKey & sc02D::
    AppsKey & sc02E::
    AppsKey & sc02F::
    AppsKey & sc030::
    AppsKey & sc031::
    AppsKey & sc032::
    AppsKey & sc033::
    AppsKey & sc034::
    AppsKey & sc035::
    AppsKey & sc073::
        onKeyDown("_appskey")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))

    return
