;;; lang_mode により、半角英数などの入力時に直接入力用の配列をただしく使用するようにする
;;; Parkyの作者のコメントを参照
;;; http://d.hatena.ne.jp/blechmusik2/20110118#c1295489720


;;; IME が有効で、かつ [Shift] を押し下げていないとき
;;;

Send_JapaneseLayout_non-shift:
    ;; 独自のショートカットキーを使用するとき
    If ( is_User_Shortcut_Key ) {
        exit_at_once := send_user_shortcutkey("{sc0" . GetScanCode_ThisCharKey("h") . "}")

        if ( exit_at_once ) {
            return
        }
    }


    If ( Is_via_other_subroutine ) {
        Is_via_other_subroutine =
    } else {
        sc_key := GetScanCode_ThisCharKey()
        sc_hex := GetScanCode_ThisCharKey("h")
    }


    ;; skkime 用設定
    if ( Is_skkime_mode ) {
        ;; vista で skkime を使うと IME の入力モードを正常に返さない不具合あり
        ;; 対処法として次の処理を考えた
        sc_hex := GetScanCode_ThisCharKey("h")
        skkime_key := results_of_English_KCmb[window_title, "_" . A_ThisHotkey]


        ;; skkime 使用時に / が押されたら
        ;; 日本語入力を常に使用しない
        If ( skkime_key = skkime_abbrev_mode_key ) {
            Is_skkime_temp_english_layout := nJapaneseLayoutMode
            nJapaneseLayoutMode = 1
            send( skkime_abbrev_mode_key )
            Exit
        }

        ;; skkime で文字を変換中で、かつ直前に {Space} が送信されたとき
        If ( ( bIME_Converting )
         && ( Is_skkime_ConvPrevSpace ) ) {
            ;; 変換の前候補を表示させるため
            ;; x を出力してスレッドを終了する
            if ( skkime_key = skkime_previous_candidate_key ) {
                send( skkime_previous_candidate_key )
                Exit
            } else {
                Is_skkime_ConvPrevSpace = 0
            }
        }
    }

    If (    ( bIME )
        && ( IME_ConvMode < 16  ) ; かな入力
        && ( !( Is_kana_typing_mode ) ) ; 「かな入力で日本語入力を使用」しないとき
        && ( !( Is_skkime_mode ) )  ; 「skkime を使用中」でないとき(skkime モード誤判定回避のため)
        && ( !( Is_googleime_mode ) ) ) { ; 「google日本語入力 を使用中」でないとき(google日本語入力誤判定回避のため)

        send( "{" . sc_key . "}" )
        
        return
    }


    onKeyDown( "_" . A_ThisHotkey, lang_mode )
return


    ;; ====================================================================== 
;;; IME が有効で、かつ [Shift] を押し下げているとき
Send_JapaneseLayout_shift:
    ;; 独自のショートカットキーを使用するとき
    If ( is_User_Shortcut_Key ) {
        exit_at_once := send_user_shortcutkey("+{sc0" . GetScanCode_ThisCharKey("h") . "}")

        if ( exit_at_once ) {
            return
        }
    }


    If ( Is_via_other_subroutine ) {
        Is_via_other_subroutine = 
    } else {
        sc_key := get_last_sc_key( A_ThisHotkey )
    }

    ; skkime を使用するとき
    If ( Is_skkime_mode ) {
        bStrokes_not_yet_sent = 1
        temp_thisSequence := thisSequence

        send_str_by_sequential_strokes("_shift_" . sc_key, "jp" )

        if ( bStrokes_not_yet_sent )
        {
            thisSequence := temp_thisSequence

            if ( bUsingSKKIME ) {
                bSKKIME_shift = 1
                send_str_by_sequential_strokes("_" . sc_key, "jp" )
            } else {
                ;; 直接入力用の配列を出力する
                onKeyDown( "_shift_" . sc_key, "en" )
            }
        }

        exit
    }



    If ( bIME
        && ( IME_ConvMode < 16  ) ; かな入力
        && ( !( Is_kana_typing_mode ) ) ; 「かな入力で日本語入力を使用」しないとき
        && ( !( Is_googleime_mode ) ) ) { ; 「google日本語入力 を使用中」でないとき(google日本語入力誤判定回避のため)
            send( "+{" . sc_key . "}" )
        
        Return
    }
    


    ;; 同時打鍵の配列で
    ;; shift キーを使用するものについては、
    ;; shift + 文字キーという動作を
    ;; shift キーを押した後に文字キーを素早く押したことにする
    If ( Japanese_mod_key[window_title, "_shift"] ) {

        ;; "_shift" が a_buffer にあるならば
        ;; a_buffer に "_shift" を入れない
        if ( arr_bufKey.indexOf("_shift")) {
            onKeyDown( "_" . sc_key, lang_mode )
        } else {
            onKeyDown( "_shift", lang_mode )
            onKeyDown( "_" . sc_key, lang_mode )
        }
        
        Return
    }
    
    ;; 日本語入力で [Shift] + [文字] を設定していないときに「何も出力しない」
    if ( Is_with_Shift_outputting_nothing ) {
        return
    } 
        
        
    If ( is_ShiftPlusAlphabetMode ) { ; IME を無効にして出力する
        IME_SET( 0 )

        onKeyDown( "_shift", "en" )
        onKeyDown( "_" . sc_key, "en" )
        
        return
    } 
        
    if ( Is_kana_typing_mode ) { ; 日本語入力（かな入力）
        ;; 一時的に「英数モード」に切り替える

        ;; CapsLockを出力する、つまり英数モードに移行する
        send("{vkf0sc03A Down}")

        onKeyDown( "_shift", "en" )
        onKeyDown( "_" . sc_key, "en" )
        ;; CapsLockを出力する、つまり英数モードを解除する
        send("{vkf0sc03A}")
        
        Return
    }

    
    onKeyDown( "_shift", "en" )
    onKeyDown( "_" . sc_key, "en" )
return
