function get_gmt_offset() {
    var current_date = new Date();
    return -current_date.getTimezoneOffset() / 60;
}

function date_to_human(date) {
    return date.toLocaleTimeString() + ' ' + date.toLocaleDateString();
}
;
