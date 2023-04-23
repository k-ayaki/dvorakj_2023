write_value_to_ini(section, key, value="")
{
    global ini_file
	;; ini ファイルに設定を追記した瞬間に、
	;; 追記した内容を表示する
	;; tooltip,% section "`n" key "`n" value

    IniWrite, %value% , %ini_file%, %section%, %key%

    return
}


read_value_from_ini(Section, key, defValue=0)
{
    global ini_file

    if ( key )
        IniRead, value, %ini_file%, %section%, %key%

    if ( value = "ERROR" )
    {
        value := defValue
        write_value_to_ini(section, key, value)
    }

    return value
}


conv_from_string_to_array( p_str, p_separator="|") {
	arr := Array()

	Loop, Parse, p_str, %p_separator%
	{
		if ( Trim(A_LoopField) ) {
			arr.append( Trim(A_LoopField) )
		}
	}

	return arr
}


read_ini_and_get_array(p_ini_file, p_mode_name) {
	arr := Array()

    IniRead, temp, %p_ini_file%, FilePath, %p_mode_name%
	
	if ( temp != "error" ) {
		Loop,Parse, temp, |
		{
			if (A_LoopField != "") {
				arr.append(A_LoopField)
			}
		}
	}

	return arr
}
