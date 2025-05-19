extends RigidBody2D

var bullet_speed = 500
var bullet_life_time = 5
var damage = 50
var origin

func _ready() -> void:
	if origin == "Player":
		set_collision_mask_bit(0, false)
	elif origin == "Enemy": 
		damage = 15
		bullet_speed = 400
		set_collision_mask_bit(1, false)
	apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	SelfDestruct()

func SelfDestruct():
	yield(get_tree().create_timer(bullet_life_time), "timeout")
	queue_free()

func _on_Bullet_body_entered(body: Node) -> void:
	get_node("CollisionShape2D").set_deferred("disabled", true)
	if body.is_in_group("Enemies") and origin == "Player":
		body.TakeDamage(damage)
	elif body.is_in_group("Player") and origin == "Enemy":
		body.TakeDamage(damage)
	self.hide()
