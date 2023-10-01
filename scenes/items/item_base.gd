extends Area2D

@export var attack = 1
@export var defence = 1

var original_position = null

var _backpack = null

func _ready():
	_become_dropped()
	add_to_group('item')
	input_event.connect(_on_input_event)
	_backpack = get_tree().get_nodes_in_group("backpack")[0]

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not _backpack.can_pick_up():
			return
		original_position = global_position

		_become_dragged()
		EventsBus.item_picked_up.emit(self)

func try_set():
	var areas = get_overlapping_areas()
	var is_blocked = false
	for area in areas:
		if area.is_in_group('item'):
			is_blocked = true
	
	if not is_blocked:
		_become_dropped()
		EventsBus.item_dropped.emit(self)

func return_to_original_position():
	_become_dropped()
	global_position = original_position
	
func _become_dragged():
	modulate = Color(1, 1, 1, 0.5)
	
func _become_dropped():
	modulate = Color(1, 1, 1, 1)
