send_str_by_sequential_strokes( this_key, p_lang ) {
    global arr_keys

    global results_of_English_KCmb
    global results_of_Japanese_KCmb

    global window_title

    global output_nothing_in_the_latest_key_input

    global g_lang
    g_lang := p_lang

    ;; キーストロークを初期化する
    if ( IsObject( arr_keys ) = False ) {
        arr_keys := Array()
    }


    ;; 入力したキーを追加する
    arr_keys.append( sort_simul_KCmb( this_key ) )

    if ( p_lang = "en" ) {

        ;;; 完全に該当する出力情報が存在するなら、それを取得
        output_key :=  get_value_of_KCmb_by_str( results_of_English_KCmb[window_title]
                                                , arr_keys.join("") )

        ;;; 入力を待機する必要があるかどうかを判定
        standby_p :=  get_state_KCmb_with_str( results_of_English_KCmb[window_title]
                                        , arr_keys.join("") )
    } else {

        ;;; 完全に該当する出力情報が存在するなら、それを取得
        output_key :=  get_value_of_KCmb_by_str( results_of_Japanese_KCmb[window_title]
                                                , arr_keys.join("") )

        ;;; 入力を待機する必要があるかどうかを判定
        standby_p :=  get_state_KCmb_with_str( results_of_Japanese_KCmb[window_title]
                                                , arr_keys.join("") )
    }



    if ( output_key != "" ) {
        ;; 次に back space が押されたとき、
        ;; 文字を必ず消す
        output_nothing_in_the_latest_key_input := False

        outputChar( output_key )
    } else {
        ;; 次に back space が押されたとき、
        ;; 文字を消さない
        output_nothing_in_the_latest_key_input := True
    }


    ;; 該当する設定が見つからなかったとき
    if ( standby_p = False ) {

        ;; 何かしら出力したとき
        if ( output_key != "" ) {

            ;; 保持しているキーストロークを破棄する
            arr_keys.clear()
        } else if ( get_string_pos( arr_keys.last(), "(" ) = 0 ) {
            ;; ( からはじまるとき
            ;; つまり最新の打鍵が同時打鍵のときは、
            ;; 組み合わせるキー数を減らして調べ直す

            ;; 最新の打鍵を取り消す
            if ( arr_keys.len() = 1 ) {
                arr_keys.clear()
            } else {
                arr_keys.pop()
            }

            ;; 最新の打鍵から () を取り去る
            StringReplace, this_key, this_key, (
            StringReplace, this_key, this_key, )

            ;; 最新の打鍵を配列に変換する
            a_tmp := conv_string_to_array_for_setting_of_keyboard( this_key )

            ;; 最新の打鍵のうち、最後に打鍵したキーを取得する
            latest_key := a_tmp.last()

            ;; 最新の打鍵のうち、最後に打鍵したキー以外を取得する
            a_tmp.pop()


            ;; 最後に打鍵したキーを除く最新の打鍵数が 1 のとき
            ;; つまり、判定し直すキーが最大一つのとき
            if ( a_tmp.len() = 1 ) {

                ;; 同時打鍵ではなく、単打として処理する
                returned_key := send_str_by_sequential_strokes( a_tmp.join(""), p_lang )
            } else {

                ;; 同時打鍵として再度処理する
                returned_key := send_str_by_sequential_strokes( "(" . a_tmp.join("") ")", p_lang )
            }

            ;; 同時に打鍵する処理を再度行うキーを文字列として返す
            return ( returned_key ) ? latest_key . returned_key
                                    : latest_key
        } else if ( arr_keys.len() = 1 ) { ; 入力されたキーだけを判定したとき

            ;; 保持しているキーストロークを破棄する
            arr_keys.clear()
        } else {

            ;; 保持しているキーストロークを破棄する
            arr_keys.clear()

            ;; 最新のキーストロークのみ判定し直す
            send_str_by_sequential_strokes( this_key, p_lang )
        }
    }

    return False
}



remove_sequential_strokes( p_str ) {
    global arr_keys

    global output_nothing_in_the_latest_key_input



    ; 文字列からコマンドを実行する
    valid_command := execute_command_from_string(p_str)
    if ( valid_command ) {
        return
    }


    if ( RegExMatch(p_str, "i)^{backspace") ) {
        ;; キー入力が蓄積されているときには
        ;; キー入力のみを取り消す
        if ( arr_keys.len() ) {
            arr_keys.delete(arr_keys.len())

            ;; 直前に文字を出力していないということは
            ;; キー入力のみ蓄積された、ということ。
            ;; このようなときに Back Space が押されたら、
            ;; 最新のキー入力を取り除き（これが上記の処理）、すぐに処理全体を停止する
            ;; つまり、 Back Space を送信しない
            if ( output_nothing_in_the_latest_key_input ) {
                return
            }
        }
    }

    if ( RegExMatch(p_str, "i)^{esc") ) {
        arr_keys := Array()
    }

    if ( RegExMatch( p_str, "i)^{enter" ) ) {
        arr_keys := Array()
    }

    if ( RegExMatch( p_str, "i)^{home" ) ) {
        arr_keys := Array()
    }

    if ( RegExMatch( p_str, "i)^{(Up|Down|Left|Right)" ) ) {
        arr_keys := Array()
    }

    return p_str
}


