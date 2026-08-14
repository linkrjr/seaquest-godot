extends Camera2D

var target_position = global_position
const FOLLOW_SPEED = 9
const MAX_Y_POSITION = 170
const MIN_Y_POSITION = 70

func _ready() -> void:
	GameEvent.connect("camera_follow_player", Callable(self, "_camera_follow_player"))		

func _physics_process(delta: float) -> void:
	global_position.y = lerp(global_position.y, target_position.y, FOLLOW_SPEED * delta)

func _camera_follow_player(y_position) -> void:
	target_position.y = y_position
	target_position.y = clamp(y_position, MIN_Y_POSITION, MAX_Y_POSITION)
