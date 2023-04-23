Gui, Tab, 6

Gui, Add, GroupBox
        , x%GroupBoxX% y20 w%GroupBoxW% %GroupBoxH%
        ,日本語入力用配列




Gui, Add, Text
        , xp+20 yp+25
        , 設定ファイル

Gui, Add, Edit
        , xp+0 yp+20 w%EditW% R1 ReadOnly vFilePathOfUserJapaneseLayout
        , %FilePathOfUserJapaneseLayout%

Gui, Add, Button
        , x+10 yp-3 w50 gSelectingJapaneseLayoutSettingFile
        , 選択...


Gui, Add, GroupBox
        , x%GroupBoxX% y105 w%GroupBoxW% R13
        ,日本語入力の設定




Loop, 3
{
    ;; チェックすべきラジオボタンのときは
    ;; n に 1 を代入する
    ;; それ以外のときには n に 0 を代入

    n := ( nJapaneseLayoutMode = A_Index ) ? 1
      :                                      0

    If (A_Index = 1)
    {
        Gui, Add, Radio
            , xp+20 yp+20 vnJapaneseLayoutMode gset_nJapaneseLayoutMode Checked%n%
            , 日本語入力用配列を常に使用しない(&N)
    }
    else
    {
        Gui, Add, Radio
            , xp+0 y+10 gset_nJapaneseLayoutMode Checked%n%
            , % (A_Index = 2) ? "日本語入力用配列を日本語入力時にのみ使用する(&O)"
                              : "日本語入力用配列を常に使用する(&U)"
    }
}

Gui, Add, Text
        , xp+0 y+5
        , 　　　※タイピングを練習するとき（以下の項目も参照）

Gui, Add, Checkbox
        , xp+0 y+20 vIs_kana_typing_mode gset_Is_kana_typing_mode Checked%Is_kana_typing_mode%
        , かな入力用の設定で日本語入力用配列を使用する(&K)

Gui, Add, Text
        , xp+0 y+5
        , 　　　※濁点と半濁点を個別に発行するとき


Gui, Add, GroupBox
        , x%DoubleGroupBoxX% y+20 w%DoubleGroupBoxW% R3
        , [Shift] + [文字] のとき


Gui, Add, Checkbox
        , xp+20 yp+20 vis_ShiftPlusAlphabetMode gset_is_ShiftPlusAlphabetMode Checked%is_ShiftPlusAlphabetMode%
        , 直接入力に切り替えて発行する(&D)


Gui, Add, Checkbox
        , xp+0 yp+30 vIs_with_Shift_outputting_nothing gset_is_with_Shift_outputting_nothing Checked%Is_with_Shift_outputting_nothing%
        , 未設定のときには何も発行しない(&W)
