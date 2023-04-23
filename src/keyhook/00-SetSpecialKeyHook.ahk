SetMultiSpecialKeyHook(p_option = 0) {
    global English_mod_key
    global Japanese_mod_key

    global English_true_mod_key
    global Japanese_true_mod_key

    global mod_key := Object()
    global true_mod_key := Object()

    global window_title

    ;; static
    static prospective_mod_keys := Array("_shift"
                                        , "_space"
                                        , "_backspace"
                                        , "_tab"
                                        , "_esc"
                                        , "_zenkaku"
                                        , "_capslock"
                                        , "_muhenkan"
                                        , "_henkan"
                                        , "_kana"
                                        , "_appskey"
                                        , "_lwin"
                                        , "_rwin"
                                        , "_lalt"
                                        , "_ralt"
                                        , "_sc002"
                                        , "_sc003"
                                        , "_sc004"
                                        , "_sc005"
                                        , "_sc006"
                                        , "_sc007"
                                        , "_sc008"
                                        , "_sc009"
                                        , "_sc00A"
                                        , "_sc00B"
                                        , "_sc00C"
                                        , "_sc00D"
                                        , "_sc07D"
                                        , "_sc010"
                                        , "_sc011"
                                        , "_sc012"
                                        , "_sc013"
                                        , "_sc014"
                                        , "_sc015"
                                        , "_sc016"
                                        , "_sc017"
                                        , "_sc018"
                                        , "_sc019"
                                        , "_sc01A"
                                        , "_sc01B"
                                        , "_sc01E"
                                        , "_sc01F"
                                        , "_sc020"
                                        , "_sc021"
                                        , "_sc022"
                                        , "_sc023"
                                        , "_sc024"
                                        , "_sc025"
                                        , "_sc026"
                                        , "_sc027"
                                        , "_sc028"
                                        , "_sc02B"
                                        , "_sc02C"
                                        , "_sc02D"
                                        , "_sc02E"
                                        , "_sc02F"
                                        , "_sc030"
                                        , "_sc031"
                                        , "_sc032"
                                        , "_sc033"
                                        , "_sc034"
                                        , "_sc035"
                                        , "_sc073")


    if ( IsObject( mod_key[window_title] ) ) {
        mod_key[window_title] := Object()
    }

    lang_name := (p_option = 1 ) ? "English"  ; 直接入力用配列
                                 : "Japanese" ; 日本語入力用配列

    mod_num := 0
    true_mod_num := 0


    for index,flagname in prospective_mod_keys {
        if ( ( %lang_name%_mod_key[window_title, flagname] )
          or ( %lang_name%_mod_key[window_title, "_True" . LTrim(flagname, "_") ] ) ) {
            mod_num += 1
            mod_key[window_title, flagname] := True
        } else {
            mod_key[window_title, flagname] := False
        }

        if ( %lang_name%_true_mod_key[window_title, flagname] ) {
            true_mod_num += 1
            true_mod_key[window_title, flagname] := True

        } else {
            true_mod_key[window_title, flagname] := False
        }
    }



    mod_key[window_title, "num"] := mod_num
    true_mod_key[window_title, "num"] := true_mod_num

    return
}
