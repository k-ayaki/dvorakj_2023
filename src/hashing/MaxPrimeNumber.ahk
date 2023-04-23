;;; AutoHotkey でハッシュ法を使用するために素数を生成する関数を作成した - blechmusik2の日記
;;; http://d.hatena.ne.jp/blechmusik2/20090926/1253905867

;;; Print Prime Numbers
;;; http://www.rsok.com/~jrm/printprimes.html

; n := 3000000000

;msgbox,% is_prime_number(n)
;msgbox,% Get_prev_prime_number(n)
;msgbox,% Get_next_prime_number(n)


Get_prev_prime_number(n, odd=0)
{
    if (odd = 0)
    {
        n -= % (Mod(n, 2) = 0) ? 1
            :  2
    }

    return % ( is_prime_number(n) ) ? n
           :  Get_prev_prime_number(n - 2, 1)
}

Get_next_prime_number(n, odd=0)
{
    if (odd = 0)
    {
        n += % (Mod(n, 2) = 0) ? 1
           :   2
    }

    return % ( is_prime_number(n) ) ? n
           :  Get_next_prime_number(n + 2, 1)
}

is_prime_number( n )
{
    return % MillerRabin(n)
}

;;; Miller-Rabin primality test - Rosetta Code
;;; http://rosettacode.org/wiki/Miller-Rabin_primality_test#AutoHotkey

MillerRabin(n,k=10) { ; 0: composite, 1: probable prime (n < 2**31)
    d := n-1
    s := 0


    While !(d&1)
    {
        d>>=1
        s++
    }

    Loop %k% {
        Random a, 2, n-2 ; if n < 4,759,123,141, it is enough to test a = 2, 7, and 61.
        x := PowMod(a,d,n)

        If (x=1 || x=n-1)
            Continue

        Cont := 0
        Loop % s-1 {
            x := PowMod(x,2,n)

            If (x = 1)
                Return 0

            If (x = n-1) {
                Cont = 1
                Break
            }
        }

        IfEqual Cont,1, Continue
        Return 0
    }

    Return 1
}

PowMod(x,n,m) { ; x**n mod m
    y := 1
    i := n
    z := x

    While i>0
    {
        y := i&1 ? mod(y*z,m) : y
        z := mod(z*z,m)
        i >>= 1
    }

    Return y
}
