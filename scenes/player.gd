extends Node2D

@export var base_health = 15
@export var base_attack = 1
@export var base_defence = 1

@onready var _health = base_health

@onready var _animation_player = $AnimationPlayer

var _backpack = null

signal player_death

func _ready():
	_backpack = get_tree().get_nodes_in_group("backpack")[0]
	var inventory_health = _backpack.inventory_attribute("health")
	_health = base_health + inventory_health
	
	var inventory_attack = _backpack.inventory_attribute("attack")
	var inventory_defence = _backpack.inventory_attribute("defence")
	
	EventsBus.update_player_status.emit({
		"attack": base_attack + inventory_attack,
		"defence": base_defence + inventory_defence,
		"health": _health
	})

func _process(delta):
	pass
	
func attack():
	_animation_player.play("player_attack")
	var inventory_attack = _backpack.inventory_attribute("attack")
	return base_attack + inventory_attack

func take_damage(damage):
	var inventory_defence = _backpack.inventory_attribute("defence")
	var def = base_defence + inventory_defence
	
	if damage > 0:
		_animation_player.play("take_damage")
		var dmg = max(damage - base_defence - inventory_defence, 1)
		EventsBus.add_to_combat_log.emit("You got hit for {damage} damage".format({"damage": dmg}))
		_health -= dmg
		EventsBus.update_player_status.emit({"health": _health})
		if _health <= 0:
			_health = 0
			die()

func die():
	_animation_player.play("die")
	EventsBus.player_death.emit()
