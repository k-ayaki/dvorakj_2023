;;; くるくるスクロール
;;; http://p2.chbox.jp/read.php?host=pc11.2ch.net&bbs=software&key=1230694774&ls=633

;;; 配布ウェブページ
;;; http://lukewarm.s101.xrea.com/up/file/108.zip

;;; マウスをくるくる回すとスクロール

Scroll_Rotation:
    if ( !(A_IsSuspended ) )
    {
        SetMouseScrolling(Scroll_timeout
                        , Scroll_high
                        , Scroll_low
                        , is_SwapDirectionsOfScrolling
                        , is_Lion_style)
    }
Return


SetMouseScrolling(Scroll_timeout
                , Scroll_high
                , Scroll_low
                , is_SwapDirectionsOfScrolling
                , is_Lion_style )
{
    static str
    static nx, ny

    static buf
    static lastpos

    static Scroll_sensitivity = 2


    If (A_TimeIdlePhysical > Scroll_timeout)
        str = 999999999


    lx := nx
    ly := ny
    MouseGetPos,nx,ny


    If (nx > lx && ny > ly)
        pos=1
    If (nx > lx && ny < ly)
        pos=2
    If (nx < lx && ny < ly)
        pos=3
    If (nx < lx && ny > ly)
        pos=4


    If (pos <> lastpos)
    {
        str := str pos
        lastpos := pos
        StringRight,str,str,10-2 * Scroll_sensitivity
    }


    dis := ((lx-nx)**2+(ly-ny)**2)**0.5
    buf += dis

    If (buf > 100 / Scroll_low)
    {
        buf = 0

        direction := ( RegExMatch("1234123412341234",str) ) ? 2 ; 時計回り
                  :  ( RegExMatch("4321432143214321",str) ) ? 1 ; 反時計回り
                  :  0

        ;; マウスがくるくると回されたとき
        if ( direction )
        {
            ;; オプションを有効にしているときは
            ;; 水平スクロールと垂直スクロールを切り替える
            if ( is_SwapDirectionsOfScrolling )
                direction *= -1

            ;; シフトキーを押し下げているときには
            ;; 水平スクロールと垂直スクロールを切り替える
            if ( GetKeyState("shift", "P") )
                direction *= -1


            ;; 垂直スクロールの方向を逆にするよう設定している場合
            if ( is_Lion_style ) {
                ;; 垂直スクロールのとき
                if ( 0 < direction ) {
                    ;; 1 -> 2 (2 = 3 - 1)
                    ;; 2 -> 1 (1 = 3 - 2)
                    direction := 3 - direction
                }
            }

            freq := dis * Scroll_high / 50 + 1
            EmulateMouseScrolling(direction, freq)
        }
    }

    return
}


;;; WheelScroll.ahk を使用して
;;; 水平スクロールを実現している
EmulateMouseScrolling(direction, freq)
{
    ;; direction が正のときは垂直スクロール
        ;;  1: ↓
        ;;  2: ↑
    ;; direction が負のときは水平スクロール
        ;; -1: →
        ;; -2: ←

    if ( direction = 1 )
    {
        Loop, %freq%
            WheelRedirect(0, 1)

        return
    }

    if ( direction = 2 )
    {
        Loop, %freq%
            WheelRedirect(0, 0)

        
        return
    }

    if ( direction = -1 )
    {
        Loop, %freq%
            WheelRedirect(1, 1)
            
        return
    }

    if ( direction = -2 )
    {
        Loop, %freq%
            WheelRedirect(1, 0)

        return
    }
}