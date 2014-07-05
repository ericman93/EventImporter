var current_request = 0;
var current_proposel = 0;

$(function () {
    get_partial_data('requests/user', '#request_data', show_calendar, 'get')   
});

function show_calendar(){
    $('#calendar').html('');
    $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        events:  "/events/"+user_mail,
        eventBorderColor: 'black',
        loading: function (bool) {
            if (bool) {
                loadPopup();
            } else {
                disablePopup(); 
            }
        },
        eventRender: function(event, element) {
              element.bind('dblclick', function() {
                // if evevnt.id start with "prop_"
                send_option_selection(event.id)
              });
           },
        defaultView: 'agendaWeek',
    });
}

function show_request_proposels(request_id){
    set_request_active(request_id);
    var request = requests.filter( function(item){return (item.id==request_id);} );
    build_proposel_list(request[0].request_proposals)
}

function build_proposel_list(proposals){
    $('#calendar').fullCalendar( 'removeEvents', "prop_"+current_proposel );
    $("#request_proposels_list").empty();
    $.each(proposals, function(index, proposal){
        start = new Date(proposal.start_time)
        end = new Date(proposal.end_time)

        var item = '<li id="proposel_'+proposal.id+'"><a href="#" onclick="proposal_selected('+proposal.id+","+proposal.request_id+')">'+start.toLocaleString()+" - "+end.toLocaleString()+'</a></li>'
        $("#request_proposels_list").append(item)
    });
}

function proposal_selected(proposal_id, request_id){
    var request = requests.filter( function(item){return (item.id==request_id);} );
    var proposal = request[0].request_proposals.filter( function(item){return (item.id==proposal_id);} );
    proposal = proposal[0]

    start_time = new Date(proposal.start_time)

    $('#calendar').fullCalendar('gotoDate',start_time)
    var new_event = {
      title:"Proposel",
      start: start_time,
      allDay: false,
      id: "prop_"+proposal_id,
      end: new Date(proposal.end_time),
      className: 'option_event'
    };

    set_propoal_active(proposal_id);
    $('#calendar').fullCalendar( 'removeEvents', "prop_"+current_proposel );
    current_proposel = proposal_id;
    $('#calendar').fullCalendar( 'renderEvent', new_event );

}

function set_request_active(request_id){
    $('#request_'+current_request).removeClass('active');
    $('#request_'+request_id).addClass('active');

    current_request = request_id;
}

function set_propoal_active(proposel_id){
    $('#proposel_'+current_proposel).removeClass('active');
    $('#proposel_'+proposel_id).addClass('active');
}

function delete_request(id){
    $.ajax({
        type: "DELETE",
        url: "/requests/"+id,
        dataType: 'json',
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        }
    })
    .success(function (d) {
        remove_request(id)
    })
    .fail(function (data) {
        alert('error')
    });
}

function send_option_selection(option_name){
    option_id = option_name.substring(5) // remove the 'prop_' in the begging of the name
    $.ajax({
        type: "POST",
        url: "/requests/"+option_id,
        dataType: 'json',
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        }
    })
    .success(function (d) {
        remove_request()
    })
    .fail(function (data) {
        alert('error')
        console.log(data)
    });
}

function remove_request(request_id){
    if(request_id == undefined){
        request_id = current_request
    }

    $('#request_'+request_id).remove();
    $('#delete_request_'+request_id).remove();

    if(request_id == current_request){
        $('#proposel_'+current_proposel).remove();
        $("#request_proposels_list").empty()
        $('#calendar').fullCalendar( 'removeEvents', "prop_"+current_proposel );
    }

    set_request_count()
}