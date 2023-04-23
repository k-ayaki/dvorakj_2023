send( p_str ) {
    global is_sending_by_way_of_WM_p

    if ( is_sending_by_way_of_WM_p ) {
        send_by_way_of_WM_pro_re_nata( p_str )
    } else {
        send,% p_str
    }

    return p_str
}


get_last_sc_key( str )
; ホットキー名から
; 後半部分を取り出す
{
    str := RegExReplace(str, "^.+&\s?")
    return RegExReplace(str, "[\+\*]+")
}


sort_modifier( p_key )
; 修飾キーをソートする
{
    RegExMatch(p_key, "^([#!\^\+]+)(.+)", $)
    modifiers := $1
    normal_key := $2

    tmp_modifier := Array()

    ;; 修飾キーを文字列に変換して格納する
    Loop, Parse, modifiers
    {
        if (A_LoopField) {
            tmp_modifier.append(to_string_for_modifier(A_LoopField))
        }
    }

    ;; 最終的に修飾キーを出力するための配列を用意する
    arr_modifier := Array()
    ;; 修飾キーを文字列のままソートする
    for i, v in tmp_modifier.sort() {
        ;; 文字列から記号に変換し直す
        arr_modifier.append(to_symbol_for_modifier(v))
    }

    ;; 並び替えた修飾キーとその他キーを返す
    return % arr_modifier.join("") . normal_key
}

to_symbol_for_modifier(str)
; {win} -> #
{
    StringReplace, str, str, {win}, #, All
    StringReplace, str, str, {alt}, !, All
    StringReplace, str, str, {ctrl}, ^, All
    StringReplace, str, str, {shift}, +, All

    return str
}


to_string_for_modifier(symbol)
; # -> {win}
{
    StringReplace, symbol, symbol, #, {win}, All
    StringReplace, symbol, symbol, !, {alt}, All
    StringReplace, symbol, symbol, ^, {ctrl}, All
    StringReplace, symbol, symbol, +, {shift}, All

    return symbol
}


GetScanCode_ThisCharKey( option = "" )
{
    IfInString, A_ThisHotkey, +
    {
        StringTrimLeft, sc_key, A_ThisHotkey, 1
    }
    else
    IfInString, A_ThisHotkey, &
    {
        IfInString, A_ThisHotkey, Win
            StringRight, sc_key, A_ThisHotkey, 5
        else
        IfInString, A_ThisHotkey, Alt
            StringRight, sc_key, A_ThisHotkey, 5
        else
            StringTrimLeft, sc_key, A_ThisHotkey, 8
    }
    else
    IfInString, A_ThisHotkey, *
    {
        StringTrimLeft, sc_key, A_ThisHotkey, 1
    }
    else
    {
        sc_key := A_ThisHotkey
    }


    if ( option = "h" )
    {
        ;; スキャン・コードの末尾 3 文字を取得する
        StringRight, sc_hex, sc_key, 3
        ;; 先頭の数字 0 をできるだけ削除する
        sc_hex := LTrim(sc_hex, "0")

        ;; 残った文字が一つのときには
        ;; 0 を付け足しておく
        if ( StrLen( sc_hex ) = 1 )
            sc_hex := "0" . sc_hex

        return sc_hex
    }
    else
    {
        return sc_key
    }
}

GetScanCode_PriorCharKey(option="")
{
    IfInString, A_PriorHotkey, +
    {
        StringTrimLeft, sc_key, A_PriorHotkey, 1
    }
    else
    IfInString, A_PriorHotkey, &
    {
        StringTrimLeft, sc_key, A_PriorHotkey, 8
    }
    else
    IfInString, A_PriorHotkey, *
    {
        StringTrimLeft, sc_key, A_PriorHotkey, 1
    }
    else
    {
        sc_key := A_PriorHotkey
    }


    if ( option = "h" )
    {
        ;; スキャン・コードの末尾 3 文字を取得する
        StringRight, sc_hex, sc_key, 3
        ;; 先頭の数字 0 をできるだけ削除する
        sc_hex := LTrim(sc_hex, "0")

        ;; 残った文字が一つのときには
        ;; 0 を付け足しておく
        if ( StrLen( sc_hex ) = 1 )
            sc_hex := "0" . sc_hex

        return sc_hex
    }

    return sc_key
}



GetScanCode_AllKey( exception = "" )
{
    static keys

    if ( keys.len() = "" )
    {
        keys := Array("sc002", "sc003", "sc004", "sc005", "sc006", "sc007", "sc008", "sc009", "sc00A", "sc00B", "sc00C", "sc00D", "sc07D"
                     , "sc010", "sc011", "sc012", "sc013", "sc014", "sc015", "sc016", "sc017", "sc018", "sc019", "sc01A", "sc01B"
                     , "sc01E", "sc01F", "sc020", "sc021", "sc022", "sc023", "sc024", "sc025", "sc026", "sc027", "sc028", "sc02B"
                     , "sc02C", "sc02D", "sc02E", "sc02F", "sc030", "sc031", "sc032", "sc033", "sc034", "sc035", "sc073"
                     , "sc07B", "sc079")
    }

    str := ""

    Loop,% keys.len()
    {
        if (GetKeyState(keys[A_Index], "P"))
        {
            ;; _23 という形式でキーの情報を格納する
            str .= keys[A_Index]

        }
    }

    return str
}

