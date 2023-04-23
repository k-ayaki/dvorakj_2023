remove_comment_out(target = "") {
	;; /* */ を取り除く
	pattern := "sS)/\*((?R)|.)*?\*/"
	return RegExReplace(target, pattern)
}
