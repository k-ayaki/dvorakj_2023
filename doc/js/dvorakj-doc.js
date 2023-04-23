jQuery(document).ready(function () {
    var header = '<div class="navbar navbar-inverse navbar-static-top" id="header"><div class="container"><a class="navbar-brand" href="#">DvorakJ Document</a><ul class="nav navbar-nav"><li><a href="./readme.html">README</a></li><li><a href="./history.html">history</a></li></ul></div></div>';

    var footer = '<div class="navbar navbar-default navbar-bottom" id="footer"><div class="container">';

    // <html lang="ja">
    $("html").attr("lang", "ja");
    $("h1").before(header);

    $("div#postamble").html("");
    $("div#postamble").addClass("container").html('<address><strong>blechmusik</strong><br><i class="icon-envelope icon-large"></i> <a href="mailto:blechmusik@gmail.com">blechmusik@gmail.com</a> / <i class="icon-twitter icon-large"></i><a href="https://www.twitter.com/blechmusik">@blechmusik (twitter)</a><br><a href="http://blechmusik.xii.jp/dvorakj/">blechmusik.xii.jp/DvorakJ</a></address>');


    // 中央部分を .container で囲む
    $("div#postamble").wrapAll(footer + '</div></div>');
    $("div#header").nextUntil("div#footer").wrapAll('<div class="container" id="content"></div>');


    $("h2").addClass("alert alert-success");
    $("h3").addClass("alert alert-info");


});

// table
jQuery(document).ready(function () {
    $("table").addClass("table table-striped table-condensed table-bordered");
});



// table
jQuery(document).ready(function () {
    $("p").each(function(){
	var text = $(this).text();

        if (text.match(/current_version/)) {
	    var title = $("h1").text();
            $("h1").text(title + text.replace(/current_version=/,"(") + "version)");
	    $(this).remove();
        }
    });
});


