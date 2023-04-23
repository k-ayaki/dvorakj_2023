;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"
Gui, tab, 20


Gui, Add, GroupBox
        , x%GroupBoxX% y+15 w%GroupBoxW% R9
        , DvorakJ 用ホットキー

Gui, Add, Checkbox
        , xp+20 yp+25 vis_hotkey_of_DvorakJ gset_is_hotkey_of_DvorakJ Checked%is_hotkey_of_DvorakJ%
        , DvorakJ 用のホットキーを有効にする(&S)

Gui, Add, text
        , x200 y+15
        , 実行を停止する

Gui, Add, Edit
        , yp-5 xp+150 w150 r1 hwndsuspend_key gset_suspend_key vsuspend_key
        , % string_to_array(suspend_key, "|").join(" | ")

set_edit_cue_banner(suspend_key, "LCtrl -> RCtrl")

Gui, Add, text
        , x200 y+20
        , 実行を再開する


Gui, Add, Edit
        , yp-5 xp+150 w150 r1 hwndresume_key gset_resume_key vresume_key
        , % string_to_array(resume_key, "|").join(" | ")

set_edit_cue_banner(resume_key, "RCtrl -> LCtrl")

Gui, Add, text
        , x200 y+20
        , 実行の状態を切り替える


Gui, Add, Edit
        , yp-5 xp+150 w150 r1 hwndtoggle_key gset_toggle_key vtoggle_key
        , % string_to_array(toggle_key, "|").join(" | ")

set_edit_cue_banner(toggle_key, "S-ScrollLock")

Gui, Add, text
        , x200 y+20
        , 再起動する

Gui, Add, Edit
        , yp-5 xp+150 w150 r1 hwndrestart_key gset_restart_key vrestart_key
        , % string_to_array(restart_key, "|").join(" | ")

set_edit_cue_banner(restart_key, "A-ScrollLock")
