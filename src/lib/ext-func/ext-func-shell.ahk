myrun( p_str ) {
    Try
    {
        ;; "z:/test/foo bar/piyo.exe --foo bar" のようにパスに空白が含まれることも想定し
        ;; ファイル名らしきものが存在するかどうかを調べる
        Array := StrSplit(p_str, " ")
        tmp := ""
        Loop % Array.MaxIndex()
        {
            tmp .= Array[A_Index] . " "
            file_rslt := Path_FileExists(tmp)
        } Until (1 == file_rslt)
        
        if ((0 == file_rslt) and (0 == Path_IsURL(p_str))) {
            Throw "指定されたパスを開くことができません`n" . p_str
        }
        
        run,% p_str
        return p_str
    }
    Catch e
    {
        MsgBox, 0, エラー, %e%
        return %p_str%
    }
}
