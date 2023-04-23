Gui, Tab, 16


Gui, Add, Checkbox
        , x200 y25 vis_User_Ten_Key gset_is_User_Ten_Key Checked%is_User_Ten_Key%
        , 独自のテンキー(&T)


Gui, Add, Edit
        , xp+0 y+10 w%EditW% R1 ReadOnly vFilePathOfUserTenKey
        , % ( FilePathOfUserTenKey = "error" ) ? "未選択"
                                                    : FilePathOfUserTenKey

Gui, Add, Button
        , x+10 yp-3 w50 gSelectingTenKeySettingFile
        , 選択...
