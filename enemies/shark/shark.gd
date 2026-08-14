extends Area2D

const SPEED = 50
const MOVIMENT_FREQUENCY = 0.15
const MOVIMENT_AMPLITUDE = 0.5
const ObjectPiece = preload("res://particles/object_piece/object_piece.tscn")
const PIECE_COUNT = 2
const POINTS_VALUE = 25
const SharkPiecesTexture = preload("res://enemies/shark/shark_pieces.png")
const PointValuePopup = preload("res://user_interface/points_value_popup/points_value_popup.tscn")

var velocity = Vector2(1, 0)

var state = "default"

@onready var sprite = $AnimatedSprite2D

const DeathSound = preload("res://enemies/shark/shark_death.ogg")

func _ready() -> void:
	GameEvent.connect("pause_enemies", Callable(self, "_pause"))
	GameEvent.connect("kill_all_enemies", Callable(self, "_death"))

func _process(delta: float) -> void:
	if global_position.x < Global.SCREEN_BOUND_MIN_X or global_position.x > Global.SCREEN_BOUND_MAX_X:
		queue_free()

func _physics_process(delta: float) -> void:
	if state == "default":
		velocity.y = sin(global_position.x * MOVIMENT_FREQUENCY) * MOVIMENT_AMPLITUDE
		global_position += velocity * SPEED * delta	

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		area.queue_free()
		_death()
		
	if area.is_in_group("player"):
		area.death()
		
func instance_point_value_popup():	
	var popup_instance = PointValuePopup.instantiate()
	popup_instance.value = POINTS_VALUE
	get_tree().current_scene.add_child(popup_instance)
	popup_instance.global_position = global_position
		
func instance_death_piece():
	for i in range(PIECE_COUNT):
		var piece_instance = ObjectPiece.instantiate()
		piece_instance.frame = i
		piece_instance.hframes = PIECE_COUNT
		piece_instance.texture = SharkPiecesTexture
		get_tree().current_scene.add_child(piece_instance)
		piece_instance.global_position = global_position

func _death():
	SoundManager.play_sound(DeathSound)
	instance_death_piece()
	instance_point_value_popup()
	Global.update_points(POINTS_VALUE)
	queue_free()
	

func _pause(pause) -> void:
	print("pause enemy? " + str(pause))
	
	if pause:
		state = "paused"
	else:
		state = "default"

func flip_direction():
	sprite.flip_h = !sprite.flip_h
	velocity = -velocity
