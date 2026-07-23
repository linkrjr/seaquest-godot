extends Area2D

var velocity = Vector2(1, 0)
const SPEED = 25

@onready var sprite = $AnimatedSprite2D

func flip_direction() -> void:
	velocity = -velocity
	sprite.flip_h = !sprite.flip_h
	
func _physics_process(delta: float) -> void:
	global_position += velocity * SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.saved_people_count += 1
		GameEvent.emit_signal("update_collected_people_count")
		queue_free()
