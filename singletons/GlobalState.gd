extends Node

var default_starting_items = [
	"res://scenes/items/dagger.tscn"
]

@onready var starting_items = default_starting_items
@onready var current_dungeon = 1
@onready var player_gold = 0
@onready var debug = true
