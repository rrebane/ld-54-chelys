extends Node2D

enum Phase { COMBAT, INVENTORY }

@export var enemies = [
	"res://scenes/enemies/slime.tscn",
	"res://scenes/enemies/slime.tscn",
	"res://scenes/enemies/boss1.tscn"
]

@onready var _combat_scene = preload("res://scenes/combat.tscn")

var _current_enemy = 0
var _current_phase = Phase.INVENTORY

func _ready():
	EventsBus.combat_end.connect(combat_end)

func _process(delta):
	match _current_phase:
		Phase.INVENTORY:
			if Input.is_action_just_pressed("debug_combat_phase"):
				combat_phase()
		_:
			pass

func config(params):
	pass

func combat_phase():
	var combat = _combat_scene.instantiate()
	combat.enemy = enemies[_current_enemy]
	add_child(combat)
	$Backpack.hide_backpack()
	
func inventory_phase():
	$Combat.queue_free()
	$Backpack.show_backpack()
	
func combat_end(win):
	if win:
		_current_enemy += 1
		if len(enemies) <= _current_enemy:
			SceneSwitcher.goto_scene("res://ui/main_menu.tscn")
		else:
			inventory_phase()
	else:
		SceneSwitcher.goto_scene("res://ui/main_menu.tscn")
