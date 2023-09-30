extends Node2D

@export var base_health = 15
@export var base_attack = 1
@export var base_defence = 1

@onready var _health = base_health

@onready var _animation_player = $AnimationPlayer

var _inventory = null

signal player_death

func _ready():
	pass

func _process(delta):
	pass
	
func attack():
	# TODO get defence from inventory
	_animation_player.play("player_attack")
	var inventory_attack = 0
	return inventory_attack

func take_damage(damage):
	# TODO get defence from inventory
	var inventory_defence = 0
	
	if damage > 0:
		var dmg = max(damage - inventory_defence, 1)
		print("You got hit for {damage} damage".format({"damage": dmg}))
		_health -= dmg
		if _health <= 0:
			die()

func die():
	print("Player died")
	EventsBus.player_death.emit()
