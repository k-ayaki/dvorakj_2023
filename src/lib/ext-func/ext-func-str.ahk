Trims(str, needle){
    return RTrims(LTrims(str, needle), needle)
}

RTrims(str, needle){
	found_position :=  InStr(str, needle, false, 0)
	str_len := strlen(str)
	needle_len := strlen(needle)
	
	if (str_len < found_position + needle_len) {
	    StringTrimRight, new_str, str, % needle_len
	    return new_str
	} else {
	    return str
	}
}

LTrims(str, needle){
	if (1 = InStr(str, needle)){
	    StringTrimLeft, new_str, str, % StrLen(needle)
	    return new_str
	}
	else{
	    return str
	}
}


string_replace(input_text, search_text, replace_text="", replace_all="All", case_sensitive=False)
; StringReplace の関数版
{
    if ( case_sensitive ) {
        StringCaseSense, On
    }

    StringReplace, output_text, input_text, %search_text%, %replace_text%, All

    if ( case_sensitive ) {
        StringCaseSense, Off
    }

	return output_text
}

get_string_pos( p_str, p_search_text, from = "L1", offset = 0 )
; 文字列の出現位置を取得する
{
	StringGetPos, output_var, p_str, %p_search_text%, %from%, %offset%
	return output_var
}


get_string_mid( p_str, p_start_char = 1, p_count = 0, from = "L" )
; 文字列の出現位置を取得する
{
	StringMid, output_var, p_str, %p_start_char%, %p_count%, %from% )
	return output_var
}


get_string( p_InputVar
			, p_count = 0
			, p_trim = False
			, from = "L" )
; 文字列を取り出す
; p_count: 取り出す文字数
; p_trim:  文字列を取り出すのではなく、削除する
; from:    左右のどちらから処理を開始するか
{
	if ( from = "L" ) {
		if ( p_trim ) {
			StringTrimLeft, OutputVar, p_InputVar, %p_count%
		} else {
			StringLeft, OutputVar, p_InputVar, %p_count%
		}
	} else {
		if ( p_trim ) {
			StringTrimRight, OutputVar, p_InputVar, %p_count%
		} else {
			StringRight, OutputVar, p_InputVar, %p_count%
		}
	}

	return OutputVar
}



trim_str( p_search_text
		, p_replace_text
		, replace_all = "all" ) {

	StringReplace, OutputVar, p_search_text, %p_replace_text%, , %replace_all%

	return OutputVar
}


get_CHAR( p_str ) {
	return Asc(p_str)
}


string_to_array(string, separator){
    arr := Array()
    Loop, Parse, string, %separator%
    {
        if (A_LoopField != "") {
            arr.append(Trim(A_LoopField))
        }
    }
    
    return arr
}
