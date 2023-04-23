Gui, Tab, 5


Gui, Add, GroupBox
        , x%GroupBoxX% y20 w%GroupBoxW% %GroupBoxH%
        , 　直接入力用配列


Gui, Add, Text
        , xp+20 yp+25
        , 設定ファイル

Gui, Add, Edit
        , xp+0 yp+20 w%EditW% R1 ReadOnly vFilePathOfUserEnglishLayout
        , %FilePathOfUserEnglishLayout%

Gui, Add, Button
        , x+10 yp-3 w50 gSelectingEnglishLayoutSettingFile
        , 選択...


    ;; GropBox ======================================== 
Gui, Add, GroupBox
        , x%GroupBoxX% y+20 w%GroupBoxW% R5.5
        , 直接入力用設定を一時利用する場合

Gui, Add, Checkbox
        , xp+20 yp+20 vis_Monitoring_Console_Window_Class gset_is_Monitoring_Console_Window_Class Checked%is_Monitoring_Console_Window_Class%
        , コマンドプロンプト等で入力中(&C)　　※有効化を強く推奨

Gui, Add, Checkbox
        , xp+0 yp+25 R1 vis_using_English_layout_on_Alphanumeric_Mode gset_is_using_English_layout_on_Alphanumeric_Mode Checked%is_using_English_Layout_on_Alphanumeric_Mode%
        , 全角英数または半角英数を入力中(&D)

Gui, Add, Checkbox
        , xp+0 yp+25 R1 vis_using_English_Layout_with_IME_Candidate_Window gset_is_using_English_Layout_with_IME_Candidate_Window Checked%is_using_English_Layout_with_IME_Candidate_Window%
        , 変換候補窓を表示中(&T)

Gui, Add, Checkbox
        , xp+0 yp+25 R1 vis_using_English_layout_with_chinese_input_mode gset_is_using_English_layout_with_chinese_input_mode Checked%is_using_English_Layout_with_chinese_input_mode%
        , 中国語を入力中(&Z)　　※簡体字・繁体字の両方に対応


