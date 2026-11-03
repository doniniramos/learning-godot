extends Node2D 

signal current_position_updated

const Config = preload("res://scripts/config.gd")

enum AnimationState {Iddle, Chop, Hit}

var originalPosition: Vector2 = Vector2(0,0)

@export var CURRENT_POSITION := Config.TreeSide.None

func _ready() -> void:
	originalPosition = position
	$AnimatedSprite2D.play("Walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CutLeft", true):
		MoveToPosition(Config.TreeSide.Left)
		
	if Input.is_action_just_pressed("CutRight", true):
		MoveToPosition(Config.TreeSide.Right)

# Move to position (Left, Right)
func MoveToPosition(playerPosition: Config.TreeSide):
	if playerPosition == Config.TreeSide.Left:
		position.x = originalPosition.x -200;
	if playerPosition == Config.TreeSide.Right:
		position.x = originalPosition.x +200;
	
	CURRENT_POSITION = playerPosition
	emit_signal("current_position_updated")
	Animate(AnimationState.Chop)

# Animate (Idle, Chop, Hit)
func Animate(state: AnimationState):
	pass
