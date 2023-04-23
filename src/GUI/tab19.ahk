;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"
Gui, tab, 19


    Gui, Add, GroupBox
            , x%GroupBoxX% y+15 w%GroupBoxW% R19
            , 自動的に実行するアプリケーション
    
    Gui, Add, Text
            , xp+20 yp+30
            , ※相対パスも利用可能（基準はDvorakJフォルダ）
    
    Gui, Add, Checkbox
            , xp+0 yp+20 Checked%is_showing_relative_path_for_applications% vis_showing_relative_path_for_applications gset_showing_relative_path_for_applications
            , 相対パスで表示する
    
    Gui, Add, Checkbox
            , xp+0 yp+20 Checked%is_executing_valid_paths_only% vis_executing_valid_paths_only gset_executing_valid_paths_only
            , 有効なパスのみ処理する
    
    Gui, Add, ListView
            , xp+0 yp+30 r10 w330 gApplicationListView Grid AltSubmit
            , アプリケーションのパス
    
    lv_add_startup_applications(is_showing_relative_path_for_applications)
    
    Gui, Add, Edit, w250 y+10 vpath_of_startup_application, 
    Gui, Add, Button, x+15 yp+0 gchoose_path_of_startup_application_from_dialog, 選択...(&C)
    Gui, Add, Button, x200 y+5 w70 gadd_path_of_startup_application_to_list, 追加(&A)
    Gui, Add, Button, x+15 yp+0 w70 gedit_path_of_startup_application_in_list, 修正(&M)
    Gui, Add, Button, x+15 yp+0 w70 gdelete_path_of_startup_application_from_list, 削除(&D)
    
    Gui, Add, Button, x540 y140 gmove_up_path_of_startup_application, ↑
    Gui, Add, Button, gmove_down_path_of_startup_application, ↓

