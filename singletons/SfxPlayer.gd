extends Node

var players = []

func createAudioStream():
	var player = AudioStreamPlayer.new()
	add_child(player)
	return player

# Called when the node enters the scene tree for the first time.
func _ready():
	players.append(createAudioStream())
	players.append(createAudioStream())
	players.append(createAudioStream())
	EventsBus.play_sfx.connect(on_play_sfx)
	pass # Replace with function body.

func on_play_sfx(wav):
	for player in players:
		if not player.playing:
			player.stream = wav
			player.play()
