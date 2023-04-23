;;; ============================================================================
;;; ---------------- キーを単独で入力したとき
;;; ============================================================================
#If

sc002:: ; 1
sc003:: ; 2
sc004:: ; 3
sc005:: ; 4
sc006:: ; 5
sc007:: ; 6
sc008:: ; 7
sc009:: ; 8
sc00A:: ; 9
sc00B:: ; 0
sc00C:: ; -
sc00D:: ; {^}
sc07D:: ; \ と |
sc010:: ; q
sc011:: ; w
sc012:: ; e
sc013:: ; r
sc014:: ; t
sc015:: ; y
sc016:: ; u
sc017:: ; i
sc018:: ; o
sc019:: ; p
sc01A:: ; @
sc01B:: ; [
sc01E:: ; a
sc01F:: ; s
sc020:: ; d
sc021:: ; f
sc022:: ; g
sc023:: ; h
sc024:: ; j
sc025:: ; k
sc026:: ; l
sc027:: ; ;
sc028:: ; :
sc02B:: ; ]
sc02C:: ; z
sc02D:: ; x
sc02E:: ; c
sc02F:: ; v
sc030:: ; b
sc031:: ; n
sc032:: ; m
sc033:: ; ,
sc034:: ; .
sc035:: ; /
sc073:: ; \ と _
	if ( bIME )
	    GoSub, Send_JapaneseLayout_non-shift
	else
	    GoSub, Send_EnglishLayout_non-shift
return

#If