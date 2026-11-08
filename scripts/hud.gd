extends Control

signal player_is_dead
signal player_got_hit

func _on_health_indicator_player_is_dead() -> void:
	emit_signal("player_is_dead")

func _on_main_scene_player_got_hit() -> void:
	emit_signal("player_got_hit")
