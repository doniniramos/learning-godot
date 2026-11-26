extends Control

signal time_ended

const GAME_TIME_SPEED := 18
const SCORE_TIME_BONUS := 5
const RED_COLOR_TIME := 40
const YELLOW_COLOR_TIME := 70

var timeRemaining := 100.0
var isActive := false

func _process(delta: float) -> void:
	if isActive:
		if timeRemaining > 0:
			timeRemaining -= delta * GAME_TIME_SPEED
		updateProgressBar()

	if Input.is_action_just_pressed("CutLeft", true) and !isActive:
		isActive = true

	if Input.is_action_just_pressed("CutRight", true) and !isActive:
		isActive = true


func updateProgressBar():
	if timeRemaining < 0:
		timeRemaining = 0
		isActive = false
		emit_signal("time_ended")

	if timeRemaining > 100:
		timeRemaining = 100
	
	if timeRemaining > YELLOW_COLOR_TIME:
		$TextureProgressBar.tint_progress = Color(0, 1, 0, 0.5)
	
	if timeRemaining <= YELLOW_COLOR_TIME:
		$TextureProgressBar.tint_progress = Color(1, 0.8, 0, 0.6)
	
	if timeRemaining <= RED_COLOR_TIME:
		$TextureProgressBar.tint_progress = Color(1, 0, 0, 0.6)

	$TextureProgressBar.value = timeRemaining


func _on_hud_player_score_point() -> void:
	if timeRemaining < 100:
		timeRemaining += SCORE_TIME_BONUS


func _on_hud_player_is_dead() -> void:
	isActive = false
