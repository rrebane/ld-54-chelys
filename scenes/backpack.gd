extends Node2D

var stash = []

var _selected_item = null
var _can_drop = false
var _can_pickup = true

func _ready():
	EventsBus.item_picked_up.connect(_on_item_pickup)
	pass # Replace with function body.

func _process(delta):
	if GlobalState.debug and Input.is_action_just_pressed("debug_attack_stat"):
		print(inventory_attribute("attack"))
	
	if GlobalState.debug and Input.is_action_just_pressed("debug_defence_stat"):
		print(inventory_attribute("defence"))
	
func config(params):
	stash = params["stash"]

func items():
	return get_tree().get_nodes_in_group("item")

func inventory_attribute(attr_name):
	var attribute = 0
	for item in items():
		if item.get(attr_name) != null:
			attribute += item.get(attr_name)
	return attribute

func _physics_process(delta):
	if _selected_item:
		
		_follow_mouse_grid(_selected_item)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			_selected_item.return_to_original_position()
			_selected_item = null
			return
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and _can_drop:
			var could_set_item = _selected_item.try_set()
			if could_set_item:
				_selected_item = null
				_can_drop = false
				_can_pickup = false
				var timer = Timer.new()
				timer.set_wait_time(0.1)
				timer.one_shot = true
				add_child(timer)
				timer.timeout.connect(func():
					_can_pickup = true
					timer.queue_free()
				)
				timer.start()
				

			
		
func _on_item_pickup(item):
	if not _can_pickup or _selected_item:
		return
		
	_can_drop = false
	var timer = Timer.new()
	timer.set_wait_time(0.1)
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(func():
		_can_drop = true
		timer.queue_free()
	)
	timer.start()
	_selected_item = item
	
func _follow_mouse_grid(item):
	var new_position = get_global_mouse_position()
	var x_mod = int(new_position.x) % 32
	var y_mod = int(new_position.y) % 32
	
	new_position.x = int(new_position.x) - x_mod
	new_position.y = int(new_position.y) - y_mod
	
	item.global_position = new_position
