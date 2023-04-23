;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"
;; last updated: 2012-07-18 00:22:11

;; ================================================================
;; AutoHotkeyJp
;; http://sites.google.com/site/autohotkeyjp/

;; AutoHotkey (AutoHotkey_L)
;; http://l.autohotkey.net/docs/

;; AutoHotkey v2 (alpha)
;; http://lexikos.github.com/AutoHotkey_L-Docs/docs/AutoHotkey.htm
;; ================================================================

#SingleInstance FORCE
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#persistent
SetWorkingDir %A_ScriptDir%

Process, Priority, , High
SetBatchLines, -1
ListLines Off
SetWinDelay, 0
DetectHiddenWindows, Off
DetectHiddenText, Off

;; タイマー割り込みを禁止する
Thread, NoTimers


;; utf-8
;; FileEncoding, CP65001


#Include %A_ScriptDir%
#Include ..\src\lib\#inc.ahk
#Include ..\src\path\#inc.ahk
#Include ..\src\string\#inc.ahk
#Include ..\src\read\ReadLayout-Keyboard.ahk




Menu, Tray, Icon
            , application_view_icons.ico
Menu, Tray, Tip, キーボード配列の分析
Menu, Tray, NoStandard

Menu, Tray, Add, 選択中のフォルダを開く(&F), open_current_dir
Menu, Tray, Add
Menu, Tray, Add, テキストとして出力する(&T), save_to_text
Menu, Tray, Add
Menu, Tray, Add, 終了(&X), GuiClose

ChooseSettingFile()

return




read_and_analyse_keyboard_layout( p_filename ) {
    global each_item
    global MyList

    global InputMode
    global TotalNum

    global all_key_info


    all_key_info := Array()
    
    Gui,ListView,each_item
    LV_Delete()

    keyboard_raw_data := read_keyboard_layout( p_filename )

    key_info_arr := get_list_of_input_and_output(conv_from_table_to_lines( keyboard_raw_data
    															, "Get_scancode_from_table_main"))

    key_input_arr := key_info_arr[1]
    key_output_arr := key_info_arr[2]
    key_numbers_arr := key_info_arr[3]


    for i, v in key_input_arr {
        LV_Add("", key_input_arr[i], key_output_arr[i], key_numbers_arr[i])
        all_key_info.append(key_input_arr[i] "`t" key_output_arr[i] "`t" key_numbers_arr[i])
    }


    GuiControl, Text, InputMode,  % get_key_stroke_mode(read_str_first_option( keyboard_raw_data ))
    GuiControl, Text, TotalNum, % key_input_arr.len()

    Gui,ListView,MyList
    return
}

get_key_stroke_mode(str){
    keystrokes_mode := 0

    ;; 同時打鍵を設定しているときは
    ;; 1 を加える
    keystrokes_mode += ( RegExMatch(str, "(同時|一緒|一斉)") ) ? 1
                    :                                                    0

    ;; 逐次打鍵を設定しているときは
    ;; 2 を加える
    keystrokes_mode += ( RegExMatch(str, "(逐次|順)") ) ? 2
                    :                                             0

    ;; キーボード配列の打鍵方法が設定ファイルに記述されていないとき
    ;; 同時打鍵の方が選択されているものとして処理する
    if ( keystrokes_mode = 0) {
        keystrokes_mode := 1
    }

    return % ( keystrokes_mode = 1 ) ? "同時に打鍵する配列"
           : ( keystrokes_mode = 2 ) ? "順に打鍵する配列"
                                     : "順にも同時にも打鍵する配列"
}


get_list_of_input_and_output( str ) {
    input_arr := Array()
    output_arr := Array()
    key_numbers_arr := Array()

    Loop, Parse, str, `n, `r
    {
        RegExMatch(A_LoopField, "S)^(.+)\t(.+)\t(.+)$", match_ )
        ; match_2 <- input
        ; match_3 <- output
        input_arr.append(get_key_name_from_scancode(remove_true_string(match_2)))
        output_arr.append(match_3)
        key_numbers_arr.append(count_under_score_or_plus_sign(match_2))

;       input_and_output .= count_under_score_or_plus_sign(match_2)         . "`t" 
;        . get_key_name_from_scancode(match_2)         . "`t" . match_3 . "`n"
    }

    return Array(input_arr, output_arr, key_numbers_arr)
}

remove_true_string(str){
    StringReplace, str, str, TRUE, , All
    return str
}

count_under_score_or_plus_sign(str){
    i := 0

    Loop, Parse, str
    {
        if ( (A_LoopField = "_") or (A_LoopField = "+") )
            i++
    }
    
    return i
}


get_key_name_from_scancode(scancode)
{
    StringReplace, scancode, scancode, _sc002, 1%A_Space%, All
    StringReplace, scancode, scancode, _sc003, 2%A_Space%, All
    StringReplace, scancode, scancode, _sc004, 3%A_Space%, All
    StringReplace, scancode, scancode, _sc005, 4%A_Space%, All
    StringReplace, scancode, scancode, _sc006, 5%A_Space%, All
    StringReplace, scancode, scancode, _sc007, 6%A_Space%, All
    StringReplace, scancode, scancode, _sc008, 7%A_Space%, All
    StringReplace, scancode, scancode, _sc009, 8%A_Space%, All
    StringReplace, scancode, scancode, _sc00A, 9%A_Space%, All
    StringReplace, scancode, scancode, _sc00B, 0%A_Space%, All
    StringReplace, scancode, scancode, _sc00C, _%A_Space%, All
    StringReplace, scancode, scancode, _sc00D, ^%A_Space%, All
    StringReplace, scancode, scancode, _sc07D, 上段\%A_Space%, All

    StringReplace, scancode, scancode, _sc010, Q%A_Space%, All
    StringReplace, scancode, scancode, _sc011, W%A_Space%, All
    StringReplace, scancode, scancode, _sc012, E%A_Space%, All
    StringReplace, scancode, scancode, _sc013, R%A_Space%, All
    StringReplace, scancode, scancode, _sc014, T%A_Space%, All
    StringReplace, scancode, scancode, _sc015, Y%A_Space%, All
    StringReplace, scancode, scancode, _sc016, U%A_Space%, All
    StringReplace, scancode, scancode, _sc017, I%A_Space%, All
    StringReplace, scancode, scancode, _sc018, O%A_Space%, All
    StringReplace, scancode, scancode, _sc019, P%A_Space%, All
    StringReplace, scancode, scancode, _sc01A, @%A_Space%, All
    StringReplace, scancode, scancode, _sc01B, [%A_Space%, All

    StringReplace, scancode, scancode, _sc01E, A%A_Space%, All
    StringReplace, scancode, scancode, _sc01F, S%A_Space%, All
    StringReplace, scancode, scancode, _sc020, D%A_Space%, All
    StringReplace, scancode, scancode, _sc021, F%A_Space%, All
    StringReplace, scancode, scancode, _sc022, G%A_Space%, All
    StringReplace, scancode, scancode, _sc023, H%A_Space%, All
    StringReplace, scancode, scancode, _sc024, J%A_Space%, All
    StringReplace, scancode, scancode, _sc025, K%A_Space%, All
    StringReplace, scancode, scancode, _sc026, L%A_Space%, All
    StringReplace, scancode, scancode, _sc027, `;%A_Space%, All
    StringReplace, scancode, scancode, _sc028, :%A_Space%, All
    StringReplace, scancode, scancode, _sc02B, ]%A_Space%, All

    StringReplace, scancode, scancode, _sc02C, Z%A_Space%, All
    StringReplace, scancode, scancode, _sc02D, X%A_Space%, All
    StringReplace, scancode, scancode, _sc02E, C%A_Space%, All
    StringReplace, scancode, scancode, _sc02F, V%A_Space%, All
    StringReplace, scancode, scancode, _sc030, B%A_Space%, All
    StringReplace, scancode, scancode, _sc031, N%A_Space%, All
    StringReplace, scancode, scancode, _sc032, M%A_Space%, All
    StringReplace, scancode, scancode, _sc033, `,%A_Space%, All
    StringReplace, scancode, scancode, _sc034, .%A_Space%, All
    StringReplace, scancode, scancode, _sc035, /%A_Space%, All
    StringReplace, scancode, scancode, _sc073, 下段\%A_Space%, All

    StringReplace, scancode, scancode, _shift, [shift]%A_Space%, All
    StringReplace, scancode, scancode, _space, [space]%A_Space%, All
    StringReplace, scancode, scancode, _henkan, [変換]%A_Space%, All
    StringReplace, scancode, scancode, _muhenkan, [無変換]%A_Space%, All
    StringReplace, scancode, scancode, _lalt, [左alt]%A_Space%, All
    StringReplace, scancode, scancode, _ralt, [右alt]%A_Space%, All
    StringReplace, scancode, scancode, _lwin, [左win]%A_Space%, All
    StringReplace, scancode, scancode, _rwin, [右win]%A_Space%, All
    StringReplace, scancode, scancode, _kana, [kana]%A_Space%, All
    StringReplace, scancode, scancode, _tab, [tab]%A_Space%, All
    StringReplace, scancode, scancode, _backspace, [backspace]%A_Space%, All
    StringReplace, scancode, scancode, _apps, [apps]%A_Space%, All
    StringReplace, scancode, scancode, _esc, [esc]%A_Space%, All
    StringReplace, scancode, scancode, _zenkaku, [全角]%A_Space%, All
    StringReplace, scancode, scancode, _capslock, [capslock]%A_Space%, All

    ;; 閉じ丸括弧の直前の空白を削除する
    StringReplace, scancode, scancode, %A_Space%), ), All

    return scancode
}





;;; Explorer-Like TreeView slightly modified from AHKHelp
;;; http://www.autohotkey.com/forum/post-230312.html#230312

ChooseSettingFile( option = 0 )
{
    global MyTree
    global MyList
    global MyPreview

    global TreeRoot

    global each_item
    global MyList
    
    
    global InputMode
    global TotalNum






    Menu, file_sub_menu, Add, 選択中のフォルダを開く(&F), open_current_dir
    Menu, file_sub_menu, Add
    Menu, file_sub_menu, Add, テキストとして出力する(&T), save_to_text
    Menu, file_sub_menu, Add
    Menu, file_sub_menu, Add, 終了(&X), GuiClose
    Menu, my_file, Add, ファイル(&F), :file_sub_menu
    Gui, Menu, my_file


    TreeRoot := GetParentDir(A_ScriptDir)



    ImageListID := IL_Create(12)
    LV_SetImageList(ImageListID)

    Loop 12
    {
        IL_Add(ImageListID, "shell32.dll", A_Index)
    }

    Gui, Add, TreeView
                , ys r11 x15 w230 vMyTree gMyTree ImageList%ImageListID% Altsubmit
    Gui, Add, ListView
                , ys r10 x260 w350 vMyList gMyList -multi AltSubmit Grid
                , ファイル名|サイズ (Byte)|更新日

    LV_ModifyCol(1, 169)
    LV_ModifyCol(2, 80 " Integer")
    LV_ModifyCol(3, 80)

    ImageListID1 := IL_Create(10)
    ImageListID2 := IL_Create(10, 10, true)
    LV_SetImageList(ImageListID1)
    LV_SetImageList(ImageListID2)

    ;; 等角フォントでテキストファイルの内容を表示する
    Gui, Font, Q5, monospace
    Gui, Font, Q5, consolas

;   2011-10-07時点では、auto オプションがエラーとなる
;    Gui,Add,ListView,x15 w300 R10 -ReadOnly -WantF2 Auto Grid veach_item ,入力するキー　　　　|出力する文字やキー|キー数
    Gui,Add,ListView,x15 w300 R10 -ReadOnly -WantF2 Grid veach_item,入力するキー　　　　|出力する文字やキー|キー数
    
    LV_ModifyCol(1, "AutoHdr")
    LV_ModifyCol(2, "AutoHdr")
    LV_ModifyCol(3, "AutoHdr")
    
;; 通常のフォントに戻す
    Gui, Font




    Gui, Add, Text, x+30 yp+30, 入力方式：
    Gui, Add, Text, xp+0 yp+50, 設定数：
    Gui, Add, Edit, xp+100 yp-50 w150 vInputMode ReadOnly, 
    Gui, Add, Edit, xp+0 yp+50 w100 vTotalNum ReadOnly, 



    Gui, Add, Button
                , gMyEdit xp-30 y+50 R1.5 w100
                , 編集
    Gui, Add, Button
                , g2GuiClose x+30 yp+0 R1.5 w80
                , 閉じる



    Gui, Add, StatusBar

    SplashTextOn, 200, 25, ファイルを読み込み中, Loading...
    AddSubFoldersToTree(TreeRoot)
    SplashTextOff



    window_title := ( option = 1 ) ? "直接入力用キーボード配列"
                 :  ( option = 2 ) ? "日本語入力用キーボード配列"
                 :  ( option = 3 ) ? "独自のショートカットキー"
                 :  ( option = 4 ) ? "独自のショートカットキー（変換キーと無変換キー版）"
                 :  ( option = 5 ) ? "独自のファンクションキー"
                 :  ( option = 6 ) ? "独自のテンキー"
                 :                   ""

;    Gui, +ToolWindow
    Gui, Show
            ,
            , キーボード配列の解析

    return
}

;;; スクリプトがあるフォルダを基準として初期化
AddSubFoldersToTree(folder, ID = 0)
{
    ID := TV_Add(folder, ID, "Icon10 expand")


    Loop, %folder%\*.*, 2
    {
        if (   ( A_LoopFileName = "data" )
            or ( A_LoopFileName = "user" ) )
        {
            IX := TV_Add(A_LoopFileName, ID, "Icon4")
            TV_gettext(FileNameX, IX)

            loop, %folder%\%FileNameX%\*.*, 2
            {
               TV_Add(A_LoopFileName, IX, "Icon4")
            }
        }
    }

    return
}



MyTree:
    ;; 項目のテキストをクリックしたとき
    ;; または、項目上でキーを押したとき
    if ( ( A_GuiEvent = "normal" ) 
        or ( A_GuiEvent = "K" ) )
    {

        ItemID := ( A_GuiEvent = "normal" ) ? A_EventInfo
               :  ( A_GuiEvent = "K" ) ? TV_GetSelection()
               :  0

        TV_Modify( ItemID )
        TV_GetText(SelectedItemText, ItemID)
        ParentID := ItemID

        Loop
        {
            ParentID := TV_GetParent(ParentID)

            if not ParentID
                break

            TV_GetText(ParentText, ParentID)
            SelectedItemText = %ParentText%\%SelectedItemText%
        }

        SelectedFullPath = %TreeRoot%\%SelectedItemText%


        StringReplace, SelectedFullPath, SelectedFullPath, \\ , \
        StringRight, LastChar, SelectedFullPath, 1

        if LastChar <> \
            SelectedFullPath = %SelectedFullPath%\

        StringReplace, SelectedFullPath, SelectedFullPath, %treeroot%\ ,

        FilenameforSB =
        SB_SetText(SelectedFullPath . FilenameforSB, 1)

        IY := tv_getselection()
        Loop
        {
            IYC := TV_GetChild(IY)

            if not IYC
                break

            TV_delete(IYC)
        }


        if ( !( SelectedFullPath ) )
        {
            AddSubFoldersToTree(TreeRoot)
        }
        else
        {
            Loop %SelectedFullPath%\*.*, 2
            {
                IX := TV_Add(A_LoopFileName, IY , "Icon4")
                TV_gettext(FileNameX, IX)

                loop %SelectedFullPath%\%FileNameX%\*.*, 2
                {
                    TV_Add(A_LoopFileName, IX , "Icon4")
                }
            }
        }

        ToolTip, Loading...,,, 2


        Gui, ListView
                ,mylist

        LV_Delete()


        VarSetCapacity(Filename, 260)
        sfi_size = 352
        VarSetCapacity(sfi, sfi_size)

        Loop %SelectedFullPath%*.*
        {
            FileName := A_LoopFileFullPath

            SplitPath, FileName,,, FileExt

            ;; 拡張子が txt のときのみ
            ;; リストを描写する
            if (FileExt = "TXT")
            {
                if FileExt in EXE,ICO,ANI,CUR,LNK
                {
                    ExtID := FileExt
                    IconNumber := 0
                }
                else
                {
                    ExtID := 0

                    Loop 7
                    {
                        StringMid, ExtChar, FileExt, A_Index, 1

                        if not ExtChar
                            break
                       
                        ExtID := ExtID | (Asc(ExtChar) << (8 * (A_Index - 1)))
                    }

                    IconNumber := IconArray%ExtID%
                }

                if not IconNumber
                {
                    if not DllCall("Shell32\SHGetFileInfoA", "WStr", FileName, "Ptr", 0, "WStr", sfi, "Ptr", sfi_size, "Ptr", 0x101)
                        IconNumber = 9999999
                    else
                    {
                        hIcon := 0

                        Loop 4
                            hIcon += *(&sfi + A_Index-1) << 8*(A_Index-1)

                        IconNumber := DllCall("ImageList_ReplaceIcon", "Ptr", ImageListID1, "int", -1, "Ptr", hIcon) + 1
                        DllCall("ImageList_ReplaceIcon", "Ptr", ImageListID2, "int", -1, "Ptr", hIcon)
                        DllCall("DestroyIcon", "Ptr", hIcon)
                        IconArray%ExtID% := IconNumber
                    }
                }

                modified := A_LoopFileTimeModified
                StringSplit, modified, modified
                modified = 20%modified3%%modified4%-%modified5%%modified6%-%modified7%%modified8%
                size := A_LoopFileSize

                LV_Add("Icon" . IconNumber, A_LoopFileName, size, modified)
            }
        }

        ToolTip,,,, 2

    }


return

MyList:
    if ( ( A_GuiEvent = "normal" ) 
        or ( A_GuiEvent = "K" ) )
    {
        ItemID := ( A_GuiEvent = "normal" ) ? A_EventInfo
               :  ( A_GuiEvent = "K" ) ? LV_GetNext(0, F)
               :  0

        LV_GetText(FileNameforSB, ItemID, 1)
        SB_SetText(SelectedFullPath . FilenameforSB, 1)

        ;; 下部にテキストファイルの内容を表示
        FileAbsolutePath := SelectedFullPath . FilenameforSB

        SplitPath, FileAbsolutePath, , , OutExtension
        ; 拡張子が .txt のときのみ、解析を開始する
        if ( OutExtension = "TXT") {
    
            Gui, 10:Add, Progress, vlvl  -Smooth 0x8 w250 h18 ; PBS_MARQUEE = 0x8
            Gui, 10:Show, , キーボード配列を解析中
            SetTimer, Push, 30
    
            read_and_analyse_keyboard_layout(FileAbsolutePath)

            Gui, 10:Destroy
        }
    }
return





MyEdit:
    SplitPath, FilenameforSB, , , OutExtension
    if ( OutExtension = "TXT")
    {
        Run,% FileAbsolutePath
    }
;    else
;    {
;        MsgBox,テキスト形式のファイルが選択されていません。`nテキスト形式のファイルを選択してください。
;    }
return

;--------------------------------------------------------------------------------------------------
2GuiClose:
    ExitApp
return


GetParentDir(path)
{
        ;; 二階層上のフォルダを探索対象にする
    StringGetPos, backslash_r1, path, \, R1
    StringLeft, new_path, path, % backslash_r1

    return new_path
}

GetGrandparentDir(path)
{
        ;; 二階層上のフォルダを探索対象にする
    StringGetPos, backslash_r2, path, \, R2
    StringLeft, new_path, path, % backslash_r2

    return new_path
}

GuiClose:
ExitApp

Push:
    GuiControl, 10:, lvl, 1
Return

open_current_dir:
    if ( SelectedFullPath )
    {
        Run,% SelectedFullPath
    }
    else
    {
        msgbox, フォルダが選択されていません。
    }
return

save_to_text:
    ; 何かしらの設定がなされているとき
    if (all_key_info.len() > 0) {
        FileSelectFile, filename, 16, , 出力先のファイルを指定してください
        
        if (filename) {
            file := FileOpen(Filename, "w")
            file.Write(all_key_info.join("`r`n"))
            file.close()
        }
        else
        {
            msgbox, 出力先のファイルが正しく設定されていません。
        }
    }
    else
    {
        msgbox, ファイルが選択されていません。
    }

return