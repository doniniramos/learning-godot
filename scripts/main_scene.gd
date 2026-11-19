extends Node2D

signal increase_point(new_value)

const Config = preload("res://scripts/config.gd")
var MainMenu = preload("res://scenes/main_menu.tscn")

@onready var N_PlayerCharacter:Node2D = get_node("PlayerCharacter")
@onready var N_Tree:Node2D = get_node("N_ActionLayer/Tree")

var score := 0
var canScorePoint := true

func _on_hud_player_is_dead() -> void:
	if get_tree():
		$PlayerCharacter.process_mode = Node.PROCESS_MODE_DISABLED
		$N_ActionLayer/Tree.process_mode = Node.PROCESS_MODE_DISABLED
		$HUD/MainMenu.visible = true
		get_tree().paused = true

func _on_player_character_player_got_hit() -> void:
	canScorePoint = false

func _on_main_menu_play_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_main_menu_home_button_pressed() -> void:
	get_tree().quit()

func _on_tree_current_position_updated() -> void:
	if get_tree():
		await get_tree().create_timer(0.05).timeout
	if canScorePoint:
		score += 1
		increase_point.emit(score)
	canScorePoint = true
