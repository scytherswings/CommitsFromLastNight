$(function () {
    let multiselect = $("#multiselect_commits");
    if (multiselect.length) {
        $(multiselect).change(function () {
        let url_params = [];
        $(':selected').each(function (i, selected) {
            let selected_item = $(selected);
            console.log('Selected item: ' + selected_item.attr('id'));
            url_params.push(selected_item.attr('id'))
        });
        console.log(url_params);
        let queryParameters = {};
        // let queryParameters = {}, queryString = location.search.substring(1),
        //     re = /([^&=]+)=([^&]*)/g, m;
        //
        // while (m = re.exec(queryString)) {
        //     queryParameters[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
        // }
        queryParameters['categories'] = url_params;
        // location.search = $.param(queryParameters); // Causes page to reload
        });
    }
});


