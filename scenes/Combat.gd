extends Node2D

enum State { PLAYER_TURN, ENEMY_TURN, FINISHED }

@export var turn_time = 1.0

var player_scene = preload("res://scenes/player.tscn")
var enemy_scene = preload("res://scenes/enemies/enemy.tscn")

var _current_state = State.PLAYER_TURN
var _player = null
var _enemy = null
var _turn_time_left = 0

func _ready():
	_player = player_scene.instantiate()
	_enemy = enemy_scene.instantiate()
	$PlayerPosition.add_child(_player)
	$EnemyPosition.add_child(_enemy)
	
	EventsBus.player_death.connect(_player_death)
	EventsBus.enemy_death.connect(_enemy_death)

func _process(delta):
	if Input.is_action_just_pressed("debug_combat_win"):
		combat_end(true)
	if Input.is_action_just_pressed("debug_combat_lose"):
		combat_end(false)
	
	if _turn_time_left > 0:
		_turn_time_left -= delta
		return
	
	match _current_state:
		State.PLAYER_TURN:
			player_turn()
			_current_state = State.ENEMY_TURN
			_turn_time_left = turn_time
		State.ENEMY_TURN:
			enemy_turn()
			_current_state = State.PLAYER_TURN
			_turn_time_left = turn_time
		_:
			pass
			
func _player_death():
	_current_state = State.FINISHED
	combat_end(false)
	
func _enemy_death():
	_current_state = State.FINISHED
	combat_end(true)
		
func player_turn():
	var damage = _player.attack()
	_enemy.take_damage(damage)

func enemy_turn():
	var damage = _enemy.attack()
	_player.take_damage(damage)

func combat_end(win):
	# TODO results
	EventsBus.combat_end.emit(win)
