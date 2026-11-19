extends Control

signal player_got_hit
signal player_is_dead
signal player_score_point
signal time_ended

func _on_health_indicator_player_is_dead() -> void:
	emit_signal("player_is_dead")

func _on_player_character_player_got_hit() -> void:
	emit_signal("player_got_hit")

func _on_main_scene_increase_point(newValue: int) -> void:
	emit_signal("player_score_point")
	$MarginContainer/VBoxContainer/BestLabel.text = str(newValue)

func _on_time_control_time_ended() -> void:
	emit_signal("time_ended")
