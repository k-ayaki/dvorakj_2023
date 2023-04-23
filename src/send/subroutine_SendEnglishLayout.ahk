; IME が無効で、かつ [Shift] を押し下げていないとき
Send_EnglishLayout_non-shift:
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

    onKeyDown( "_" . A_ThisHotkey, "en" )
return



; IME が無効で、かつ [Shift] を押し下げているとき
Send_EnglishLayout_shift:
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


    ;; "_shift" が a_buffer にあるならば
    ;; a_buffer に "_shift" を入れない
    if ( arr_bufKey.indexOf("_shift")) {
        onKeyDown( "_" . sc_key, "en" )
        
        return
    }
    
    onKeyDown( "_shift", "en" )
    onKeyDown( "_" . sc_key, "en" )
return