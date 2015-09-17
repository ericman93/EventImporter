var callback = {
	'work_hours': setUpTimePickers,
	'web_mails' : undefined
}

$(function () {
    $('.setting_option').click(function(){
    	getPartialData("settings/"+this.id, '#option_data', 'get', callback[this.id])
    })   

    getPartialData("settings/work_hours", '#option_data', 'get', setUpTimePickers)
});
