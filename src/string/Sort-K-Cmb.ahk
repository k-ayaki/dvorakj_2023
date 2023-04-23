SortKCmb( str )
{
    ;;; 設定内容が一つ以上存在するときのみ
    ;;; 設定を順番に並び替える
    if ( InStr(str, "_", "", 2) )
    {
        StringReplace, str, str, _, `n, All
        Sort, str, F StringSort
        StringReplace, str, str, `n, _, All
    }

    return str
}

StringSort(a1, a2)
{
    return a1 > a2 ? 1 : a1 < a2 ? -1 : 0
}


