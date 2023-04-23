;; 快適！下駄配列その１
;; http://kohada.2ch.net/test/read.cgi/pc/1201883108/

outputChar( p_str )
{
    global nJapaneseLayoutMode

    global is_US_keyboard

    global bIME
    global bIME_Converting

    ;; skkime 用
    global Is_skkime_mode
    global bSKKIME_shift
    global Is_skkime_temp_english_layout
    global Is_skkime_ConvPrevSpace
    global skkime_abbrev_mode_key
    global skkime_previous_candidate_key

    global bCapsLockState



    ; 文字列からコマンドを実行する
    valid_command := execute_command_from_string(p_str)
    if ( valid_command ) {
        return
    }

    ;; タイピング練習ソフト向けの設定
    if ( nJapaneseLayoutMode = 3 ) {
        ;; 以下の US keyboard 向けのキーコードを OADG 109A のキーコードに変換する
        ;; そうしないと、タイピング練習ソフトが打鍵を認識しない

        if ( is_US_keyboard ) {
            ;; 置換の都合上、
            ;; + がつくもの、すなわちシフトキーとともにキーを送信するはずのものをまず設定し直す
            ;; + がつくもの
            StringReplace, p_str, p_str, +{sc003},  {vkC0sc01A}, All ; atmark

            StringReplace, p_str, p_str, +{sc007},  {vkDEsc00D}, All ; {^}
            StringReplace, p_str, p_str, +{sc008}, +{vk36sc007}, All ; & (amp)
            StringReplace, p_str, p_str, +{sc009}, +{vkBAsc028}, All ; *
            StringReplace, p_str, p_str, +{sc00A}, +{vk38sc009}, All ; ( 
            StringReplace, p_str, p_str, +{sc00B}, +{vk39sc00A}, All ; )
            StringReplace, p_str, p_str, +{sc00C}, +{vkE2sc073}, All ; _ (under score)
            StringReplace, p_str, p_str, +{sc00D}, +{vkBBsc027}, All ; + (plus)

            StringReplace, p_str, p_str, +{sc027},  {vkBAsc028}, All ; colon
            StringReplace, p_str, p_str, +{sc028}, +{vk32sc003}, All ; " (double)
            StringReplace, p_str, p_str, +{sc029}, +{vkDEsc00D}, All ; ~ (tilde)

            ;; + がつかないもの
            StringReplace, p_str, p_str,  {sc00D}, +{vkBDsc00C}, All ; equal
            StringReplace, p_str, p_str,  {sc027},  {vkBBsc027}, All ; semi colon
            StringReplace, p_str, p_str,  {sc028}, +{vk37sc008}, All ; ' (single)
            StringReplace, p_str, p_str,  {sc029}, +{vkC0sc01A}, All ; ` (accent grave)
        }
    }


    ;; 現在時刻を取得する
    str := ConvConstToTime( p_str )


    if ( bCapsLockState ) {
        str := conv_caps_char( p_str )
    }



    If ( Is_skkime_mode ) {
        if ( bSKKIME_shift ) {
            SendSKKIMEWithShift( str )

            bSKKIME_shift = 0
            
            return
        }
        
        if ( ( bIME_Converting ) && ( Is_skkime_ConvPrevSpace ) ) {
            ;; skkime で文字を変換中で、かつ直前に {Space} が送信されたとき

            ;; 変換の前候補を表示させるため
            ;; x を出力してスレッドを終了する
            if ( str = skkime_previous_candidate_key ) {
                send( skkime_previous_candidate_key )
            } else {
                Is_skkime_ConvPrevSpace = 0
            }
            
            return
        }
        
        if ( ( bIME ) && ( str = skkime_abbrev_mode_key ) ) {
            ;; vista で skkime を使うと IME の入力モードを正常に返さない不具合あり
            ;; 対処法として次の処理を考えた

            ;; skkime 使用時に / が押されたら
            ;; 日本語入力を常に使用しない

            Is_skkime_temp_english_layout := nJapaneseLayoutMode
            nJapaneseLayoutMode := 1
            send( skkime_abbrev_mode_key )
            
            return
        }
        
        send( ConvStrWithoutXTU( str ) )
        return
    }
    

    send( ConvStrWithoutXTU( str ) )
    return
}

conv_caps_char( p_str )
; 大文字 <-> 小文字 の変換
{
    new_str := ""

    Loop, Parse, p_str, 
    {
        char := A_LoopField

        if char is upper
            StringLower, char, char
        else
            StringUpper, char, char
        
        new_str .= char
    }

    return new_str
}


execute_command_from_string(p_str)
; 文字列からコマンドを実行する
{
    ; IME の状態を変更する
    if (p_str = "IME_SET(0)") {
        IME_SET(0)
        GoSub, IME_GET

        return True
    } 
    
    if (p_str = "IME_SET(1)") {
        IME_SET(1)
        GoSub, IME_GET

        return True
    }

    ; Caps Lock の状態を変更する
    if (p_str = "{CapsLock on}") {
        SetCapsLockState, On

        return True
    }
    
    if (p_str = "{CapsLock off}") {
        SetCapsLockState, Off

        return True
    }
    
    if (p_str = "{CapsLock toggle}") {
        SetCapsLockState, % ( GetKeyState("CapsLock", "T") ) ? "Off" : "On"

        return True
    }

    ; 再起動
    if (p_str = "{reload}") {
        reload
    }

    ; ファイルを開くかプログラムを実行する
    if ( RegExMatch(p_str, "i)^{Run(-As-Admin)?\s+""(.+?)""(.*)}$", arg_) ) {
        cmnd := """" . relative_path_to_absolute_path(slash_to_backslash(escape_comma(arg_2))) . """"
                . arg_3

        if ( arg_1 ) { ; run-as-admin 
              if A_IsAdmin
              {
                  run, open %cmnd% , , UseErrorLevel
              }
              else
              {
                  run, *RunAs %cmnd% , , UseErrorLevel
              }
        }
        else
        {
            run, open %cmnd% , , UseErrorLevel
        }
        
        if (ErrorLevel = "ERROR") {
            tooltip("エラー： ファイルまたはコマンドが見つかりません", cmnd)
            ;; 2000 ミリ秒の間、ツールチップを表示する
            SetTimer, RemoveToolTip1, 2000
        }

        return True
    }

    return False
}

escape_comma(arg)
{
    return string_replace(arg, ",", "`,")
}

slash_to_backslash(p_str)
{
    return string_replace(p_str, "/", "\")

}

relative_path_to_absolute_path(p_str)
{
    StringLeft, one_char, p_str, 1
    StringLeft, two_chars, p_str, 2
    StringLeft, three_chars, p_str, 3
    StringTrimLeft, rest1, p_str, 1
    StringTrimLeft, rest2, p_str, 2
    StringTrimLeft, rest3, p_str, 3

    ;; top directory
    if ((one_char = "\" ) && (two_chars != "\\" )) { 

        ;; 現在のパスから、ドライブ名を取得する
        SplitPath, A_ScriptDir, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
        return OutDrive . "\" . rest1
    }

    ;; current directory
    if (two_chars = ".\" ) { 

        return A_ScriptDir . "\" . rest2

    }


    ;; parent directory
    if (three_chars = "..\" ) { 

        i := 1

        Loop, {
            StringLeft, three_chars, rest3, 3
            if (three_chars = "..\") {

                i++
                StringTrimLeft, rest3, rest3, 3
            }
            else {
                no_upper_dir := True
            }
        } until (no_upper_dir)

        return get_parent_dir(A_ScriptDir, i) . "\" . rest3

    }


    return p_str
}

get_parent_dir(path, num)
{
    tmp_path := RTrim(path, "\\")
    backslash_pos := get_string_pos( tmp_path, "\", "R" . num )

    if (backslash_pos = -1) { ; "..\" が想定以上に出現したとき
        ;; ディレクトリのトップ (Z:\) に設定しておく
        backslash_pos := 2
    }

    StringLeft, new_path, tmp_path, %backslash_pos%
    return new_path
}

RemoveToolTip1:
    SetTimer, RemoveToolTip1, Off
    ToolTip, , , , 1
return
