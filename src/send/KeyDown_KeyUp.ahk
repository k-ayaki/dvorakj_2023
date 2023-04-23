onKeyDown(p_this_key, p_lang="")
;; 同時打鍵の設定
; ----------------------------------------------------------
; キーを押し下げたときの処理
; 一定時間以内にキーを複数個押し下げたときには、それらのキーを組み合わせる処理を行う
; キーを単独で押し下げたときには、そのキーの情報を保持するよう設定し、何も出力しない
; ----------------------------------------------------------
{
    global arr_bufKey
    global time_of_input_key
    global MaximalGT
    global debug_new_proc
    global timer_continues := False


    ;; arr_bufKey にキーの情報が格納されているとき
    if ( arr_bufKey.len() ) {
        ;; 新しいキーの情報を追加する
        arr_bufKey.append(p_this_key)

        ;; 新しく入力したキーに、時間の情報を結びつける
        time_of_input_key.insert(p_this_key, PF_Count())
    } else { ; arr_bufKey に何も情報が格納されていないとき
        setTimer, onKeyUp, %MaximalGT%

        ;; 出力する入力方式を確定する
        if (p_lang = "") {
            p_lang := GetOutputLang()
        }
        

        ;; 新しいキーの情報を追加する
        arr_bufKey := Array(p_lang, p_this_key)

        ;; 新しく入力したキーに、時間の情報を結びつける
        time_of_input_key := Object(p_this_key, PF_Count())
    }


    ;; キー入力をさらに待機する必要がないとき
    if ( Get_next_KCmb( arr_bufKey.first(), arr_bufKey.rest() ) = False) {
        GoSub, onKeyUp
    }


    Return
}




;; さらにキー入力を待機する必要があるか？
Get_next_KCmb( p_lang, p_arr_keys ) {
    global  English_max_num_of_each_key
    global Japanese_max_num_of_each_key

    global window_title

    total_num_of_keys := p_arr_keys.len()


    for index, value in p_arr_keys {
        ;; キー毎の最大同時打鍵数を取得する
        num_of_the_key  := ( p_lang = "en" ) ?  English_max_num_of_each_key[window_title, value]
                        :                      Japanese_max_num_of_each_key[window_title, value]

        if ( total_num_of_keys >= num_of_the_key ){
            return false
        }
    }

    return true
}



Send_onKeyUp( p_lang, p_arr_keys ) {
    ;; この関数に渡されたキーの総数を取得する
    total_num_of_keys := p_arr_keys.len()

    ;; 入力されたキーが 1 つだけのとき
    if ( total_num_of_keys = 1) {
        ;; すぐに出力する
        renew_bufKey := send_str_by_sequential_strokes( p_arr_keys.first(), p_lang )
    } else { ; 入力されたキーが 2 つ以上のとき
        renew_bufKey := send_str_by_sequential_strokes( "(" p_arr_keys.join("") ")", p_lang )
    }

    ;; 同時に打鍵するキーとして使われなかったものがあるとき
    if ( renew_bufKey ) {
        ;; キー情報を配列に変換して返す
        ;; [1]: 最も古いキー
        ;; [2]: その次に古いキー

        ;; renew_bufKey は最新のキー情報が先頭にあるので
        ;; reverse() を適用する
        return conv_string_to_array_for_setting_of_keyboard( renew_bufKey ).reverse()
    } else {
        return Array()
    }
}


onKeyUp:
; ----------------------------------------------------------
; キーを押し上げたときの処理
; ----------------------------------------------------------
    if ( arr_bufKey.len() ) {
        ;; 出力処理を行う
        arr_renew_bufKey := Send_onKeyUp( arr_bufKey.first()
                                        , arr_bufKey.rest() )

        ;; 同時に打鍵するキーとして使われなかったものがあるとき
        if ( arr_renew_bufKey.len() ) {
            ;; 判定し直すキーを設定する
            arr_bufKey := arr_renew_bufKey.clone().insert2(1, arr_bufKey.first())

            ;; キー入力の待機状態を延長する
            ;; 判定し直すキーを入力した時間を呼び出す
            setTimer, onKeyUp, % MaximalGT - ( PF_Count() - time_of_input_key[arr_bufKey.rest().first()] )

            ;; スレッドをここで終了する
            ;; こうしないと、タイマーが停止してしまう
            return
        } else {
            arr_bufKey := Array()
            time_of_input_key := Object()
        }
    }

    ;; タイマーを停止する
    setTimer, onKeyUp, Off
Return