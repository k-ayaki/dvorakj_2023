delete_and_append_file(p_filename, p_contents="")
; ファイルを新規に作成してから
; 追記する
{
	FileDelete, % p_filename
	FileAppend, %p_contents%, % p_filename
}

get_filename_without_extension( s )
{
    SplitPath
        , s
        , 
        , 
        , 
        , FileNameWithoutExt

    return FileNameWithoutExt
}

get_filename_with_current_dir( s )
{
    return to_windows_path("./") . s
}

to_windows_path(path)
{
	StringReplace, path, path, /, \, All
	StringReplace, path, path, \\, \, All
	return path
}

get_file_full_path( s )
{
    ;; 相対パスの先頭にある ".\" を除去する
    if ( RegExMatch(s, "^\.\\" ) )
    {
        StringTrimLeft, s, s, 2
    }

    return A_ScriptDir . to_windows_path("/") . s
}

get_file_mtime( p_filename ) {
	FileGetTime, OutputVar, % p_filename
	return OutputVar
}

