extends Label

func _ready() -> void:
	GameEvent.connect("update_points", Callable(self, "_update_points"))

func _update_points() -> void:
	text = str(Global.current_points)
