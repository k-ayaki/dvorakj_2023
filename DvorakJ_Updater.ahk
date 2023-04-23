;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance force

;; ================================================================

;;; 最新版の DvorakJ を自動的に導入する

;;; アイコンを設定する
if (A_IsCompiled) {
    Menu, Tray, Icon, %A_ScriptName%
}

;; ================================================================
;; DvorakJ.exe の存在の確認
if ( FileExist( A_ScriptDir . "\DvorakJ.exe" ) = "" ) {
    msgbox, , DvorakJ の更新, 同一フォルダ内に DvorakJ.exe が存在しません

    ExitApp
}

;; ================================================================
;; ini
version_ini := ".\data\version.ini"

if not (FileExist(version_ini)){
   msgbox, %version_ini% が見つかりません`n設定ファイルの置き場所を確認してください
   ExitApp
}

the_latest_info_url := get_update_setting_from_ini("web", "the_latest_info_url")
the_latest_file_url := get_update_setting_from_ini("web", "the_latest_file_url")
history_url := get_update_setting_from_ini("web", "history_url")
current_version := get_update_setting_from_ini("local", "current_version")

;; ================================================================

;;; 処理を一時的に停止する時間（ミリ秒）
sleep_time := 1000

;;; プロキシサーバーの設定を読み込み、設定する
proxy_server := get_proxy_server(".\user\proxy_server.txt")

;; ================================================================
;;; パラメーターを取得する
arg0 = %0%

if ( arg0 > 0 ) { ; パラメーターが1つ以上のとき
    arg1 = %1%
    arg2 = %2%
    arg3 = %3%
}

;; ================================================================
;; GUI の表示

TrayTip, DvorakJ の更新, DvorakJ の更新情報を確認しています, 1, 0

;; ================================================================
;; 最新版をコピーするとき
if (( arg1 = "--copy" ) or ( arg1 = "-copy" ))  {

    Gui, 10:Add, Progress, vlvl  -Smooth 0x8 w250 h18 ; PBS_MARQUEE = 0x8
    Gui, 10:Add, Text, vprogress_text w250, DvorakJ の更新情報を確認しています
    Gui, 10:Show, , DvorakJ の更新
    SetTimer, Push, 45



    ;; 先に起動している DvorakJ_Updater の終了を待つために
    ;; 1秒間待機する
    sleep,1000
    
    
    version_of_the_web := arg2
    ;; 末尾に " が付いてしまうので除去する
    dest_path := Trim(arg3, """")

    GuiControl, 10:Text, progress_text, [3/4] %version_of_the_web% 版のファイルを移動しています

    CopyFilesAndFolders(A_ScriptDir . "\*.*", dest_path)

    ;; DvorakJ を起動する
    Run,%dest_path%\DvorakJ.exe

    ;; 最新版のコピーが終わったのでプログラムを終了する
    ExitApp
}


;; ================================================================
;; 最新版かどうかを調べる
;; GuiControl, 10:Text, progress_text, [1/4] DvorakJ の更新情報を取得しています

TrayTip, DvorakJ の更新, DvorakJ の更新情報を取得しています, 1, 0


version_of_the_web   := get_text_from_web(the_latest_info_url)


;; ================================================================
;; 情報をただしく取得できなかったとき
if not ( RegExMatch(version_of_the_web, "(\d{4}-\d{2}-\d{2})") ) {
    if ( "" = arg1 ) {
        Run,% A_ScriptDir . "\DvorakJ.exe"
    }

    if ( "--not-stand-alone" = arg1 ) {
        MsgBox,% ("nil" = proxy_server) ? "更新情報を取得できません"
                    : (proxy_server) ? "更新情報を取得できません`n" . "以下のプロキシサーバーの設定を確認して下さい`n`n" . proxy_server
                    : "更新情報を取得できません"
    }

    ;; 情報をただしく取得できなかったのでプログラムを終了する
    ExitApp
}


;; ================================================================
;; 最新版のファイルをダウンロードするフォルダを作成する
zip_dir := A_Temp . to_windows_path("/DvorakJ_update" . A_TickCount  . "/")
IfNotExist, %zip_dir%
{
    FileCreateDir, %zip_dir%
}


;; ================================================================
;; web 上の方が local の方よりも新しくないとき
;; つまり、最新版が公開されていないとき
If ( trim_str(version_of_the_web, "-") <= trim_str(current_version, "-") ) {
    Gui, 10:Destroy

    if ( arg1 = "" ) {
        Run,% A_ScriptDir . "\DvorakJ.exe"
    }
    
    if ( arg1 = "--not-stand-alone" ) {
        If ( trim_str(version_of_the_web, "-") = trim_str(current_version, "-") ) {
           msgbox, , DvorakJ の更新, 最新のプログラムを使用しています`n（%current_version% 版）
        }
        else
        {
            msgbox, , DvorakJ の更新, 更新の必要はありません`nウェブ上の版 (%version_of_the_web% 版) よりも新しい版（%current_version% 版）を使用しています
        }
    }

    
    ;; 最新版を入手する必要がないのでプログラムを終了する
    ExitApp
}


;; ================================================================
;; web 上の方が local の方よりも新しいとき
;; つまり、最新版が公開されているとき
Gui, 10:Destroy

new_update_text .= ""
new_update_text .= "新しいプログラムを入手できます`n"
new_update_text .= "`n"
new_update_text .= "使用中のプログラム:`t" . current_version . " 版`n"
new_update_text .= "新しいプログラム:`t`t" . version_of_the_web . " 版`n"
Gui, 10:Add, Text, , %new_update_text%

web_text := get_text_from_web(history_url)

;; 更新内容の差分をここに表示する
Gui, 10:Add, Edit, VScroll ReadOnly w400 r15 -Wrap, % get_update_info_diff(web_text, current_version)

new_update_text := "`n"
new_update_text .= "新しいプログラムを自動的に導入しますか？"
Gui, 10:Add, Text, , %new_update_text%

Gui, 10:Add, Button, gpush_yes_button x250 w70, はい(&Y)
Gui, 10:Add, Button, gpush_no_button xp+80 w70, いいえ(&N)

Gui, 10:-MaximizeBox
Gui, 10:-MinimizeBox

Gui, 10:Show, , DvorakJ の更新
return

;; ================================================================
;; 以上で GUI の表示処理が終了
;; ================================================================

;;; FileCopy - AutoHotkeyJp
;;; http://sites.google.com/site/autohotkeyjp/reference/commands/FileCopy

CopyFilesAndFolders(SourcePattern, DestinationFolder, DoOverwrite = True)
; Copies all files and folders matching SourcePattern into the folder named DestinationFolder and
; returns the number of files/folders that could not be copied.
{
    ; First copy all the files (but not the folders):
    ErrorCount := file_copy(SourcePattern, DestinationFolder, DoOverwrite)

    ; Now copy all the folders:
    Loop, %SourcePattern%, 2  ; 2 means "retrieve folders only".
    {
        ErrorCount += file_copy_dir(A_LoopFileFullPath, DestinationFolder . to_windows_path("/") . A_LoopFileName, DoOverwrite)
    }

    return ErrorCount
}


file_copy(SourcePattern, DestinationFolder, DoOverwrite = False) {
    FileCopy, %SourcePattern%, %DestinationFolder%, %DoOverwrite%

    if ( ErrorLevel ) { ; Report each problem folder by name.
        MsgBox,総計 %ErrorLevel% のファイルをコピーできません。
    }

    return ErrorLevel
}


file_copy_dir(source_path, destination_path, DoOverwrite = False) {
    FileCopyDir, %source_path%, %destination_path%, %DoOverwrite%

    if ( ErrorLevel ) { ; Report each problem folder by name.
        MsgBox,%source_path% を %destination_path% にコピーできません。
    }

    return ErrorLevel
}



;;; Zip/Unzip using native ZipFolder Feature in XP
;;; http://www.autohotkey.com/forum/post-335359.html#335359

download_file( p_url, p_filename) {
    UrlDownloadToFile, %p_url%, %p_filename%

    return p_filename
}

close_dvorakj() {
    global

    ;; dvorakj の処理を終了するよう命令を送る
    SendState_to_exit("exit")
    return
}
  
  
Push:
  GuiControl, 10:, lvl, 1
Return


; ================================
; ================================
; ================================

get_update_setting_from_ini(section, key){
    global 
    IniRead, OutputVar, %version_ini%, %Section%, %Key%
    return OutputVar
}

get_update_info_diff(str, local_date){
    ;; ================================================================
    ;; load str to arr
    text_arr := Array()
     
    Loop, Parse, str, `n, `r
    {
        text_arr[A_Index] := A_LoopField
    }
     
    ;; ================================================================
    ;; parse text
    new_text_arr := Array()
    each_update_date := ""
    
    
    ;; 日付毎に更新情報をまとめておく
    for i,v in text_arr
    {
        if ("過去の更新履歴" = v) {
           break
        }
        
        if ("" == v) {
            continue
        }
        
        if (RegExMatch(v, "^            ")) {
            continue
        }
    
    
        if ("~~~~~~~~~~" = text_arr[i + 1])
        {
            each_update_date := v
     
            new_text_arr[each_update_date] := each_update_date . "`n"
        }
        else if (each_update_date) {
            new_text_arr[each_update_date] .= v . "`n"
        }
    }
     
    ;; ================================================================
     
    output_text := ""
     
    ;; local_date よりも新しい日付の更新情報をテキストとして出力する
    for i,v in new_text_arr
    {
        if (local_date < i) {
            output_text .= v
        }
    }

    ;; 余分な改行を取り除く
    return RegExReplace(output_text, "`n+$", "")
}


push_yes_button:
    if not (A_IsCompiled) {
        MsgBox, "スクリプト版では自動更新機能を利用できません`n実行バイナリ版の自動更新機能をご使用ください"
        ExitApp
    }


    ;; 確認画面を一旦破毀する
     Gui, 10:Destroy

     ;; 進捗画面の GUI を作成する
     Gui, 10:Add, Progress, vlvl  -Smooth 0x8 w250 h18 ; PBS_MARQUEE = 0x8
     Gui, 10:Add, Text, vprogress_text w250, [2/4] DvorakJ %version_of_the_web% 版をダウンロードしています
     Gui, 10:Show, , DvorakJ の更新
     ;; SetTimer, Push, 45

    ;; ファイルサイズは HttpQueryInfo.ahk を使えば簡単に取得できる
    ;; ただ、このスクリプトでは扱っていない
    ;; DllCall: HttpQueryInfo - Get HTTP headers
    ;; http://www.autohotkey.com/forum/topic10510.html

    ;; まず zip ファイルを DvorakJ_temp.zip というファイル名で保存し、
    ;; それから圧縮ファイルを展開した後に、すぐに削除する
    unzip_and_remove_file( download_file( the_latest_file_url
                            , zip_dir . "DvorakJ_temp.zip")
                            , zip_dir)

    ;; DvorakJ を終了させる
    close_dvorakj()

    ;; コピー先のフォルダとして現在のフォルダを指定する
    If ( trim_str(version_of_the_web, "-") <= trim_str("2012-01-11", "-") ) {
       run,%zip_dir%DvorakJ_Updater.exe -copy %version_of_the_web% "%A_ScriptDir%"
    }
    else {
         run,%zip_dir%DvorakJ_Updater.exe --copy %version_of_the_web% "%A_ScriptDir%"
    }
    

    ;; 最新版の DvorakJ_Updater.exe を起動したのでプログラムを終了する
    ExitApp
return

10GUIclose:
push_no_button:
    ExitApp
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

SendState_to_exit(value) {
    ;; check process on compile version
    dvorakj_filename := (A_IsCompiled) ? "DvorakJ.exe" : "DvorakJ.ahk"
    dvorakj_manager_filename := (A_IsCompiled) ? "DvorakJ_manager.exe" : "DvorakJ_manager.ahk"

    SendText(value, dvorakj_filename, 0x1111)
    SendText(value, dvorakj_manager_filename, 0x1111)
}


#Include %A_ScriptDir%
#Include .\src\lib\#inc.ahk
#Include .\src\path\#inc.ahk
