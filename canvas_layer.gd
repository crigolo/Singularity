extends CanvasLayer

@onready var label: Label = $Label

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_button_pressed() -> void:
	pass # Replace with function body.
