extends Area2D

var velocity = Vector2(0, 0)
var can_shoot = true

var state = "default"

const BULLET_OFFSET = 10
const OXYGEN_DECREASE_SPEED = 2.5
const OXYGEN_INCREASE_SPEED = 60
const SPEED = Vector2(125, 90)
const OXYGEN_REFUEL_Y_POSITION = 38
const OXYGEN_REFUEL_MOVE_SPEED = 70

const MAX_X_POSITION = 248
const MIN_X_POSITION = 13
const MAX_Y_POSITION = 205
const MIN_Y_POSITION = OXYGEN_REFUEL_Y_POSITION

const Bullet = preload("res://player/player_bullet/playerbullet.tscn")

@onready var sprite = $AnimatedSprite2D
@onready var reload_timer = $ReloadTimer
@onready var decrease_people_timer = $DecreasePeopleTimer

func _ready() -> void:
	GameEvent.connect("full_crew_oxygen_refuel", Callable(self, "_full_crew_oxygen_refuel"))
	GameEvent.connect("less_people_oxygen_refuel", Callable(self, "_less_people_oxygen_refuel"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(state)
	if state == "default":
		process_moviment_input()
		direction_follows_input()
		process_shooting()	
		lose_oxygen()
	elif state == "oxygen_refuel":
		oxygen_refuel()
		move_to_shore_line()
	elif state == "people_refuel":
		move_to_shore_line()
		
		
func _physics_process(delta: float) -> void:
	if state == "default":
		movement()
	
	clamp_moviment()
	
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
	if Global.oxygen_level > 0:
		Global.oxygen_level = move_toward(Global.oxygen_level, 0, OXYGEN_DECREASE_SPEED * get_process_delta_time()) 
	
func oxygen_refuel():
	Global.oxygen_level += OXYGEN_INCREASE_SPEED * get_process_delta_time()
	
	if Global.oxygen_level > 99:
		state = "default"
		
func move_to_shore_line():
	var move_speed = OXYGEN_REFUEL_MOVE_SPEED * get_process_delta_time()
	global_position.y = move_toward(global_position.y, OXYGEN_REFUEL_Y_POSITION, move_speed)
			
func movement():
	global_position += velocity * SPEED * get_physics_process_delta_time()	
	
func clamp_moviment():
	global_position.x = clamp(global_position.x, MIN_X_POSITION, MAX_X_POSITION)
	global_position.y = clamp(global_position.y, MIN_Y_POSITION, MAX_Y_POSITION)

func remove_one_person():
	if Global.saved_people_count > 0:
		Global.saved_people_count -= 1
		GameEvent.emit_signal("update_collected_people_count")

func _on_reload_timer_timeout() -> void:
	can_shoot = true
	
func _less_people_oxygen_refuel() -> void:
	state = "oxygen_refuel"
	remove_one_person()
	
func _full_crew_oxygen_refuel() -> void:
	state = "people_refuel"
	decrease_people_timer.start()

func _on_decrease_people_timer_timeout() -> void:
	remove_one_person()
	
	if Global.saved_people_count <= 0:
		state = "oxygen_refuel"
		decrease_people_timer.stop()
		
