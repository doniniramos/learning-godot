extends Node2D

signal player_got_hit

const Config = preload("res://scripts/config.gd")

@onready var N_PlayerCharacter:Node2D = get_node("PlayerCharacter")
@onready var N_Tree:Node2D = get_node("N_ActionLayer/Tree")

var PlayerUpdated := false
var TreeUpdated := false

var SCORE := 3

func _on_player_character_current_position_updated() -> void:
	PlayerUpdated = true
	if TreeUpdated:
		IsOnSameSide()

func _on_tree_current_position_updated() -> void:
	TreeUpdated = true
	if PlayerUpdated:
		IsOnSameSide()

func IsOnSameSide():
	if N_Tree == null or N_PlayerCharacter == null:
		return
		
	if N_Tree.CURRENT_POSITION == N_PlayerCharacter.CURRENT_POSITION:
		SCORE-=1
		emit_signal('player_got_hit')
		
	PlayerUpdated = false
	TreeUpdated = false


func _on_hud_player_is_dead() -> void:
	get_tree().reload_current_scene()
