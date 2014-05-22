var current_active = 0;

$(function () {
    get_partial_data('requests_partial', '#request_data', show_calendar)   
});

function show_calendar(){
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
                //loading();
            } else {
                disablePopup(); 
                //closeloading();
            }
        },
        defaultView: 'agendaWeek',
    });
}

function set_as_active(request_id){
    $('#request_'+current_active).removeClass('active');
    $('#request_'+request_id).addClass('active');

    current_active = request_id;
}