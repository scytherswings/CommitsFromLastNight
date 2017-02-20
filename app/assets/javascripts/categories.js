var getQueryStringAsObject, getQueryStringKey;

getQueryStringKey = function (key) {
    return getQueryStringAsObject()[key];
};

getQueryStringAsObject = function () {
    var b, cv, d, e, k, ma, q, r, s, sk, v;
    b = void 0;
    cv = void 0;
    e = void 0;
    k = void 0;
    ma = void 0;
    sk = void 0;
    v = void 0;
    r = {};
    d = function (v) {
        return decodeURIComponent(v).replace(/\+/g, ' ');
    };
    q = window.location.search;
    s = /([^&;=]+)=?([^&;]*)/g;
    ma = function (v) {
        if (typeof v !== 'object') {
            cv = v;
            v = {};
            v.length = 0;
            if (cv) {
                Array.prototype.push.call(v, cv);
            }
        }
        return v;
    };
    while (e = s.exec(q)) {
        b = e[1].indexOf('[');
        v = d(e[2]);
        if (b < 0) {
            k = d(e[1]);
            if (r[k]) {
                r[k] = ma(r[k]);
                Array.prototype.push.call(r[k], v);
            } else {
                r[k] = v;
            }
        } else {
            k = d(e[1].slice(0, b));
            sk = d(e[1].slice(b + 1, e[1].indexOf(']', b)));
            r[k] = ma(r[k]);
            if (sk) {
                r[k][sk] = v;
            } else {
                Array.prototype.push.call(r[k], v);
            }
        }
    }
    return r;
};

$(function () {
    var categories_array_from_url, multiselect, url_param_categories;
    multiselect = $('#multiselect_commits');
    if (multiselect.length) {
        var query_params_output = query.parse();

        if (!query_params_output) {
            url_param_categories = null;
        } else {
            url_param_categories = query_params_output['categories[]'];
        }

        if (!url_param_categories) {
            url_param_categories = [];
            console.log('URL params were empty. Checking for selected categories.');
            if (multiselect.find(':selected').length === 0) {
                console.log('No selected categories were found. Setting selected to match default categories');
                multiselect.find('[default=true]').each(function (i, selected) {
                    var selected_item;
                    selected_item = $(selected);
                    console.log('Selecting default category: ' + selected_item.attr('name'));
                    $('#' + selected_item.attr('id')).prop('selected', 'selected');
                });
            }
        }
        categories_array_from_url = jQuery.makeArray(url_param_categories);
        console.log('Categories found from url_params on page load: ' + categories_array_from_url);
        categories_array_from_url.forEach(function (category) {
            $('#category_id_' + category).prop('selected', 'selected');
        });
    }
});

var button_for_select = null;
var parent_of_select = null;

$(function () {
    $('#hamburger').click(function () {
        $('#navbar').css('overflow-y', '');
        if (!parent_of_select) {
            parent_of_select = $('#multiselect_commits').closest('div');
        }
        if (!button_for_select) {
            button_for_select = $('#multiselect_commits').siblings("button[data-id='multiselect_commits']");
        }
        register_multiselect_for_clicks();
    });
});

function register_multiselect_for_clicks() {
    $(parent_of_select).click(function () {
        if ($('#multiselect_commits').parent().hasClass("open")) {
            console.log('Multiselect changing state from open to closed.');
            $('#navbar').css('overflow-y', '')
        } else {
            console.log('Multiselect changing state from closed to open.');
            $('#navbar').css('overflow-y', 'visible')
        }
    })
}


