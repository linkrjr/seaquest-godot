extends Node2D

@onready var left = $left
@onready var right = $right

var spawned = {}

var used_spawn_points = []

const Shark = preload("res://enemies/shark/shark.tscn")
const Person = preload("res://person/person.tscn")

@onready var spawn_person_timer = $SpawnPersonTimer
@onready var spawn_enemy_timer = $SpawnEnemyTimer

func _ready() -> void:
	GameEvent.connect("pause_enemies", Callable(self, "_pause"))

func spawn_enemy() -> void:
	var available_spawn_points = []
	
	for i in range(1, 5):
		if !used_spawn_points.has(i):
			available_spawn_points.append(i)
	
	var rand_spawn_point_index = randi_range(0, available_spawn_points.size() - 1)
	var selected_spawn_point_number = available_spawn_points[rand_spawn_point_index]
	used_spawn_points.append(selected_spawn_point_number)
	
	#if not spawned.has(str(rand_spawn_point_number)):
	
	var selected_side_node = left
	var spawn_right = bool(randi_range(0, 1))
	
	if spawn_right:
		selected_side_node = right
	
	var selected_spawn_point = selected_side_node.get_node(str(selected_spawn_point_number))
	var spawn_position = selected_spawn_point.global_position
	var shark_instance = Shark.instantiate()
	#spawned[str(selected_spawn_point_number)] = shark_instance
	shark_instance.global_position = spawn_position
	get_tree().current_scene.add_child(shark_instance)
	
	if spawn_right:
		shark_instance.flip_direction()
		
# Events
func _on_spawn_enemy_timer_timeout() -> void:
	#while len(spawned) < 4:
	for i in range(4):
		spawn_enemy()
	
	used_spawn_points.clear()
	#for key in spawned:
		#var value = spawned.get(key)
		#if value == null or not is_instance_valid(value):
			#spawned.erase(key)

func _on_spawn_player_timer_timeout() -> void:
	var person_instance = Person.instantiate()
	get_tree().current_scene.add_child(person_instance)
	
	var rand_spawn_point_number = randi_range(1, 4)
	
	var selected_side_node = left
	var spawn_right = bool(randi_range(0, 1))
	
	if spawn_right:
		selected_side_node = right
		person_instance.flip_direction()
		
	var selected_spawn_point = selected_side_node.get_node(str(rand_spawn_point_number))
	var spawn_position = selected_spawn_point.global_position
	
	person_instance.global_position = spawn_position
	
	
func _pause(pause) -> void:
	if pause:
		spawn_enemy_timer.stop()
		spawn_person_timer.stop()
	else:
		spawn_enemy_timer.start()
		spawn_person_timer.start()
