jQuery(document).ready(function () {
    $("h1").after('<div class="alert alert-warning" id="TOC"></div>');
    $("div#TOC").prepend('<span class="label label-default">TOC</span>');

    var chapter = 0;
    var section = 0;
    var subsection = 0;
    var numbering = "";
    var value = "";
    var prev_tag = "H2";
    var toc_html = "<ul>";

    $("h2, h3, h4").each(function (i) {
        var current = $(this);
        var tag = current.get(0).tagName;
        var diff_tag = 0;

        if (tag == "H2") {
            chapter++;

            section = 0;
            subsection = 0;
        } else if (tag == "H3") {
            section++;
            subsection = 0;
        } else {
            subsection++;
        }


        numbering = [chapter, section, subsection].filter(function (e) {
            return 0 < e;
        }).join(".") + ". ";

        value = $(this).attr("id");
        if (null == value) {
            value = "title_" + i;
            current.attr("id", value);
        }


        diff_tag = Number(prev_tag.slice(-1)) - Number(tag.slice(-1));


        if (0 == diff_tag) {
            if (!((1 == chapter) && (0 == section))) {
                toc_html += "</li>";
            }
        } else if (0 < diff_tag) {
            toc_html += "</ul></li>";

            if (diff_tag == 2) {
                toc_html += "</ul></li>";
            }
        } else if (diff_tag < 0) {
            toc_html += "<ul>";
        }


	// url の末尾に #id がついているときは、真っ先に削除する
        var url = location.href.replace(/#.+$/,"").split("/").slice(-1) + "#" + value;
        toc_html += "<li><a id='link" + i + "' href='" + url + "'>" + numbering + current.html() + "</a>";

        prev_tag = tag;



	// ページ内の各見出しの直前に番号を挿入する
	$(this).prepend(numbering);
    });


    diff_tag = Number(prev_tag.slice(-1)) - Number("H2".slice(-1));
    if (0 == diff_tag) {
        toc_html += "</li>";
    } else if (0 < diff_tag) {
        toc_html += "</li></ul></li>";

        if (diff_tag == 2) {
            toc_html += "</ul></li>";
        }
    }

    toc_html += "</ul>";

    $("div#TOC").append(toc_html);
    // console.log(toc_html);
});


// caret
jQuery(document).ready(function () {
    // url の末尾に #id がついているときは、真っ先に削除する
    var url = location.href.replace(/#.+$/,"").split("/").slice(-1) + "#TOC";
    $("h2, h3, h4").append(" <a href=\"" + url + "\" style=\"font-size:80%\"><i class=\"icon-caret-up\" /></a>");
});


// remove TOC section
jQuery(document).ready(function () {
    // empty within ul attribute
    if (0 == $("div#TOC ul *").length) {
	$("div#TOC").remove();
    }
});

