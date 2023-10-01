extends MainMenuButton

func on_pressed():
	EventsBus.play_sfx.emit(pressed_sound)
	SceneSwitcher.goto_scene("res://ui/how_to_play.tscn")
