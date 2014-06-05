var days = [
    'sun','mon','tue','wed','thu','fri','sat'
]

$(function () {
	$.each(days, function(index, day){
		set_up_timepicker('timepicker-end-'+day);
		set_up_timepicker('timepicker-start-'+day);

		$('#vication_'+day).change(function(){
			on_checkbox_chnage(day, $(this).prop("checked"))
		});
	});
});

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
		showMeridian: false
	});
}

function send_to_server(){
	var data = {
		work_days: get_data_as_json()
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
        console.log(data)
    })
    .done(function()
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
			short_day_name: day,
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
