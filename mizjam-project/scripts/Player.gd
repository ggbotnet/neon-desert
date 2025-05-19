extends KinematicBody2D

var mouse_moving = load("res://assets/ui_mouse_moving.png")
var mouse_shoot = load("res://assets/ui_mouse_shoot.png")
var max_hp = 100
var current_hp
var dead = false
signal health_updated(current_hp)
export var max_speed = 250.0
var speed = 0
var acceleration = 1000
var move_direction = 0
var moving = false
var destination = Vector2()
var movement = Vector2()
var bullet = preload("res://scenes/Bullet.tscn")
var can_fire = true
var rate_of_fire = 0.4
var shooting = false
var bullet_direction
onready var sound_shoot = $shoot
onready var kills_score_text = $Camera2D/CanvasLayer/RichTextLabel

func _ready() -> void:
	Input.set_custom_mouse_cursor(mouse_moving)
	current_hp = max_hp

func _input(event):
	if event.is_action_pressed('mouse_left'):
		moving = true
		destination = get_global_mouse_position()

func _process(delta: float) -> void:
	AnimationLoop()
	BulletLoop()

func BulletLoop():
	if dead == false:
		if Input.is_action_pressed("mouse_right") and can_fire == true:
			can_fire = false
			shooting = true
			sound_shoot.play()
			get_node("TurnAxis").rotation = get_angle_to(get_global_mouse_position())
			var bullet_instance = bullet.instance()
			bullet_instance.position = get_node("TurnAxis/GunPoint").get_global_position()
			bullet_instance.rotation = get_angle_to(get_global_mouse_position())
			bullet_direction = (get_angle_to(get_global_mouse_position())/3.14)*180
			bullet_instance.origin = "Player"
			get_parent().add_child(bullet_instance)
			yield(get_tree().create_timer(rate_of_fire), "timeout")
			can_fire = true
			shooting = false
			sound_shoot.stop()

func _physics_process(delta):
	MovementLoop(delta)
	kills_score_text.text = str(Global.kills_score)+"/15 kills"

func MovementLoop(delta):
	if moving == false:
		speed = 0
	else:
		speed += acceleration * delta
		if speed > max_speed:
			speed = max_speed
	movement = position.direction_to(destination) * speed
	move_direction = rad2deg(destination.angle_to_point(position))
	if position.distance_to(destination) > 5:
		movement = move_and_slide(movement)
	else:
		moving = false

func AnimationLoop():
	if dead == false:
		var anim_direction = "down"
		var anim_mode = "move"
		var animation
		if shooting == true:
			anim_mode = "move"
			if bullet_direction <= 15 and bullet_direction >= -15:
				anim_direction = "right"
			elif bullet_direction <= 60 and bullet_direction >= 15:
				anim_direction = "right"
			elif bullet_direction <= 120 and bullet_direction >= 60:
				anim_direction = "down"
			elif bullet_direction <= 165 and bullet_direction >= 120:
				anim_direction = "down"
			elif bullet_direction >= -60 and bullet_direction <= -15:
				anim_direction = "up"
			elif bullet_direction >= -120 and bullet_direction <= -60:
				anim_direction = "up"
			elif bullet_direction >= -165 and bullet_direction <= -120:
				anim_direction = "left"
			elif bullet_direction <= -165 and bullet_direction >= 165:
				anim_direction = "left"
		else:
			if move_direction <= 15 and move_direction >= -15:
				anim_direction = "right"
			elif move_direction <= 60 and move_direction >= 15:
				anim_direction = "right"
			elif move_direction <= 120 and move_direction >= 60:
				anim_direction = "down"
			elif move_direction <= 165 and move_direction >= 120:
				anim_direction = "down"
			elif move_direction >= -60 and move_direction <= -15:
				anim_direction = "up"
			elif move_direction >= -120 and move_direction <= -60:
				anim_direction = "up"
			elif move_direction >= -165 and move_direction <= -120:
				anim_direction = "left"
			elif move_direction <= -165 and move_direction >= 165:
				anim_direction = "left"
		if moving == true:
			anim_mode = "move"
		elif moving == false:
			anim_mode = "move"
		animation = anim_mode + "_" + anim_direction
		get_node("AnimationPlayer").play(animation)

func _set_health(value):
	var prev_health = current_hp
	current_hp = clamp(value, 0, max_hp)

func healup(amount):
	_set_health(current_hp + amount)

func _on_FirstAid_health_pickup():
	healup(100)
	get_node("Camera2D/CanvasLayer/HPbar").value += 100

func TakeDamage(damage):
	current_hp -= damage
	get_node("Camera2D/CanvasLayer/HPbar").value = int((float(current_hp) / max_hp) * 100)
	if current_hp <= 0:
		Dead()

func Dead():
	dead = true
	get_node("Camera2D/CanvasLayer/Popup").show()
	Global.kills_score = 0
	can_fire = false
	max_speed = 0
	speed = 0
	acceleration = 0
	bullet_direction = 0
	moving = false

func _on_BtnContinue_pressed() -> void:
	get_tree().reload_current_scene()

func _on_BtnEnd_pressed() -> void:
	get_tree().change_scene("res://scenes/MainMenu.tscn")
