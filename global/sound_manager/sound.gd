extends AudioStreamPlayer

func _ready() -> void:
	connect("finished", Callable(self, "_finished"))

func _finished() -> void:
	queue_free()
