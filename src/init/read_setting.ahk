read_general_setting() {
    global
    
    ahk_or_exe := (A_IsCompiled) ? "exe" : "ahk"

    if ( ini_file_exists )
    {
        ;; ============================================================================
        ;; ---------------- キーボード配列の設定ファイルのありか
        ;; ============================================================================


        ;; キーボード配列の設定ファイル名を読み込む

        IniRead, FilePathOfUserEnglishLayout, %ini_file%, FilePath, UserEnglishLayout

        IniRead, FilePathOfUserJapaneseLayout, %ini_file%, FilePath, UserJapaneseLayout


        IniRead, FilePathOfUserShortcutKey, %ini_file%, FilePath, UserShortcutKey

        IniRead, FilePathOfUserShortcutKeyMuhenkanHenkan, %ini_file%, FilePath, UserShortcutKeyMuhenkanHenkan


        IniRead, FilePathOfUserFunctionKey, %ini_file%, FilePath, UserFunctionKey

        IniRead, FilePathOfUserTenKey, %ini_file%, FilePath, UserTenKey

    }
    else ;;; 設定ファイルが存在しないとき、つまり初回起動時
    {
        msgbox_option( 0, "DvorakJ について"
                        , "DvorakJ をご利用下さりありがとうございます。"
                        , " "
                        , "DvorakJ はキーボード配列用設定ファイルを選択して"
                        , "キーボード配列を変更するソフトウェアです。"
                        , " "
                        , "挙動の設定方法についてはヘルプページを参照して下さい。")

        FilePathOfUserEnglishLayout := read_value_from_ini("FilePath", "UserEnglishLayout", ".\data\lang\eng\QWERTY\QWERTY 配列 (OADG 109A版).txt")
        FilePathOfUserJapaneseLayout := read_value_from_ini("FilePath", "UserJapaneseLayout", ".\data\lang\jpn\同時に打鍵する配列\QWERTY 配列系\QWERTY 配列 (OADG 109A版).txt")
    }



    ;; ============================================================================
    ;;; ---------------- キーボード入力一般
    ;;; ============================================================================

    ;;; スペースキーにシフトキーの機能を持たせる
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 0
    is_SandS := read_value_from_ini("key", "is_SandS")

    ;;; コマンドプロンプト等で直接入力を常に使用するか
    ;;; そうするならば 1
    ;;; しないならば 0 を指定する
    ;;; 初期値は 1
    is_Monitoring_Console_Window_Class := read_value_from_ini("key", "is_Monitoring_Console_Window_Class", 1)

    ;;; 英語配列キーボードを使用中
    ;;; 無効にするならば 0
    ;;; 有効にするなら 1
    ;;; 初期値は 0
    is_US_keyboard := read_value_from_ini("key", "is_US_keyboard")

    ;;; IME の判定間隔
    ;;; 初期値は 100
    IMEms := read_value_from_ini("general", "IMEms", 100)

    ;;; 同時打鍵の判定間隔
    ;;; 初期値は 40
    MaximalGT_ENG := read_value_from_ini("general", "MaximalGT_ENG", 40)
    MaximalGT_JPN := read_value_from_ini("general", "MaximalGT_JPN", 40)

    ;;; キー間の遅延間隔
    ;;; 初期値は 10
    key_delay := read_value_from_ini("general", "key_delay", 10)


    ;;; IME の候補窓を開いているときに、
    ;;; 直接入力用配列を一時的に使用する
    ;;; 初期値は False
    is_using_English_Layout_with_IME_Candidate_Window := read_value_from_ini("key", "is_using_English_Layout_with_IME_Candidate_Window", False)

    ;;; 全角英数や半角英数で入力するときには
    ;;; 直接入力用配列を一時的に使用する
    ;;; 初期値は True
    is_using_English_layout_on_Alphanumeric_Mode := read_value_from_ini("key", "is_using_English_layout_on_Alphanumeric_Mode", True)

    ;;; 中国語を入力するときには
    ;;; 直接入力用配列を一時的に使用する
    ;;; 初期値は False
    is_using_English_layout_with_chinese_input_mode := read_value_from_ini("key", "is_using_English_layout_with_chinese_input_mode")

    ;;; Is_skkime_mode
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 0
    Is_skkime_mode := read_value_from_ini("key", "Is_skkime_mode")

    ;;; Is_googleime_mode
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 0
    Is_googleime_mode := read_value_from_ini("key", "Is_googleime_mode")

    ;;; Is_chinese_mode
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 0
    Is_chinese_mode := read_value_from_ini("key", "Is_chinese_mode")

    ;;; is_sending_by_way_of_WM_p
    ;;; いくつかの文字や記号を、IME を経由せずに、出力する
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 0
    is_sending_by_way_of_WM_p := read_value_from_ini("key", "is_sending_by_way_of_WM_p")



    ;; ============================================================================
    ;;; ---------------- 直接入力
    ;;; ============================================================================

    ;;; 拡張入力方式の使用
    ;;; 初期値は 2
    nEnglishLayoutMode := read_value_from_ini("key", "nEnglishLayoutMode", 2)

    ;;; Ctrl キーを押している最中は QWERTY 配列にするか
    ;;; そうするならば 1
    ;;; しないならば 0 を指定する
    ;;; 初期値は 0
    is_Using_QWERTY_with_CTRL := read_value_from_ini("key", "is_Using_QWERTY_with_CTRL")

    ;;; Alt キーを押している最中は QWERTY 配列にするか
    ;;; そうするならば 1
    ;;; しないならば 0 を指定する
    ;;; 初期値は 0
    is_Using_QWERTY_with_Alt := read_value_from_ini("key", "is_Using_QWERTY_with_Alt")

    ;;; Win キーを押している最中は QWERTY 配列にするか
    ;;; そうするならば 1
    ;;; しないならば 0 を指定する
    ;;; 初期値は 0
    is_Using_QWERTY_with_Win := read_value_from_ini("key", "is_Using_QWERTY_with_Win")


    ;;; ============================================================================
    ;;; ---------------- 日本語入力
    ;;; ============================================================================


    ;;; 拡張入力方式の使用
    ;;; 初期値は 2
    ;;; nEnglishLayoutMode := read_value_from_ini("key", "nEnglishLayoutMode", 2)

    nJapaneseLayoutMode := read_value_from_ini("key", "nJapaneseLayoutMode", 2)


    ;;; 濁点や半濁点を単独で入力する配列を使用する
    ;;; 無効にするならば 0
    ;;; 有効にするなら 1
    ;;; 初期値は 0
    Is_kana_typing_mode := read_value_from_ini("key", "Is_kana_typing_mode")

    ;;; is_ShiftPlusAlphabetMode
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 0
    is_ShiftPlusAlphabetMode := read_value_from_ini("key", "is_ShiftPlusAlphabetMode")

    ;;; vIs_with_Shift_outputting_nothing
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 0
    Is_with_Shift_outputting_nothing := read_value_from_ini("key", "Is_with_Shift_outputting_nothing")


    ;;; ============================================================================
    ;;; ---------------- 複数キー
    ;;; ============================================================================


    Loop, 5
    {
        IME_toggle_key_%A_Index% := read_value_from_ini("key", "IME_toggle_key_" . A_Index, 0)
    }

    ;;; ============================================================================
    ;;; ---------------- ショートカットキー
    ;;; ============================================================================

    ;;; 独自のショートカットキーを使用する
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 0
    is_User_Shortcut_Key := read_value_from_ini("key", "is_User_Shortcut_Key")

    ;;; [無変換]　[変換]　の設定
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 0
    is_Muhenkan_Henkan := read_value_from_ini("key", "is_Muhenkan_Henkan")


    ;;; ============================================================================
    ;;; ---------------- キーの置き換え
    ;;; ============================================================================

    ;;; キーを個別に置き換えるか？
    ;;; 何も変更しないならば 1
    ;;; 初期値は 1

    Loop, 26 {
        ;; DropDownList
        key_%A_Index%_en_number := read_value_from_ini("key", "key_" . A_Index . "_en_number", 1)
        key_%A_Index%_jp_number := read_value_from_ini("key", "key_" . A_Index . "_jp_number", 1)
        ;; Edit
        key_%A_Index%_en_text := read_value_from_ini("key", "key_" . A_Index . "_en_text", "")
        key_%A_Index%_jp_text := read_value_from_ini("key", "key_" . A_Index . "_jp_text", "")
    }

    ;;; ============================================================================
    ;;; ---------------- ファンクションキー
    ;;; ============================================================================

    ;;; 独自のファンクションキーを使用するか？
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 0
    is_User_Function_Key := read_value_from_ini("key", "is_User_Function_Key")



    ;;; ============================================================================
    ;;; ---------------- テンキー
    ;;; ============================================================================

    ;;; 独自のテンキーを使用するか？
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 0
    is_User_Ten_Key := read_value_from_ini("key", "is_User_Ten_Key")



    ;;; ============================================================================
    ;;; ---------------- くるくるスクロール
    ;;; ============================================================================

    ;;; マウスをくるくる回すとスクロール
    ;;; 使用するならば 0
    ;;; 使用しないならば 1
    ;;; 初期値は 0
    is_KuruKuruScroll := read_value_from_ini("mouse", "is_KuruKuruScroll")


    ;;; 垂直スクロールと水平スクロールを入れ替える
    is_SwapDirectionsOfScrolling := read_value_from_ini("mouse", "is_SwapDirectionsOfScrolling")

    ;;; 垂直スクロールと水平スクロールを入れ替える
    is_Lion_style := read_value_from_ini("mouse", "is_Lion_style")

    ;;; 高速時のスクロールスピード(1-3)
    Scroll_high := read_value_from_ini("mouse", "Scroll_high", 2)

    ;;; 低速時のスクロールスピード(1-3)
    Scroll_low := read_value_from_ini("mouse", "Scroll_low", 2)

    ;;; タイムアウトまでの時間
    Scroll_timeout := read_value_from_ini("mouse", "Scroll_timeout", 100)




    ;;; ============================================================================
    ;;; ---------------- 設定ウィンドウ
    ;;; ============================================================================

    ;;; 設定ウィンドウの位置
    ;;; software / AutoHotkey スレッド part10
    ;;; http://p2.chbox.jp/read.php?url=http%3A//pc12.2ch.net/test/read.cgi/software/1265518996/524-526
    
    Dirs := "XY"
    Loop, PARSE, Dirs
    {
        ;; GUI の表示位置
        Gui%A_LoopField% := read_value_from_ini("window", A_LoopField, 100)
        ;; プログレス・バーの表示位置
        Progress%A_LoopField% := Gui%A_LoopField% + 70
    }


    ;;; 最小化時にタスクトレイに収納するか
    ;;; 収納しないなら 0
    ;;; 収納するなら 1
    ;;; 初期値は 0
    is_minimising_DvorakJ_to_tray_p := read_value_from_ini("window", "is_minimising_DvorakJ_to_tray_p", 0)

    ;;; 設定画面右上のボタンを無効にするか
    ;;; 無効にしないなら 0
    ;;; 無効にするなら 1
    ;;; 初期値は 0
    is_minimising_by_pressing_close_button := read_value_from_ini("window", "is_minimising_by_pressing_close_button", 0)


    ;;; より多くの項目を通知するか
    ;;; 通知しないなら False
    ;;; 通知するなら True
    ;;; 初期値は False
    is_viewing_full_messages := read_value_from_ini("window", "is_viewing_full_messages", False)

    ;; デバッグ用メニューを表示するか
    ;; 表示するなら False
    ;; 表示しないなら True
    ;; 初期値は True
    show_menu_for_debug_p := read_value_from_ini("window", "show_menu_for_debug_p", True)


    ;;; ============================================================================
    ;;; ---------------- 起動時の処理
    ;;; ============================================================================

    ;;; 起動時にウィンドウを最小化するか
    ;;; 表示するならば 0
    ;;; 隠すならば 1
    ;;; 初期値は 0
    is_Minimising_Window := read_value_from_ini("window", "is_Minimising_Window")

    ;;; ログオン時に DvorakJ を起動する（ショートカット）
    ;;; 使用するならば 0
    ;;; 使用しないならば 1
    ;;; 初期値は 0
    is_shortcut_link := read_value_from_ini("general", "is_shortcut_link")
    
    ;;; DvorakJ 起動時に更新情報を取得
    ;;; 使用するならば 0
    ;;; 使用しないならば 1
    ;;; 初期値は 0
    is_Checking_Update_On_StartUp := read_value_from_ini("general", "is_Checking_Update_On_StartUp")

    ;;; ============================================================================
    ;;; ---------------- 他のアプリケーションを自動的に起動する設定
    ;;; ============================================================================

    ;;; 他のアプリケーションを自動的に起動する設定
    ;;; アプリケーションを|で区切って指定していく
    ;;; 初期値は ""
    startup_applications := read_value_from_ini("application", "startup_applications", "")

    ;;; アプリケーションのパスを相対パスで表示する
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 0
    is_showing_relative_path_for_applications := read_value_from_ini("application", "is_showing_relative_path_for_applications", False)

    ;;; アプリケーションのパスが正しいときのみ処理をすすめる
    ;;; 無効にするならば False
    ;;; 有効にするならば True
    ;;; 初期値は True
    is_executing_valid_paths_only := read_value_from_ini("application", "is_executing_valid_paths_only", True)

    ;;; ============================================================================
    ;;; ---------------- DvorakJ の有効/無効を切り替える設定
    ;;; ============================================================================

    ;;; DvorakJ 用のホットキーを無効にする
    ;;; 無効にするならば 0
    ;;; 有効にするならば 1
    ;;; 初期値は 1
    is_hotkey_of_DvorakJ := read_value_from_ini("key", "is_hotkey_of_DvorakJ", 1)
    ;; キーの設定
    suspend_key := read_value_from_ini("key", "suspend_key", "LCtrl -> RCtrl")
    resume_key := read_value_from_ini("key", "resume_key", "RCtrl -> LCtrl")
    toggle_key := read_value_from_ini("key", "toggle_key", "S-ScrollLock")
    restart_key := read_value_from_ini("key", "restart_key", "A-ScrollLock")


    debug_mode := read_value_from_ini("general", "debug_mode", 0)

    history_of_EnglishLayout := read_ini_and_get_array(ini_file, "history_of_EnglishLayout")
    history_of_JapaneseLayout := read_ini_and_get_array(ini_file, "history_of_JapaneseLayout")
    history_of_ShortcutKey := read_ini_and_get_array(ini_file, "history_of_ShortcutKey")
    history_of_MuhenkanHenkan := read_ini_and_get_array(ini_file, "history_of_MuhenkanHenkan")
    history_of_FunctionKey := read_ini_and_get_array(ini_file, "history_of_FunctionKey")
    history_of_TenKey := read_ini_and_get_array(ini_file, "history_of_TenKey")


    ;;; ============================================================================
    ;;; ---------------- ini を直接編集する
    ;;; ============================================================================

    ;;; skk-abbrev-mode
    skkime_abbrev_mode_key := read_value_from_ini("special_setting", "skkime_abbrev_mode_key", "/")

    ;;; skk-previous-candidate
    skkime_previous_candidate_key := read_value_from_ini("special_setting", "skkime_previous_candidate_key", "x")


    ;;; WM_UNICHAR_list
    ;;; WM_UNICHAR_apps_list := conv_from_string_to_array( read_value_from_ini("special_setting", "WM_UNICHAR_apps_list", "") )

    ;;; WM_CHAR_list
    WM_CHAR_apps_list := conv_from_string_to_array( read_value_from_ini("special_setting", "WM_CHAR_apps_list", "firefox.exe | POWERPNT.EXE | ") )


    ;; 文字やキーの置換リスト
    path_general_string_replace := read_value_from_ini("special_setting"
                                                    , "path_general_string_replace"
                                                    , ".\data\system\pattern_replacement\general\string_replace.txt")
    path_general_reg_ex_replace := read_value_from_ini("special_setting"
                                                    , "path_general_reg_ex_replace"
                                                    , ".\data\system\pattern_replacement\general\reg_ex_replace.txt")

    ;; ローマ字入力用置換リスト
    path_romanization_string_replace := read_value_from_ini("special_setting"
                                                        , "path_romanization_string_replace"
                                                        , ".\data\system\pattern_replacement\romanization\string_replace.txt")
    path_romanization_reg_ex_replace := read_value_from_ini("special_setting"
                                                        , "path_romanization_reg_ex_replace"
                                                        , ".\data\system\pattern_replacement\romanization\reg_ex_replace.txt")

    path_romanization_skkime_string_replace := read_value_from_ini("special_setting"
                                                        , "path_romanization_skkime_string_replace"
                                                        , ".\data\system\pattern_replacement\romanization\skkime_string_replace.txt")
    path_romanization_skkime_reg_ex_replace := read_value_from_ini("special_setting"
                                                        , "path_romanization_skkime_reg_ex_replace"
                                                        , ".\data\system\pattern_replacement\romanization\skkime_reg_ex_replace.txt")

    ;; カナ入力用置換リスト
    path_kana_string_replace := read_value_from_ini("special_setting"
                                                        , "path_kana_string_replace"
                                                        , ".\data\system\pattern_replacement\kana\string_replace.txt")
    path_kana_reg_ex_replace := read_value_from_ini("special_setting"
                                                        , "path_kana_reg_ex_replace"
                                                        , ".\data\system\pattern_replacement\kana\reg_ex_replace.txt")

    path_kana_googleime_string_replace := read_value_from_ini("special_setting"
                                                        , "path_kana_googleime_string_replace"
                                                        , ".\data\system\pattern_replacement\kana\googleime_string_replace.txt")
    path_kana_googleime_reg_ex_replace := read_value_from_ini("special_setting"
                                                        , "path_kana_googleime_reg_ex_replace"
                                                        , ".\data\system\pattern_replacement\kana\googleime_reg_ex_replace.txt")


    release_key_hook_on_pressing_down_modifier := read_value_from_ini("special_setting"
                                                                    , "release_key_hook_on_pressing_down_modifier_key", False)

    ;; すべてのキーの押し上げを監視する
    proportion_mode_ENG := read_value_from_ini("special_setting", "proportion_mode_ENG", False)
    proportion_mode_JPN := read_value_from_ini("special_setting", "proportion_mode_JPN", False)

    ;; キーの押し上げを監視する間隔を設定する
    ;; See, http://kouy.exblog.jp/12591916/
    proportion_of_simultaneous_keydown_events_ENG := read_value_from_ini("special_setting", "proportion_of_simultaneous_keydown_events_ENG", 100)
    proportion_of_simultaneous_keydown_events_JPN := read_value_from_ini("special_setting", "proportion_of_simultaneous_keydown_events_JPN", 100)

    ;; キーを押し下げてからリピートするまでの時間を設定する
    ;; 単位はミリ秒
    key_repeat_delay_ENG := read_value_from_ini("special_setting", "key_repeat_delay_ENG", 1000)
    key_repeat_delay_JPN := read_value_from_ini("special_setting", "key_repeat_delay_JPN", 1000)
}

read_version_setting(filename) {
    filename := to_windows_path(filename)
    IniRead, OutputVar, %filename%, local, current_version
    return OutputVar
}