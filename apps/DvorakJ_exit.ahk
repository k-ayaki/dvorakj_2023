;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"
#NoEnv
SendMode Input
#SingleInstance force

RegExMatch(A_ScriptName, "^(.+)_(.+?)(\..+)$", $)
dvorakj_application := $1 . $3
dvorakj_manager_application := $1 . "_manager" . $3
action := $2
SendState_to_GUI(action)
return

SendText(text, script, Msg) {
    DetectHiddenWindows, On
    SetTitleMatchMode, 2
    IfWinExist, %script% ahk_class AutoHotkey
    {
        ControlSetText, Edit1, % text
        PostMessage, % Msg
    }
}

SendState_to_GUI(value) {
    global dvorakj_application
    global dvorakj_manager_application

    SendText(value, dvorakj_application, 0x1111)
    SendText(value, dvorakj_manager_application, 0x1111)
}
