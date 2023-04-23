;;; ============================================================================
;;; ---------------- [Zenkaku] を 同時打鍵のキーとして使用する
;;; ============================================================================

#If ( mod_key[window_title, "_zenkaku"] )
    sc029::
        onKeyDown("_zenkaku")
    return

;;; ============================================================================
;;; ---------------- [変換] + [文字] を使用する
;;; ============================================================================

/*
#If ( true_mod_key[window_title, "_zenkaku"] )
    sc029 up::
        onKeyDown("_zenkaku")
    return

    sc029::return
    sc029 & sc002::
    sc029 & sc003::
    sc029 & sc004::
    sc029 & sc005::
    sc029 & sc006::
    sc029 & sc007::
    sc029 & sc008::
    sc029 & sc009::
    sc029 & sc00A::
    sc029 & sc00B::
    sc029 & sc00C::
    sc029 & sc00D::
    sc029 & sc07D::
    sc029 & sc010::
    sc029 & sc011::
    sc029 & sc012::
    sc029 & sc013::
    sc029 & sc014::
    sc029 & sc015::
    sc029 & sc016::
    sc029 & sc017::
    sc029 & sc018::
    sc029 & sc019::
    sc029 & sc01A::
    sc029 & sc01B::
    sc029 & sc01E::
    sc029 & sc01F::
    sc029 & sc020::
    sc029 & sc021::
    sc029 & sc022::
    sc029 & sc023::
    sc029 & sc024::
    sc029 & sc025::
    sc029 & sc026::
    sc029 & sc027::
    sc029 & sc028::
    sc029 & sc02B::
    sc029 & sc02C::
    sc029 & sc02D::
    sc029 & sc02E::
    sc029 & sc02F::
    sc029 & sc030::
    sc029 & sc031::
    sc029 & sc032::
    sc029 & sc033::
    sc029 & sc034::
    sc029 & sc035::
    sc029 & sc073::

        onKeyDown("_zenkaku")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))
    return
*/



;; 英語配列のキーボードを使用していないときで
;; 単一キーとして新たな機能を何かしら割り当てているとき
#If ( !( mod_key[window_title, "_zenkaku"] ) 
    and !( is_US_keyboard )
    and ( Get_key_mode( Get_key_number( A_ThisHotkey ), lang_mode ) ) )

    sc029::


        key_number := Get_key_number( A_ThisHotkey )


        output_in_accordance_with_the_pull_down_setting( Get_key_mode( key_number, lang_mode )
                          , Get_key_output_text( key_number, lang_mode ) )
    return


;; 英語配列のキーボードを使用しているときで
#If ( !( mod_key[window_title, "_zenkaku"] ) 
    and ( is_US_keyboard ))

    sc029::


        if ( bIME ) {
            GoSub, Send_JapaneseLayout_non-shift
        } else {
            GoSub, Send_EnglishLayout_non-shift
        }
    return



#If ( is_US_keyboard )
    +sc029::


        if ( bIME ) {
            GoSub, Send_JapaneseLayout_shift
        } else {
            GoSub, Send_EnglishLayout_shift
        }
    return

    *sc029:: ; \ と _


        GoTo, subroutine_multiple_keys
    return

#If (( is_US_keyboard ) 
        and (is_SandS) )
    Space & sc029::

        if ( bIME ) {
            GoSub, Send_JapaneseLayout_shift
        } else {
            GoSub, Send_EnglishLayout_shift
        }
    return

#If