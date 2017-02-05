var ready;
ready = function() {
    $('[id^=commit_message_id]').highlight(['fuck', 'suck']);
};

$(document).ready(ready);
$(document).on('page:load', ready);
