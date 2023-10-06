extends State

const _cell_size = 50

var _selected_item

func enter(msg := {}) -> void:
	if msg.has('item'):
		_selected_item = msg['item']
		_selected_item.modulate = Color(1, 1, 1, 0.5)
	

func exit(msg = {}) -> void:
	_selected_item.modulate = Color(1, 1, 1, 1)
	_selected_item = null
	
func update(delta: float) -> void:
	
	var new_position = _selected_item.get_global_mouse_position()
	var x_mod = int(new_position.x) % _cell_size # _cell_size / 2
	var y_mod = int(new_position.y) % _cell_size # _cell_size / 2
	
	new_position.x = int(new_position.x) - x_mod
	new_position.y = int(new_position.y) - y_mod
	
	var parent_offset = Vector2(
		int(owner.position.x) % _cell_size,
		int(owner.position.y) % _cell_size
	)
	
	_selected_item.global_position = new_position + parent_offset

func handle_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and _selected_item:
		owner.item_placeholder_state_machine.transition_to('Hidden')
		state_machine.transition_to("Idle")
		
