extends Node2D

var stash = []

func _ready():
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
