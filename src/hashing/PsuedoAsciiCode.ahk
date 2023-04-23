;;; 日本語入力用の配列（ローマ字かな変換表版）の設定を数値に変換する関数を作成した - blechmusik2の日記
;;; http://d.hatena.ne.jp/blechmusik2/20090927/1253988318

;;; 文字列を Ascii Code を使用する数値に変換して返す関数
PsuedoAsciiCode(str)
{
    ;; キーを数字で表す
    ;; 数字を 10 から割り振っている理由は
    ;; 10 の位にある 0 が消失することがあるため
    StringReplace, str, str, -02, _10, All
    StringReplace, str, str, -03, _11, All
    StringReplace, str, str, -04, _12, All
    StringReplace, str, str, -05, _13, All
    StringReplace, str, str, -06, _14, All
    StringReplace, str, str, -07, _15, All
    StringReplace, str, str, -08, _16, All
    StringReplace, str, str, -09, _17, All
    StringReplace, str, str, -0A, _18, All
    StringReplace, str, str, -0B, _19, All
    StringReplace, str, str, -0C, _20, All
    StringReplace, str, str, -0D, _21, All
    StringReplace, str, str, -7D, _22, All
    StringReplace, str, str, -10, _23, All
    StringReplace, str, str, -11, _24, All
    StringReplace, str, str, -12, _25, All
    StringReplace, str, str, -13, _26, All
    StringReplace, str, str, -14, _27, All
    StringReplace, str, str, -15, _28, All
    StringReplace, str, str, -16, _29, All
    StringReplace, str, str, -17, _30, All
    StringReplace, str, str, -18, _31, All
    StringReplace, str, str, -19, _32, All
    StringReplace, str, str, -1A, _33, All
    StringReplace, str, str, -1B, _34, All
    StringReplace, str, str, -1E, _35, All
    StringReplace, str, str, -1F, _36, All
    StringReplace, str, str, -20, _37, All
    StringReplace, str, str, -21, _38, All
    StringReplace, str, str, -22, _39, All
    StringReplace, str, str, -23, _40, All
    StringReplace, str, str, -24, _41, All
    StringReplace, str, str, -25, _42, All
    StringReplace, str, str, -26, _43, All
    StringReplace, str, str, -27, _44, All
    StringReplace, str, str, -28, _45, All
    StringReplace, str, str, -2B, _46, All
    StringReplace, str, str, -2C, _47, All
    StringReplace, str, str, -2D, _48, All
    StringReplace, str, str, -2E, _49, All
    StringReplace, str, str, -2F, _50, All
    StringReplace, str, str, -30, _51, All
    StringReplace, str, str, -31, _52, All
    StringReplace, str, str, -32, _53, All
    StringReplace, str, str, -33, _54, All
    StringReplace, str, str, -34, _55, All
    StringReplace, str, str, -35, _56, All
    StringReplace, str, str, -73, _57, All
    StringReplace, str, str, -muhenkan, _58, All
    StringReplace, str, str, -space, _59, All
    StringReplace, str, str, -henkan, _60, All
    StringReplace, str, str, -shift, _61, All
    StringReplace, str, str, -backspace, _62, All
    StringReplace, str, str, -esc, _63, All
    StringReplace, str, str, -zenkaku, _64, All
    StringReplace, str, str, -tab, _65, All
    StringReplace, str, str, -capslock, _66, All
    StringReplace, str, str, -lwin, _67, All
    StringReplace, str, str, -rwin, _68, All
    StringReplace, str, str, -kana, _69, All
    StringReplace, str, str, -apps, _70, All
    StringReplace, str, str, -lalt, _71, All
    StringReplace, str, str, -ralt, _72, All


    ;; 数字の前の _ を取り除く
    ;; たとえば、_15 を 15 とする
    StringReplace, str, str, _, , All
    return str
}
