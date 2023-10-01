extends Node2D

@export var display_name = "Enemy"
@export var victory_text = ""
@export var base_health = 10
@export var base_attack = 5
@export var base_defence = 0
@export var base_gold = 5

@onready var _health = base_health
@onready var _attack = base_attack
@onready var _defence = base_defence
@onready var _gold = base_gold

@onready var _animation_player = $AnimationPlayer

signal enemy_died

func _ready():
	EventsBus.update_enemy_status.emit({
		"attack": _attack,
		"defence": _defence,
		"health": _health
	})

func _process(delta):
	pass

func attack():
	_animation_player.play("enemy_attack")
	return _attack

func take_damage(damage):
	if damage > 0:
		_animation_player.play("take_damage")
		var dmg = max(damage - _defence, 1)
		EventsBus.add_to_combat_log.emit("{name} got hit for  {damage} damage".format({"name": display_name, "damage": dmg}))
		_health -= dmg
		EventsBus.update_enemy_status.emit({"health": _health})
		if _health <= 0:
			_health = 0
			die()

func die():
	_animation_player.play("die")
	if len(victory_text) > 0:
		EventsBus.enemy_death.emit(_gold, victory_text)
	else:
		EventsBus.enemy_death.emit(_gold)
