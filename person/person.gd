extends Area2D

var state = STATES.DEFAULT
var velocity = Vector2(1, 0)

const SPEED = 25
const POINT_VALUE = 30
const PointValuePopup = preload("res://user_interface/points_value_popup/points_value_popup.tscn")
const SaveSound = preload("res://person/saving_person.ogg")
const DeathSound = preload("res://person/person_death.ogg")

enum STATES {DEFAULT, PAUSED}

@onready var sprite = $AnimatedSprite2D

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
	if area.is_in_group("player") and Global.saved_people_count < 7:
		Global.saved_people_count += 1
		SoundManager.play_sound(SaveSound)
		GameEvent.emit_signal("update_collected_people_count")
		Global.update_points(POINT_VALUE)
		instance_point_value_popup()
		queue_free()
	elif area.is_in_group("PlayerBullet"):
		SoundManager.play_sound(DeathSound)
		area.queue_free()
		queue_free()
		
func instance_point_value_popup():
	var popup_instance = PointValuePopup.instantiate()
	popup_instance.value = POINT_VALUE
	get_tree().current_scene.add_child(popup_instance)
	popup_instance.global_position = global_position
