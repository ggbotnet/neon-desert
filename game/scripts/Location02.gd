extends Node2D

onready var exitgrid = get_node("Ground/Exit")

func _process(delta):
	if Global.kills_score >= 15:
		exitgrid.get_child(0).show()
		exitgrid.set_collision_mask(1)
	
func _on_Exit_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		Global.kills_score = 0
		get_tree().change_scene("res://scenes/Location03.tscn")

func _on_Exit_draw() -> void:
	exitgrid.get_child(0).hide()
	exitgrid.set_collision_mask(0)
