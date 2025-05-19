extends Control

var mouse_main = load("res://assets/ui_mouse_main.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(mouse_main)

func _on_Btn_WinExitGame_pressed() -> void:
	get_tree().quit()
