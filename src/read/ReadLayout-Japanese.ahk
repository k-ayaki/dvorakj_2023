read_layout_of_Japanese( layout_path ) {
    global

    Japanese_mod_key := Object()
    Japanese_true_mod_key := Object()

    Japanese_max_num_of_each_key := Object()
    results_of_Japanese_KCmb := Object()

    read_and_set_keyboard_layout( get_file_full_path( layout_path )
                                , Japanese_mod_key
                                , Japanese_true_mod_key
                                , Japanese_max_num_of_each_key
                                , results_of_Japanese_KCmb )

    ;; if (debug_mode) {
    ;;      tmptime :=PF_Count()
    ;;      ;; キーボード配列の表を設定の一覧に変換し、試しに出力する
    ;;      delete_and_append_file("z:\" . get_filename_without_extension( layout_path) . "-conved.txt" ;"
    ;;                                  , conv_from_table_to_lines( read_keyboard_layout( get_file_full_path( layout_path ) )															, "Get_scancode_from_table_main" ))
    ;;      w_tickcount := PF_Count()
    ;;      msgbox,% w_tickcount - tmptime
    ;; }

	
	return 
}

