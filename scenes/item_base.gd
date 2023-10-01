extends Area2D

@export var attack = 1
@export var defence = 1

var original_position = null

func _ready():
	_become_unselected()
	add_to_group('item')
	input_event.connect(_on_input_event)


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not original_position:
			original_position = global_position

		EventsBus.item_picked_up.emit(self)


func try_set():
	var areas = get_overlapping_areas()
	var is_blocked = false
	for area in areas:
		if area.is_in_group('item'):
			is_blocked = true
	
	if not is_blocked:
		_become_placed()
		return true
	else:
		return false


func return_to_original_position():
	_become_unselected()
	global_position = original_position
	
func _become_unselected():
	modulate = Color(1, 1, 1, 0.5)
	
func _become_placed():
	modulate = Color(1, 1, 1, 1)
