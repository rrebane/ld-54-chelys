extends State

func enter(_msg := {}) -> void:
	pass


func handle_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var clicked_item = owner.get_clicked_item(event)
		if clicked_item:
			state_machine.transition_to("ItemBeingDragged", {'item' = clicked_item})
			owner.item_placeholder_state_machine.transition_to('Shown', {'item' = clicked_item})
		

func exit() -> void:
	pass
