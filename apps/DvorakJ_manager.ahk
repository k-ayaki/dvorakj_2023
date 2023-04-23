;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"
;;; ============================================================================
;;; ---------------- 各種設定
;;; ============================================================================

;;; Performance
;;; http://www.autohotkey.com/docs/misc/Performance.htm
#NoEnv
#SingleInstance FORCE
#WinActivateForce
#persistent
;;; AutoHotkeyJp: SetBatchLines
;;; http://sites.google.com/site/autohotkeyjp/reference/commands/SetBatchLines
SetBatchLines, -1
;;; スクリプトの実行履歴を保存しない
ListLines Off


SetWorkingDir %A_ScriptDir%


;;; AutoHotkey_L - #MenuMaskKey
;;; http://www.autohotkey.net/~Lexikos/AutoHotkey_L/docs/commands/_MenuMaskKey.htm
#MenuMaskKey vk07

;;; #MaxThreadsBuffer - AutoHotkeyJp
;;; http://sites.google.com/site/autohotkeyjp/reference/commands/-MaxThreadsBuffer
;;; #MaxThreadsBuffer On




#UseHook
#InstallKeybdHook
#InstallMouseHook


;;; AutoHotkeyJp: Process
;;; http://sites.google.com/site/autohotkeyjp/reference/commands/Process
Process, Priority, , High



;;; sendmode を input に設定しない
;;; 非常に素早く何度も打鍵すると、キーフックが効かなくなることがあるから
;;; たとえば、Dvorak 配列の [H] を押したままにすると、元のキーである QWERTY 配列の [J] がときたま出力されてしまう
;;; sendmode input

; SetKeyDelay, 0
; SetControlDelay, 0
; SetMouseDelay, 0
; SetWinDelay, 0

#HotkeyInterval 1000
#MaxHotkeysPerInterval 100



DetectHiddenWindows, Off
DetectHiddenText, Off


#include %A_ScriptDir%

;; タイマー割り込みを禁止する
Thread, NoTimers


;; ------------------------------ Listner ------------------------------
OnMessage(0x1111, "ReceiveState")
ReceiveState() {
    DetectHiddenWindows, On
    ControlGetText, value, Edit1, ahk_id %A_ScriptHwnd%

    if ("exit" == value) {
        ;; from DvorakJ_Updater
        ExitApp
    } else if (("false" == value) or ("suspend" == value)){
        ;; from DvorakJ_Updater
        GUI_Toggle(false)
    } else if (("true" == value) or ("resume" == value)){
        ;; from DvorakJ_Updater
        GUI_Toggle(true)
    } else {
        GUI_Toggle(value)
    }
    
    return
}

OnMessage(0x2222, "ReceiveText_For_TrayTip")
ReceiveText_For_TrayTip() {
    DetectHiddenWindows, On
    ControlGetText, text, Edit1, ahk_id %A_ScriptHwnd%
    my_traytip(text)
}


OnMessage(0x5555, "MsgListener")
MsgListener() {
    DetectHiddenWindows, On
    ControlGetText, value, Edit1, ahk_id %A_ScriptHwnd%
    ; これ以降で受け取った文字を処理
    MsgBox, % value
}

OnMessage(0x4444, "ValueListener")
ValueListener() {
    DetectHiddenWindows, On
    ControlGetText, value, Edit1, ahk_id %A_ScriptHwnd%
    ; これ以降で受け取った文字を処理
    RegExMatch(value, "^(.+?):(.+)", $)
    name := $1
    value := $2
    MsgBox, % name "`n" value
}

;;; ==============================
;;; ==============================
;;; ==============================
;;; 設定ファイルを指定する
;;; z:\dvorakj\apps\dvorakj_manager.ahk というパスから、z:\dvorakj を取り出す
;;; つまり、このファイルの絶対パスから "\apps\dvorakj_manager.ahk" を取り除く
SplitPath, A_ScriptDir, name, dvorakj_dir


setting_file_path_folder := dvorakj_dir . to_windows_path("/user/")
setting_file_path_filename := "setting.ini"
version_ini := dvorakj_dir . to_windows_path("/data/version.ini")

;; check process on compile version
dvorakj_filename := (A_IsCompiled) ? "DvorakJ.exe" : "DvorakJ.ahk"

;;; ==============================
;;; ==============================

;; DvorakJ の版の情報を取得する
dvorakj_current_version := read_version_setting(version_ini)

;;; ==============================
;;; ==============================

;;; ==============================


this_key := ""



;;; ============================================================================
;;; ---------------- アイコンを指定する
;;; ============================================================================

;;; ユーザーが指定するアイコンを使用する
#Include ..\src\GUI\icon.ahk


;;; ============================================================================
;;; ---------------- ini ファイルで管理する項目
;;; ============================================================================

;;; ini ファイルの指定
ini_file := setting_file_path_folder . setting_file_path_filename
IfExist, %ini_file%
    ini_file_exists := True


;; 
#Include ..\src\init\read_setting.ahk

read_general_setting()


;;; ============================================================================
;;; ---------------- キーボード配列の設定を設定ファイルから読み込む
;;; ============================================================================

;;; ============================================================================
;;; ---------------- GUI
;;; ============================================================================



;;; 設定ウィンドウ上で設定できるもの
#Include ..\src\GUI\overall_framework.ahk
;;; メニューバー中のメニューとタスクトレイのメニュー
#Include ..\src\GUI\menu.ahk
;;; 設定ウィンドウ
#Include ..\src\GUI\tab1-4.ahk
#Include ..\src\GUI\tab5.ahk
#Include ..\src\GUI\tab6.ahk
#Include ..\src\GUI\tab7-14.ahk
#Include ..\src\GUI\tab15.ahk
#Include ..\src\GUI\tab16.ahk
#Include ..\src\GUI\tab17.ahk
#Include ..\src\GUI\tab18.ahk
#Include ..\src\GUI\tab19.ahk
#Include ..\src\GUI\tab20.ahk
#Include ..\src\GUI\tab21.ahk

#Include ..\src\GUI\my_traytip.ahk

;;; ステータスバー
#Include ..\src\GUI\change_text_within_status_bar.ahk
;;; DvorakJ の機能の有効にしたり無効にしたりする
#Include ..\src\GUI\toggle_Layout.ahk

;;; ============================================================================
;;; ---------------- 設定ウィンドウを表示する
;;; ============================================================================

;;; 設定ウィンドウを表示
#Include ..\src\GUI\show.ahk

;;; 設定ウィンドウの画面上の位置を取得出来るようにメッセージを送る
OnMessage(0x232, "WM_SIZEMOVE")


;;; ============================================================================
;;; ---------------- return
;;; ============================================================================

if ( ini_file_exists ) {
    Progress, Off
}


return




;;; ============================================================================
;;; ---------------- GUI
;;; ============================================================================


#Include ..\src\GUI\subroutine_for_GUI.ahk
;;; キーボード配列の設定ファイルを選択するウィンドウ
#Include ..\src\GUI\ChooseSettingFile.ahk

;;; ステータスバーを定期的に更新する
#Include ..\src\GUI\update_status_bar.ahk

;;; ============================================================================
;;; ---------------- lib
;;; ============================================================================

#include ..\src\lib\#inc.ahk
;;; ============================================================================
;;; ---------------- path
;;; ============================================================================
#include ..\src\path\#inc.ahk


;;; ============================================================================
;;; ---------------- system
;;; ============================================================================

;;; 設定ファイルから設定ウィンドウの表示位置の設定を読み込む
#Include ..\src\system\GetWinPos.ahk
;;; ファイル名を取得する
#Include ..\src\system\GetFileName.ahk
;;; フォントサイズを取得する
#Include ..\src\system\GetDPI.ahk
;;; Caps Lock の値を定期的に調べる
#Include ..\src\system\CapsLockState.ahk
;;; 実際に押し下げている修飾キーを取得する
#Include ..\src\system\get_modified_keys_pressed_down.ahk






SendText(text, script, Msg) {
    DetectHiddenWindows, On
    SetTitleMatchMode, 2
    IfWinExist, %script% ahk_class AutoHotkey
    {
        ControlSetText, Edit1, % text
        PostMessage, % Msg
    }
}

SendState_from_GUI(value) {
    global dvorakj_filename
    SendText(value, dvorakj_filename, 0x1111)
}

SendUpdate_from_GUI(TEXT) {
    global dvorakj_filename
    SendText(TEXT, dvorakj_filename, 0x3333)
}
