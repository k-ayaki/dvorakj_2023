;; IME の状態を一定間隔毎に取得する
;; 取得した IME の状態に応じ、キー・フックを自動的に変更する
IME_GET:
    ;; window 名
    window_title := "all"
;


    ; カーソル位置に何かを表示させる
    if not ( A_IsCompiled ) {
        if ( caret_mode ) {
            w_TickCount := PF_Count()
            tooltip_pos_mode( w_TickCount, A_CaretX + 20, A_CaretY + 20)
        }
    }


    ;; 日本語入力用配列を全く使用しないとき
    if ( nJapaneseLayoutMode = 1 ) {
        if ( lang_mode != "en" ) {
            GoSub, sub_use_English_layout
        }

        return
    }


    ;; 日本語入力用配列を常に使用するとき
    if ( nJapaneseLayoutMode = 3 ) { 
        if ( lang_mode != "jp" ) {
            IME_ConvMode :=  ( Is_kana_typing_mode ) ? 9  ; かな入力
                         :                             16 ; ローマ字入力

            GoSub, sub_use_Japanese_layout
        }

        ; IMEの状態を取得
        If ( IME_GET() ) {
            IME_SET(0)
        }

        ;; 処理を停止する
        return
    }



    ;; コマンドプロンプトでは IME の状態を取得できない
    ;; そのため、「コマンドプロンプト等で直接入力を常に使用する」を有効にしているときには、
    ;; 直接入力を強制的に使用する
    If ( is_Monitoring_Console_Window_Class ) {
        IfWinActive, ahk_class ConsoleWindowClass
        {
            If ( bIME ) {
                IME_SET(0)
                GoSub, sub_use_English_layout
            }

            ;; 処理を停止する
            return
        }
    }

    ;; 日本語入力用配列への切り替えの推定処理を初期化
    temp_Switch_Layout_to_Japanese := False


    ;; IME が有効か否かを定期的に確認する
    if ( bIME != IME_GET() ) {
        bIME := IME_GET()

        if ( bIME ) {
            ;; 日本語入力用配列への切り替えを推定しておく
            ;; なぜ推定かというと、入力が英数モードになっているために
            ;; 日本語入力用配列に切り替える必要がないかもしれないから

            temp_Switch_Layout_to_Japanese := True
        } else {
            GoSub, Switch_Layout_to_English
        }
    }



    ;; IME が無効のとき
    If not ( bIME ) {
        return
    }




    ;; IME が有効のとき
    


    ;; Caps Lock: On
    If ( bCapsLockState ) { 
        GoSub, sub_use_English_layout

        ;; 処理を停止する
        return
    }
    



    ;; 変換候補窓が出現している間、直接入力用配列を一時的に使用するとき
    if ( is_using_English_Layout_with_IME_Candidate_Window ){
        if (2 == IME_GetConverting()) { 
            ;; 一時的に直接入力用配列を使用する
            GoSub, sub_use_English_layout

            ;; 処理を停止する
            return
        }
    }
        

    ;; 文字列を入力している最中かどうかを調べる
    bIME_Converting := IME_GetConverting()

    ; IME 入力モードを取得
    IME_ConvMode := IME_GetConvMode()

    ;; 全角英数モード、半角英数モード
    ;; または半角アルファベットの固定入力のときには
    ;; 1 を返す
    ;; それ以外は 0 を返す
    bAlphanumericMode := ( 0 == IME_ConvMode )   ? 1 ; かな    半英数
                      :  ( 8 == IME_ConvMode )   ? 1 ; かな    全英数
                      :  ( 16 == IME_ConvMode )  ? 1 ; ローマ字半英数
                      :  ( 24 == IME_ConvMode )  ? 1 ; ローマ字全英数
                      :  ( 256 == IME_ConvMode ) ? 1 ; 半角アルファベットの入力 (ATOK)
                      :  ( 265 == IME_ConvMode ) ? 1 ; 半角アルファベットの入力 (ATOK)
                      :  ( 272 == IME_ConvMode ) ? 1 ; 半角アルファベットの固定入力
                      :  ( 281 == IME_ConvMode ) ? 1 ; 半角アルファベットの固定入力
                      :                            0

    is_using_English_layout_without_fail := false

    
    ;; 全角英数モード、半角英数モード
    ;; または半角アルファベットの固定入力のときには
    ;; 直接入力用配列を一時的に使用する
    If (( is_using_English_layout_on_Alphanumeric_Mode ) and ( bAlphanumericMode )) {
        is_using_English_layout_without_fail := True
    }


    ;; 中国語入力のときも同様
    if ((is_using_English_layout_with_chinese_input_mode) and ( RegExMatch(Get_languege_name(), "zh-"))){ 
        is_using_English_layout_without_fail := True
    }


    If ( is_using_English_layout_without_fail ) {

        ;; 日本語入力用配列を使用しているとき
        if ( lang_mode = "jp") {
            ;; 直接入力用配列に切り替える
            GoSub, sub_use_English_layout
        }
        
        return
    }
    

    
    ;; 英数入力モードではないにもかかわらず
    ;; 直接入力を使用するようになっているときには
    ;; 日本語入力へと強制的に変更する
    ;; ATOK の「半角アルファベットをそのまま入力します」対策
    if ( Is_UsingEnglishLayout ) {

        GoSub, Switch_Layout_to_Japanese
        return
    } 
    
    ;; 推定のままにしておいた、日本語入力用配列への切り替えを実行する
    if ( temp_Switch_Layout_to_Japanese ) { 
        GoSub, Switch_Layout_to_Japanese
    }
return



;;; 直接入力用のキー・フックへと設定を一度に変更する
Switch_Layout_to_English:
    ;; debug_new_proc := False

    ;; tooltip, Switch_Layout_to_English

    Is_UsingEnglishLayout := True
    lang_mode := "en"

    ;; 同時に打鍵するときの判定時間
    MaximalGT := MaximalGT_ENG

    proportion_mode := proportion_mode_ENG
    proportion_of_simultaneous_keydown_events := proportion_of_simultaneous_keydown_events_ENG

    ;; キーを押し下げてからリピートし始めるまでの時間
    key_repeat_delay := key_repeat_delay_ENG

    arr_keys := Array()
    key_stack := Array()

    SetMultiSpecialKeyHook(1)
return


;;; 日本語入力用のキー・フックへと設定を一度に変更する
Switch_Layout_to_Japanese:
    ;; if (debug_mode) {
    ;;      debug_new_proc := True
    ;; }
    ;; tooltip, Switch_Layout_to_Japanese        

    Is_UsingEnglishLayout := False
    lang_mode := "jp"


    ;; 同時に打鍵するときの判定時間
    MaximalGT := MaximalGT_JPN

    proportion_mode := proportion_mode_JPN
    proportion_of_simultaneous_keydown_events := proportion_of_simultaneous_keydown_events_JPN

    ;; キーを押し下げてからリピートし始めるまでの時間
    key_repeat_delay := key_repeat_delay_JPN

    arr_keys := Array()
    key_stack := Array()

    SetMultiSpecialKeyHook(2)
return



;; IME 関連の設定を無効にする
sub_use_English_layout:
    bIME := False
    GoSub, Switch_Layout_to_English
return


;; IME 関連の設定を有効にする
sub_use_Japanese_layout:

    bIME := True
    GoSub, Switch_Layout_to_Japanese
return
