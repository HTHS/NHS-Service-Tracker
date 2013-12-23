jQuery ->
	change_hours = (button, data) ->
		button.parents('tr').removeClass().addClass(data.data.row_class)
		button.parents('tr').children('.status-field').html(data.data.status)
		old_text = button.parents('tr').children('.hour-field').text()
		button.parents('tr').children('.hour-field').text(data.data.hours.toString() + old_text.slice(-4))
		$('#total-hours').text(data.data.srv_hours + ' SRV, ' + data.data.led_hours + ' LED')

	$('.btn-div').on('click', '.approve-button.btn-danger', ->
		button = $(this)
		user_id = $('#userid').text()
		event_id = button.data 'event-id'
		type = button.data 'type'
		response = $.ajax(
			'/ajax/main/toggle_event_approval.json'
			data:
				'user_id': user_id
				'event_id': event_id
				'type': type
			success: (data) ->
				button.removeClass('btn-danger').addClass('btn-success').html('Approve')
				change_hours(button, data)
			timeout: 3000
			type: "POST"
			)
		undefined)

	$('.btn-div').on('click', '.approve-button.btn-success', ->
		button = $(this)
		user_id = $('#userid').text()
		event_id = button.data 'event-id'
		type = button.data 'type'
		response = $.ajax(
			'/ajax/main/toggle_event_approval.json'
			data:
				'user_id': user_id
				'event_id': event_id
				'type': type
			success: (data) ->
				button.removeClass('btn-success').addClass('btn-danger').html('Disapprove')
				change_hours(button, data)
			timeout: 3000
			type: "POST"
			)
		undefined)

	undefined