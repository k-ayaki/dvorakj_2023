#SingleInstance FORCE
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#persistent
SetWorkingDir %A_ScriptDir%

Menu, Tray, Icon
			, keyboard_magnify.ico

;;; On-Screen Keyboard (requires XP/2k/NT) -- by Jon
;;; http://www.autohotkey.com/docs/scripts/KeyboardOnScreen.htm


;---- Configuration Section: Customize the size of the on-screen keyboard and
; other options here.

; Changing this font size will make the entire on-screen keyboard get
; larger or smaller:
k_FontSize := 10
k_FontName := "Constantia, Verdana"  ; This can be blank to use the system's default font.
k_FontStyle := "Bold"    ; Example of an alternative: Italic Underline

; To have the keyboard appear on a monitor other than the primary, specify
; a number such as 2 for the following variable.  Leave it blank to use
; the primary:
k_Monitor = 

;---- End of configuration section.  Don't change anything below this point
; unless you want to alter the basic nature of the script.


;---- Alter the tray icon menu:
;Menu, Tray, Default, %k_MenuItemHide%
Menu, Tray, NoStandard
Menu, Tray, Add, 終了(&X), GuiClose
Menu, Tray, Tip, 文字キーのスキャンコードの調査

;---- Calculate object dimensions based on chosen font size:
k_KeyWidth      := k_FontSize * 3
k_KeyWidth2     := k_FontSize * 3
k_KeyWidth3     := k_FontSize * 4
k_KeyWidth4     := k_FontSize * 5
k_KeyHeight     := k_FontSize * 3
k_KeyMargin     := k_FontSize / 6
k_SpacebarWidth := k_FontSize * 20
k_KeyWidthHalf := k_KeyWidth / 2

k_KeySize = w%k_KeyWidth% h%k_KeyHeight%
k_Position = x+%k_KeyMargin% %k_KeySize%

Gui, Font, S16
Gui, Add, Edit, ReadOnly vScanCode, scan code
Gui, Font, S10
Gui, Add, Text, yp+3 x+100, [Ctrl] + [c]: スキャンコードの値をコピー
Gui, Add, Text, yp+20 xp+0, [Ctrl] + [x]: このプログラムを終了


;---- Create a GUI window for the on-screen keyboard:
Gui, Font, s%k_FontSize% %k_FontStyle%, %k_FontName%


;---- Add a button for each key. Position the first button with absolute
Gui, Add, Button, section %k_KeySize% xm+%k_FontSize%, 1
Gui, Add, Button, %k_Position%, 2
Gui, Add, Button, %k_Position%, 3
Gui, Add, Button, %k_Position%, 4
Gui, Add, Button, %k_Position%, 5
Gui, Add, Button, %k_Position%, 6
Gui, Add, Button, %k_Position%, 7
Gui, Add, Button, %k_Position%, 8
Gui, Add, Button, %k_Position%, 9
Gui, Add, Button, %k_Position%, 0
Gui, Add, Button, %k_Position%, -
Gui, Add, Button, %k_Position%, ^
Gui, Add, Button, %k_Position%, \ |

Gui, Add, Button, h%k_KeyHeight% y+%k_KeyMargin% w%k_KeyWidth% xm+%k_KeyWidth2%, Q ; Auto-width.
Gui, Add, Button, %k_Position%, W
Gui, Add, Button, %k_Position%, E
Gui, Add, Button, %k_Position%, R
Gui, Add, Button, %k_Position%, T
Gui, Add, Button, %k_Position%, Y
Gui, Add, Button, %k_Position%, U
Gui, Add, Button, %k_Position%, I
Gui, Add, Button, %k_Position%, O
Gui, Add, Button, %k_Position%, P
Gui, Add, Button, %k_Position%, @
Gui, Add, Button, %k_Position%, [

Gui, Add, Button, h%k_KeyHeight% y+%k_KeyMargin% w%k_KeyWidth% xm+%k_KeyWidth3%, A ; Auto-width.
Gui, Add, Button, %k_Position%, S
Gui, Add, Button, %k_Position%, D
Gui, Add, Button, %k_Position%, F
Gui, Add, Button, %k_Position%, G
Gui, Add, Button, %k_Position%, H
Gui, Add, Button, %k_Position%, J
Gui, Add, Button, %k_Position%, K
Gui, Add, Button, %k_Position%, L
Gui, Add, Button, %k_Position%, `;
Gui, Add, Button, %k_Position%, :
Gui, Add, Button, %k_Position%, ]

Gui, Add, Button, h%k_KeyHeight% y+%k_KeyMargin% w%k_KeyWidth% xm+%k_KeyWidth4%, Z ; Auto-width.
Gui, Add, Button, %k_Position%, X
Gui, Add, Button, %k_Position%, C
Gui, Add, Button, %k_Position%, V
Gui, Add, Button, %k_Position%, B
Gui, Add, Button, %k_Position%, N
Gui, Add, Button, %k_Position%, M
Gui, Add, Button, %k_Position%, `,
Gui, Add, Button, %k_Position%, .
Gui, Add, Button, %k_Position%, /
Gui, Add, Button, %k_Position%, \ _


;---- Show the window:
;Gui, +ToolWindow
Gui, Show, , 文字キーのスキャンコードの調査


WinGet, k_ID, ID, A   ; Get its window ID.
WinGetPos,,, k_WindowWidth, k_WindowHeight, A


;---- Set all keys as hotkeys. See www.asciitable.com

return ; End of auto-execute section.


;---- When a key is pressed by the user, click the corresponding button on-screen:



~sc002:: ; 1
~sc003:: ; 2
~sc004:: ; 3
~sc005:: ; 4
~sc006:: ; 5
~sc007:: ; 6
~sc008:: ; 7
~sc009:: ; 8
~sc00A:: ; 9
~sc00B:: ; 0
~sc00C:: ; -
~sc00D:: ; {^}
~sc07D:: ; \ と |
~sc010:: ; q
~sc011:: ; w
~sc012:: ; e
~sc013:: ; r
~sc014:: ; t
~sc015:: ; y
~sc016:: ; u
~sc017:: ; i
~sc018:: ; o
~sc019:: ; p
~sc01A:: ; @
~sc01B:: ; [
~sc01E:: ; a
~sc01F:: ; s
~sc020:: ; d
~sc021:: ; f
~sc022:: ; g
~sc023:: ; h
~sc024:: ; j
~sc025:: ; k
~sc026:: ; l
~sc027:: ; ;
~sc028:: ; :
~sc02B:: ; ]
~sc02C:: ; z
~sc02D:: ; x
~sc02E:: ; c
~sc02F:: ; v
~sc030:: ; b
~sc031:: ; n
~sc032:: ; m
~sc033:: ; ,
~sc034:: ; .
~sc035:: ; /
~sc073:: ; \ と _
    StringTrimLeft, k_ThisHotkey, A_ThisHotkey, 4
    sc_key := "sc0" . k_ThisHotkey
    GuiControl, , ScanCode, %sc_key%

    k_ThisHotkey := (k_ThisHotkey = "02") ? "1"
                 :  (k_ThisHotkey = "03") ? "2"
                 :  (k_ThisHotkey = "04") ? "3"
                 :  (k_ThisHotkey = "05") ? "4"
                 :  (k_ThisHotkey = "06") ? "5"
                 :  (k_ThisHotkey = "07") ? "6"
                 :  (k_ThisHotkey = "08") ? "7"
                 :  (k_ThisHotkey = "09") ? "8"
                 :  (k_ThisHotkey = "0A") ? "9"
                 :  (k_ThisHotkey = "0B") ? "0"
                 :  (k_ThisHotkey = "0C") ? "-"
                 :  (k_ThisHotkey = "0D") ? "^"
                 :  (k_ThisHotkey = "7D") ? "\ |"
                 :  (k_ThisHotkey = "10") ? "Q"
                 :  (k_ThisHotkey = "11") ? "W"
                 :  (k_ThisHotkey = "12") ? "E"
                 :  (k_ThisHotkey = "13") ? "R"
                 :  (k_ThisHotkey = "14") ? "T"
                 :  (k_ThisHotkey = "15") ? "Y"
                 :  (k_ThisHotkey = "16") ? "U"
                 :  (k_ThisHotkey = "17") ? "I"
                 :  (k_ThisHotkey = "18") ? "O"
                 :  (k_ThisHotkey = "19") ? "P"
                 :  (k_ThisHotkey = "1A") ? "@"
                 :  (k_ThisHotkey = "1B") ? "["
                 :  (k_ThisHotkey = "1E") ? "A"
                 :  (k_ThisHotkey = "1F") ? "S"
                 :  (k_ThisHotkey = "20") ? "D"
                 :  (k_ThisHotkey = "21") ? "F"
                 :  (k_ThisHotkey = "22") ? "G"
                 :  (k_ThisHotkey = "23") ? "H"
                 :  (k_ThisHotkey = "24") ? "J"
                 :  (k_ThisHotkey = "25") ? "K"
                 :  (k_ThisHotkey = "26") ? "L"
                 :  (k_ThisHotkey = "27") ? ";"
                 :  (k_ThisHotkey = "28") ? ":"
                 :  (k_ThisHotkey = "2B") ? "]"
                 :  (k_ThisHotkey = "2C") ? "Z"
                 :  (k_ThisHotkey = "2D") ? "X"
                 :  (k_ThisHotkey = "2E") ? "C"
                 :  (k_ThisHotkey = "2F") ? "V"
                 :  (k_ThisHotkey = "30") ? "B"
                 :  (k_ThisHotkey = "31") ? "N"
                 :  (k_ThisHotkey = "32") ? "M"
                 :  (k_ThisHotkey = "33") ? ","
                 :  (k_ThisHotkey = "34") ? "."
                 :  (k_ThisHotkey = "35") ? "/"
                 :  (k_ThisHotkey = "73") ? "\ _"
                : 0


    ControlClick, %k_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, D
    KeyWait, %k_ThisHotkey%
    ControlClick, %k_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, U
return




GuiClose:
k_MenuExit:
ExitApp



^X::
    ExitApp
return

^C::
    clipboard := sc_key
    ExitApp
return
