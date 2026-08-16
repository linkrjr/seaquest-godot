extends Node

var first_load = true
var saved_people_count = 0

var oxygen_level = 100
var current_points = 0
var highscore = 0

const SCREEN_BOUND_MIN_X = -50
const SCREEN_BOUND_MAX_X = 300

func update_points(points) -> void:
	Global.current_points += points
	GameEvent.emit_signal("update_points")

func set_highscore():
	highscore = max(current_points, highscore)
	
func reset() -> void:
	saved_people_count = 0
	oxygen_level = 100
	current_points = 0
