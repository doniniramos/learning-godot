extends Node2D 

enum AnimationState {Iddle, Chop, Hit}
enum PlayerPosition {Left, Right}

var originalPosition: Vector2 = Vector2(0,0)

func _ready() -> void:
	originalPosition = position
	$AnimatedSprite2D.play("Walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CutLeft", true):
		MoveToPosition(PlayerPosition.Left)
		
	if Input.is_action_just_pressed("CutRight", true):
		MoveToPosition(PlayerPosition.Right)

# Move to position (Left, Right)
func MoveToPosition(playerPosition: PlayerPosition):
	if playerPosition == PlayerPosition.Left:
		position.x = originalPosition.x -200;
	if playerPosition == PlayerPosition.Right:
		position.x = originalPosition.x +200;
		
	Animate(AnimationState.Chop)

# Animate (Idle, Chop, Hit)
func Animate(state: AnimationState):
	pass
