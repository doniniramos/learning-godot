extends Node2D

const Config = preload("res://scripts/config.gd")

@onready var N_PlayerCharacter:Node2D = get_node("PlayerCharacter")
@onready var N_Tree:Node2D = get_node("N_ActionLayer/Tree")

var PlayerUpdated := false
var TreeUpdated := false

var SCORE := 3

func _on_hud_player_is_dead() -> void:
	get_tree().reload_current_scene()

func _on_player_character_player_got_hit() -> void:
	SCORE-=1
	
	if get_tree():
		get_tree().paused = true
