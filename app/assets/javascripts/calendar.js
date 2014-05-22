var options = []
var user_email

function load_event_to_calendar(user_mail, should_load_events, is_self_user) {
    $('#calendar').html('');

    user_email = user_mail;
    var cal = $('#calendar').fullCalendar({
        //theme: true,
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
        selectable: !is_self_user,
        selectHelper: !is_self_user,
        select: function(start, end, allDay) {
            add_new_proposal(start, end, allDay);
            cal.fullCalendar('renderEvent',
					{
					    start: start,
					    end: end,
					    allDay: allDay,
                        title: "Option",
                        requested: true,
					},
					!is_self_user // make the event "stick"
				);
        },
        eventRender: function(event, element) {
              element.bind('dblclick', function() {
                $('#calendar').fullCalendar('removeEvents', function(e) {
                    return should_be_deleted(event, e)
                })
              });
           },
        editable: !is_self_user,
    });
}

function send_to_server(){
    if(options.length == 0){
        alert('Please select proposals before sending')
        return;
    }

    change_request_input_disable(true)
    data = {
        proposals: options,
        request_info : { 'mail' : $('#request_mail_input').val(),
                         'name' : $('#request_name_input').val() },
        event_metadata : {'subject' : $('#event_subject_input').val(),
                           'location' : $('#event_location_input').val()},
        email: user_email,
        gmt_offset: get_gmt_offset()
    }

    $.ajax({
        type: "POST",
        url: "/calendarapi/insertTempEvent",
        //contentType: "application/json",
        dataType: 'json',
        data: data
    })
   .success(function (d) {
       //$('#dates tbody').remove();
       options = []
       $('#popup_content').html("<h1>Reuqest has sent successfuly ;)</h1>")
       change_request_input_disable(false)
   })
   .fail(function (data) {
       alert('error');
       console.log(data);
       change_request_input_disable(false)
   });
}

function should_be_deleted(event_to_remove, calendar_event){
    if(event_to_remove.requested && event_to_remove.start == calendar_event.start && event_to_remove.end == calendar_event.end){

        item = $.each(options, function(i, option) {
          if(option != undefined && option.start_time == event_to_remove.start && option.end_time == event_to_remove.end){
            options.splice(i,1);
            return true
          }
        });

        return true
    }

    return false;
}

function add_new_proposal(start, end, allday){
    proposel = {
        'start_time': start,
        'start_ticks' :start.getTime(),
        'end_time': end,
        'end_ticks': end.getTime(),
        'is_all_day': allday
    }

    options.push(proposel)
    console.log(options)
}

function show_temp_events(){
    if(options.length == 0){
        alert('Please select proposals before sending')
        return;
    }

    $("#proposal_table tbody").html('')
    $.each(options, function(i, option){
        add_proposal_to_table(option)
    })

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
    return '<button type="submit" class="btn btn-danger remove-prop-btn" onclick="remove_date(this)">X</button>'
}

function change_request_input_disable(disable){
    $("#event_subject_input").prop('disabled', disable);
    $("#event_location_input").prop('disabled', disable);
    $("#request_mail_input").prop('disabled', disable);
    $("#request_name_input").prop('disabled', disable);
    $("#send_request_btn").prop('disabled', disable);
    $(".remove-prop-btn").prop('disabled', disable);
}