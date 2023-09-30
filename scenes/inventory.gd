extends Node2D

@onready var item_scene_path = preload("res://scenes/item.tscn")

func _process(delta):
	if Input.is_action_just_pressed("debug_add_item"):
		var item_scene = item_scene_path.instantiate()
		$ItemContainer.add_child(item_scene)
		
	if Input.is_action_just_pressed("debug_attack_stat"):
		print(inventory_attribute("attack"))
	
	if Input.is_action_just_pressed("debug_defence_stat"):
		print(inventory_attribute("defence"))

func items():
	return $ItemContainer.get_children()

func inventory_attribute(name):
	var attribute = 0
	for item in items():
		if item.get(name) != null:
			attribute += item.get(name)
	return attribute
