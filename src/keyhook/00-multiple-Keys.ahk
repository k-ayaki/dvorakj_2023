
#if ( get_state_of_modifier_and_key( A_ThisHotkey ) )
    *sc002:: ; 1
    *sc003:: ; 2
    *sc004:: ; 3
    *sc005:: ; 4
    *sc006:: ; 5
    *sc007:: ; 6
    *sc008:: ; 7
    *sc009:: ; 8
    *sc00A:: ; 9
    *sc00B:: ; 0
    *sc00C:: ; -
    *sc00D:: ; {^}
    *sc07D:: ; \ と |
    *sc010:: ; q
    *sc011:: ; w
    *sc012:: ; e
    *sc013:: ; r
    *sc014:: ; t
    *sc015:: ; y
    *sc016:: ; u
    *sc017:: ; i
    *sc018:: ; o
    *sc019:: ; p
    *sc01A:: ; @
    *sc01B:: ; [
    *sc01E:: ; a
    *sc01F:: ; s
    *sc020:: ; d
    *sc021:: ; f
    *sc022:: ; g
    *sc023:: ; h
    *sc024:: ; j
    *sc025:: ; k
    *sc026:: ; l
    *sc027:: ; ;
    *sc028:: ; :
    *sc02B:: ; ]
    *sc02C:: ; z
    *sc02D:: ; x
    *sc02E:: ; c
    *sc02F:: ; v
    *sc030:: ; b
    *sc031:: ; n
    *sc032:: ; m
    *sc033:: ; ,
    *sc034:: ; .
    *sc035:: ; /
    *sc073:: ; \ と _
/*
    *sc001::  ; esc
    *sc00F::  ; tab
    *sc03A::  ; caps lock
    *sc00E::  ; backspace
    *sc01C::  ; enter
    *LWin::
    *RWin::
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
    *LButton:: ; 左ボタン
    *RButton:: ; 右ボタン
    *MButton:: ; 中ボタン (ホイールクリック)
    *XButton1:: ; 拡張ボタン1 (戻る)
    *XButton2:: ; 拡張ボタン2 (進む)
    *WheelDown:: ; ホイール↓
    *WheelUp:: ; ホイール↑
    *WheelLeft:: ; チルト左
    *WheelRight:: ; チルト右
*/

        Goto, subroutine_multiple_keys
    return


subroutine_multiple_keys:
    SendMultipleKeys(get_last_sc_key( A_ThisHotkey )
                    , get_modified_keys_pressed_down())
return



SendMultipleKeys(sc_key
                , p_modifier_specified = "") {
    global bIME
    global arr_bufKey

    global is_User_Shortcut_Key

    global is_Using_QWERTY_with_CTRL
    global is_Using_QWERTY_with_Win
    global is_Using_QWERTY_with_Alt

    global results_of_English_KCmb

    global window_title

    global Is_skkime_mode
    global Is_skkime_temp_english_layout

    global nJapaneseLayoutMode
    global Japanese_mod_key

    global lang_mode

    if p_modifier_specified contains ^
        bCtrlDown := True
    if p_modifier_specified contains #
        bWinDown := True
    if p_modifier_specified contains !
        bAltDown := True
    if p_modifier_specified contains +
        bShiftDown := True



    this_key := ( ( is_Using_QWERTY_with_CTRL ) and ( bCtrlDown ) ) ? "{" . sc_key . "}"
            :   ( ( is_Using_QWERTY_with_Win ) and ( bWinDown ) ) ? "{" . sc_key . "}"
            :   ( ( is_Using_QWERTY_with_Alt ) and ( bAltDown ) ) ? "{" . sc_key . "}"
            :   get_value_of_KCmb_by_str( results_of_English_KCmb[window_title], "_" . sc_key ) ? get_value_of_KCmb_by_str( results_of_English_KCmb[window_title], "_" . sc_key )
            :   "{" . sc_key . "}" ; up や left

;   マウスのボタンのときには、処理をすぐに停止する
;   IfInstring, this_key, button
;   {
;       send,% get_modified_keys_pressed_down() . swap_mouse_button(this_key)
;       return
;   }

    if ( Get_key_mode( Get_key_number( Trim(this_key, "*") ), lang_mode ) ) {
        key_number := Get_key_number( Trim(this_key, "*") )

        output_in_accordance_with_the_pull_down_setting( Get_key_mode( key_number, lang_mode )
                          , Get_key_output_text( key_number, lang_mode )
                          , "+" . get_modified_keys_pressed_down())

        return
    } else {


        ;; 独自のショートカットキーを使用するとき
        If ( is_User_Shortcut_Key ) {
            exit_at_once := send_user_shortcutkey( p_modifier_specified . this_key )

            if ( exit_at_once ) {
                return
            }
        }


        If (         ( bIME )
             and     ( bShiftDown )
             and ( ! ( bWinDown ) )
             and ( ! ( bAltDown ) )
             and ( ! ( bCtrlDown ) ) ) {
            ; 同時打鍵の設定に [shift] が含まれているとき
            If ( Japanese_mod_key[window_title, "_shift"] ) {
                ; 同時打鍵の判定で、直前に押し下げられたキーの情報が無いとき
                If ( arr_bufKey.len() = 0 ) {
                    ; 同時打鍵の判定で [shift] を押し下げたことにする
                    onKeyDown( "_shift ")
                }

                ; 同時打鍵の判定に文字キーの情報を送る
                onKeyDown( "_" . sc_key )

                return
            }
        }



        ;; vista で skkime を使うと IME の入力モードを正常に返さない不具合あり
        ;; 対処法として次の処理を考えた

        ;; skkime 使用時に Ctrl + G が押されたら
        ;; 日本語配列に切り替える
        ;; すなわち、IME を有効にする
        If ( ( Is_skkime_mode )
         and ( Is_skkime_temp_english_layout ) ) {

            if ( ( p_modifier_specified = "^" )
             and ( this_key = "g" ) ) {

                nJapaneseLayoutMode := Is_skkime_temp_english_layout
                Is_skkime_temp_english_layout := 0
            }
        }

        send( "{Blind}" . p_modifier_specified . this_key )

        return
    }
}
