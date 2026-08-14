extends Node2D

@onready var texture_progress = $TextureProgress

var previous_amount = 0

const alert_values = {
	"25" = {
		scale_value = 1.25, 
		rotation_value = 5
	},
	"15" = {
		scale_value = 1.3, 
		rotation_value = 7
	},
	"10" = {
		scale_value = 1.35, 
		rotation_value = 10
	},
	"7" = {
		scale_value = 1.4, 
		rotation_value = 15
	},
	"5" = {
		scale_value = 1.5, 
		rotation_value = 20
	},
	"2" = {
		scale_value = 1.6, 
		rotation_value = 25
	},
	"1" = {
		scale_value = 1.8, 
		rotation_value = 35
	},
}

func _process(delta: float) -> void:
	texture_progress.value = Global.oxygen_level
	
	var amount_rounded = round(Global.oxygen_level)
	
	if amount_rounded == previous_amount:
		return
	
	print("alert " + str(int(amount_rounded)))
	if alert_values.has(str(int(amount_rounded))):
		var current_alert = alert_values.get(str(int(amount_rounded)))
		alert(
			current_alert.scale_value, 
			current_alert.rotation_value
		)

	previous_amount = amount_rounded

func _physics_process(delta: float) -> void:
	scale = lerp(scale, Vector2(1, 1), 6 * delta)
	rotation_degrees = lerp(rotation_degrees, 0.0, 6 * delta)
	modulate = Color(1, 1, 1)

func alert(scale_value, rotation_value) -> void:
	scale = Vector2(scale_value, scale_value)
	rotation_degrees = randf_range(-rotation_value, rotation_value)
	modulate = Color(50, 50, 50)
