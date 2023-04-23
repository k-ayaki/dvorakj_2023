;;; Explorer-Like TreeView slightly modified from AHKHelp
;;; http://www.autohotkey.com/forum/post-230312.html#230312

ChooseSettingFile( option = 0 )
{
    global MyTree
    global MyList
    global MyPreview

    global dvorakj_dir
    global TreeRoot


    global history_of_EnglishLayout
    global history_of_JapaneseLayout
    global history_of_ShortcutKey
    global history_of_MuhenkanHenkan
    global history_of_FunctionKey
    global history_of_TenKey

    global history_arr


    ;; 設定ファイルを指定する
    ;; z:\dvorakj\apps\dvorakj_manager.ahk というパスから、z:\dvorakj を取り出す
    ;; つまり、このファイルの絶対パスから "\apps\dvorakj_manager.ahk" を取り除く
    SplitPath, A_ScriptDir, name, dvorakj_dir

;   dvorakj_dir := A_ScriptDir
    TreeRoot := dvorakj_dir



    ImageListID := IL_Create(12)
    LV_SetImageList(ImageListID)

    Loop 12
    {
        IL_Add(ImageListID, "shell32.dll", A_Index)
    }

    Gui, 2:Add, TreeView
                , ys r11 x15 w230 vMyTree gMyTree ImageList%ImageListID% Altsubmit
    Gui, 2:Add, ListView
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
    Gui, 2:Font, Q5, monospace
    Gui, 2:Font, Q5, MS Gothic
    Gui, 2:Add, Edit
                , x10 w600 R10 vMyPreview multi ReadOnly
                , ファイルの内容
    ;LV_ModifyCol(1, 679)
    ;; 通常のフォントに戻す
    Gui, 2:Font


    Gui, 2:Add, Button
                , gMyChoice xp+200 y+25 R1.5 w160
                , 選択
    Gui, 2:Add, Button
                , gMyEdit x+30 yp+0 R1.5 w80
                , 編集
    Gui, 2:Add, Button
                , g2GuiClose x+30 yp+0 R1.5 w80
                , キャンセル

    Gui, 2:Add, StatusBar
                , gMyStatusBar
    SB_SetParts(450)
    SB_SetText("［選択中のフォルダを開く］", 2)

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


    Gui, 2:Show
            ,
            , % "DvorakJ - " . window_title . "の設定ファイル"

    return
}

;;; スクリプトがあるフォルダを基準として初期化
AddSubFoldersToTree(folder, ID = 0)
{
    ID := TV_Add(folder, ID, "Icon10 expand")

    Loop, %folder%\*.*, 2
    {
        ;; data フォルダと user フォルダ以外は
        ;; 処理対象から除外する
        if not(("data" = A_LoopFileName) || ("user" = A_LoopFileName)) {
            continue
        }
        

        IX := TV_Add(A_LoopFileName, ID, "Icon4")
        TV_gettext(FileNameX, IX)

        loop, %folder%\%FileNameX%\*.*, 2
        {
            TV_Add(A_LoopFileName, IX, "Icon4")
        }
    }

    return true
}



MyTree:
    ;; 項目のテキストをクリックしたとき
    ;; または、項目上でキーを押したとき
    if ((A_GuiEvent = "normal") || (A_GuiEvent = "K")) {
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


        if not (SelectedFullPath) {
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


        Gui, 2:ListView
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
                    IconNumber = 0
                }
                else
                {
                    ExtID = 0

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
                        hIcon = 0

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
    if (("normal" = A_GuiEvent) || ("K" = A_GuiEvent)) {
        ItemID := ( A_GuiEvent = "normal" ) ? A_EventInfo
               :  ( A_GuiEvent = "K" ) ? LV_GetNext(0, F)
               :  0

        LV_GetText(FileNameforSB, ItemID, 1)
        SB_SetText(SelectedFullPath . FilenameforSB, 1)

        ;; 下部にテキストファイルの内容を表示
        FileAbsolutePath := SelectedFullPath . FilenameforSB
        FileRead, ContentsOfSetting, % FileAbsolutePath
        GuiControl, Text, MyPreview, % ContentsOfSetting
    }

    if ( "DoubleClick" = A_GuiEvent)
    {
        Goto, MyChoice
    }
return


MyStatusBar:
    if ("Normal" = A_GuiEvent) {
        ;; 何かしらのフォルダが選択されているときは
        ;; そのフォルダを開く
        if (SelectedFullPath) {
            myrun(SelectedFullPath)
        }
    }
return


MyChoice:
    SplitPath, FilenameforSB, , , OutExtension


    ;; テキストファイルが選択された場合
    if ( OutExtension = "TXT") {
        ;; 設定ファイルのありかを取得する
        ;; 相対パスで情報を保存する
        ScriptDirLen := StrLen( dvorakj_dir ) + 2
        StringMid, FileRelativePath, FileAbsolutePath, %ScriptDirLen%,

        file_path := get_filename_with_current_dir(FileRelativePath)



        ;; 英語配列
        if ( file_number_selected = 1 ) {
            Gosub, 2GuiClose

            IniWrite, %file_path%, %ini_file%, FilePath, UserEnglishLayout
            FilePathOfUserEnglishLayout := file_path

            ;; 履歴を更新する
            history_of_EnglishLayout := history_update(history_arr, FilePathOfUserEnglishLayout).DeepCopy()
            ;; 履歴を ini に書き出す
            write_value_to_ini("FilePath", "history_of_EnglishLayout", history_of_EnglishLayout.join("|"))

            set_GUI_name_of_EnglishLayout()
            set_keyboard_layout_version(1, FilePathOfUserEnglishLayout)
            
            return
        }


                
        ;; 日本語配列
        if ( file_number_selected = 2 )
        {
            Gosub, 2GuiClose

            IniWrite, %file_path%, %ini_file%, FilePath, UserJapaneseLayout
            FilePathOfUserJapaneseLayout := file_path


            ;; 履歴を更新する
            history_of_JapaneseLayout := history_update(history_arr, FilePathOfUserJapaneseLayout).DeepCopy()
            ;; 履歴を ini に書き出す
            write_value_to_ini("FilePath", "history_of_JapaneseLayout", history_of_JapaneseLayout.join("|"))


            set_GUI_name_of_JapaneseLayout()
            set_keyboard_layout_version(2, FilePathOfUserJapaneseLayout)
            
            return
        }


        ;;  ユーザー独自のショートカットキー
        if ( file_number_selected = 3 )
        {
            Gosub, 2GuiClose

            IniWrite, %file_path%, %ini_file%, FilePath, UserShortcutKey
            FilePathOfUserShortcutKey := file_path


            ;; 履歴を更新する
            history_of_ShortcutKey := history_update(history_arr, FilePathOfUserShortcutKey).DeepCopy()
            ;; 履歴を ini に書き出す
            write_value_to_ini("FilePath", "history_of_ShortcutKey", history_of_ShortcutKey.join("|"))

            set_keyboard_layout_version(3, FilePathOfUserShortcutKey)
            set_GUI_Text("FilePathOfUserShortcutKey", FilePathOfUserShortcutKey)

            return
        }
        
        
        ;;  無変換キーと変換キー
        if ( file_number_selected = 4 ) {
            Gosub, 2GuiClose

            IniWrite, %file_path%, %ini_file%, FilePath, UserShortcutKeyMuhenkanHenkan
            FilePathOfUserShortcutKeyMuhenkanHenkan := file_path


            ;; 履歴を更新する
            history_of_MuhenkanHenkan := history_update(history_arr, FilePathOfUserShortcutKeyMuhenkanHenkan).DeepCopy()
            ;; 履歴を ini に書き出す
            write_value_to_ini("FilePath", "history_of_MuhenkanHenkan", history_of_MuhenkanHenkan.join("|"))

            set_keyboard_layout_version(4, FilePathOfUserShortcutKeyMuhenkanHenkan)
            set_GUI_Text("FilePathOfUserShortcutKeyMuhenkanHenkan", FilePathOfUserShortcutKeyMuhenkanHenkan)

            return
        }
        
        ;; ファンクションキー
        if ( file_number_selected = 5 ) {
            Gosub, 2GuiClose

            IniWrite, %file_path%, %ini_file%, FilePath, UserFunctionKey
            FilePathOfUserFunctionKey := file_path


            ;; 履歴を更新する
            history_of_FunctionKey := history_update(history_arr, FilePathOfUserFunctionKey).DeepCopy()
            ;; 履歴を ini に書き出す
            write_value_to_ini("FilePath", "history_of_FunctionKey", history_of_FunctionKey.join("|"))


            set_keyboard_layout_version(5, FilePathOfUserFunctionKey)
            set_GUI_Text("FilePathOfUserFunctionKey", FilePathOfUserFunctionKey)

            return
        }
        
        ;; テンキー
        if ( file_number_selected = 6 ) {
            Gosub, 2GuiClose

            IniWrite, %file_path%, %ini_file%, FilePath, UserTenKey
            FilePathOfUserTenKey := file_path


            ;; 履歴を更新する
            history_of_TenKey := history_update(history_arr, FilePathOfUserTenKey).DeepCopy()
            ;; 履歴を ini に書き出す
            write_value_to_ini("FilePath", "history_of_TenKey", history_of_TenKey.join("|"))


            set_keyboard_layout_version(6, FilePathOfUserTenKey)
            set_GUI_Text("FilePathOfUserTenKey", FilePathOfUserTenKey)

            return
        }
        

        ;;  テキストファイルが選択されたものの
        ;; file_number が不正のとき
        return
    }
    
    
    ;; テキストファイルが選択されなかった場合
        msgbox_option( 0, "ファイル形式に誤りがあります"
                        , "テキスト形式のファイルが選択されていません。"
                        , "テキスト形式のファイルを選択してください。")
    return



MyEdit:
    SplitPath, FilenameforSB, , , OutExtension

    if (OutExtension = "TXT") {
        myrun( FileAbsolutePath )
        return
    }

    msgbox_option( 0, "ファイル形式に誤りがあります"
                        , "テキスト形式のファイルが選択されていません。"
                        , "テキスト形式のファイルを選択してください。")
    return



history_update(history_arr, filepath) {
    if (history_arr.IndexOf(filepath)) {
        removed_index := history_arr.IndexOf(filepath)

        new_list := Array()
        for i, v in history_arr
        {
            if (i != removed_index) {
                new_list.append(v)
            }
        }
        new_list.append(filepath)

        history_arr := new_list.DeepCopy()
    }
    else
    {
        history_arr.append(filepath)
    }


    ;; 履歴を最大 5 件記録する
    ;; 
    if (history_arr.len() > 5) {
        history_arr.delete(1)
    }

    return history_arr
}

set_keyboard_layout_version(p_keyboard_type, p_keyboard_layout_path)
; キーボード配列の設定ファイルが何のものなのか（直接入力用配列、テンキー用配列、等）とその設定ファイルのパスを
;; GUIからDvorakJ本体に送る
{
    SendUpdate_from_GUI(p_keyboard_type "," p_keyboard_layout_path)
    return
}

;--------------------------------------------------------------------------------------------------
2GuiClose:
    Gui, 2:Destroy
    another_file_selector := False

    Gui, 1:Default
return

