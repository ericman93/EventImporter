var current_active = 0;

$(function () {
    get_partial_data('requests_partial', '#request_data', show_calendar)   
});

function show_calendar(){
    $('#calendar').html('');
    $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        loading: function (bool) {
            if (bool) {
                loadPopup();
            } else {
                disablePopup(); 
            }
        },
        defaultView: 'agendaWeek',
    });
}

function load_requests(request_id){
    set_as_active(request_id);
    
    $('#calendar').html('');
    var cal = $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        events: "/requests/"+request_id,
        loading: function (bool) {
            if (bool) {
                loadPopup();
            } else {
                disablePopup(); 
            }
        },
        eventRender: function(event, element) {
              element.bind('dblclick', function() {
                send_option_selection(event.id)
              });
           },
        defaultView: 'agendaWeek',
    });
}

function set_as_active(request_id){
    $('#request_'+current_active).removeClass('active');
    $('#request_'+request_id).addClass('active');

    current_active = request_id;
}

function send_option_selection(option_id){
    $.ajax({
        type: "POST",
        url: "/calendarapi/select_proposal",
        dataType: 'json',
        data: {'proposal_id': option_id},
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        }
    })
    .success(function (d) {
        remove_request()
    })
    .fail(function (data) {
        alert('error')
    });
}

function remove_request(){
    $('#request_'+current_active).remove();
    set_request_count()
    show_calendar()
}