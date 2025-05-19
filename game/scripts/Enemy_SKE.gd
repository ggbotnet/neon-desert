extends KinematicBody2D

var speed = 200 
var max_hp = 100
var current_hp
onready var player = get_parent().get_node("Player")
var player_in_range
var player_in_sight
var player_seen
var dead = false
var state = "Rest"
var can_fire = true
var bullet_direction
var player_position
var destination
onready var map_navigation = get_parent().get_node("Navigation2D")
var move_distance = 135
var velocity = Vector2.ZERO
var acceleration = 1000
var move_direction = 0
var anim_direction = "down"
var anim_mode = "move"
var animation = "move_down"
onready var sound_shoot = $shootenemy

func _ready():
	current_hp = max_hp

func _process(delta):
	AnimationLoop()
	match state:
		"Rest":
			pass
		"Attack":
			if can_fire == true:
				Attack()
			else:
				pass
		"Follow":
			pass
		"Search":
			Search(delta)
		"Return":
			pass

func _physics_process(delta: float) -> void:
	SightCheck()
	if player.current_hp <= 0:
		can_fire = false
		velocity = Vector2.ZERO
		speed = 0
		acceleration = 0
		player_position = false
		bullet_direction = 0

func TakeDamage(damage):
	current_hp -= damage
	if current_hp <= 0:
		Dead()

func Dead():
	Global.kills_score += 1
	dead = true
	queue_free()

func Search(delta):
	var path_to_destination = map_navigation.get_simple_path(get_global_position(), destination)
	var direction = (player.global_position - global_position).normalized()
	velocity = velocity.move_toward(direction * speed, acceleration * delta)
	anim_mode = "move"
	move_direction = (get_angle_to(get_global_mouse_position())/3.14)*180
	velocity = move_and_slide(velocity)

func Attack():
	can_fire = false
	anim_mode = "shoot"
	speed = 0
	sound_shoot.play()
	bullet_direction = (get_angle_to(get_global_mouse_position())/3.14)*180
	get_node("TurnAxis").rotation = get_angle_to(player_position)
	var bullet = load("res://scenes/Bullet.tscn")
	var bullet_instance = bullet.instance()
	bullet_instance.rotation = get_angle_to(player_position)
	bullet_instance.position = get_node("TurnAxis/GunPoint").get_global_position()
	bullet_instance.origin = "Enemy"
	get_parent().add_child(bullet_instance)
	yield(get_tree().create_timer(0.9), "timeout")
	can_fire = true
	anim_mode = "move"
	speed = 200
	sound_shoot.stop()

func _on_Sight_body_entered(body: Node) -> void:
	if body == player:
		player_in_range = true

func _on_Sight_body_exited(body: Node) -> void:
	if body == player:
		player_in_range = false
		if player_seen == true:
			state = "Search"

func SightCheck():
	if player_in_range == true:
		var space_state = get_world_2d().direct_space_state
		var sight_check = space_state.intersect_ray(position, player.position, [self], collision_mask)
		if sight_check:
			if sight_check.collider.name == "Player":
				player_in_sight = true
				player_seen = true
				player_position = player.get_global_position()
				destination = map_navigation.get_closest_point(player_position)
				state = "Attack"
			else:
				player_in_sight = false
				if player_seen == true:
					state = "Search"
				else:
					state = "Rest"

func AnimationLoop():
	if anim_mode == "shoot":
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
	elif anim_mode == "move":
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
	animation = anim_mode + "_" + anim_direction
	get_node("AnimationPlayer").play(animation)
