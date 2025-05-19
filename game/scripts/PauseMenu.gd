extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("keyboard_esc"):
		get_tree().paused = not get_tree().paused
		visible = not visible

func _on_BtnResume_pressed() -> void:
	get_tree().paused = not get_tree().paused
	visible = not visible

func _on_BtnQuit_pressed() -> void:
	get_tree().paused = not get_tree().paused
	get_tree().change_scene("res://scenes/MainMenu.tscn")
