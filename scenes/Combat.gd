extends Node2D

enum Result { PLAYER_DEATH, ENEMY_DEATH }
enum State { PLAYER_TURN, ENEMY_TURN, COMBAT_END }

@export var turn_time = 0.5

@onready var _overlay = $CanvasLayer
@onready var _overlay_label = $CanvasLayer/Label

var player_scene = preload("res://scenes/player.tscn")
var enemy_scene = preload("res://scenes/enemies/enemy.tscn")

var _current_state = State.PLAYER_TURN
var _turn_time_left = 0

var _player = null
var _enemy = null

var _combat_result = {}

func _ready():
	_player = player_scene.instantiate()
	_enemy = enemy_scene.instantiate()
	$PlayerPosition.add_child(_player)
	$EnemyPosition.add_child(_enemy)
	
	EventsBus.player_death.connect(_player_death)
	EventsBus.enemy_death.connect(_enemy_death)
	
	_overlay.hide()

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
			_current_state = State.ENEMY_TURN
			_turn_time_left = turn_time
			player_turn()
		State.ENEMY_TURN:
			_current_state = State.PLAYER_TURN
			_turn_time_left = turn_time
			enemy_turn()
		State.COMBAT_END:
			if Input.is_action_just_pressed("continue"):
				combat_end(_combat_result)
			
			
func _player_death():
	_combat_result["winner"] = Result.ENEMY_DEATH
	_current_state = State.COMBAT_END
	_overlay_label.text = "You were defeated!\n\nPress SPACE to return to main menu."
	_overlay.show()
	
func _enemy_death(_gold_earned):
	_combat_result["gold"] = _gold_earned
	_combat_result["winner"] = Result.ENEMY_DEATH
	_current_state = State.COMBAT_END
	_overlay_label.text = "You won!\n\nPress SPACE to continue.".format({"gold": _gold_earned})
	_overlay.show()
		
func player_turn():
	var damage = _player.attack()
	_enemy.take_damage(damage)

func enemy_turn():
	var damage = _enemy.attack()
	_player.take_damage(damage)

func combat_end(result):
	if "gold" in result:
		GlobalState.player_gold += result["gold"]
		
	var player_win = result["winner"] == Result.ENEMY_DEATH
	EventsBus.combat_end.emit(player_win)
