;;; ============================================================================
;;; ---------------- GUI_Toggle がよびだされたときは設定画面の表示を切り替える
;;; ============================================================================


GUI_Toggle(bSuspended) {
    global name_of_EnglishLayout
    global name_of_JapaneseLayout

	global dvorakj_dir

    If ( bSuspended )
    {
        Menu, Tray, Icon
            , %dvorakj_dir%\icon\off.ico

        Menu, Tray, Tip, % Array("DvorakJ - 停止中"
            , name_of_EnglishLayout
            , name_of_JapaneseLayout).join()

        Gui, Font, Strike
        GuiControl, Font, Static1
        GuiControl, Font, Static2
    }
    else
    {
        Menu, Tray, Icon
            , %dvorakj_dir%\icon\on.ico

        Menu, Tray, Tip, % Array("DvorakJ - 動作中"
            , name_of_EnglishLayout
            , name_of_JapaneseLayout).join()

        Gui, Font, Norm
        GuiControl, Font, Static1
        GuiControl, Font, Static2
    }

    return
}
