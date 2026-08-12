extends Area2D

var velocity = Vector2(0, 0)
var can_shoot = true

var state = "default"

const BULLET_OFFSET = 10
const OXYGEN_DECREASE_SPEED = 2.5
const OXYGEN_INCREASE_SPEED = 60
const SPEED = Vector2(125, 90)
const Bullet = preload("res://player/player_bullet/playerbullet.tscn")

@onready var sprite = $AnimatedSprite2D
@onready var reload_timer = $ReloadTimer

func _ready() -> void:
	GameEvent.connect("full_crew_oxygen_refuel", Callable(self, "_full_crew_oxygen_refuel"))
	GameEvent.connect("less_people_oxygen_refuel", Callable(self, "_less_people_oxygen_refuel"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "default":
		process_moviment_input()
		direction_follows_input()
		process_shooting()	
		lose_oxygen()
	elif state == "less_people_refuel":
		oxygen_refuel()
	elif state == "people_refuel":
		oxygen_refuel()
		
		
func _physics_process(delta: float) -> void:
	if state == "default":
		movement()
	
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
			
func movement():
	global_position += velocity * SPEED * get_physics_process_delta_time()	

func _on_reload_timer_timeout() -> void:
	can_shoot = true
	
func _less_people_oxygen_refuel() -> void:
	state = "people_refuel"
	
func _full_crew_oxygen_refuel() -> void:
	state = "less_people_refuel"
