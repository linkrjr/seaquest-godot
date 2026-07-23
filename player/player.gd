extends Area2D

var velocity = Vector2(0, 0)
var can_shoot = true

const BULLET_OFFSET = 10
const OXYGEN_DECREASE_SPEED = 2.5
const SPEED = Vector2(125, 90)
const Bullet = preload("res://player/player_bullet/playerbullet.tscn")

@onready var sprite = $AnimatedSprite2D
@onready var reload_timer = $ReloadTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_moviment_input()
	direction_follows_input()
	process_shooting()	
	lose_oxygen()
		
	
func process_moviment_input():
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized()	

func direction_follows_input():
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
		
func process_shooting():
	if Input.is_action_pressed("shoot") and can_shoot:
		var bullet_instance = Bullet.instantiate()
		get_tree().current_scene.add_child(bullet_instance)		
		if sprite.flip_h:
			bullet_instance.global_position = global_position - Vector2(BULLET_OFFSET, 0)
			bullet_instance.flip_direction()
		else:
			bullet_instance.global_position = global_position + Vector2(BULLET_OFFSET, 0)
		
		can_shoot = false
		reload_timer.start()

func lose_oxygen():
#	get_process_delta_time can be used instead of the parameter, it gets the same delta from a global state
	Global.oxygen_level -= OXYGEN_DECREASE_SPEED * get_process_delta_time()
	
func _physics_process(delta: float) -> void:
	movement()
		
func movement():
	global_position += velocity * SPEED * get_physics_process_delta_time()	

func _on_reload_timer_timeout() -> void:
	can_shoot = true
