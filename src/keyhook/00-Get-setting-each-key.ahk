#If
;;; [全角/半角]キーの設定においては US_keyboard の状態も重要になる
;;; ZenkakuKey.ahk を参照
#If ( !( is_US_keyboard ) 
    and ( Get_key_mode( Get_key_number( Trim(A_ThisHotkey, "*") ), lang_mode ) ) )

;    sc029::  ; zenkaku
    *sc029::  ; zenkaku

            key_number := Get_key_number( Trim(A_ThisHotkey, "*") )

            output_in_accordance_with_the_pull_down_setting( Get_key_mode( key_number, lang_mode )
                              , Get_key_output_text( key_number, lang_mode ) )
    return



#If ( ( Get_key_mode( Get_key_number(Trim(A_ThisHotkey, "*")), lang_mode ) ) 
    and !(mod_key[window_title, scancode_to_keyname(Trim(A_ThisHotkey, "*"))]))


    sc001::  ; esc
    sc00F::  ; tab
    sc03A::  ; caps lock
    sc00E::  ; backspace
    sc01C::  ; enter
    LWin::
    RWin::
    space::
    sc07B:: ; 無変換
    sc079:: ; 変換
    sc070:: ; かな
    AppsKey:: ; メニュー
    Left:: ; ←
    Right:: ; →
    Up:: ; ↑
    Down:: ; ↓
    Home:: ; home
    End:: ; end
    PgUp:: ; page up
    PgDn:: ; page down
    Insert:: ; insert
    Delete:: ; delete
    PrintScreen:: ; print screen
    ScrollLock:: ; scroll lock
    Pause::  ; pause
    *sc001::  ; esc
    *sc00F::  ; tab
    *sc03A::  ; caps lock
    *sc00E::  ; backspace
    *sc01C::  ; enter
    *LWin:: 
    *RWin:: 
    *space::  ; space
    *sc07B:: ; 無変換
    *sc079:: ; 変換
    *sc070:: ; かな
    *AppsKey:: ; メニュー
    *Left:: ; ←
    *Right:: ; →
    *Up:: ; ↑
    *Down:: ; ↓
    *Home:: ; home
    *End:: ; end
    *PgUp:: ; page up
    *PgDn:: ; page down
    *Insert:: ; insert
    *Delete:: ; delete
    *PrintScreen:: ; print screen
    *ScrollLock:: ; scroll lock
    *Pause::  ; pause

        key_number := Get_key_number( Trim(A_ThisHotkey, "*") )


        ;; output_in_accordance_with_the_pull_down_settingで
        output_in_accordance_with_the_pull_down_setting( Get_key_mode( key_number, lang_mode )
                          , Get_key_output_text( key_number, lang_mode ) )

    return


#If

;;; ---------------------------------------------
;;; ---------------------------------------------
;;; ---------------------------------------------


Get_key_mode( key_number, lang_mode = "en" ) {
    ;; キーに何かしらの設定が紐付けられているかどうかを調べる
    ;; 何も設定されていなければfalseを返し
    ;; 何かしら設定されているならばその機能を表す番号を返す

    global

    if ( key_number ) {
        ; 「そのまま」を選択しているとき
        if ( key_%key_number%_%lang_mode%_number = 1 ) {
            return false
        }
        
        return key_%key_number%_%lang_mode%_number
    }
    
    return False
}


Get_key_output_text( key_number, lang_mode = "en" ) {
    global

    return % key_%key_number%_%lang_mode%_text
}


Get_key_number( user_hotkey ) {
    return  % ( "sc001"       = user_hotkey) ?  1  ; esc
            : ( "sc029"       = user_hotkey) ?  2  ; zenkaku
            : ( "sc00F"       = user_hotkey) ?  3  ; tab
            : ( "sc03A"       = user_hotkey) ?  4  ; caps lock
            : ( "sc00E"       = user_hotkey) ?  5  ; backspace
            : ( "sc01C"       = user_hotkey) ?  6  ; enter
            : ( "LWin"        = user_hotkey) ?  7
            : ( "RWin"        = user_hotkey) ?  8
            : ( "space"       = user_hotkey) ?  9  ; space
            : ( "sc07B"       = user_hotkey) ? 10  ; 無変換
            : ( "sc079"       = user_hotkey) ? 11  ; 変換
            : ( "sc070"       = user_hotkey) ? 12  ; かな
            : ( "AppsKey"     = user_hotkey) ? 13  ; メニュー
            : ( "Left"        = user_hotkey) ? 14  ; ←
            : ( "Right"       = user_hotkey) ? 15  ; →
            : ( "Up"          = user_hotkey) ? 16  ; ↑
            : ( "Down"        = user_hotkey) ? 17  ; ↓
            : ( "Home"        = user_hotkey) ? 18
            : ( "End"         = user_hotkey) ? 19
            : ( "PgUp"        = user_hotkey) ? 20
            : ( "PgDn"        = user_hotkey) ? 21
            : ( "Insert"      = user_hotkey) ? 22
            : ( "Delete"      = user_hotkey) ? 23
            : ( "PrintScreen" = user_hotkey) ? 24
            : ( "ScrollLock"  = user_hotkey) ? 25
            : ( "Pause"       = user_hotkey) ? 26
            :  False
}


scancode_to_keyname(scancode) {
    return  % ( "sc001"       = scancode) ?  "_esc"
            : ( "sc029"       = scancode) ?  "_zenkaku"
            : ( "sc00F"       = scancode) ?  "_tab"
            : ( "sc03A"       = scancode) ?  "_capslock"
            : ( "sc00E"       = scancode) ?  "_backspace"
            ;; : ( "sc01C"       = scancode) ?  "_enter"
            : ( "LWin"        = scancode) ?  "_lwin"
            : ( "RWin"        = scancode) ?  "_rwin"
            : ( "space"       = scancode) ?  "_space"
            : ( "sc07B"       = scancode) ? "_muhenkan"
            : ( "sc079"       = scancode) ? "_henkan"
            : ( "sc070"       = scancode) ? "_kana"
            : ( "AppsKey"     = scancode) ? "_appskey"
            ;; : ( "Left"        = scancode) ? 14  ; ←
            ;; : ( "Right"       = scancode) ? 15  ; →
            ;; : ( "Up"          = scancode) ? 16  ; ↑
            ;; : ( "Down"        = scancode) ? 17  ; ↓
            ;; : ( "Home"        = scancode) ? 18
            ;; : ( "End"         = scancode) ? 19
            ;; : ( "PgUp"        = scancode) ? 20
            ;; : ( "PgDn"        = scancode) ? 21
            ;; : ( "Insert"      = scancode) ? 22
            ;; : ( "Delete"      = scancode) ? 23
            ;; : ( "PrintScreen" = scancode) ? 24
            ;; : ( "ScrollLock"  = scancode) ? 25
            ;; : ( "Pause"       = scancode) ? 26
            :  scancode
}


output_in_accordance_with_the_pull_down_setting( func_number
                    , user_text
                    , p_modifier_specified = "" ) {

    ;; CapsLock とひらがなキーを強制的に押し上げる
    ;; こうしないと、このキーを押し上げてもずっと押し下げたままだと認識されてしまう
    If ( A_ThisHotkey = "*SC03A" ) {
        send("{vkF0sc03A up}")
    }
    
    If ( A_ThisHotkey = "*SC070" ) {
        send("{vkF2sc070 up}")
    }


    if ( func_number = 5 ) { ; 直接入力にする
        IME_SET(0)
        Exit
    }
        
        
    if ( func_number = 6 ) { ; 日本語入力にする
        IME_SET(1)
        Exit
    }
    
 
    str :=    (  1 = func_number) ? ""
            ;; : ( 2 = func_number ) ? "　"
            : (  3 = func_number) ? ""
            ;; : ( 4 = func_number ) ? "　"
            ;; : ( 7 = func_number ) ? "　"
            : (  8 = func_number) ?  conv_str_for_sending("{←}")
            : (  9 = func_number) ?  conv_str_for_sending("{→}")
            : ( 10 = func_number) ?  conv_str_for_sending("{↑}")
            : ( 11 = func_number) ?  conv_str_for_sending("{↓}")
            ;; : ( 12 = func_number ) ? "　"
            : ( 13 = func_number) ? "{Home}"
            : ( 14 = func_number) ? "{End}"
            : ( 15 = func_number) ? "{PgUp}"
            : ( 16 = func_number) ? "{PgDn}"
            ;; : ( 17 = func_number ) ? "　"
            : ( 18 = func_number) ? "{ESC}"
            : ( 19 = func_number) ?  conv_str_for_sending("{全角}")
            : ( 20 = func_number) ? "{Tab}"
            : ( 21 = func_number) ? "{CapsLock}"
            ;; : ( 22 = func_number ) ? "　"
            : ( 23 = func_number) ? "{BackSpace}"
            : ( 24 = func_number) ? "{Enter}"
            ;; : ( 25 = func_number ) ? "　"
            : ( 26 = func_number) ? "{Space}"
            : ( 27 = func_number) ?  conv_str_for_sending("{無変換}")
            : ( 28 = func_number) ?  conv_str_for_sending("{変換}")
            : ( 29 = func_number) ?  conv_str_for_sending("{ひらがな}")
            : ( 30 = func_number) ?  conv_str_for_sending("{メニュー}")
            ;; : ( 31 = func_number ) ? "　"
            : ( 32 = func_number) ? "{Insert}"
            : ( 33 = func_number) ? "{Delete}"
            ;; : ( 34 = func_number ) ? "　"
            : conv_str_for_sending(user_text) ; ★独自の設定"


    if ( p_modifier_specified ) {
        send( remove_sequential_strokes( p_modifier_specified . str ) )
    } else {
        send( remove_sequential_strokes( get_modified_keys_pressed_down() . str ) )
    }

    return get_modified_keys_pressed_down() . str
}
