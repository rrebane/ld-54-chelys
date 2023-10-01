extends Node2D

@export var action_timeout = 0.1
@export var cell_size = 80

var stash = []

var _selected_item = null
var _can_drop = false
var _can_pickup = true

var _current_action_timeout = 0
var _action_just_happened = false

func _ready():
	EventsBus.item_picked_up.connect(_on_item_pickup)
	EventsBus.item_dropped.connect(_on_item_drop)
	
	$CanvasLayer/Control/Label.text = "Choose the items for your journey"

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
	
	_update_info(item)
	
func _on_item_drop(_item):
	_current_action_timeout = action_timeout
	
	_can_drop = false
	_can_pickup = true
	
	_selected_item = null
	_action_just_happened = true
	
	_clear_item_info()
	
func _follow_mouse_grid(item):
	var new_position = get_global_mouse_position()
	var x_mod = int(new_position.x) % cell_size + cell_size / 2
	var y_mod = int(new_position.y) % cell_size + cell_size / 2
	
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

func hide_backpack():
	$CanvasLayer/Control.hide()
	hide()
	
func show_backpack():
	$CanvasLayer/Control.show()
	show()

func _update_info(item):
	$CanvasLayer/Control/Label.text = ""
	$CanvasLayer/Control/Label.text += 'attack: {attack}'.format({'attack': item.attack})
	$CanvasLayer/Control/Label.text += '\n' + 'defence: {defence}'.format({'defence': item.defence})
	$CanvasLayer/Control/Label.text += '\n' + 'health: {health}'.format({'health': item.health})

func _clear_item_info():
	$CanvasLayer/Control/Label.text = "Choose the items for your journey!"
	$CanvasLayer/Control/Label.text += "\nSelect an item to see its stats!"
	$CanvasLayer/Control/Label.text += "\n\nPress SPACE to depart!"

func get_items_in_inventory():
	return $Inventory.get_items_in_inventory()

