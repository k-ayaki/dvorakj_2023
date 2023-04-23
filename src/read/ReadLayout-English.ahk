read_layout_of_English( layout_path ) {
	global


	English_mod_key := Object()
	English_true_mod_key := Object()

	English_max_num_of_each_key := Object()
	results_of_English_KCmb := Object()

	read_and_set_keyboard_layout( get_file_full_path( layout_path )
	                            , English_mod_key
	                            , English_true_mod_key
	                            , English_max_num_of_each_key
	                            , results_of_English_KCmb )

	return
}