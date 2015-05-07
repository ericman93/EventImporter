var options = []
var user_email
var request_info_data = {};

$(document).ready(function() {
    $(window).resize(function() {
        $('#calendar').fullCalendar('option', 'height', getCalendarHeight());
    });
});


function load_event_to_calendar(user_name, is_auto_approval, should_load_events, selectable, namebale, has_services) {
    $('#calendar').html('');

    user_email = user_name;
    var slot_min = 30;

    var time_day = getWorkHours(user_name)

    var cal = $('#calendar').fullCalendar({
        //theme: true,
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        //minTime: 5,
        height: getCalendarHeight(),
        firstHour: 9,
        //theme: true,
        allDaySlot: false,
        handleWindowResize: true,
        //aspectRatio: 2,
        hiddenDays: getHolidays(time_day),
        slotMinutes: slot_min,
        events: should_load_events ? "/events/"+user_name : [],
        defaultView: 'agendaWeek',
        selectable: selectable,
        selectHelper: selectable,
        disableResizing: has_services,
        eventBorderColor: 'black',
        dayRender: function (date, cell) {
          console.log('test')
        },
        select: function(start, end, allDay, title) {
            if(!namebale && is_auto_approval && options.length > 0){
                alert('You can select only one proposel')
                cal.fullCalendar('unselect');
                return;
            }

            var temp_id = "temp_" + options.length;

            var title;
            if(namebale){
                title = prompt('Event Title:');
            }
            else{
                title = has_services ? $( "#services option:selected" ).text() : 'Option';
            }

            addNewProposal(start, end, allDay, temp_id, title); 

            if(has_services){
                end = new Date(start);
                end.setMinutes(end.getMinutes() + Number($('#services').val()))
            }

            cal.fullCalendar('renderEvent',
					{
                        id: temp_id, // I'm addind the poposel in the addNewProposal function , so the array size increase by 1 
					    start: start,
					    end: end,
					    allDay: allDay,
                        title: title,
                        is_temp: true,
                        editable: true,
                        // There is no option to edit the html id , so i'm using the class
                        className: (namebale ? 'orange-event ' : 'proposel_event ') + temp_id
					},
					selectable // make the event "stick"
				);

            cal.fullCalendar('unselect');
        },
        loading: function (bool) {
            if (bool) {
                popupLoading();
            } else {
                closeLoading();
                showRequestInfoWindow();
            }
        },
        eventClick: function(event){
            if(!event.is_temp){
                showEvent(event.id)
            }
        },
        eventRender: function(event, element) {
            updateEvent(event);
            add_button(event.id, 'close', removeProposel)
        }
    });

    selectWorkTime(time_day, slot_min, 0, 24, true)

    setEmailInputs();
}

function showRequestUserInfo(){
    // remove old alert
    $('#result_alert').remove();
    loadPopup();
}

function showEvent(event_id){
    window.location = "../events/"+event_id;
}

function getWorkHours(user_name){
    time_day = []
    $.ajax({url:"/user/"+user_name+"/work_day?gmt="+get_gmt_offset(),
            async: false,
            success: function(data){
                time_day = data
            }
        })

    return time_day
}

function getHolidays(work_days){
    var holidays = $.map(work_days, function(day, key){
        if (day.hours[0] == 0 && day.hours[1] == 0){
            return key
        }
    })

    return holidays
}

function sendToServer(){
    if(options.length == 0){
        showError('Please select proposals before sending')
        return;
    }

    popupLoading();
    //changeRequestInputDisable(true)
    data = {
        proposals: options,
        request_info : { 'mail' : request_info_data.mail,
                         'name' : request_info_data.name },
        event_metadata : {'subject' : request_info_data.subject,
                           'location' : request_info_data.location},
        user_name: user_email,
        gmt_offset: get_gmt_offset()
    }

    $.ajax({
        type: "POST",
        url: "/requests/proposels",
        //contentType: "application/json",
        dataType: 'json',
        data: data,
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        }
    })
    .success(function (d) {
        $.each(options, function(index,item){
            $('#calendar').fullCalendar('removeEvents', item.temp_id );
        });
        options = []
        $("#proposal_table tbody").empty();
        
        addAlert('Request was sent successfuly ;)', 'alert-success')
        
        closeLoading();
        //clearRequestedForm();
        //changeRequestInputDisable(false)  
    })
    .fail(function (data) {
        var error_text = ""
        switch(data.status){
            case 400:
                error_text = data.responseText
                break;
            case 500:
                error_text = "Something went wrong"
                break;
            default:
                error_text = 'An error as occurred'
        }

        showError(error_text)
        console.log(data);

        closeLoading();
        //changeRequestInputDisable(false)  
    })
}

function addNewProposal(start, end, allday, temp_id, title){
    proposel = {
        'start_time': start,
        'start_ticks' :start.getTime(),
        'end_time': end,
        'end_ticks': end.getTime(),
        'is_all_day': allday,
        'temp_id': temp_id,
        'title': title
    }

    addProposalToPopup(proposel, options.length)
    options.push(proposel)
}

function updateEvent(event){
    // opdate options array
    $.each(options, function(i, option){
        if(option.temp_id == event.id){
            option.start_time = event.start;
            option.start_ticks = event.start.getTime();
            option.end_time = event.end;
            option.end_ticks = event.end.getTime();

            return;
        }
    })
    //var to_update = options.filter( function(item){return (item.temp_id == event.id);} );
    //to_update.start = event.start
    //to_update.end = event.end

    // update propsal table
    var prop_tr = $('#prop_'+event.id+'>td')
    if(prop_tr.length > 0){
        $(prop_tr[1]).html(date_to_human(event.start))
        $(prop_tr[2]).html(date_to_human(event.end))
    }
}

function addProposalToPopup(proposel){
    $("#proposal_table tbody").append('<tr id="prop_'+proposel.temp_id+'"><td>' + getRemoveButtonTd(proposel.temp_id) + 
                                      '</td><td class="start_time">' + date_to_human(proposel.start_time) + 
                                      '</td><td class="end_time">' + date_to_human(proposel.end_time) + '</tr>')
}

function getRemoveButtonTd(proposel_id) {
    return '<button type="button" class="btn btn-danger remove-prop-btn" onclick="removeProposel('+"'"+proposel_id+"'"+')"> <span class="glyphicon glyphicon-remove"/></button>'
}

function removeProposel(proposel_id) {
    // remove from grid
    $("#prop_"+proposel_id).fadeOut(300, function () {
        $(this).remove();
    });

    // remove from options array
    var to_delete = options.filter( function(item){return (item.temp_id == proposel_id);} );
    index = $(options).index(to_delete[0])
    options.splice(index,1);

    // remove from calendar
    $('#calendar').fullCalendar('removeEvents', proposel_id );
}

function changeRequestInputDisable(disable){
    $("#event_subject_input").prop('disabled', disable);
    $("#event_location_input").prop('disabled', disable);
    $("#request_mail_input").prop('disabled', disable);
    $("#request_name_input").prop('disabled', disable);
    $("#send_request_btn").prop('disabled', disable);
    $("#services").prop('disabled', disable);
    $(".remove-prop-btn").prop('disabled', disable);
}

function addAlert(content, color){
    var $alert = $("<div/>", {
        id: "result_alert",
        class: "alert "+color,
        html: content
    })

    $("#popup_content form").append($alert)
}

function clearRequestedForm(){
    $("#event_subject_input").val('');
    $("#event_location_input").val('');
    $("#request_mail_input").val('');
    $("#request_name_input").val('');
}

function saveLocalEvents(){
    $.ajax({
        type: "PUT",
        url: "/local",
        //contentType: "application/json",
        data: {
            events: options
        },
        beforeSend: function(xhr) {
            popupLoading();
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        }
    })
   .success(function (d) {
        disablePopup();
   })
   .fail(function (data) {
        disablePopup();
   })
}

function showRequestInfoWindow(){
    $('#requestInfoModal').modal('show'); 
}

function saveRequestInfoData(){
    request_info_data = {
        mail : $('#request_mail_input').val(),
        name: $('#request_name_input').val(),
        subject: $('#event_subject_input').val(),
        location: $('#event_location_input').val()
    }

    $('#requestInfoModal').modal('hide');
}

function getCalendarHeight(){
    return ($(window).height() * 0.85);
}