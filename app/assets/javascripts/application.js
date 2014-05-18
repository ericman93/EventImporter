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

function get_partial_data(url, content_to){
    $.ajax({
        url: url,
        type: "post",
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        success: function(data){
            $(content_to).html(data)
        },
        error:function(data, res){
            $(content_to).html(data)
            console.log(data)
        }
    });
}