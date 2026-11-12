extends Node2D 

const Config = preload("res://scripts/config.gd")

signal player_got_hit

@export var CURRENT_POSITION := Config.TreeSide.None

var originalPosition: Vector2 = Vector2(0,0)
var CanReceiveInput := true

func _ready() -> void:
	originalPosition = position
	Animate(Config.AnimationState.Iddle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CutLeft", true) and CanReceiveInput:
		MoveToPosition(Config.TreeSide.Left)
		CanReceiveInput = false
		ResetInputCooldown()
	if Input.is_action_just_pressed("CutRight", true) and CanReceiveInput:
		MoveToPosition(Config.TreeSide.Right)
		CanReceiveInput = false
		ResetInputCooldown()

func ResetInputCooldown():
	if get_tree():
		await get_tree().create_timer(Config.INPUT_COOLDOWN_TIME).timeout
		CanReceiveInput = true

# Move to position (Left, Right)
func MoveToPosition(playerPosition: Config.TreeSide):
	if playerPosition == Config.TreeSide.Left:
		position.x = originalPosition.x -200;
	if playerPosition == Config.TreeSide.Right:
		position.x = originalPosition.x +200;
	
	Animate(Config.AnimationState.Chop)

# Animate (Idle, Chop, Hit)
func Animate(state: Config.AnimationState):
	if state == Config.AnimationState.Iddle:
		$AnimatedSprite2D.play("idle")
	
	if state == Config.AnimationState.Chop:
		$AnimatedSprite2D.play("chop")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("idle")
	
	if state == Config.AnimationState.Hit:
		$AnimatedSprite2D.play("hit")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("idle")

func _on_area_2d_area_entered(area: Area2D) -> void:
	area.process_mode = Node.PROCESS_MODE_DISABLED
	Animate(Config.AnimationState.Hit)
	emit_signal('player_got_hit')
	if get_tree():
		await get_tree().create_timer(0.25).timeout
		get_tree().paused = false
