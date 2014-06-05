// timeArray - work hours per day
// slotMinutes - how much is every slot in the calendar
function selectWorkTime(timeArray, slotMinutes, minTime, maxTime, showAtHolidays){
    // each day in the calendar is split to sots
    // here I check witch slots i need to marks as the not working slot

    // When I'm setting a work day there are 2 times that user is disable (morning and evening) :
    //      0am to the start of the work day
    //      form the end day to next day 0am
    // so i want to marks thos 2 time 

    for(var day_index in timeArray){
        day = timeArray[day_index]

        var startBefore = 0; // each day start at slot 0 
        var endBefore = day['hours'][0] / (60 * slotMinutes) - (minTime * 60) / slotMinutes; // until witch slot the user is disabled in the morning
        var startAfter = day['hours'][1] / (60 * slotMinutes) - (minTime * 60) / slotMinutes; // from which slot the user is disable in the evening
        var endAfter = (maxTime - minTime) * 60 / slotMinutes - 1; // the end of day ( calcuated how much slots there are )

        if(startBefore > endBefore) endBefore = startBefore;
        if(startAfter > endAfter) startAfter = endAfter;
        try{
            markDisableTimes(endBefore, startAfter, endAfter, day['day'], 'fc-work-time')
        }
        catch(e){
            continue;
        }
    }
}

function markDisableTimes(startWorkRowNo, endWorkRowNo, endCalendarRowNo , dayName, cellClass){
    //var width = $('.fc-content').find('.fc-view-agendaWeek').find('.fc-'+dayName+':last').width();

    // For some reason the saterday when I try to get saterday's slot width it is return a smaller then everyone
    // allthow he looks the same .
    // So if I'm caleming that all slots are with the same width , I'm taking the with of sunday 
    var width = $('.fc-content').find('.fc-view-agendaWeek').find('.fc-sun:last').width();
    var marging = (width * day_to_index(dayName));
    var height = $('.fc-slot0').height();

    var disableSartHeight = (startWorkRowNo * height) + startWorkRowNo;
    add_disable_time(disableSartHeight, width, marging, 0, cellClass,height)

    var disableEveningSlotCount = endCalendarRowNo - endWorkRowNo
    var disableStartHeight = (disableEveningSlotCount * height) + disableEveningSlotCount;
    add_disable_time(disableStartHeight, width, marging, endWorkRowNo, cellClass,height)
}

function add_disable_time(height, width, marging, slot_num, disable_class, slot_height){
    slot_num = Math.round(slot_num)
    var div = "<div class='"+disable_class+"' style='height:"+height+"px; width:"+width+"px; margin-left:"+marging+"px; margin-top:-"+slot_height+"px;'></div>"
    var full_div = $('.fc-slot'+slot_num+' .fc-widget-content').html() + div;
    $('.fc-slot'+slot_num+' .fc-widget-content').html(full_div)
}

function day_to_index(day_name){
    var index = 0;
    switch(day_name){
        case 'sun': index=0; break;
        case 'mon': index=1; break;
        case 'tue': index=2; break;
        case 'wed': index=3; break;
        case 'thu': index=4; break;
        case 'fri': index=5; break;
        case 'sat': index=6; break;
    }

    return index;
}