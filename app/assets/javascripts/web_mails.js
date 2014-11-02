function testConnection(btn){
	var info = {
		user_name: $('#user_name').val(),
		password: $('#password').val(),
		server: $('#server').val()
	}

	var $jBtn = $(btn)
	
	$jBtn.attr("disabled", true);
	$jBtn.removeClass('btn-danger').removeClass('btn-success')

	$.post("/exchange/test", {echange_info: info}, function(data) {
		$jBtn.removeClass('btn-danger').addClass('btn-success')
	})
    .fail(function() {
    	$jBtn.removeClass('btn-success').addClass('btn-danger')
    })
    .always(function(){
		$jBtn.attr("disabled", false);
    })
}
