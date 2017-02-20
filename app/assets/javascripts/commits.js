var categories = {};

function getListOfSelectedCategories() {
    return $.map($('#multiselect_commits').find(':selected'), function (obj) {
        return obj.value;
    })
}

function highlight_text(keywords) {
    if (typeof keywords !== 'undefined' && keywords.length > 0) {
        $('[id^=commit_message_id]').highlight(keywords);
    }
}

function getListOfFilterWordsAndHighlight(listOfCategories) {
    console.log(listOfCategories);
    $.ajax({
        type: "GET",
        dataType: "json",
        url: "/highlight_keywords.json",
        data: {'categories': listOfCategories},
        success: function (response) {
            console.log(response);
            categories['categories'] = response.categories;
            categories['keywords'] = response.keywords;
            highlight_text(categories['keywords']);
            enableHighlighting();
        },
        error: function (response, status, error) {
            window.alert("If you think there's a real problem, " +
                "then go ahead and complain about the incompetence of the " +
                "complete idiot who designed this piece of garbage loudly to yourself. " +
                "Sum ting wong:\n " + status +  error + response.responseText +
                "This is payback for your shitty error messages, Zack.");
        }
    });
}

function disableHighlighting() {
    var mark_hoverable = $('mark.hoverable');
    mark_hoverable.css('background', 'none');
    console.log("Keywords should not be highlighted now.")
}

function enableHighlighting() {
    var mark_hoverable = $('mark.hoverable');
    mark_hoverable.css('background', 'lemonchiffon');
    console.log("Keywords should be highlighted now.")
}

jQuery.changeHighlighting = function () {
    if ($('#HighlightToggle').is(':checked')) {
        highlight_text(categories['keywords']);
        enableHighlighting();
    } else {
        disableHighlighting();
    }
};

function refreshWithSelectedCategories() {
    var url_params = new Set;

    $('#multiselect_commits').find(':selected').each(function (i, selected) {
        var selected_item = $(selected);
        url_params.add(selected_item.val())
    });
    var categories_array = Array.from(url_params);
    console.log('Array of new url_params: ' + categories_array);

    if (categories_array.length) {
        url_params['categories'] = categories_array;
    } else {
        url_params = {};
    }

    location.search = $.param(url_params);
}

$(document).ready($.changeHighlighting);
$(document).on('page:load', $.changeHighlighting);
