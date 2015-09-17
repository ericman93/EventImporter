
var current_request = 0;
var current_proposel = 0;

$(function () {
    getPartialData('requests/user', '#request_data', 'get', show_calendar)   
});

function show_calendar(){
    $('#calendar').html('');
    $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        timezone: "local",
        events:  "/events/"+user_name,
        eventBorderColor: 'black',
        allDaySlot: false,
        loading: function (bool) {
            if (bool) {
                popupLoading();
            } else {
                closeLoading(); 
            }
        },
        eventAfterRender: function(event, element) {
            if(event.id > 0 && event.id.indexOf('prop') >= 0){
                add_button(event.id, 'approve', send_option)
            }

            fixEventsPosition(element);
        },
        defaultView: 'agendaWeek',
    });

    formatTime();
}

function show_request_proposels(request_id){
    set_request_active(request_id);
    var request = requests.filter( function(item){return (item.id==request_id);} );
    build_proposel_list(request[0].request_proposals)
}

function build_proposel_list(proposals){
    $('#calendar').fullCalendar('removeEvents', "prop_"+current_proposel );
    $("#request_proposels_list").empty();
    $.each(proposals, function(index, proposal){
        start = new Date(proposal.start_time)
        end = new Date(proposal.end_time)

        var item = '<li id="proposel_'+proposal.id+'"><a href="#" onclick="proposal_selected('+proposal.id+","+proposal.request_id+')">'+start.toLocaleString()+" - "+end.toLocaleString()+'</a></li>'
        $("#request_proposels_list").append(item)
    });
}

function proposal_selected(proposalId, startTime, endTime){
    start = new Date(startTime)
    end = new Date(endTime)

    $('#calendar').fullCalendar('gotoDate',start)
    var prop_id = "prop_"+proposalId
    var new_event = {
      title:"Proposel",
      allDay: false,
      id: prop_id,
      start: start,
      end: end,
      className: 'option_event ' + prop_id
    };

    setPropoalActive(proposalId);

    $('#calendar').fullCalendar( 'removeEvents', "prop_"+current_proposel );
    current_proposel = proposalId;
    $('#calendar').fullCalendar( 'renderEvent', new_event );

    add_button(prop_id, 'approve', send_option);
}

function getSelectedRequestId(){
    return $('.panel .in').parent('div').data('request-id');
}

function send_option(proposel_id){
    $.when(showYesOrNo('really ?')).then(
        function(){
            send_option_selection(proposel_id).then(function(){
                removeRequest(getSelectedRequestId());
            }, function(message){
                showError(message)
            });       
        }
    );
}

function setPropoalActive(proposelId){
    $('#prop_'+current_proposel).removeClass('active');
    $('#prop_'+proposelId).addClass('active');
}

function deleteRequest(requestId){
    $.ajax({
        type: "DELETE",
        url: "/requests/"+requestId,
        dataType: 'json',
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        }
    })
    .success(function (d) {
        removeRequest(requestId)
    })
    .fail(function (data) {
        showError('error')
    });
}

function removeRequest(request_id){
    if(request_id == undefined){
        request_id = current_request
    }

    $('#request-panel-'+request_id).remove();

    if(request_id == current_request){
        $('#proposel_'+current_proposel).remove();
        $("#request_proposels_list").empty()
        $('#calendar').fullCalendar( 'removeEvents', "prop_"+current_proposel );
    }

    set_request_count()
}

function clear_propsolas(){
    $('.fc-event.option_event').remove()
}