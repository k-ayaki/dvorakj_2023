#If
;;; ============================================================================
;;; ---------------- テンキー
;;; ============================================================================

;;; 独自のテンキーの機能を使用するとき
#If ( is_User_Ten_Key )

sc135::
sc037::
sc04A::
sc04E::
sc11C::
sc047::
sc048::
sc049::
sc04B::
sc04C::
sc04D::
sc04F::
sc050::
sc051::
sc052::
sc053::

    ;; Num Lock が有効のとき
    if ( GetKeyState("NumLock", "T") ) {
        send( outputChar(Tenkey_results_of_KCmb["_NumLock_" . A_ThisHotkey]) )
	}
    else
	{
        send( outputChar(Tenkey_results_of_KCmb["_" . A_ThisHotkey]) )
	}

return
