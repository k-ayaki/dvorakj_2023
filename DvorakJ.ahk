; -*-mode: ahk; coding:utf-8-with-signature-dos-*-

;;; DvorakJ
;;; AutoHotkey_L <http://www.autohotkey.net/~Lexikos/AutoHotkey_L/>
;;; blechmusik <http://blechmusik.xii.jp/>

;;; ============================================================================
;;; ---------------- 各種設定
;;; ============================================================================

;;; Performance
;;; http://www.autohotkey.com/docs/misc/Performance.htm

#NoEnv
#SingleInstance FORCE
#WinActivateForce
; #persistent
; #Warn
;;; AutoHotkeyJp: SetBatchLines
;;; http://sites.google.com/site/autohotkeyjp/reference/commands/SetBatchLines
SetBatchLines, -1
;;; スクリプトの実行履歴を保存しない
ListLines Off
gosub,PfInit

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

;;; Console2 のようなアプリケーションでは、キーを素早く発行すると、そのキーを認識できない
;;; SetKeyDelay は、ini から設定を読み込む際に設定する
;SetKeyDelay, 0
;SetControlDelay, 0
;SetMouseDelay, 0
SetWinDelay, 0

#HotkeyInterval 1000
#MaxHotkeysPerInterval 100



DetectHiddenWindows, Off
DetectHiddenText, Off

;; タイマー割り込みを禁止する
Thread, NoTimers



;; ------------------------------ Listner ------------------------------
OnMessage(0x1111, "ReceiveState")
ReceiveState() {
    DetectHiddenWindows, On
    ControlGetText, value, Edit1, ahk_id %A_ScriptHwnd%
    if ("toggle" == value) {
        GoSub, sub_toggle
    }
    if ("suspend" == value) {
        ;; sleep を入れないと subroutine が正しく動かない？
        sleep, 500
        GoSub, sub_suspend
    }
    if ("resume" == value) {
        sleep, 500
        GoSub, sub_resume
    }
    if ("exit" == value) {
        ExitApp
    }
    if ("reload" == value) {
        Reload
    }

    return
}


OnMessage(0x3333, "ReceiveUpdate")
ReceiveUpdate() {
    DetectHiddenWindows, On
    ControlGetText, value, Edit1, ahk_id %A_ScriptHwnd%
    if ("not-keyboard-layout" == value) {
        read_general_setting()
        ;; 各タイマーを設定し直す
        set_various_timers()
    } else {
        ; これ以降で受け取った文字を処理
        RegExMatch(value, "^(.+?),(.+)", $)
        num := $1
        layout_path := $2
        

        SendText_for_traytip_from_GUI("設定ファイルを読み込みんでいます")
        SetTimer, Push, 45

        if (1 == num)
            read_layout_of_English( layout_path )
        else
        if (2 == num)
            read_layout_of_Japanese( layout_path )
        else
        if (3 == num)
            read_layout_of_shortcutkey( layout_path )
        else
        if (4 == num)
            read_layout_of_muhenkan_henkan( layout_path )
        else
        if (5 == num)
            read_layout_of_function_key( layout_path )
        else
        if (6 == num)
            read_layout_of_ten_key( layout_path )

        SendText_for_traytip_from_GUI("設定ファイルの再読み込みが終了しました")

    }

    return
}


;; ----------------------------------------------------------------------
;;; 設定ファイルを指定する
dvorakj_dir := A_ScriptDir
setting_file_path_folder := dvorakj_dir . to_windows_path("/user/")
setting_file_path_filename := "setting.ini"
version_ini := dvorakj_dir . to_windows_path("/data/version.ini")

;; check process on compile version
dvorakj_manager_filename := (A_IsCompiled) ? "DvorakJ_manager.exe" : "DvorakJ_manager.ahk"

;; ----------------------------------------------------------------------

this_key := ""

;;; 真に同時に打鍵する処理を使用するとき
key_stack := Array()




;; ----------------------------------------------------------------------
;;; ---------------- tray icon
;; ----------------------------------------------------------------------


;;; 実行ファイルのときには
;;; タスクトレイ内にアイコンを表示しない
if ( A_IsCompiled ) {
    Menu, TRAY, NoIcon
} else {
    Menu, Tray, Icon, %dvorakj_dir%\icon\folder.ico
}



;;; ============================================================================
;;; ---------------- include
;;; ============================================================================

#Include %A_ScriptDir%
;;; オブジェクト操作を拡張する
;;; スクリプトの初めの方で読み込むこと
; #Include .\src\lib\ext_object.ahk


;;; ============================================================================
;;; ---------------- ini ファイルで管理する項目
;;; ============================================================================


;;; ini ファイルの指定
ini_file := setting_file_path_folder . setting_file_path_filename
IfExist, %ini_file%
{
    ini_file_exists := True
}

;;; ini ファイルから設定を読み込む
read_general_setting()

;;; 発行するキー毎の遅延時間
;;; AutoExecute section で設定すること
SetKeyDelay, %key_delay%


; 設定ファイルを作成した筈なので
; 設定ファイルが存在していることにする
ini_file_exists := True

;;; ============================================================================
;;; ---------------- 設定画面を生成する
;;; ============================================================================

if (is_viewing_full_messages) {
    SendText_for_traytip_from_GUI(status_of_progress(1, 8) . "`n設定画面を作成中...")
}


run, % dvorakj_dir . to_windows_path("/apps/" . dvorakj_manager_filename)


;;; ============================================================================
;;; ---------------- キーボード配列の設定を設定ファイルから読み込む
;;; ============================================================================

;;; 直接入力用配列
if (is_viewing_full_messages) {
    SendText_for_traytip_from_GUI(status_of_progress(2, 8) . "`n直接入力用配列を設定中...")
}
read_layout_of_English( FilePathOfUserEnglishLayout )



;;; 日本語入力用配列
if (is_viewing_full_messages) {
    SendText_for_traytip_from_GUI(status_of_progress(3, 8) . "`n日本語入力用配列を設定中...")
}
read_layout_of_Japanese( FilePathOfUserJapaneseLayout )



; 独自のショートカットキー（無変換と変換版）
If ( is_Muhenkan_Henkan )
{
    read_layout_of_muhenkan_henkan( FilePathOfUserShortcutKeyMuhenkanHenkan )
}






;;; 無変換と変換
if (is_viewing_full_messages) {
    SendText_for_traytip_from_GUI(status_of_progress(5, 8) . "`n無変換＋文字と変換＋文字を設定中...")
}
;;; 独自のショートカットキー
If ( is_User_Shortcut_Key )
{
    read_layout_of_shortcutkey( FilePathOfUserShortcutKey )
}




;;; ファンクションキー
if (is_viewing_full_messages) {
    SendText_for_traytip_from_GUI(status_of_progress(6, 8) . "`n独自のファンクションキーを設定中...")
}
;;; 独自のファンクションキー
If ( is_User_Function_Key )
{
    read_layout_of_function_key( FilePathOfUserFunctionKey )
}



;;; テンキー
if (is_viewing_full_messages) {
    SendText_for_traytip_from_GUI(status_of_progress(7, 8) . "`n独自のテンキーを設定中...")
}
;;; 独自のテンキー
If ( is_User_Ten_Key )
{
    read_layout_of_ten_key( FilePathOfUserTenKey )
}

if (is_viewing_full_messages) {
    SendText_for_traytip_from_GUI(status_of_progress(8, 8) . "`nその他...")
}

;;; ============================================================================
;;; ---------------- DvorakJ 用ホットキーを設定
;;; ============================================================================

remap_dvorakj_hotkey()

;;; ============================================================================
;;; ---------------- 更新情報を取得
;;; ============================================================================

;;; DvorakJ 起動時に更新情報を取得
if ( is_Checking_Update_On_StartUp ) {
    Run,%dvorakj_dir%\DvorakJ_Updater.exe --silent
}

;;; ============================================================================
;;; ---------------- 他のアプリケーションを実行
;;; ============================================================================
Loop, PARSE, startup_applications,|
{
    ;; 空白はリストに表示しない
    if ("" == Trim(A_LoopField)) {
        continue
    }

    ;; 相対パスは絶対パスに変換してからリストに表示する
    path := Trim(A_LoopField)
    
    if (is_executing_valid_paths_only) {
        if (Path_FileExists(path)) {
            Run,% path
        }
    } else {
        Run,% path
    }
}


;;; ============================================================================
;;; ---------------- timer
;;; ============================================================================

set_various_timers()

SendText_for_traytip_from_GUI("起動処理が完了しました")

return

;;; ============================================================================
;;; ---------------- 
;;; ============================================================================


;;; ============================================================================
;;; ---------------- usefook
;;; ============================================================================
#Include .\src\keyhook\#inc.ahk


;; 以下の処理を別ファイルに保存して #include を使うと
;; hotkey コマンドで設定したホットキーが動作しなくなる


#if ( IME_toggle_key_1 )
    Ctrl & Space::
        IME_SET( !IME_GET() )
    return

#if ( IME_toggle_key_2 )
    RWin & Space::
    LWin & Space::
        IME_SET( !IME_GET() )
    return

#if ( IME_toggle_key_3 )
    Alt & Space::
        IME_SET( !IME_GET() )
    return

#if ( IME_toggle_key_4 )
    sc07b & sc079::
    sc079 & sc07b::
        IME_SET( !IME_GET() )
        Exit
    return

#if ( IME_toggle_key_5 )
    Alt & sc029::
        IME_SET( !IME_GET() )
    return

#if

;;; ============================================================================
;;; ---------------- 状態の保持を中止
;;; ============================================================================


Enter::
    ;; vista で skkime を使うと IME の入力モードを正常に返さない不具合あり
    ;; 対処法として次の処理を考えた

    ;; skkime 使用時に Enter が押されたら
    ;; 日本語配列に切り替える
    ;; すなわち、IME を有効にする
    If ( ( Is_skkime_mode )
     and ( Is_skkime_temp_english_layout ) ) {
        nJapaneseLayoutMode := Is_skkime_temp_english_layout
        Is_skkime_temp_english_layout := 0
    }

    send( remove_sequential_strokes("{Enter}") )
return


#UseHook off

;;; ============================================================================
;;; ---------------- #inc.ahk
;;; ============================================================================
#Include .\src\lib\#inc.ahk
#Include .\src\path\#inc.ahk
#Include .\src\hashing\#inc.ahk
#Include .\src\system\#inc.ahk
#Include .\src\string\#inc.ahk

#Include .\src\IME\#inc.ahk

#Include .\src\init\#inc.ahk
#Include .\src\read\#inc.ahk

#Include .\src\send\#inc.ahk
#Include .\src\mouse\#inc.ahk


toggle_status_of_dvorakj(bSuspended){
    global is_viewing_full_messages

    If ( bSuspended )
    {
        SetTimer, IME_GET, Off
    }
    else
    {
        SetTimer, IME_GET, On
    }

    SendState_to_GUI(bSuspended)

    if (is_viewing_full_messages) {
        if (bSuspended) {
            SendText_for_traytip_from_GUI("実行を停止しました")
        } else {
            SendText_for_traytip_from_GUI("実行を再開しました")
        }
    }

    Suspend, % bSuspended ? "On" : "Off"

    return
}



Push:
  GuiControl, 9:, lvl, 1
Return



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
    global dvorakj_manager_filename

    SendText(value, dvorakj_manager_filename, 0x1111)
}

SendValue(name, value, Msg) {
    DetectHiddenWindows, On
    SetTitleMatchMode, 2
    IfWinExist, %script% ahk_class AutoHotkey
    {
        ControlSetText, Edit1, % name ":" value
        PostMessage, % Msg
    }
}


SendText_for_traytip_from_GUI(text) {
    global dvorakj_manager_filename

    DetectHiddenWindows, On
    SetTitleMatchMode, 2
    IfWinExist, %dvorakj_manager_filename% ahk_class AutoHotkey
    {
        ControlSetText, Edit1, % text
        PostMessage, 0x2222
    }
}

PfInit:
;; 高精度タイマーの初期化
    Pf_Init()
    if (A_IsCompiled == "") {    
        g_Debug00 := Object()
        g_Debug00[0] := 0
        g_Debug00[1] := 0
        g_Debug00[2] := 0
        g_Debug00[3] := 0
        g_Debug00[4] := 0
        SetTimer,debugTooltip,100
    }
    return

debugTooltip:
    g_debug01 := (g_debug00[0] - g_debug00[1]) . ","
    g_debug01 .= (g_debug00[1] - g_debug00[2]) . ","
    g_debug01 .= (g_debug00[2] - g_debug00[3]) . ","
    g_debug01 .= (g_debug00[3] - g_debug00[4]) . ","
    ToolTip, %g_debug01%, 0,0,2
    return