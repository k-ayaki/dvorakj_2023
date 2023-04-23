Gui, Tab, 15


Gui, Add, Checkbox
        , x200 y25 vis_User_Function_Key gset_is_User_Function_Key Checked%is_User_Function_Key%
        , 独自のファンクションキー(&F)


Gui, Add, Edit
        , xp+0 y+10 w%EditW% R1 ReadOnly vGUI_FilePathOfUserFunctionKey
        , % ( FilePathOfUserFunctionKey = "error" ) ? "未選択"
                                                    : FilePathOfUserFunctionKey

Gui, Add, Button
        , x+10 yp-3 w50 gSelectingFunctionKeySettingFile
        , 選択...


