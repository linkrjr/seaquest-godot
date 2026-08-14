extends Area2D

const SPEED = 50
const MOVIMENT_FREQUENCY = 0.15
const MOVIMENT_AMPLITUDE = 0.5

var velocity = Vector2(1, 0)

var state = "default"

const POINTS_VALUE = 25

@onready var sprite = $AnimatedSprite2D

const DeathSound = preload("res://enemies/shark/shark_death.ogg")

func _ready() -> void:
	GameEvent.connect("pause_enemies", Callable(self, "_pause"))

func _process(delta: float) -> void:
	if global_position.x < Global.SCREEN_BOUND_MIN_X or global_position.x > Global.SCREEN_BOUND_MAX_X:
		queue_free()

func _physics_process(delta: float) -> void:
	if state == "default":
		velocity.y = sin(global_position.x * MOVIMENT_FREQUENCY) * MOVIMENT_AMPLITUDE
		global_position += velocity * SPEED * delta	

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		SoundManager.play_sound(DeathSound)
		Global.update_points(POINTS_VALUE)
		area.queue_free()
		queue_free()
		
	if area.is_in_group("player"):
		area.death()

func _pause(pause) -> void:
	print("pause enemy? " + str(pause))
	
	if pause:
		state = "paused"
	else:
		state = "default"

func flip_direction():
	sprite.flip_h = !sprite.flip_h
	velocity = -velocity
