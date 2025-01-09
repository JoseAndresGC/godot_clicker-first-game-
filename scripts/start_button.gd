extends Button

func _ready() -> void:
	connect("pressed", Callable(self, "_on_pressed"))


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Intento_De_UI.tscn")
