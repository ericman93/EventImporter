var options = []
var user_email

function load_event_to_calendar(user_mail, should_load_events, is_self_user) {
    $('#calendar').html('');

    user_email = user_mail;
    var slot_min = 30;

    var time_day = get_work_hours(user_mail)

    var cal = $('#calendar').fullCalendar({
        //theme: true,
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        //minTime: 5,
        firstHour: 9,
        hiddenDays: get_holidays(time_day),
        slotMinutes: slot_min,
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
        eventBorderColor: 'black',
        select: function(start, end, allDay) {
            var temp_id = "temp_" + options.length;
            add_new_proposal(start, end, allDay, temp_id); 
            cal.fullCalendar('renderEvent',
					{
                        id: temp_id, // I'm addind the poposel in the add_new_proposal function , so the array size increase by 1 
					    start: start,
					    end: end,
					    allDay: allDay,
                        title: "Option",
                        requested: true,
                        className: 'proposel_event'
					},
					!is_self_user // make the event "stick"
				);
        },
        eventRender: function(event, element) {
              element.bind('dblclick', function() {
                //if(event.requested){
                //    $('#calendar').fullCalendar( 'removeEvents', event.id );
                //}
              });
           },
        editable: !is_self_user,
    });

    selectWorkTime(time_day, slot_min, 0, 24, true)
}

function get_work_hours(user_mail){
    time_day = []
    $.ajax({url:"/user/"+user_mail+"/work_day?gmt="+get_gmt_offset(),
            async: false,
            success: function(data){
                time_day = data
            }
        })

    return time_day
}

function get_holidays(work_days){
    var holidays = $.map(work_days, function(day, key){
        if (day.hours[0] == 0 && day.hours[1] == 0){
            return key
        }
    })

    return holidays
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
        url: "/requests/insert_proposels",
        //contentType: "application/json",
        dataType: 'json',
        data: data,
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        }
    })
    .success(function (d) {
        //$('#dates tbody').remove();
        $.each(options, function(index,item){
            $('#calendar').fullCalendar('removeEvents', item.temp_id );
        });
        options = []
        $("#proposal_table tbody").empty();
        
        $('#result_alert').removeClass()
        $('#result_alert').addClass('alert alert-success')
        $('#result_alert').html('Request was sent successfuly ;)')

        change_request_input_disable(false)  
    })
    .fail(function (data) {
        var error_text = ""
        switch(data.status){
            case 400:
                error_text = data.responseText
                break;
            case 500:
                error_text = "Something went wrong :("
                break;
            default:
                error_text = 'An error as occurred :('
        }

        $('#result_alert').removeClass()    
        $('#result_alert').addClass('alert alert-danger')
        $('#result_alert').html(error_text)
        console.log(data);

        change_request_input_disable(false)  
    })
}

function add_new_proposal(start, end, allday, temp_id){
    proposel = {
        'start_time': start,
        'start_ticks' :start.getTime(),
        'end_time': end,
        'end_ticks': end.getTime(),
        'is_all_day': allday,
        'temp_id': temp_id
    }

    add_proposal_to_table(proposel, options.length)
    options.push(proposel)
}

/*function show_temp_events(){
    if(options.length == 0){
        alert('Please select proposals before sending')
        return;
    }

    $("#proposal_table tbody").html('')
    $.each(options, function(i, option){
        add_proposal_to_table(option, i)
    })

    var div_html = $('#temp_events').html()
    $('#popup_content').html(div_html)

    loadPopup()
}*/

function add_proposal_to_table(proposel){
    $("#proposal_table tbody").append('<tr id="remove_prop_'+proposel.temp_id+'"><td>' + get_remove_button_td(proposel.temp_id) + 
                                      '</td><td>' + date_to_human(proposel.start_time) + 
                                      '</td><td>' + date_to_human(proposel.end_time) + '</tr>')
}

function get_remove_button_td(proposel_id) {
    return '<button type="button" class="btn btn-danger remove-prop-btn" onclick="remove_date('+"'"+proposel_id+"'"+')"> <span class="glyphicon glyphicon-remove"/></button>'
}

function remove_date(proposel_id) {
    // remove from grid
    $("#remove_prop_"+proposel_id).fadeOut(300, function () {
        $(this).remove();
    });

    // remove from options array
    var to_delete = options.filter( function(item){return (item.temp_id == proposel_id);} );
    index = $(options).index(to_delete[0])
    options.splice(index,1);

    // remove from calendar
    $('#calendar').fullCalendar('removeEvents', proposel_id );
}

function change_request_input_disable(disable){
    $("#event_subject_input").prop('disabled', disable);
    $("#event_location_input").prop('disabled', disable);
    $("#request_mail_input").prop('disabled', disable);
    $("#request_name_input").prop('disabled', disable);
    $("#send_request_btn").prop('disabled', disable);
    $(".remove-prop-btn").prop('disabled', disable);
}
