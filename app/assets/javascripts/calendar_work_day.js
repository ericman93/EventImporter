// timeArray - work hours per day
// slotMinutes - how much is every slot in the calendar
var BORDER_SPACE = 11;

function selectWorkTime(timeArray, slotMinutes, minTime, maxTime, showAtHolidays){
    for(var day_index  in timeArray){
        day = timeArray[day_index]

        var startBefore = minTime; // each day start at slot 0 
        var endBefore = day.hours[0].second_of_day
        var height = markDisableTimes(day.day, 0, endBefore, slotMinutes)

        var startBefore = day.hours[1].second_of_day; 
        var endBefore = 3600 * maxTime;
        markDisableTimes(day.day, startBefore, endBefore, slotMinutes, height)
    }
}

function markDisableTimes(dayName, from, to, slotMinutes, previus){
    if(previus == undefined){
        previus = 0
    }

    var slotHeight = $('.fc-slats').find('.fc-widget-content').height();

    height = getDivHeight(to-from, slotHeight, slotMinutes);
    $busy = $('<div>').addClass('busy-time').height(height).css('margin-top', getDivHeight(from, slotHeight, slotMinutes) - previus)
    $('.fc-day.fc-widget-content.fc-'+day.day).append($busy)

    return height;
}

function getDivHeight(secondsOfDay, slotWith, slothMinuts){
    return (BORDER_SPACE+slotWith) * (secondsOfDay/3600) * (60/slothMinuts);
}