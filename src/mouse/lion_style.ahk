;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"

#if (is_Lion_style)

WheelUp::
    Send, {WheelDown}
    Return

WheelDown::
    Send, {WheelUp}
    Return

#if