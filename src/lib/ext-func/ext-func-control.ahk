send_by_way_of_WM_at_all_times( p_str )
; 常に WM を使用する
{
	;; List of Windows Messages
	;; http://www.autohotkey.com/docs/misc/SendMessageList.htm

	message := get_wm_()

	Loop, Parse, p_str
	{
		send_by_way_of_%message%( get_CHAR( A_LoopField ) )
	}

	return False
}


send_by_way_of_WM_pro_re_nata( p_str )
;; 必要に応じて WM を使用する
;; 0xA5 以前の文字や記号
{
	;; List of Windows Messages
	;; http://www.autohotkey.com/docs/misc/SendMessageList.htm

	arr_value := Array()
	arr_str := Array()

	message := get_wm_()

	Loop, Parse, p_str
	{
		if ( A_LoopField != "" ){
			arr_str.append( A_LoopField )
			arr_value.append( get_CHAR( A_LoopField ) )

		}
	} until ( arr_value.last() > 165 )


	if ( arr_value.last() = "" ) {
		return False
	} else if ( arr_value.last() > 165 ) {
		for index, value in arr_value {
			send_by_way_of_%message%( value )
		}

		new_str := get_string( p_str
								, arr_value.len()
								, True)

		return send_by_way_of_WM_pro_re_nata( new_str )
	} else {
		send,% p_str
		return False
	}
}



send_by_way_of_WM_UNICHAR( p_key_code ) {
	return SendMessageW( "0x0109", p_key_code )
}

send_by_way_of_WM_CHAR( p_key_code ) {
	return SendMessageW( "0x0102", p_key_code )
}

send_by_way_of_WM_IME_CHAR( p_key_code ) {
	return SendMessageW( "0x0286", p_key_code )
}

SendMessageW( Message, wParam = 0, lParam = 0 ) {
    VarSetCapacity(stGTI, 48, 0)
    NumPut(48, stGTI,  0, "UInt")   ;	DWORD   cbSize;
	hWnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,12,"UInt") : WinExist(WinTitle)

    return DllCall("SendMessageW"
          , UInt, hWnd      ;hWnd
          , UInt, Message   ;Message
          ,  Int, wParam    ;wParam
          ,  Int, lParam)   ;lParam
}


get_wm_(){
	global WM_UNICHAR_apps_list
	global WM_CHAR_apps_list

	SetTitleMatchMode,2
	WinGet, OutputVar, ProcessName, A

	for index, value in WM_UNICHAR_apps_list {
		if ( OutputVar = value ) {
			return "WM_UNICHAR"
		}
	}

	for index, value in WM_CHAR_apps_list {
		if ( OutputVar = value ) {
			return "WM_CHAR"
		}
	}

	return "WM_IME_CHAR"
}

