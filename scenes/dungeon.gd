extends Node2D

@export var phase_switch_delay = 1.0

enum Phase { COMBAT, INVENTORY }

var _phase_timeout = 0

@export var enemies = [
	preload("res://scenes/enemies/enemy.tscn"),
	preload("res://scenes/enemies/enemy2.tscn"),
	preload("res://scenes/enemies/enemy3.tscn"),
	preload("res://scenes/enemies/enemy4.tscn"),
	preload("res://scenes/enemies/boss1.tscn")
]

@onready var _combat_scene = preload("res://scenes/combat.tscn")

var _current_enemy = 0
var _current_phase = Phase.INVENTORY

func _ready():
	EventsBus.combat_end.connect(combat_end)

func _process(delta):
	if _phase_timeout > 0:
		_phase_timeout -= delta
	
	match _current_phase:
		Phase.INVENTORY:
			if Input.is_action_just_pressed("combat_phase"):
				combat_phase()
		Phase.COMBAT:
			pass

func combat_phase():
	var combat = _combat_scene.instantiate()
	combat.enemy_scene = enemies[_current_enemy]
	combat.is_boss = _current_enemy + 1 >= len(enemies)
	add_child(combat)
	$Backpack.hide_backpack()
	
	_current_phase = Phase.COMBAT
	_phase_timeout = phase_switch_delay
	
func inventory_phase():
	$Combat.queue_free()
	$Backpack.show_backpack()
	
	_current_phase = Phase.INVENTORY
	_phase_timeout = phase_switch_delay
	
func combat_end(win):
	if win:
		_current_enemy += 1
		if len(enemies) <= _current_enemy:
			SceneSwitcher.goto_scene("res://ui/main_menu.tscn")
		else:
			inventory_phase()
	else:
		SceneSwitcher.goto_scene("res://ui/main_menu.tscn")
