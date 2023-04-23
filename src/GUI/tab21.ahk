;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"
lv_add_startup_applications(relative=False) {
    global
    
    ;; | で複数のアプリケーションのパスが区切られている
    ;; そのアプリケーションのパス毎に処理を行う
    Loop, PARSE, startup_applications,|
    {
        ;; 空白はリストに表示しない
        if ("" == Trim(A_LoopField)) {
            continue
        }

        path := Trim(A_LoopField)

        ;; 相対パスは必要に応じて絶対パスに変換してからリストに表示する
        if ((False=relative) and (Path_IsRelative(path))) {
            ;; path := Path_SearchAndQualify(path)
            path := Path_AbsolutePathFromDvorakJ(path)
        }
        
        ;; 絶対パスも必要に応じて相対パスに変換すること
        if ((relative) and (False=Path_IsRelative(path))) {
            path := Path_RelativePathFromDvorakJTo(path)
        }
        
        LV_Add("", path)
    }

    ;; 幅を最大限拡張する
    LV_ModifyCol(0, "Auto")
}
    

make_tab21() {
    global

    Gui, tab, 21
    
        
    
    Gui, Add, GroupBox
            , x%GroupBoxX% y+25 w%GroupBoxW% R3
            , 設定画面の最小化
    
    Gui, Add, Checkbox
            , xp+20 yp+20 vis_minimising_by_pressing_close_button gset_is_minimising_by_pressing_close_button Checked%is_minimising_by_pressing_close_button%
            , 設定画面の右上の[×]ボタン押したら、設定画面を最小化する(&B)
    
    Gui, Add, Checkbox
            , xp+0 yp+25 vis_minimising_DvorakJ_to_tray_p gset_is_minimising_DvorakJ_to_tray_p Checked%is_minimising_DvorakJ_to_tray_p%
            , 設定画面を最小化したら、設定画面をタスクトレイに格納する(&T)
    
   
    
    Gui, Add, GroupBox
            , x%GroupBoxX% y+25 w%GroupBoxW% R2
            , 通知
    
    Gui, Add, Checkbox
            , xp+20 yp+20 vis_viewing_full_messages gset_is_viewing_full_messages Checked%is_viewing_full_messages%
            , より多くの項目を通知する(&N)
    
    
}


make_tab21()