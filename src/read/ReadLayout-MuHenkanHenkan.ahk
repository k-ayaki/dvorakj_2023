read_layout_of_muhenkan_henkan( path_layout_file ){
	global

	muhenkan_henkan_results_of_KCmb := Object()

    return set_keyboard_layout2( conv_from_table_to_lines( read_keyboard_layout( get_file_full_path( path_layout_file ) )
															, "Get_scancode_from_table_main"
															, path_layout_file )
                              , muhenkan_henkan_results_of_KCmb )
}


set_keyboard_layout2( p_str
                   , ByRef r_results_of_KCmb ) {
    if ( p_str = "error") {
        return p_str
    } else {
        Loop, parse, p_str, `r, `n
        {
            if ( RegExMatch(A_LoopField, "m)^(.+?)\t(.+?)\t(.+?)$", item) ) { ; option_keys[tab]this_key[tab]output
                window_title := Trim( item1 )
                input_key := Trim( item2 )
                output_key := Trim( item3 )

				StringReplace, input_key, input_key, (, , All
				StringReplace, input_key, input_key, ), , All

	            if ( input_key != "" ) {
					r_results_of_KCmb[window_title, input_key] := output_key

					if input_key contains muhenkan
					{
						r_results_of_KCmb[window_title, "_muhenkan"] := True
					} else {
						r_results_of_KCmb[window_title, "_henkan"] := True
					}
	            }
			}
        }

        return True
    }
}
