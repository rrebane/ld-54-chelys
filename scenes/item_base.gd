extends Area2D

@export var attack = 1
@export var defence = 1

var in_place = false
var is_selected = false
var is_over_inventory = false
var original_position = null
var can_drop = false
var is_first_drop = true

func _ready():
	modulate = Color(1, 1, 1, 0.5)
	add_to_group('item')
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	input_event.connect(_on_input_event)

func _physics_process(delta):
	if is_selected:
		followMouse()
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_drop and is_selected:
			print("got left mouse, can drop si ", can_drop)
			var did_set = try_set()
			if did_set:
				is_selected = false
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			is_selected = false
			can_drop = false
			global_position = original_position

	if is_over_inventory:
		var x_mod = int(global_position.x) % 32
		var y_mod = int(global_position.y) % 32
		
		global_position.x -= x_mod
		global_position.y -= y_mod


func followMouse():
	global_position = get_global_mouse_position()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_selected:
			become_selected()

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
		can_drop = false
		return true
	else:
		return false
		
func become_selected():
	var timer = Timer.new()
	timer.set_wait_time(0.2)
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(func():
		can_drop = true
		timer.queue_free()
	)
	timer.start()

	if is_first_drop:
		original_position = global_position
		is_first_drop = false
	is_selected = true
	in_place = false
	return

