extends State

func enter(_msg := {}) -> void:
	owner.input_event.connect(_handle_input_event)



func _handle_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		state_machine.transition_to("BeingDragged")
	

func exit() -> void:
	owner.input_event.disconnect(_handle_input_event)
	pass
