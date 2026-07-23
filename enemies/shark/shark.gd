extends Area2D

const SPEED = 50
const MOVIMENT_FREQUENCY = 0.15
const MOVIMENT_AMPLITUDE = 0.5

var velocity = Vector2(1, 0)

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	velocity.y = sin(global_position.x * MOVIMENT_FREQUENCY) * MOVIMENT_AMPLITUDE
	global_position += velocity * SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		area.queue_free()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func flip_direction():
	sprite.flip_h = !sprite.flip_h
	velocity = -velocity
