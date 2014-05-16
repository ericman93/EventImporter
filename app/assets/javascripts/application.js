$(function () {
    $.ajax({
        url: "/users/requests_count",
        type: "get",
        success: function(data){
            $('#request_count').html("Requests ("+data+")")
        },
        error:function(data){
            console.log(data)
        }
    });
});

function date_to_human(date) {
    return date.toLocaleTimeString() + ' ' + date.toLocaleDateString();
}

function get_gmt_offset() {
    var current_date = new Date();
    return -current_date.getTimezoneOffset() / 60;
}