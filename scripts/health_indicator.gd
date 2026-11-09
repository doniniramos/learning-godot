extends Control

@onready var HEARTS_ARRAY: Array[Control] = [$HBoxContainer/Heart01, $HBoxContainer/Heart02, $HBoxContainer/Heart03]

signal player_is_dead

const HEALTH_LIMIT := 3
var HEALTH := 3

func IncreaseHealth():
	HEALTH += 1
	if HEALTH > HEALTH_LIMIT:
		HEALTH = HEALTH_LIMIT
	UpdateVisuals()

func DecreaseHealth():
	HEALTH -= 1
	if HEALTH <= 0:
		HEALTH = 0		
		emit_signal("player_is_dead")
	UpdateVisuals()

func UpdateVisuals():
	for i in HEARTS_ARRAY.size():
		if i+1 > HEALTH:
			HEARTS_ARRAY[i].hide()
		else:
			HEARTS_ARRAY[i].show()

func _on_hud_player_got_hit() -> void:
	DecreaseHealth()
