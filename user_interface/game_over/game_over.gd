extends Control

@onready var score_label = $ScoreLabel
@onready var higscore_label = $HighScoreLabel
@onready var game_over_delay = $GameOverDelay

const GameOverSound = preload("res://player/game_over.ogg")

func _ready() -> void:
	GameEvent.connect("game_over", Callable(self, "_game_over"))
	visible = false
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and visible:
		Global.reset()
		get_tree().reload_current_scene()	
	
func _game_over() -> void:
	game_over_delay.start()

func _on_game_over_delay_timeout() -> void:
	Global.set_highscore()
	score_label.text = "Score " + str(Global.current_points)
	higscore_label.text = "HighScore "  + str(Global.highscore)
	visible = true
	SoundManager.play_sound(GameOverSound)
	game_over_delay.stop()
