extends Control

signal HomeButtonPressed
signal PlayButtonPressed

@onready var bestScoreLabel := $VBoxContainer/TextureRect/BestLabel
@onready var currentScoreLabel := $VBoxContainer/TextureRect/ScoreLabel

func _on_home_button_pressed() -> void:
	emit_signal('HomeButtonPressed')

func _on_play_button_pressed() -> void:
	emit_signal('PlayButtonPressed')

func setBestScore(bestScore: int):
	bestScoreLabel.text = str(bestScore)

func setScore(currentScore: int):
	currentScoreLabel.text = str(currentScore)
