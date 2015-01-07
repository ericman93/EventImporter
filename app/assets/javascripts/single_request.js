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
                popupLoading();
            } else {
                closeLoading();
                show_all_proposals() 
            }
        },
        eventRender: function(event, element) {
              add_button(event.id, 'approve', approve_option)
           },
        defaultView: 'agendaWeek',
    });
}

function show_all_proposals(){
    $.each(proposels, function(key, proposal){
        var new_event = {
          title:"Proposel",
          start: new Date(proposal.start_time),
          allDay: false,
          id: 'prop-'+proposal.id,
          end: new Date(proposal.end_time),
          className: event_colors[key % event_colors.length] + '-event prop-'+proposal.id
        };

        $('#calendar').fullCalendar('renderEvent', new_event );
    })
}

function approve_option(proposal_id){
    remove_other_options(proposal_id)
    send_option_selection(proposal_id)
}

function remove_other_options(option_name){
    proposal_id = Number(option_name.substring(5))

    var to_remove = proposels.filter( function(item){return (item.id!=proposal_id);} );
    $.each(to_remove, function(key, prop){
        $('#calendar').fullCalendar( 'removeEvents', 'prop-'+prop.id );
    })
}

function proposal_selected(proposal_id){
    var proposal = proposels.filter( function(item){return (item.id==proposal_id);} );
    proposal = proposal[0]

    var start_time = new Date(proposal.start_time)
    $('#calendar').fullCalendar('gotoDate',start_time)

    //set_propoal_active(proposal_id);
}