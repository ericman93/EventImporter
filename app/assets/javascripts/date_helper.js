function get_gmt_offset() {
    var current_date = new Date();
    return -current_date.getTimezoneOffset() / 60;
}

function date_to_human(date) {
    return date.format('L') + ' ' + date.format('L');
}

function formatTime(){
	$("span[data-time]").each(function(index, span) {
		var unixTimestamp = $(span).data('time');
		//var format = $(sapn).data('format');
    	var time = new Date(unixTimestamp* 1000);
    	
    	$(span).html(toHourAndMinutesString(time))
    	//span.val(time.getHour())
        // get the value from data-time and format according to data-timezone
        // write the content back into the span tag
    });
}

function getNumberWithLeadingZero(number){
	return ('0' + number).slice(-2);
}

function toHourAndMinutesString(date){
	return getNumberWithLeadingZero(date.getHours()) + ":" + getNumberWithLeadingZero(date.getMinutes())
}
