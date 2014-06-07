var current_active = 0;
var current_proposel = 0;

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
        events:  "/events/"+user_mail,
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

function show_request_proposels(request_id){
    set_as_active(request_id);
    var request = requests.filter( function(item){return (item.id==request_id);} );
    build_proposel_list(request[0].request_proposals)
}

function build_proposel_list(proposals){
    $("#request_proposels_list").empty();
    $.each(proposals, function(index, proposal){
        start = new Date(proposal.start_time)
        end = new Date(proposal.end_time)

        var item = '<li id="'+proposal.id+'"><a href="#" onclick="proposal_selected('+proposal.id+","+proposal.request_id+')">'+start.toLocaleString()+" - "+end.toLocaleString()+'</a></li>'
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
      color:'Green',
      start: start_time,
      allDay: false,
      id: proposal_id,
      end: new Date(proposal.end_time)
    };
        
    $('#calendar').fullCalendar( 'removeEvents', current_proposel );
    current_proposel = proposal_id;
    $('#calendar').fullCalendar( 'renderEvent', new_event );

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