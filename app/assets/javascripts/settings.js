var callback = {
'work_hours': setUpTimePickers,
'web_mails' : undefined
}

$(function () {
    $('.setting_option').click(function(){
    	get_partial_data("settings/"+this.id, '#option_data', 'get', callback[this.id])
    })   

    get_partial_data("settings/work_hours", '#option_data', 'get', setUpTimePickers)
});