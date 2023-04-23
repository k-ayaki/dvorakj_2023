
;;; Zip/Unzip using native ZipFolder Feature in XP
;;; http://www.autohotkey.com/forum/post-335359.html#335359


;;; COM Standard Library
;;; http://www.autohotkey.com/forum/viewtopic.php?p=330998#330998
Unz(sZip, sUnz) {
    psh := ComObjCreate("Shell.Application")
    psh.Namespace( sUnz ).CopyHere( psh.Namespace( sZip ).items, 4|16 )
    return sZip
}

unzip_and_remove_file(sZip, sUnz) {
    FileDelete, % Unz(sZip, sUnz)
    return sUnz
}
