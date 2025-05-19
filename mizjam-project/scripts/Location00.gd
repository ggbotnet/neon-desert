extends Node2D

onready var exitgrid = get_node("Ground/Exit")
onready var dialogoldman = get_node("DialogOldMan")
onready var timer_dialog_old = $TimerDialogOldman

func _process(delta):
	pass
	
func _on_Exit_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		Global.kills_score = 0
		get_tree().change_scene("res://scenes/Location01.tscn")
		
func dialog_gamecontrol():
	var dialoggamecontrols = get_node("DialogGameControl")
	dialoggamecontrols.get_child(0).hide()
	
func _on_TimerGameControl_timeout() -> void:
	dialog_gamecontrol()
	
func _on_TimerDialogOldman_timeout() -> void:
	dialogoldman.get_child(0).hide()
	
func _on_AreaDialog_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		dialogoldman.get_child(0).show()
		TimerDialogOldManRun()
		
func TimerDialogOldManRun():
	if timer_dialog_old.is_stopped():
		timer_dialog_old.start()
