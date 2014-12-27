function addService(){
	var servicesCount = $('#services tbody tr').length;
	// i dont increment , because the index starts from 0

	var $removeButton = $('<button/>', {
		class: 'btn btn-danger remove-btn',
		html: 'X',
		type: 'button',
		click: removeService
	})

	var $serviceName = $('<input/>',{
		id: 'user_services_attributes_'+servicesCount+'_name',
		name: 'user[services_attributes]['+servicesCount+'][name]',
		required: 'required',
		class: 'form-control',
	})
	var $serviceDuration = $('<input/>',{
		id: 'user_services_attributes_'+servicesCount+'_time_in_minutes',
		name: 'user[services_attributes]['+servicesCount+'][time_in_minutes]',
		type: 'number',
		required: 'required',
		class: 'form-control',
	})

	var $service = $('<tr/>')
	$service.append($('<td/>').append($removeButton))
	$service.append($('<td/>').append($serviceName))
	$service.append($('<td/>').append($serviceDuration))

	$('#services tbody').append($service)
}

function removeService(event){
	$(event.currentTarget).closest('tr').next().remove();
	$(event.currentTarget).closest('tr').remove();
}