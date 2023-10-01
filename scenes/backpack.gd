extends Node2D

@export var action_timeout = 0.1

var stash = []

var _selected_item = null
var _can_drop = false
var _can_pickup = true

var _current_action_timeout = 0
var _action_just_happened = false

func _ready():
	EventsBus.item_picked_up.connect(_on_item_pickup)
	EventsBus.item_dropped.connect(_on_item_drop)

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
	_action_just_happened = false
	
	if _selected_item:
		_follow_mouse_grid(_selected_item)
	
	if _current_action_timeout > 0:
		_current_action_timeout -= delta
		return
	
	if _selected_item:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			_selected_item.return_to_original_position()
			_on_item_drop(_selected_item)
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and _can_drop:
			_selected_item.try_set()

func _on_item_pickup(item):
	_current_action_timeout = action_timeout
		
	_can_drop = true
	_can_pickup = false
	_selected_item = item
	
	_action_just_happened = true
	
func _on_item_drop(_item):
	_current_action_timeout = action_timeout
	
	_can_drop = false
	_can_pickup = true
	
	_selected_item = null
	_action_just_happened = true
	
func _follow_mouse_grid(item):
	var new_position = get_global_mouse_position()
	var x_mod = int(new_position.x) % 32
	var y_mod = int(new_position.y) % 32
	
	new_position.x = int(new_position.x) - x_mod
	new_position.y = int(new_position.y) - y_mod
	
	item.global_position = new_position

func can_drop():
	if _current_action_timeout > 0 or _action_just_happened:
		return false

	return _can_drop

func can_pick_up():
	if _current_action_timeout > 0 or _action_just_happened:
		return false

	return _can_pickup
