#If
/*
;;; ============================================================================
;;; 同時に打鍵する配列だが、
;;; 真に同時に打鍵する配列ではないとき
;;; ============================================================================

#If (( mod_key[window_title, "_space"] 
		and !( true_mod_key[window_title, "_space"] ) ))
    Space::
            onKeyDown("_space")
    return


;;; ============================================================================
;;; 真に同時に打鍵する配列のとき
;;; ============================================================================

#If ( true_mod_key[window_title, "_space"] )
	Space up::
		;; up を取り除く
	    key_up("space", PF_Count())
	    return


	Space::
		;; 真に同時に打鍵するキーのリスト
		key_down("space", PF_Count(), true_mod_key[window_title, "_space"])
	    return
*/

;;; ============================================================================
;;; ---------------- [Space] を 同時打鍵のキーとして使用する
;;; ============================================================================

#If ( mod_key[window_title, "_space"] )
    Space::
        onKeyDown("_space")
    return

;;; ============================================================================
;;; ---------------- [Space] を [Shift] とする
;;; ============================================================================

#If ( true_mod_key[window_title, "_space"] )
    Space up::
        onKeyDown("_space")
    return

    Space::return

    Space & sc002::
    Space & sc003::
    Space & sc004::
    Space & sc005::
    Space & sc006::
    Space & sc007::
    Space & sc008::
    Space & sc009::
    Space & sc00A::
    Space & sc00B::
    Space & sc00C::
    Space & sc00D::
    Space & sc07D::
    Space & sc010::
    Space & sc011::
    Space & sc012::
    Space & sc013::
    Space & sc014::
    Space & sc015::
    Space & sc016::
    Space & sc017::
    Space & sc018::
    Space & sc019::
    Space & sc01A::
    Space & sc01B::
    Space & sc01E::
    Space & sc01F::
    Space & sc020::
    Space & sc021::
    Space & sc022::
    Space & sc023::
    Space & sc024::
    Space & sc025::
    Space & sc026::
    Space & sc027::
    Space & sc028::
    Space & sc02B::
    Space & sc02C::
    Space & sc02D::
    Space & sc02E::
    Space & sc02F::
    Space & sc030::
    Space & sc031::
    Space & sc032::
    Space & sc033::
    Space & sc034::
    Space & sc035::
    Space & sc073::

        onKeyDown("_space")
        onKeyDown("_" . get_last_sc_key( A_ThisHotkey ))

    return


;;; ============================================================================
;;; ---------------- skkime 対策
;;; ============================================================================

#if ( !( mod_key[window_title, "_space"] ) and ( Is_skkime_mode ) )

    space::

        ;; vista で skkime を使うと IME の入力モードを正常に返さない不具合あり
        ;; 対処法として次の処理を考えた

        ;; skkime 使用時に space が押されたら
        ;; 日本語配列に切り替える
        ;; すなわち、IME を有効にする
        If ( ( Is_skkime_mode ) and ( Is_skkime_temp_english_layout ) )
        {
            nJapaneseLayoutMode := Is_skkime_temp_english_layout
            Is_skkime_temp_english_layout = 0
        }


        ;; skkime で文字を変換中
        If ( bIME_Converting )
        {
            ;; x を単独で出力するためにフラグを立てる
            Is_skkime_ConvPrevSpace = 1
        }

        send( "{space}" )
    return


;;; ============================================================================
;;; ---------------- [Space] を [Shift] とする
;;; ============================================================================

#If ( !( mod_key[window_title, "_space"] )
    and ( is_SandS ) )


    Space & sc001::  ; esc
    Space & sc00F::  ; tab
    Space & sc03A::  ; caps lock
    Space & sc00E::  ; backspace
    Space & sc01C::  ; enter
    Space & LWin::
    Space & RWin::
    Space & sc07B:: ; 無変換
    Space & sc079:: ; 変換
    Space & sc070:: ; かな
    Space & AppsKey:: ; メニュー
    Space & Left:: ; ←
    Space & Right:: ; →
    Space & Up:: ; ↑
    Space & Down:: ; ↓
    Space & Home:: ; home
    Space & End:: ; end
    Space & PgUp:: ; page up
    Space & PgDn:: ; page down
    Space & Insert:: ; insert
    Space & Delete:: ; delete
    Space & PrintScreen:: ; print screen
    Space & ScrollLock:: ; scroll lock
    Space & Pause::  ; pause

		the_key := get_last_sc_key( A_ThisHotkey )

        if ( Get_key_mode( Get_key_number( Trim(the_key, "Space & ") ), lang_mode ) ) {
            key_number := Get_key_number( Trim(the_key, "Space & ") )

            output_in_accordance_with_the_pull_down_setting( Get_key_mode( key_number, lang_mode )
                              , Get_key_output_text( key_number, lang_mode )
                              , "+" . get_modified_keys_pressed_down())
        } else {
			RegExMatch(A_ThisHotkey, "(.+) & (.+)", match_)
            send( "+{" . the_key . "}" )
        }
    return


    space up::
        send("{space}")
    return


    Space & sc002::
    Space & sc003::
    Space & sc004::
    Space & sc005::
    Space & sc006::
    Space & sc007::
    Space & sc008::
    Space & sc009::
    Space & sc00A::
    Space & sc00B::
    Space & sc00C::
    Space & sc00D::
    Space & sc07D::
    Space & sc010::
    Space & sc011::
    Space & sc012::
    Space & sc013::
    Space & sc014::
    Space & sc015::
    Space & sc016::
    Space & sc017::
    Space & sc018::
    Space & sc019::
    Space & sc01A::
    Space & sc01B::
    Space & sc01E::
    Space & sc01F::
    Space & sc020::
    Space & sc021::
    Space & sc022::
    Space & sc023::
    Space & sc024::
    Space & sc025::
    Space & sc026::
    Space & sc027::
    Space & sc028::
    Space & sc02B::
    Space & sc02C::
    Space & sc02D::
    Space & sc02E::
    Space & sc02F::
    Space & sc030::
    Space & sc031::
    Space & sc032::
    Space & sc033::
    Space & sc034::
    Space & sc035::
    Space & sc073::

		sc_key := get_last_sc_key( A_ThisHotkey )

        if ( ( muhenkan_henkan_results_of_KCmb[window_title, "_muhenkan"] )
            and (GetKeyState("sc07B", "P")) ) { ; [無変換] + [文字]
            send( get_modified_keys_pressed_down() . "+" . muhenkan_henkan_results_of_KCmb[window_title, "_muhenkan_" . sc_key] )
            
            return
        } 
        
        
        if ( ( muhenkan_henkan_results_of_KCmb[window_title,"_henkan"] )
            and (GetKeyState("sc079", "P")) ) { ; [変換] + [文字]
            send( get_modified_keys_pressed_down() . "+" . muhenkan_henkan_results_of_KCmb[window_title, "_henkan_" . sc_key] )
            return
        }
            
            
        if ( get_modified_keys_pressed_down() ) { ; 修飾キー付き
            SendMultipleKeys( sc_key
                            , "+" . get_modified_keys_pressed_down())
                            return
        }
            
            
        if (bIME) {
            GoSub, Send_JapaneseLayout_shift
        } else {
            GoSub, Send_EnglishLayout_shift
        }

    return