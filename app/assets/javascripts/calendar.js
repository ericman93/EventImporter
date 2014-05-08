var options = []
var user_email

function load_event_to_calendar(user_mail, should_load_events) {
    $('#calendar').html('');

    user_email = user_mail;
    var cal = $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        events: should_load_events ? "/events/"+user_mail : [],
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
        selectable: true,
        selectHelper: true,
        select: function(start, end, allDay) {
            add_new_proposal(start, end, allDay);
            cal.fullCalendar('renderEvent',
					{
					    start: start,
					    end: end,
					    allDay: allDay
					},
					true // make the event "stick"
				);
        },
        editable: true,
    });
}

function send_to_server(){
    if(options.length == 0){
        alert('Please select proposals before sending')
        return;
    }

    $.ajax({
        type: "POST",
        url: "/calendarapi/insertTempEvent",
        //contentType: "application/json",
        //dataType: 'json',
        data: {
            proposals: options,
            request_info : { 'mail' : $('#request_mail_input').val(),
                             'name' : $('#request_name_input').val() },
            subject : $('#event_subject_input').val(),
            email: user_email,
            gmt_offset: get_gmt_offset(),
        }
    })
   .success(function (d) {
       //$('#dates tbody').remove();
       clear_form();
       disable_or_unable_form(false);
   })
   .fail(function (data) {
       alert('error');
       console.log(data);
       disable_or_unable_form(false);
   });;
}

function add_new_proposal(start, end, allday){
    proposel = {
        'start_time': start,
        'start_ticks' :start.getTime(),
        'end_time': end,
        'end_ticks': end.getTime(),
        'is_all_day': allday
    }

    add_proposal_to_table(proposel)
    options.push(proposel)
}

function show_temp_events(){
    var div_html = $('#temp_events').html()
    $('#popup_content').html(div_html)

    loadPopup()
}

function add_proposal_to_table(proposel){
    $("#proposal_table tbody").append('<tr><td>' + get_remove_button_td() + 
                                      '</td><td>' + date_to_human(proposel.start_time) + 
                                      '</td><td>' + date_to_human(proposel.end_time) + '</tr>')
}

function get_remove_button_td() {
    return '<button type="submit" class="btn btn-danger" onclick="remove_date(this)">X</button>'
}