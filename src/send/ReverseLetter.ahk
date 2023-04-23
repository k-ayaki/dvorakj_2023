ReverseLetter( str, currentKCmb )
{
    if ( InStr(currentKCmb, "_shift") )
    {
        ;; 小文字→大文字
        if str is lower
            StringUpper, str, str
        else ; 大文字→小文字
            StringLower, str, str
    }

    return str
}
