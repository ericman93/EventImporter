var event_colors = ['green', 'purple', 'orange', 'turquoise']

function add_button(event_id, image_name, callback){
    var close_btn = $("<div/>",{
        class: image_name+'-event',
    })
    .click(function(){
    	callback(event_id)
    })

    $('.fc-event.'+event_id).prepend(close_btn)
}

function send_option_selection(option_name){
    popupLoading();

    option_id = option_name.substring(5) // remove the 'prop-' in the begging of the name
    $.ajax({
        type: "POST",
        url: "/requests/"+option_id,
        dataType: 'json',
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        }
    })
    .success(function (d) {
        closeloading();
        remove_proposels()
        $('.fc-event.'+option_name+' .approve-event').remove()
    })
    .fail(function (data) {
        closeloading();
        alert('error')
        console.log(data)
    });
}