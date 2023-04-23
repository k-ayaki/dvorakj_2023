#SingleInstance FORCE
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#persistent
SetWorkingDir %A_ScriptDir%

Menu, Tray, Icon
			, application_form_magnify.ico
Menu, Tray, Tip, ウィンドウの情報の調査
Menu, Tray, NoStandard
Menu, Tray, Add, 終了(&X), GuiClose

/*
 * MouseGetPos
 * http://www.autohotkey.com/docs/commands/MouseGetPos.htm
 */

SetTimer, WatchCursor, 500
return



WatchCursor:
	SetTitleMatchMode,2
	WinGet, process_name, ProcessName, A


    MouseGetPos
        , 
        , 
        , id, control
    WinGetTitle
        , title
        , ahk_id %id%
    WinGetClass
        , class
        , ahk_id %id%
    ToolTip, 
        (LTrim
            Shortcutkey`t説明
			--------------------------------------------------------------------------
            [Ctrl] + [N]`tアプリケーション名 "%process_name%" をコピーする

            [Ctrl] + [I]`tウィンドウハンドルの値 "%id%" をコピーする
            [Ctrl] + [C]`tウィンドウクラスの値 "%class%" をコピーする

            [Ctrl] + [X]`tこの監視プログラムを終了する（タスクバーからも終了可能）
        )
return


^N::
    clipboard := process_name
    ExitApp
return

^I::
    clipboard := id
    ExitApp
return

^C::
    clipboard := class
    ExitApp
return

^X::
    ExitApp
return

GuiClose:
ExitApp
