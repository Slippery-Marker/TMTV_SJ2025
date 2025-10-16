extends VBoxContainer
const MAIN_LEVEL = preload("uid://cngt7q1vhu5l2")
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_LEVEL)
func _on_exit_button_pressed() -> void:
	get_tree().quit()
