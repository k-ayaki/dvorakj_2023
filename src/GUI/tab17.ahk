Gui, tab, 17

Gui, Add, Checkbox
        , x200 y25 vis_Lion_style gset_is_Lion_style Checked%is_Lion_style%
        , 垂直スクロールの方向を逆にする(&L)


Gui, Add, Checkbox
        , xp+0 yp+30 vis_KuruKuruScroll gset_is_KuruKuruScroll Checked%is_KuruKuruScroll%
        , マウスをくるくる回してスクロールする(&M)


Gui, Add, Text
        , xp+0 y+5
        , 　　　※[Shift]を押している間は水平にスクロールする


Gui, Add, Checkbox
        , xp+0 yp+30 vis_SwapDirectionsOfScrolling gset_is_SwapDirectionsOfScrolling Checked%is_SwapDirectionsOfScrolling%
        , 垂直スクロールと水平スクロールを入れ替える(&V)

Gui, Add, Text
        , xp+0 y+5
        , 　　　※Microsoft Excel においてのみ動作する


Gui, Add, GroupBox
        , x%GroupBoxX% yp+40 w%GroupBoxW% R5
        , スクロールする量 (1--3)

;;; テキストの配置
Gui, Add, text
        , x200 yp+25
        , 高速時

;;; スライドの配置
Gui, Add, Slider
        , xp+40 yp-5 w%SliderW% Range1-3 TickInterval1 Line1 ToolTipBottom vScroll_high_1 gset_Scroll_high
        , % Scroll_high

;;; 編集欄の配置
Gui, Add, Edit 
        , x+5 yp+0 w30 vScroll_high_2 gset_Scroll_high ReadOnly
        , % Scroll_high

;;; テキストの配置
Gui, Add, text
        , x200 yp+50
        , 低速時

;;; スライドの配置
Gui, Add, Slider
        , xp+40 yp-5 w%SliderW% Range1-3 TickInterval1 Line1 ToolTipBottom vScroll_low_1 gset_Scroll_low
        , % Scroll_low

;;; 編集欄の配置
Gui, Add, Edit
        , x+5 yp+0 w30 vScroll_low_2 gset_Scroll_low ReadOnly
        , % Scroll_low

Gui, Add, GroupBox
        , x%GroupBoxX% yp+60 w%GroupBoxW% R2.5 
        , マウスの入力情報を維持する時間 (100---1000 ミリ秒)

;;; スライドの配置
Gui, Add, Slider
        , xp+15 yp+20 w%SliderW% Range100-1000 TickInterval100 Line100 ToolTipBottom vScroll_timeout_1 gset_Scroll_timeout
        , % Scroll_timeout

;;; 編集欄の配置
Gui, Add, Edit 
        , x+5 yp+0 w35 vScroll_timeout_2 gset_Scroll_timeout ReadOnly
        , % Scroll_timeout

;;; テキストの配置
Gui, Add, text
        , xp+40 yp+5
        , ミリ秒