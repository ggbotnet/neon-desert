extends Control

var mouse_main = load("res://assets/ui_mouse_main.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(mouse_main)
	pass

func _on_BtnNewGame_pressed() -> void:
	Global.kills_score = 0
	get_tree().change_scene("res://scenes/Location00.tscn")

func _on_BtnExit_pressed() -> void:
	get_tree().quit()
