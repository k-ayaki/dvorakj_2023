;;; 文字列を Ascii Code を使用する数値に変換して返す関数　修飾キー付属版
PsuedoAsciiCode_WithModifiedKeys(str)
{
    str_PsuedoAsciiCode_WithModifiedKeys := 0
    Is_str_NotReplaced := 1
    count =

    ;; Alt ではなく ! の判定
    str := RegExReplace(str, "\{!\}", "", count)
    if (count)
    {
        str_PsuedoAsciiCode_WithModifiedKeys += Asc("!")
        count =
        Is_str_NotReplaced := 0
    }

    ;; Ctrl ではなく ^ の判定
    str := RegExReplace(str, "\{\^\}", "", count)
    if (count)
    {
        str_PsuedoAsciiCode_WithModifiedKeys += Asc("^")
        count =
        Is_str_NotReplaced := 0
    }

    ;; Win ではなく # の判定
    str := RegExReplace(str, "\{#\}", "", count)
    if (count)
    {
        str_PsuedoAsciiCode_WithModifiedKeys += Asc("#")
        count =
        Is_str_NotReplaced := 0
    }

    ;; Shift ではなく + の判定
    str := RegExReplace(str, "\{\+\}", "", count)
    if (count)
    {
        str_PsuedoAsciiCode_WithModifiedKeys += Asc("+")
        count =
        Is_str_NotReplaced := 0
    }


    ;; Alt の判定
    str := RegExReplace(str, "i){Alt}", "", count)
    if (count)
    {
        str_PsuedoAsciiCode_WithModifiedKeys += (2 ** 1) * 1000
        count =
    }

    ;; Ctrl の判定
    str := RegExReplace(str, "i){Ctrl}", "", count)
    if (count)
    {
        str_PsuedoAsciiCode_WithModifiedKeys += (2 ** 2) * 1000
        count =
    }

    ;; Win の判定
    str := RegExReplace(str, "i){Win}", "", count)
    if (count)
    {
        str_PsuedoAsciiCode_WithModifiedKeys += (2 ** 3) * 1000
        count =
    }

    ;; Shift の判定
    str := RegExReplace(str, "i){Shift}", "", count)
    if (count)
    {
        str_PsuedoAsciiCode_WithModifiedKeys += (2 ** 4) * 1000
        count =
    }

    ;; Alt の判定
    str := RegExReplace(str, "!", "", count)
    if (count)
    {
        str_PsuedoAsciiCode_WithModifiedKeys += (2 ** 1) * 1000
        count =
    }

    ;; Ctrl の判定
    str := RegExReplace(str, "\^", "", count)
    if (count)
    {
        str_PsuedoAsciiCode_WithModifiedKeys += (2 ** 2) * 1000
        count =
    }

    ;; Win の判定
    str := RegExReplace(str, "#", "", count)
    if (count)
    {
        str_PsuedoAsciiCode_WithModifiedKeys += (2 ** 3) * 1000
        count =
    }

    ;; Shift の判定
    str := RegExReplace(str, "\+", "", count)
    if (count)
    {
        str_PsuedoAsciiCode_WithModifiedKeys += (2 ** 4) * 1000
        count =
    }


    ;; 文字を数値にまだ置き換えていないとき
    if (Is_str_NotReplaced)
    {
        ;; 右端の 1文字の Ascii Code を取得して、以下の値を掛け合わせる
        StringRight, str, str, 1
        str_PsuedoAsciiCode_WithModifiedKeys += Asc(str)
    }

    ;; 文字列を数値に変換したものを返り値とする
    return str_PsuedoAsciiCode_WithModifiedKeys
}
