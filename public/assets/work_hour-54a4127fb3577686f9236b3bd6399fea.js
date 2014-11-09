var days = [
    'sun','mon','tue','wed','thu','fri','sat'
]

function setUpTimePickers(work_days){
	$('.hour_picker').timepicker({
		showMeridian: false,
		defaultTime: '00:00'
	});

	$.each($('.hour_picker'), function(i, picker){
		var seconds = $(picker).data('seconds');

		$(picker).timepicker('setTime', from_seconds_to_view(parseInt(seconds)))
	})

	$('.vication').change(function(){
		day = $(this).data('day')
		on_checkbox_chnage(day, $(this).prop("checked"))
	});

	$("#gmt_offset").val(get_gmt_offset())
}

function on_checkbox_chnage(day, is_checked){
	if(is_checked){
		$('#timepicker-start-'+day).timepicker('setTime', '00:00');
		$('#timepicker-end-'+day).timepicker('setTime', '00:00');
	}	

	$('#timepicker-start-'+day).prop('disabled', is_checked);
	$('#timepicker-end-'+day).prop('disabled', is_checked);
}

function from_seconds_to_view(seconds){
	seconds += get_gmt_offset() * 3600;
	hour = seconds / 3600.0;
	min = (hour % 1) * 60;
	return Math.floor(hour)+":"+min;
}
;
