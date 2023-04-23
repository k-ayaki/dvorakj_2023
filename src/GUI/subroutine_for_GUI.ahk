;;; ============================================================================
;;; ---------------- TreeView
;;; ============================================================================

Path_AbsolutePathFromDvorakJ(path){
    global dvorakj_dir
    return Path_SearchAndQualify(dvorakj_dir . "/" . path)
}

Path_RelativePathFromDvorakJTo(path){
    global dvorakj_dir

    ;; DvorakJのフォルダと同一ドライブにあるファイルのときには相対パスを返す
    if (Path_StripToRoot(path) == Path_StripToRoot(Path_SearchAndQualify(dvorakj_dir))) {
        return Path_RelativePathTo(Path_SearchAndQualify(dvorakj_dir), 0x10, path, 0x20)
    }
    
    ;; そうでなければパスをそのまま返す
    return path
}


Change_state_of_treeview:
    GUI, Submit, NoHide
    changing_tab :=  (A_GuiEvent = "DoubleClick") ? 1
                     :  (A_GuiEvent = "normal") ? 1
                     :  (A_GuiEvent = "F") ? 1
                     :  (A_GuiEvent = "f") ? 1
                     :  (A_GuiEvent = "K") ? 1
                     :  (A_GuiEvent = "*") ? 1
                     : 0


    if (changing_tab) {
        TV_GetText(GUI_treeview_name, TV_GetSelection())
        tree_number := (GUI_treeview_name = "キーボード") ? 1
                     :  (GUI_treeview_name = "入力全般") ? 1
                     :  (GUI_treeview_name = "SandS など") ? 1
                     :  (GUI_treeview_name = "待機と遅延") ? 2
                     :  (GUI_treeview_name = "IME 関連") ? 3
                     :  (GUI_treeview_name = "修飾キー関連") ? 4

                     :  (GUI_treeview_name = "直接入力") ? 5
                     :  (GUI_treeview_name = "日本語入力") ? 6

                     :  (GUI_treeview_name = "単一キー") ? 7
                     :  (GUI_treeview_name = "[Esc] など") ? 7
                     :  (GUI_treeview_name = "[Enter] など") ? 8
                     :  (GUI_treeview_name = "[Win]") ? 9
                     :  (GUI_treeview_name = "[無変換] など") ? 10
                     :  (GUI_treeview_name = "カーソルキー") ? 11
                     :  (GUI_treeview_name = "[Home] など") ? 12
                     :  (GUI_treeview_name = "[Insert] など") ? 13
                     :  (GUI_treeview_name = "[Pause] など") ? 14
                     :  (GUI_treeview_name = "ファンクションキー") ? 15
                     :  (GUI_treeview_name = "テンキー") ? 16

                     :  (GUI_treeview_name = "マウス") ? 17

                     :  (GUI_treeview_name = "その他") ? 18
                     :  (GUI_treeview_name = "起動時の設定") ? 18
                     :  (GUI_treeview_name = "起動時の自動実行") ? 19
                     :  (GUI_treeview_name = "ホットキー") ? 20
                     :  (GUI_treeview_name = "画面") ? 21
                     :    1

        GuiControl, Choose, tab_number, % tree_number
    }
return

;;; ============================================================================
;;; ---------------- すでに作成したメニューの動作を定義する
;;; ============================================================================

open_file(path){
    if (FileExist(path)) {
        myrun(path)
        return True
    }
    
    msgbox_option( 0, "設定ファイルの検索"
                    , "設定ファイルを開くことができません"
                    , ""
                    , path)
    return False
}

;;; 直接入力用配列
edit_en_layout_file:
    open_file(get_file_full_path( "." . FilePathOfUserEnglishLayout ))
    return

;;; 日本語入力用配列
edit_jp_layout_file:
    open_file(get_file_full_path( "." . FilePathOfUserJapaneseLayout ))
    return

;;; 独自のショートカットキー
edit_shortcutkey_file:
    open_file(get_file_full_path( "." . FilePathOfUserShortcutKey ))
    return


;;; [無変換] + [文字] と [変換] + [文字]
edit_muhenkan_henkan_file:
    open_file(get_file_full_path( "." . FilePathOfUserShortcutKeyMuhenkanHenkan ))
    return

;;; 独自のファンクションキー
edit_function_key_file:
    open_file(get_file_full_path( "." . FilePathOfUserFunctionKey ))
    return

;;; 独自のテンキー
edit_tenkey_file:
    open_file(get_file_full_path( "." . FilePathOfUserTenKey ))
    return

;;; ============================================================================
;;; ---------------- DvorakJ
;;; ============================================================================

about_get_new_version:
    myrun( "http://blechmusik.xii.jp/dvorakj/" )
    return

about_go_to_vector:
    myrun( "http://www.vector.co.jp/soft/winnt/util/se480857.html" )
    return


;;; ============================================================================
;;; ---------------- ヘルプ用
;;; ============================================================================


about_DvorakJ_ShortcutKey:
    msgbox_option( 0, "DvorakJ 用ショートカット・キー一覧"
                    , "[左 Ctrl] + [右 Ctrl]`t機能を無効にする"
                    , "[右 Ctrl] + [左 Ctrl]`t機能を有効にする"
                    , ""
                    , "[Shift] + [ScrollLock]`t機能の有効と無効を交互に切り替える"
                    , ""
                    , "[Alt] + [ScrollLock]`tDvorakJ を再起動する")
return



open_DvorakJ_folder:
    myrun(dvorakj_dir . "/")
return

open_user_folder:
    myrun(dvorakj_dir . "/user")
return

open_data_folder:
    myrun(dvorakj_dir . "/data")
return


tool_initialise_ini:
    msgbox_option( 0x1134, "DvorakJ の設定"
                    , "DvorakJ の設定情報をすべて消去します。"
                    , "消去後には DvorakJ を自動的に再起動します。"
                    , "よろしいですか？")

    IfMsgBox, Yes
    {
        FileDelete, % ini_file
        reload
    }
    return

tool_analyser_of_keyboard_layout:
    myrun(dvorakj_dir . "/apps/AnalyserOfKeyboardLayout." ahk_or_exe)
    return

tool_get_window_info:
    myrun(dvorakj_dir . "/apps/DisplayOfWindowInfoOnMouseOver." ahk_or_exe)
    return

tool_get_scan_code:
    myrun(dvorakj_dir . "/apps/DisplayOfscanKeyCode." ahk_or_exe)
    return

about_reference_manual:
    myrun("http://blechmusik.xii.jp/dvorakj/wiliki.cgi?DvorakJ%3a%e3%83%ac%e3%83%95%e3%82%a1%e3%83%ac%e3%83%b3%e3%82%b9%e3%83%9e%e3%83%8b%e3%83%a5%e3%82%a2%e3%83%ab")
    return

about_tutorial:
    myrun("http://blechmusik.xii.jp/dvorakj/wiliki.cgi?DvorakJ%3a%e3%83%81%e3%83%a5%e3%83%bc%e3%83%88%e3%83%aa%e3%82%a2%e3%83%ab")
    return

about_help:
    myrun("http://blechmusik.xii.jp/dvorakj/help/")
    return

about_readme:
    myrun(dvorakj_dir . "/doc/README.html")
    return

about_history:
    myrun(dvorakj_dir . "/doc/history.html")
    return

about_software:
    Gui, about:New
    Gui, about:Add, Text, x130 y20, DvorakJ
    Gui, about:Add, Text, , %dvorakj_current_version%　版
    GUI, about:Add, Text, , blechmusik

    Gui, about:Add, Button, gAboutGuiClose w70 Default x200 y180, OK (&O)

    Gui, about:Add, Link, x150 y100, website: <a href="http://blechmusik.xii.jp">blechmusik.xii.jp</a>
    Gui, about:Add, Link, , twitter: <a href="https://twitter.com/blechmusik">@blechmusik</a>
    Gui, about:Add, Link, gMail_to_blechmusik, mail: <a>blechmusik@gmail.com</a>

    Gui, about:Add, Picture, x10 y20 w100 h-1, ..\icon\things_digital.png

    gui, about:show, , On DvorakJ
    Gui, about:+Owner1
    Gui, 1:+Disabled
    return

aboutGuiClose:
    Gui, 1:-Disabled
    Gui, about:-Owner1
    GUI, about:Destroy
    return

mail_to_blechmusik:
    run, mailto:blechmusik@gmail.com
    return


about_is_update:
    updater_path := Path_SearchAndQualify(dvorakj_dir . "/DvorakJ_Updater." . ahk_or_exe)

    if ( Path_FileExists(updater_path) ) {
        myrun(updater_path . " --not-stand-alone")
        return
    }
    
    
    msgbox, 0, DvorakJ エラー, %updater_path% が存在しません`n更新処理を終了します
    return



;;; ============================================================================
;;; ---------------- debug 用
;;; ============================================================================

debug_ini:
    myrun(ini_file)
return

debug_version_ini:
    myrun(version_ini)
return

debug_Reload:
    Reload
return

debug_ListVars:
    ListVars
return

debug_ListLines:
    ListLines
return

debug_ListHotkeys:
    ListHotkeys
return

debug_KeyHistory:
    KeyHistory
return



;;; ============================================================================
;;; ---------------- ウィンドウのボタンのクリックやチェックの動作の定義
;;; ============================================================================


;;; タスクトレイのアイコンをダブルクリックすればウィンドウを表示
ResizeWindow:
    Gui,show
return


Toggle:
    bSuspended := !(bSuspended)
    
    action := (bSuspended) ? "suspend" : "resume"
    path := (A_IsCompiled) ? "DvorakJ_" . action . ".exe" :  "DvorakJ_" . action . ".ahk"
    run,% path

    return


AboutOK:
    GUI, 2:Destroy
    return


;;; ============================================================================
;;; ---------------- 独自配列の設定ファイルを指定する
;;; ============================================================================

SelectingEnglishLayoutSettingFile:
SelectingJapaneseLayoutSettingFile:
SelectingShortcutKeySettingFile:
SelectingShortcutKeyMuhenkanHenkanSettingFile:
SelectingFunctionKeySettingFile:
SelectingTenKeySettingFile:

    ;; ラベル名からどのような設定用のファイルかを判断する
    RegExMatch( A_ThisLabel, "(?<=Selecting)(.+)(?=SettingFile)", layout_name_seleted )

    file_number_selected := ( layout_name_seleted = "EnglishLayout" )              ? 1
                         :   ( layout_name_seleted = "JapaneseLayout" )            ? 2
                         :   ( layout_name_seleted = "ShortcutKey" )               ? 3
                         :   ( layout_name_seleted = "ShortcutKeyMuhenkanHenkan" ) ? 4
                         :   ( layout_name_seleted = "FunctionKey" )               ? 5
                         :   ( layout_name_seleted = "TenKey" )                    ? 6
                         : 0


    ;; 履歴リストの別名を定義する
    ;; DeepCopy() を使用していないので、今回処理する履歴リストと history_arr は同一となる
    history_arr := ( file_number_selected = 1 ) ? history_of_EnglishLayout
                :  ( file_number_selected = 2 ) ? history_of_JapaneseLayout
                :  ( file_number_selected = 3 ) ? history_of_ShortcutKey
                :  ( file_number_selected = 4 ) ? history_of_MuhenkanHenkan
                :  ( file_number_selected = 5 ) ? history_of_FunctionKey
                :  ( file_number_selected = 6 ) ? history_of_TenKey
                :  Array()

    ;; ポップアップを一度作成しているならば
    ;; 廃棄する
    if (menu_made_already) {
        menu, Menu1, DeleteAll
    }

    if ( history_arr.len()) { ; 履歴が一つ以上蓄積されているとき
        Menu, Menu1, Add, 参照..., recent_history_pop_up
        ;; 区切り線
        Menu, Menu1, Add

        ;; 最新の設定順に並べる
        ;; つまり、最後に追加したものを一番初めに置く
        for i,v in history_arr.reverse()
        {
            Menu, Menu1, Add, %v%, recent_history_pop_up
        }

        ;; ポップアップを廃棄するかどうか判断するための変数
        menu_made_already := True

        ;; ポップアップを、マウスカーソルの左下に出すよう調整する
        MouseGetPos, OutputVarX, OutputVarY
        pop_upX := OutputVarX - 350
        pop_upY := OutputVarY + 20

        ;; ポップアップを表示する
        Menu, Menu1, Show, %pop_upX%, %pop_upY%
    }
    else ; 参照ボタンを直接クリックしたのと同一の処理をする
    {
        Gui, 2:+owner1
        Gui, 1:+Disabled
        Gui, 2:Default

        ;; ファイルの選択画面を一つだけ表示する
        another_file_selector := True

        ChooseSettingFile(file_number_selected)

        Gui, 1:-Disabled
    }
Return



recent_history_pop_up:
    if (A_ThisMenuItemPos = 1) { ; 参照ボタンをクリックしたとき
        Gui, 2:+owner1
        Gui, 1:+Disabled
        Gui, 2:Default

        ;; ファイルの選択画面を一つだけ表示する
        another_file_selector := True

        ChooseSettingFile(file_number_selected)

        Gui, 1:-Disabled
        return
    }


    ;; 区切り線以外、つまり履歴のどれかをクリックしたとき
    if (A_ThisMenuItemPos != 2) {
        ;; 表示している履歴の順番から選択された設定内容を取得する
        ;; ただし、そのパスは dvorakj\ を基準とするものとして解釈する

        ;; DvorakJ.ahk からの相対パスを絶対パスに変換する
        FileAbsolutePath := Path_AbsolutePathFromDvorakJ(A_ThisMenuItem)

        ;; 選択された内容を保持しているリスト中
        ;; 今回選択された文字列が何番目に格納されているかを確認する
        index := history_arr.len() - (A_ThisMenuItemPos - 2) + 1

        if ( A_ThisMenuItem = ".\" ) { ; "\"
            msgbox_option( 0, "設定ファイルの検索"
                            , "設定ファイルを読み込めません。"
                            , ""
                            , A_ThisMenuItem)

            ;; 不要な設定を取り除く
            history_arr.delete(index)
            return
        }
        
        if ( Path_FileExists(FileAbsolutePath)) {
            FilenameforSB := FileAbsolutePath
            GoTo, MyChoice
            return
        }

        msgbox_option( 0, "設定ファイルの検索"
                        , "設定ファイルを読み込めません。"
                        , ""
                        , A_ThisMenuItem)

        ;; 不要な設定を取り除く
        history_arr.delete(index)
    }
Return

;;; ============================================================================
;;; ---------------- 
;;; ============================================================================

set_is_Using_QWERTY_with_CTRL:
set_is_Using_QWERTY_with_Win:
set_is_Using_QWERTY_with_Alt:
    keyname := LTrims(A_ThisLabel, "set_is_Using_QWERTY_with_")

    GUI, Submit, NoHide
    write_ini_then_update("key"
                        , "is_Using_QWERTY_with_" . keyname
                        , is_Using_QWERTY_with_%keyname%)

    SendUpdate_from_GUI("not-keyboard-layout")
return



set_is_US_keyboard:
set_is_Muhenkan_Henkan: ; 無変換と変換
set_is_hotkey_of_DvorakJ: ; DvorakJ 用ホットキーの機能
    GoSub, Sub_need_to_restart

    var_name := LTrims(A_ThisLabel, "set_")

    write_ini_then_update("key"
                        , var_name
                        , %var_name%)

    SendUpdate_from_GUI("not-keyboard-layout")
return


set_is_Monitoring_Console_Window_Class: ; コマンドプロンプトでは……
set_is_ShiftPlusAlphabetMode: ; Shift + 文字で……
set_is_using_English_Layout_with_IME_Candidate_Window: ; 候補選択窓が表示されているとき……
set_is_using_English_layout_on_Alphanumeric_Mode: ; 全角英数や半角英数……
set_is_using_English_layout_with_chinese_input_mode: ; 全角英数や半角英数……
set_is_sending_by_way_of_WM_p: ; IME を経由せずに……
set_is_SandS: ; SandS
set_is_with_Shift_outputting_nothing:
set_is_User_Shortcut_Key: ; ショートカットキー
set_is_User_Function_Key: ; ファンクション・キー
set_is_User_Ten_Key: ; テンキー
    GUI, Submit, NoHide
    var_name := LTrims(A_ThisLabel, "set_")

    write_ini_then_update("key"
                        , var_name
                        , %var_name%)


    SendUpdate_from_GUI("not-keyboard-layout")
return


set_Is_chinese_mode:
set_Is_skkime_mode:
set_Is_googleime_mode:
set_Is_kana_typing_mode:
set_nJapaneseLayoutMode: ; 日本語入力を常に使うか？
    GUI, Submit, NoHide
    
    var_name := LTrims(A_ThisLabel, "set_")

    write_ini_then_update("key"
                        , var_name
                        , %var_name%)

    set_GUI_name_of_JapaneseLayout()
    SendUpdate_from_GUI("not-keyboard-layout")
    set_keyboard_layout_version(2, FilePathOfUserJapaneseLayout)
return





set_IME_toggle_key_1:
set_IME_toggle_key_2:
set_IME_toggle_key_3:
set_IME_toggle_key_4:
set_IME_toggle_key_5:
    GUI, Submit, NoHide

    i := LTrims(A_ThisLabel, "set_IME_toggle_key_")

    write_ini_then_update("key"
                        , "IME_toggle_key_" . i
                        , IME_toggle_key_%i%)

    SendUpdate_from_GUI("not-keyboard-layout")
return



set_is_minimising_DvorakJ_to_tray_p:
set_is_minimising_Window:
set_is_minimising_by_pressing_close_button:
set_is_viewing_full_messages:
    GUI, Submit, NoHide
    var_name := LTrims(A_ThisLabel, "set_")

    write_ini_then_update("window"
                        , var_name
                        , %var_name%)

    SendUpdate_from_GUI("not-keyboard-layout")
return


set_show_menu_for_debug_p:
    GoSub, Sub_need_to_restart
    var_name := LTrims(A_ThisLabel, "set_")

    write_ini_then_update("window"
                        , var_name
                        , %var_name%)

    SendUpdate_from_GUI("not-keyboard-layout")
return



set_GUI_key_1_setting:
set_GUI_key_2_setting:
set_GUI_key_3_setting:
set_GUI_key_4_setting:
set_GUI_key_5_setting:
set_GUI_key_6_setting:
set_GUI_key_7_setting:
set_GUI_key_8_setting:
set_GUI_key_9_setting:
set_GUI_key_10_setting:
set_GUI_key_11_setting:
set_GUI_key_12_setting:
set_GUI_key_13_setting:
set_GUI_key_14_setting:
set_GUI_key_15_setting:
set_GUI_key_16_setting:
set_GUI_key_17_setting:
set_GUI_key_18_setting:
set_GUI_key_19_setting:
set_GUI_key_20_setting:
set_GUI_key_21_setting:
set_GUI_key_22_setting:
set_GUI_key_23_setting:
set_GUI_key_24_setting:
set_GUI_key_25_setting:
set_GUI_key_26_setting:
    GUI, Submit, NoHide

    key_number := LTrims(Rtrims(A_ThisLabel, "_setting"), "set_GUI_key_")

    key_%key_number%_en_number  := ( key_%key_number%_en_number = 2) ? 1
                                :  ( key_%key_number%_en_number = 4) ? 1
                                :  ( key_%key_number%_en_number = 7) ? 1
                                :  ( key_%key_number%_en_number = 12) ? 1
                                :  ( key_%key_number%_en_number = 17) ? 1
                                :  ( key_%key_number%_en_number = 22) ? 1
                                :  ( key_%key_number%_en_number = 25) ? 1
                                :  ( key_%key_number%_en_number = 31) ? 1
                                :  ( key_%key_number%_en_number = 34) ? 1
                                :   key_%key_number%_en_number

    key_%key_number%_jp_number  := ( key_%key_number%_jp_number = 2) ? 1
                                :  ( key_%key_number%_jp_number = 4) ? 1
                                :  ( key_%key_number%_jp_number = 7) ? 1
                                :  ( key_%key_number%_jp_number = 12) ? 1
                                :  ( key_%key_number%_jp_number = 17) ? 1
                                :  ( key_%key_number%_jp_number = 22) ? 1
                                :  ( key_%key_number%_jp_number = 25) ? 1
                                :  ( key_%key_number%_jp_number = 31) ? 1
                                :  ( key_%key_number%_jp_number = 34) ? 1
                                :   key_%key_number%_jp_number

/*
    key_%key_number%_en_text := GUI_key_%key_number%_en_text
    key_%key_number%_jp_text := GUI_key_%key_number%_jp_text
*/

    ;; DropDownList
    write_value_to_ini("key", "key_" . key_number . "_en_number", key_%key_number%_en_number)
    write_value_to_ini("key", "key_" . key_number . "_jp_number", key_%key_number%_jp_number)
    ;; Edit
    write_value_to_ini("key", "key_" . key_number . "_en_text", key_%key_number%_en_text)
    write_value_to_ini("key", "key_" . key_number . "_jp_text", key_%key_number%_jp_text)


    SendUpdate_from_GUI("not-keyboard-layout")
return


set_is_KuruKuruScroll:
set_is_SwapDirectionsOfScrolling:
set_is_Lion_style:
    GUI, Submit, NoHide
    var_name := LTrims(A_ThisLabel, "set_")

    write_ini_then_update("mouse"
                        , var_name
                        , %var_name%)

    SendUpdate_from_GUI("not-keyboard-layout")
return



;;; 高速
;;; 低速
;;; 感度
;;; 入力待ち状態の保持時間
set_Scroll_high:
set_Scroll_low:
set_Scroll_timeout:
    GUI, Submit, NoHide

    Scroll_option := LTrims(A_ThisLabel, "set_scroll_")

    GuiControlGet, OutputVar1, , Scroll_%Scroll_option%_1
    GuiControlGet, OutputVar2, , Scroll_%Scroll_option%_2

    If (Scroll_%Scroll_option% <> OutputVar1) ; スライドが変更されたとき
    {
        Scroll_%Scroll_option% := OutputVar1
        GuiControl, Text, Scroll_%Scroll_option%_2, % Scroll_%Scroll_option%

        write_value_to_ini("mouse", "Scroll_" . Scroll_option, Scroll_%Scroll_option%)

        SendUpdate_from_GUI("not-keyboard-layout")
    }
return


;;; IME の状態の検出
set_IMEms_1:
set_IMEms_2:
    GUI, Submit, NoHide

    RegExMatch( A_ThisLabel, "(?<=set_IMEms_)(.+)", n )

    If (1 = LTrims(A_ThisLabel, "set_IMEms_")) { ; スライドが変更されたとき
        GuiControlGet, IMEms, , IMEms_1
        GuiControl, Text, IMEms_2, %IMEms%
    } else { ; 編集欄が変更されたとき
        GuiControlGet, IMEms, , IMEms_2
        GuiControl, Text, IMEms_1, %IMEms%
    }

    write_value_to_ini("general", "IMEms", IMEms)

    SendUpdate_from_GUI("not-keyboard-layout")
return

;;; key_delay の検出
set_key_delay_1:
set_key_delay_2:
    GoSub, Sub_need_to_restart

    If (1 = LTrims(A_ThisLabel, "set_key_delay_")) { ; スライドが変更されたとき
        GuiControlGet, key_delay, , key_delay_1
        GuiControl, Text, key_delay_2, %key_delay%
    } else { ; 編集欄が変更されたとき
        GuiControlGet, key_delay, , key_delay_2
        GuiControl, Text, key_delay_1, %key_delay%
    }

    write_value_to_ini("general", "key_delay", key_delay)

    SendUpdate_from_GUI("not-keyboard-layout")
return


;;; 同時打鍵の検出
set_SimultaneousStroke_ENG:
set_SimultaneousStroke_JPN:
    GUI, Submit, NoHide
    
    lang := LTrims(A_ThisLabel, "set_SimultaneousStroke_")

    GuiControlGet, OutputVar1, , SimultaneousStroke_%lang%_1
    GuiControlGet, OutputVar2, , SimultaneousStroke_%lang%_2

    If (MaximalGT_%lang% <> OutputVar1) ; スライドが変更されたとき
    {
        MaximalGT_%lang% := OutputVar1
        GuiControl, Text, SimultaneousStroke_%lang%_2, %OutputVar1%
    }
    else ; 編集欄が変更されたとき
    {
        MaximalGT_%lang% := OutputVar2
        GuiControl, Text, SimultaneousStroke_%lang%_1, %OutputVar2%
    }

    write_value_to_ini("general", "MaximalGT_" . lang, MaximalGT_%lang%)

    SendUpdate_from_GUI("not-keyboard-layout")
return

set_suspend_key:
set_resume_key:
set_toggle_key:
set_restart_key:
    GoSub, Sub_need_to_restart

    var_name := LTrims(A_ThisLabel, "set_")
    
    write_ini_then_update("key"
                        , var_name
                        , %var_name%)

    SendUpdate_from_GUI("not-keyboard-layout")
return



set_is_Checking_Update_On_StartUp:
    GUI, Submit, NoHide
    var_name := LTrims(A_ThisLabel, "set_")

    write_ini_then_update("general"
                        , var_name
                        , %var_name%)

    SendUpdate_from_GUI("not-keyboard-layout")
    return


set_is_shortcut_link:
    GUI, Submit, NoHide
    var_name := LTrims(A_ThisLabel, "set_")

    write_ini_then_update("general"
                        , var_name
                        , %var_name%)

    SendUpdate_from_GUI("not-keyboard-layout")


    ;; ショートカットの生成or削除処理を行う
    ;; ショートカットは次のパスに生成されるはず      
    LinkFile := A_Startup . "\DvorakJ.lnk" 

    ;; ショートカットリンクが使用されるとき 
    ;; ショートカットリンクを必ず作成する
    if (is_shortcut_link) {
        FileCreateShortcut, %dvorakj_dir%\DvorakJ.%ahk_or_exe%, %LinkFile%
        return
    }
    
    ;; ショートカットリンクが使用されないとき
    ;; ショートカットリンクの所在を確認する
    FileGetShortcut, %LinkFile%
    
    ;; ショートカットリンクが存在しているときは
    ;; それを削除しなければならない
    if (0 == ErrorLevel) {
        FileDelete, %LinkFile%
    }
    
    return


;; --------------------------------------------------------------------------------
;; startup applications

set_showing_relative_path_for_applications:
    GUI, Submit, NoHide
    write_ini_then_update("application"
                        , "is_showing_relative_path_for_applications"
                        , is_showing_relative_path_for_applications)

    ;; いったんすべての項目を削除する
    LV_Delete()
    lv_add_startup_applications(is_showing_relative_path_for_applications)

    SendUpdate_from_GUI("not-keyboard-layout")
return

set_executing_valid_paths_only:
    GUI, Submit, NoHide
    write_ini_then_update("application"
                        , "is_executing_valid_paths_only"
                        , is_executing_valid_paths_only)
    SendUpdate_from_GUI("not-keyboard-layout")
return
    
get_paths_of_startup_applications()
{
    global

    tmp := ""
    Loop,% LV_GetCount() 
    {
        LV_GetText(path, A_Index, 1)
        tmp .= Path_RelativePathFromDvorakJTo(path) "|"
    }
    
    return Trim(tmp, "|")
}


save_paths_of_startup_applications:
    write_ini_then_update("application"
                        , "startup_applications"
                        , get_paths_of_startup_applications())
    SendUpdate_from_GUI("not-keyboard-layout")
    return

choose_path_of_startup_application_from_dialog:
    Gui, Submit, NoHide
    RowNumber := LV_GetNext(, "F")
    
    ;; 何かしらの項目が選択されているときには
    ;; その項目のパスを起点としてファイル選択画面を表示する
    ;; 何の項目も選択されていなければ
    ;; DvorakJ のフォルダを起点としてファイル選択画面を表示する
    if (0 < RowNumber) {
        base_folder := ""
    } else {
        base_folder := "..\"
    }
    
    FileSelectFile, filename, 3, %base_folder%
    GuiControl, Text, path_of_startup_application, %filename%
    return

add_path_of_startup_application_to_list:
    Gui, Submit, NoHide
    
    ;; 実質的に空白文字をアプリケーションに追加しようとしたとき
    if ("" == Trim(path_of_startup_application)) {
        ;; 処理を停止する
        return
    }

    ;; 相対パスで表示する場合
    if (is_showing_relative_path_for_applications) {
        LV_Add(, Path_RelativePathFromDvorakJTo(path_of_startup_application))
    } else {
        LV_Add(, path_of_startup_application)
    }
    ;; 選択状態をいったんすべて解除する
    LV_Modify(0 , "-Select")
    ;; リストの末尾にフォーカスを合わせる
    LV_Modify(LV_GetCount(), "Select Focus")

    Gosub, save_paths_of_startup_applications
    return
    
edit_path_of_startup_application_in_list:
    Gui, Submit, NoHide
    RowNumber := LV_GetNext(, "F")
    LV_Modify(RowNumber, , path_of_startup_application)

    Gosub, save_paths_of_startup_applications
    return
    
delete_path_of_startup_application_from_list:
    Gui, Submit, NoHide
    RowNumber := LV_GetNext(, "F")
    LV_Delete(RowNumber)

    ;; リストの末尾の項目を削除したとき
    if (LV_GetCount() < RowNumber) 
    {
        LV_Modify(RowNumber - 1, "Select Focus")
    } else {
        LV_Modify(RowNumber, "Select Focus")
    }

    Gosub, save_paths_of_startup_applications
    return

move_up_path_of_startup_application:
move_down_path_of_startup_application:
    Gui, Submit, NoHide
    RowNumber := LV_GetNext(, "F")
    from := RowNumber
    
    ;; サブルーチン名によって項目の移動方向を決定する
    ;; 数が少ない方が上
    if ("move_up_path_of_startup_application" == A_ThisLabel) 
    {
        to := RowNumber - 1
    } else {
        to := RowNumber + 1
    }

    ;; 表示されているリストの項目が何かしら選択されているとき
    if ((0 < to) and (to <= LV_GetCount()))
    {
        LV_GetText(LVtext1, from, 1)
        LV_GetText(LVtext2, to  , 1)

        LV_Modify(from , "-Select", LVtext2)
        LV_Modify(to   ,  "Select Focus", LVtext1)

        Gosub, save_paths_of_startup_applications
    }
    return


;; --------------------------------------------------------------------------------
ApplicationListView:
    if ("Normal"== A_GuiEvent){
        RowNumber := A_EventInfo
        
        ;; 何かしらの項目がフォーカスされているとき
        if (0 < RowNumber) {
            LV_GetText(LVtext, RowNumber, 1)
            GuiControl, Text, path_of_startup_application, %LVtext%
        }        
    }
Return
;; --------------------------------------------------------------------------------





GuiClose:
    if (is_minimising_by_pressing_close_button ){
        GoTo, GuiMinimise
    }
    else
    {
        GoTo, ProgramClose
    }
return

ProgramClose:
    ;; SendState_from_GUI("exit")
    ;; ExitApp

    ;; path := (A_IsCompiled) ? "DvorakJ_exit.exe" : "DvorakJ_exit.ahk"
    ;; run,% path

    myrun(dvorakj_dir . "/apps/DvorakJ_exit." ahk_or_exe)
return

AppReload:
    myrun(dvorakj_dir . "/apps/DvorakJ_reload." ahk_or_exe)
    ;; SendState_from_GUI("reload")
return

GuiSize:
    if ( A_EventInfo = 1 ) { ; 最小化したとき
        GoTo, GuiMinimise
    }
return


GuiMinimise:
    if ( is_minimising_DvorakJ_to_tray_p ) {
        Gui, Show, Hide
        return
    }
    
    GUI, Minimize
    return


Sub_need_to_restart:
    GUI, Submit, NoHide
    TrayTip, DvorakJ の再起動,% "DvorakJ の設定を更新しました`nDvorakJ を再起動してください"
    return


write_ini_then_update(p_section_name
                    , p_raw_value
                    , p_GUI_value) {
    global

    write_value_to_ini(p_section_name, p_raw_value, p_GUI_value)
    %p_raw_value% := p_GUI_value

    return p_GUI_value
}



set_GUI_Text(p_controlID, p_str) {
    global

    GuiControl, Text
        , %p_controlID%
        , % p_str

    return p_str
}

