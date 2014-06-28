var days = [
    'sun','mon','tue','wed','thu','fri','sat'
]

function set_up(work_days){
	// default initalize
	$.each(days, function(index,day){
		set_up_timepicker('timepicker-end-'+day);
		set_up_timepicker('timepicker-start-'+day);

		$('#vication_'+day).change(function(){
			on_checkbox_chnage(day, $(this).prop("checked"))
		});
	});

	// set user time
	$.each(work_days, function(index, day){
		$('#timepicker-start-'+day['day']).timepicker('setTime', from_seconds_to_view(day['hours'][0]));
		$('#timepicker-end-'+day['day']).timepicker('setTime', from_seconds_to_view(day['hours'][1]));
	});
}

function on_checkbox_chnage(day, is_checked){
	if(is_checked){
		$('#timepicker-start-'+day).timepicker('setTime', '00:00');
		$('#timepicker-end-'+day).timepicker('setTime', '00:00');
	}	

	$('#timepicker-start-'+day).prop('disabled', is_checked);
	$('#timepicker-end-'+day).prop('disabled', is_checked);
}

function set_up_timepicker(timepicker_id){
	$('#'+timepicker_id).timepicker({
		showMeridian: false,
		defaultTime: '00:00'
	});
}

function send_to_server(){
	var data = {
		work_days: get_data_as_json(),
		gmt: get_gmt_offset()
	}

	$.ajax({
        type: "POST",
        url: "/user/save_work_days",
        //contentType: "application/json",
        dataType: 'json',
        data: data,
        beforeSend: function(xhr) {
        	$('#save_work_days').prop('disabled', true);
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        }
    })
    .success(function (d) {
        alert('success')
    })
    .fail(function (data) {
        alert('error');
    })
    .always(function()
    {
		$('#save_work_days').prop('disabled', false);
    })
}

function get_data_as_json(){
	var work_days = []
	$.each(days, function(index, day){
		var work_day = {
			start_at : get_seconds_from_midnight('timepicker-start-'+day),
			end_at : get_seconds_from_midnight('timepicker-end-'+day),
			day_index: index,
			day: $('#'+day).html()
		}

		work_days.push(work_day)
	});

	return work_days
}

function get_seconds_from_midnight(timepicker_id){
	var time = $('#'+timepicker_id).data("timepicker")
	return (time.hour * 3600) + (time.minute * 60)
}

function from_seconds_to_view(seconds){
	hour = seconds / 3600.0
	min = (hour % 1) * 60
	return Math.floor(hour)+":"+min
}
