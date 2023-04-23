;; ============================================================================
;;; ---------------- メニューの作成
;;; ============================================================================



arr_menu := Array()
arr_menu.append( Array("ファイル(&F)", "File"
                    , Array( Array("DvorakJ フォルダを開く(&O)"
                                         , "open_DvorakJ_folder"
                                         , "..\icon\menu\folder.ico" )
                         ,   Array("DvorakJ/data フォルダを開く(&D)"
                                          , "open_data_folder"
                                          , "..\icon\menu\folder_go.ico" )
                         ,   Array("DvorakJ/user フォルダを開く(&U)"
                                         , "open_user_folder"
                                         , "..\icon\menu\folder_go.ico" )
                         ,   ""
                         ,   Array("再起動(&R)"
                                        , "AppReload"
                                        , "..\icon\menu\restart_services.ico")
                         ,   ""
                         ,   Array("最小化(&M)"
                                        , "GuiMinimise"
                                         , "..\icon\menu\application_control_bar.ico")
                         ,   ""
                         ,   Array("終了(&X)"
                                        , "ProgramClose"
                                        , "..\icon\menu\cancel.ico"))))

arr_menu.append( Array("編集(&E)", "Edit"
                    , Array( Array("「直接入力用配列」の設定ファイル(&E)"
                                        , "edit_en_layout_file"
                                        , "..\icon\menu\script_edit.ico" )
                            , Array("「日本語入力用配列」の設定ファイル(&J)"
                                        , "edit_jp_layout_file"
                                        , "..\icon\menu\script_edit.ico" )
                            , ""
                            , Array("「独自のショートカットキー」の設定ファイル(&S)"
                                        , "edit_shortcutkey_file"
                                        , "..\icon\menu\script_edit.ico" )
                            , Array("「[無変換] + [文字] と [変換] + [文字]」の設定ファイル(&M)"
                                      , "edit_muhenkan_henkan_file"
                                      , "..\icon\menu\script_edit.ico" )
                            , ""
                            , Array("「独自のファンクションキー」の設定ファイル(&F)"
                                        , "edit_function_key_file"
                                        , "..\icon\menu\script_edit.ico" )
                            , Array("「独自のテンキー」の設定ファイル(&T)"
                                        , "edit_tenkey_file"
                                        , "..\icon\menu\script_edit.ico" ))))

arr_menu.append( Array("ツール(&T)", "Tool"
                    , Array( Array("DvorakJ の実行を停止 / 再開する(&T)"
                                       , "Toggle"
                                       , "..\icon\menu\switch.ico" )
                            , ""
                            , Array("キーボード配列を解析する(&K)"
                                        , "tool_analyser_of_keyboard_layout"
                                        , "..\icon\menu\application_view_icons.ico" )
                            , Array("ウィンドウの情報を取得する(&W)"
                                    , "tool_get_window_info"
                                    , "..\icon\menu\application_form_magnify.ico" )
                            , Array("文字キーの情報を取得する(&C)"
                                    , "tool_get_scan_code"
                                    , "..\icon\menu\keyboard_magnify.ico" )
                            , ""
                            , Array("DvorakJ の設定をすべて消去する(&D)"
                                    , "tool_initialise_ini"
                                    , "..\icon\menu\siren.ico" ))))

arr_menu.append( Array("ヘルプ(&H)", "About"
                    , Array( Array("DvorakJ 配布ページ(&P)"
                                   , "about_get_new_version"
                                   , "..\icon\menu\world_go.ico" )
                            , Array("DvorakJ 配布ページ(&Vector.co.jp)"
                                                    , "about_go_to_vector"
                                                    , "..\icon\menu\world_go.ico" )
                            , ""
                            , Array("DvorakJ レファレンスマニュアル(&M)"
                                                    , "about_reference_manual"
                                                    , "..\icon\menu\world_go.ico" )
                            , Array("DvorakJ チュートリアル(&T)", "about_tutorial", "..\icon\menu\world_go.ico" )
                            , ""
                            , Array("&README"
                                        , "about_readme"
                                        , "..\icon\menu\document_info.ico")
                            , Array("更新履歴(&H)"
                                        , "about_history"
                                        , "..\icon\menu\document_info.ico")
                            , ""
                            , Array("DvorakJ の更新情報を取得する(&U)"
                                                    , "about_is_update"
                                                    , "..\icon\menu\update.ico" )
                            , ""
                            , Array("DvorakJ について(&A)"
                                                    , "about_software"
                                                    , "..\icon\menu\information.ico" ))))


If ( !A_IsCompiled && show_menu_for_debug_p ) {
    arr_menu.append( Array("&Debug", "debug"
                        , Array( Array("&1) Open ./user/&setting.ini"
                                               , "debug_ini" )
                                , Array("&2) Open ./data/&version.ini"
                                  , "debug_version_ini" )
                                , ""
                                , Array("&Reload", "debug_Reload" )
                                , Array("List&Vars", "debug_ListVars" )
                                , Array("List&Lines", "debug_ListLines" )
                                , Array("List&Hotkeys", "debug_ListHotkeys" )
                                , Array("&KeyHistory", "debug_KeyHistory" ))))
}

add_menu(arr_menu, "MyMenuBar")



;;; ============================================================================
;;; ---------------- タスクトレイの項目
;;; ============================================================================

;;; タスクトレイの項目の設定
Menu, Tray, Click, 1
Menu, Tray, % ( show_menu_for_debug_p ) ? "Add" : "NoStandard" 

;;; ツールチップに使用している配列を表示
Menu, Tray, Tip, % Array("DvorakJ"
, name_of_EnglishLayout
, name_of_JapaneseLayout).join()



arr_menu := Array()

arr_menu.append( Array("ウィンドウを表示する", "ResizeWindow"))

arr_menu.append("add")

arr_menu.append( Array("ファイル(&F)", "FileTray"
                    , Array( Array("DvorakJ フォルダを開く(&O)"
                               , "open_DvorakJ_folder"
                               , "..\icon\menu\folder.ico" )
                         ,   Array("DvorakJ/data フォルダを開く(&D)"
                                                        , "open_data_folder"
                                                        , "..\icon\menu\folder_go.ico" )
                         ,   Array("DvorakJ/user フォルダを開く(&U)"
                                                        , "open_user_folder"
                                                        , "..\icon\menu\folder_go.ico" )
                         ,   ""
                         ,   Array("再起動(&R)"
                                        , "AppReload"
                                        , "..\icon\menu\restart_services.ico")
                         ,   ""
                         ,   Array("最小化(&M)"
                                        , "GuiMinimise"
                                        , "..\icon\menu\application_control_bar.ico")
                         ,   ""
                         ,   Array("終了(&X)"
                                        , "ProgramClose"
                                        , "..\icon\menu\cancel.ico"))))

arr_menu.append( Array("編集(&E)", "EditTray"
                    , Array( Array("「直接入力用配列」の設定ファイル(&E)"
                               , "edit_en_layout_file"
                               , "..\icon\menu\script_edit.ico" )
                            , Array("「日本語入力用配列」の設定ファイル(&J)"
                                        , "edit_jp_layout_file"
                                        , "..\icon\menu\script_edit.ico" )
                            , ""
                            , Array("「独自のショートカットキー」の設定ファイル(&S)"
                                        , "edit_shortcutkey_file"
                                        , "..\icon\menu\script_edit.ico" )
                            , Array("「[無変換] + [文字] と [変換] + [文字]」の設定ファイル(&M)"
                                                             , "edit_muhenkan_henkan_file"
                                                             , "..\icon\menu\script_edit.ico" )
                            , ""
                            , Array("「独自のファンクションキー」の設定ファイル(&F)"
                                        , "edit_function_key_file"
                                        , "..\icon\menu\script_edit.ico" )
                            , Array("「独自のテンキー」の設定ファイル(&T)"
                                        , "edit_tenkey_file"
                                        , "..\icon\menu\script_edit.ico" ))))

arr_menu.append( Array("ツール(&T)", "ToolTray"
                    , Array( Array("DvorakJ の実行を停止 / 再開する(&T)"
                                        , "Toggle"
                                        , "..\icon\menu\switch.ico" )
                            , ""
                            , Array("キーボード配列を解析する(&K)"
                                        , "tool_analyser_of_keyboard_layout"
                                        , "..\icon\menu\application_view_icons.ico" )
                            , Array("ウィンドウの情報を取得する(&W)"
                                        , "tool_get_window_info"
                                        , "..\icon\menu\application_form_magnify.ico" )
                            , Array("文字キーの情報を取得する(&C)"
                                        , "tool_get_scan_code"
                                        , "..\icon\menu\keyboard_magnify.ico" )
                            , ""
                            , Array("DvorakJ の設定をすべて消去する(&D)"
                                                    , "tool_initialise_ini"
                                                    , "..\icon\menu\siren.ico" ))))

arr_menu.append( Array("ヘルプ(&H)", "AboutTray"
                    , Array(  Array("DvorakJ 配布ページ(&P)"
                                        , "about_get_new_version"
                                        , "..\icon\menu\world_go.ico" )
                            , Array("DvorakJ 配布ページ(&Vector.co.jp)"
                                                    , "about_go_to_vector"
                                                    , "..\icon\menu\world_go.ico" )
                            , ""
                            , Array("DvorakJ レファレンスマニュアル(&M)"
                                                    , "about_reference_manual"
                                                    , "..\icon\menu\world_go.ico" )
                            , Array("DvorakJ チュートリアル(&T)"
                                                    , "about_tutorial"
                                                    , "..\icon\menu\world_go.ico" )
                            , ""
                            , Array("&README"
                                        , "about_readme"
                                        , "..\icon\menu\document_info.ico")
                            , Array("更新履歴(&H)"
                                        , "about_history"
                                        , "..\icon\menu\document_info.ico")
                            , ""
                            , Array("DvorakJ の更新情報を取得する(&U)"
                                                    , "about_is_update"
                                                    , "..\icon\menu\update.ico" )
                            , ""
                            , Array("DvorakJ について(&A)"
                                                    , "about_software"
                                                    , "..\icon\menu\information.ico" ))))


If ( !A_IsCompiled && show_menu_for_debug_p ) {
    arr_menu.append("add")


    arr_menu.append( Array("&Debug", "debugTray"
                        , Array( Array("&1) Open ./user/&setting.ini"
                                   , "debug_ini" )
                                , Array("&2) Open ./data/&version.ini"
                                  , "debug_version_ini" )
                                , ""
                                , Array("&Reload", "debug_Reload" )
                                , Array("List&Vars", "debug_ListVars" )
                                , Array("List&Lines", "debug_ListLines" )
                                , Array("List&Hotkeys", "debug_ListHotkeys" )
                                , Array("&KeyHistory", "debug_KeyHistory" ))))
}


arr_menu.append("add")

arr_menu.append( Array("終了", "ProgramClose") )


add_menu(arr_menu, "Tray")

Menu, Tray, Default, ウィンドウを表示する



add_menu(p_arr, p_parent_menu_name) {
    for index, value in p_arr {
        this_menu_title := value[1]
        this_menu_name := value[2]
        arr_each_menu := value[3]


        ;; ("add")
        if ( value = "add" ) {
            Menu, %p_parent_menu_name%, Add
        } else if ( IsObject( arr_each_menu ) ) { ; Array(p_1, p_2, Array() )
            for i, v in arr_each_menu {
                if ( v.len() ) { ; Array(p_1, p_2, Array( Array(item_text, label_name, menu_icon) ) )
                    item_text := v[1]
                    label_name := v[2]

                    icon_filename := ( v[3] ) ? get_file_full_path(v[3])
                                  : False

                    icon_number := v[4]
                    icon_width := v[5]

                    Menu, %this_menu_name%, Add, %item_text%, %label_name%

                    ;; アイコンを追加する
                    if ( FileExist(icon_filename) ) {
                        Menu, %this_menu_name%, Icon, %item_text%, %icon_filename%, , 16
                    }
                } else { ; Array(p_1, p_2, Array( ) )
                    Menu, %this_menu_name%, Add
                }
            }

            Menu, %p_parent_menu_name%, Add, %this_menu_title%, :%this_menu_name%
        } else { ; Array(p_1, p_2 )
            Menu, %p_parent_menu_name%, Add, %this_menu_title%, %this_menu_name%
        }
    }

    if ( p_parent_menu_name != "Tray" ) {
        Gui, Menu, %p_parent_menu_name%
    }

    return False
}