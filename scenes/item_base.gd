extends Area2D
class_name ItemBase
@export var attack = 1
@export var defence = 1

var in_place = false

var is_selected = false

var is_over_inventory = false

func _ready():
	modulate = Color(1, 1, 1, 0.5)
	add_to_group('item')
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	input_event.connect(_on_input_event)

func _physics_process(delta):
	if in_place:
		return
	elif is_selected:
		followMouse()
		
	if is_over_inventory:
		
		var x_mod = int(global_position.x) % 32
		var y_mod = int(global_position.y) % 32
		
		global_position.x -= x_mod
		global_position.y -= y_mod


func followMouse():
	global_position = get_global_mouse_position()


func _on_input_event(viewport, event, shape_idx):
	print("called me")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_selected:
			is_selected = true
			return
		if event.pressed and is_selected:
			if try_set():
				is_selected = false
	pass # Replace with function body.




func _on_area_entered(area):
	if area.is_in_group("inventory"):
		is_over_inventory = true
	pass # Replace with function body.



func _on_area_exited(area):
	if area.is_in_group("inventory"):
		is_over_inventory = false
		

	pass # Replace with function body.

func try_set():
	var areas = get_overlapping_areas()
	var is_blocked = false
	for area in areas:
		if area.is_in_group('item'):
			is_blocked = true
	if not is_blocked:
		in_place = true
		modulate = Color(1, 1, 1, 1)
		return true
	else:
		return false
