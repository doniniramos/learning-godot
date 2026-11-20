extends Node2D

signal increase_point(new_value)

const Config = preload("res://scripts/config.gd")

@onready var MainMenu := $HUD/MainMenu
@onready var N_PlayerCharacter:Node2D = get_node("PlayerCharacter")
@onready var N_Tree:Node2D = get_node("N_ActionLayer/Tree")

var bestScore := 0
var score := 0
var canScorePoint := true

func _ready() -> void:
	load_score()

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

func _on_hud_player_is_dead() -> void:
	endGame()

func _on_hud_time_ended() -> void:
	endGame()

func endGame():
	if score > bestScore:
		bestScore = score
		save_score()

	MainMenu.setBestScore(bestScore)
	MainMenu.setScore(score)

	if get_tree():
		$PlayerCharacter.set_process(false)
		$PlayerCharacter.set_physics_process(false)
		$N_ActionLayer/Tree.set_process(false)
		$HUD/MainMenu.visible = true

func save_score():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_var(bestScore)

func load_score():
	if not FileAccess.file_exists("user://savegame.save"):
		return

	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var loadedScore = save_file.get_var()

	if loadedScore != null:
		bestScore = int(loadedScore)
