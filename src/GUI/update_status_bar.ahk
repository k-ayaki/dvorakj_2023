update_status_bar:
	if ( lang = "en" ) {
	    change_text_within_status_bar(1, "`t[直接入力用]`t")
	} else {
	    change_text_within_status_bar(1, "`t[日本語入力用]`t")
	}

	change_text_within_status_bar( 2, arr_keys.join("　") )


    CoordMode,Mouse,Screen
	MouseGetPos, pos_mouse_X , pos_mouse_Y
	change_text_within_status_bar( 3, "`t(" pos_mouse_X ", " pos_mouse_Y ")`t" )


	FormatTime, now_time, , yyyy-MM-dd (ddd)  HH:mm
	change_text_within_status_bar( 5, "`t" now_time "`t" )
return
