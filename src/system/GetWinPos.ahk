;;; GUI +alwaysontop Z-Order and Overlaying Multiple GUIs
;;; http://www.autohotkey.com/forum/topic52541.html

;;; software / AutoHotkey スレッド part10
;;; http://p2.chbox.jp/read.php?url=http%3A//pc12.2ch.net/test/read.cgi/software/1265518996/524-526

WM_SIZEMOVE(wParam,lParam,msg, hwnd)
{
    global GuiX, GuiY
    global ini_file

    If ( A_Gui = 1 ) {
        VarSetCapacity(rect, 4*4)
        WinGetPos, GuiX, GuiY, , , ahk_id %hwnd%

/*
        DllCall("GetClientRect", "IntPtr",hwnd, "IntPtr",&rect)

        GuiW:=NumGet(rect, 8)
        GuiH:=NumGet(rect, 12)
*/

        ;; 設定ファイルに位置情報を保存する
        if ( ini_file != "")
        {
		    write_value_to_ini("window", "X", GuiX)
		    write_value_to_ini("window", "Y", GuiY)
        }
        else
            msgbox,設定ファイルが見つからないため、ウィンドウの位置情報を保存できません
    }

    return
}
