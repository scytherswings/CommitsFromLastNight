// function highlight_words() {
//     $('[id^=commit_message_id]').highlight(['fuck', 'suck', 'damn', 'shit']);
//     console.log("Words have been highlighted.");
// }
// $(document).ready(highlight_words);
// $(document).on('page:load', highlight_words);
//

function refreshWithSelectedCategories() {
    let url_params = new Set;

    $('#multiselect_commits').find(':selected').each(function (i, selected) {
        let selected_item = $(selected);
        url_params.add(selected_item.val())
    });
    let categories_array = Array.from(url_params);
    console.log('Array of new url_params: ' + categories_array);

    if (categories_array.length) {
        url_params['categories'] = categories_array;
    } else {
        url_params = {};
    }

    location.search = $.param(url_params);
}

jQuery.toggleHighlighting = function () {
    changeHighlighting($('#HighlightToggle'))
};

jQuery.runToggleOnChange = function runToggleOnChange() {
    $('#HighlightToggle').change(function () {
        changeHighlighting($('#HighlightToggle'));
    })
};

function changeHighlighting(highlight_toggle) {
    if (highlight_toggle.is(':checked')) {
        enableHighlighting();
    } else {
        disableHighlighting();
    }
}

function enableHighlighting() {
    $('mark.hoverable').css('background', 'lemonchiffon');
    console.log("Keywords should be highlighted now.")
}

function disableHighlighting() {
    $('mark.hoverable').css('background', 'none');
    console.log("Keywords should not be highlighted now.")
}

$(document).ready($.toggleHighlighting);
$(document).on('page:load', $.toggleHighlighting);
