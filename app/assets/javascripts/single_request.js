var current_proposel = 0;

$(function () {
    get_partial_data('user/'+request_id, '#request_data', 'get', show_calendar)   
});

function show_calendar(){
    $('#calendar').html('');
    $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        events:  "/events/"+user_name,
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

function proposal_selected(proposal_id){
    var proposal = proposels.filter( function(item){return (item.id==proposal_id);} );
    proposal = proposal[0]
    var start_time = new Date(proposal.start_time)

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

function set_propoal_active(proposel_id){
    $('#proposel_'+current_proposel).removeClass('active');
    $('#proposel_'+proposel_id).addClass('active');
}