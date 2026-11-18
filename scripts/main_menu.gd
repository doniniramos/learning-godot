extends Control

signal HomeButtonPressed
signal PlayButtonPressed

func _on_home_button_pressed() -> void:
	emit_signal('HomeButtonPressed')

func _on_play_button_pressed() -> void:
	emit_signal('PlayButtonPressed')
