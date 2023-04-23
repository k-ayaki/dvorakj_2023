;;; How to detect Normal or Large font size settings (DPI)
;;; http://www.autohotkey.com/forum/post-198727.html&sid=5f964c930528a1331705e692e5bcf639#198727
;;; Posted: Mon May 26, 2008 6:31 pm


GetDPI() {
/*
    RegRead, DPI_value, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI
    return % (errorlevel = 1) ? 96
            : DPI_value
*/

    hDC := DllCall("GetDC", Int, 0)
    dpi := DllCall("GetDeviceCaps", UInt, hDC , UInt, 88)
    DllCall("ReleaseDC",Int, 0, UInt, hDC)

    return dpi ? dpi : 0
}
