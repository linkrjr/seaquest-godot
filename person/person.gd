extends Area2D

var velocity = Vector2(1, 0)
const SPEED = 25

const POINT_VALUE = 30

enum STATES {DEFAULT, PAUSED}

var state = STATES.DEFAULT

@onready var sprite = $AnimatedSprite2D

const SaveSound = preload("res://person/saving_person.ogg")
const DeathSound = preload("res://person/person_death.ogg")

func _ready() -> void:
	GameEvent.connect("pause_enemies", Callable(self, "_pause"))

func flip_direction() -> void:
	velocity = -velocity
	sprite.flip_h = !sprite.flip_h
	
func _pause(pause) -> void:
	if pause:
		state = STATES.PAUSED
	else:
		state = STATES.DEFAULT
	
func _process(delta: float) -> void:
	if global_position.x < Global.SCREEN_BOUND_MIN_X or global_position.x > Global.SCREEN_BOUND_MAX_X:
		queue_free()		
	
func _physics_process(delta: float) -> void:
	if state == STATES.DEFAULT:
		global_position += velocity * SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.saved_people_count += 1
		SoundManager.play_sound(SaveSound)
		GameEvent.emit_signal("update_collected_people_count")
		Global.update_points(POINT_VALUE)
		queue_free()
	elif area.is_in_group("PlayerBullet"):
		SoundManager.play_sound(DeathSound)
		area.queue_free()
		queue_free()
