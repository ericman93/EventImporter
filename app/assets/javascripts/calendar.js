function load_event_to_calendar(user_mail, should_load_events) {
    $('#calendar').html('');

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
            add_new_date(start, end, allDay,'@Model.UserEmail');
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