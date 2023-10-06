extends State

func enter(_msg := {}) -> void:
	owner.inventory_area.area_entered.connect(_on_area_2d_area_entered)
	pass


func handle_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var clicked_item = owner.get_clicked_item(event)
		if clicked_item:
			state_machine.transition_to("ItemBeingDragged", {'item' = clicked_item})
		

func exit() -> void:
	owner.inventory_area.area_entered.disconnect(_on_area_2d_area_entered)
	pass

func _on_area_2d_area_entered(area):
	if area.is_in_group('item'):
		state_machine.transition_to("Shown", {'item' = area})
