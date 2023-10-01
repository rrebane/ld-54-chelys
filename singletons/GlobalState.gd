extends Node

var default_starting_items = [
	preload("res://scenes/items/level1/dagger.tscn"),
	preload("res://scenes/items/level1/buckler.tscn")
]

var items = [
	# Level 1
	[
		preload("res://scenes/items/level1/belt.tscn"),
		preload("res://scenes/items/level1/buckler.tscn"),
		preload("res://scenes/items/level1/dagger.tscn"),
		preload("res://scenes/items/level1/gloves.tscn"),
		preload("res://scenes/items/level1/health_potion_small.tscn"),
		preload("res://scenes/items/level1/ring.tscn"),
		preload("res://scenes/items/level1/shuriken.tscn"),
		preload("res://scenes/items/level1/sickle.tscn")
	],
	# Level 2
	[
		
	],
	# Level 3
	[
		
	]
]

@onready var starting_items = default_starting_items
@onready var current_dungeon = 1
@onready var player_gold = 0
@onready var debug = false
