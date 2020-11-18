extends TextureRect

func _ready():
	AudioManager.play_bgm("menu")
	Debug.set_version_visible(true)

# (❁´◡`❁)


func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
	elif event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		OS.window_borderless = OS.window_fullscreen


func _on_NewGameButton_pressed():
#	Debug.set_version_visible(false)
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://game/dungeon/Dungeon.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
