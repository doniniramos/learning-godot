extends Node2D 

const Config = preload("res://scripts/config.gd")

signal player_got_hit

@export var CURRENT_POSITION := Config.TreeSide.None

var canReceiveInput := true
var life := 3
var originalPosition: Vector2 = Vector2(0,0)

func _ready() -> void:
	originalPosition = position
	Animate(Config.AnimationState.Idle, Config.TreeSide.None)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CutLeft", true) and canReceiveInput:
		MoveToPosition(Config.TreeSide.Left)
		canReceiveInput = false
		ResetInputCooldown()

	if Input.is_action_just_pressed("CutRight", true) and canReceiveInput:
		MoveToPosition(Config.TreeSide.Right)
		canReceiveInput = false
		ResetInputCooldown()


func ResetInputCooldown():
	if get_tree():
		await get_tree().create_timer(Config.INPUT_COOLDOWN_TIME).timeout
		canReceiveInput = true


# Move to position (Left, Right)
func MoveToPosition(playerPosition: Config.TreeSide):
	if playerPosition == Config.TreeSide.Left:
		position.x = originalPosition.x -210;
	elif playerPosition == Config.TreeSide.Right:
		position.x = originalPosition.x +210;

	if position.y != 500:
		position.y = 500

	Animate(Config.AnimationState.Chop, playerPosition)


# Animate (Idle, Chop, Hit)
func Animate(state: Config.AnimationState, side: Config.TreeSide):
	if state == Config.AnimationState.Idle:
		$AnimatedSprite2D.play("idle")

	elif state == Config.AnimationState.Dead:
		$AnimatedSprite2D.play("dead")

	elif state == Config.AnimationState.Chop:
		$AnimatedSprite2D.play("chop")
		$AnimatedSprite2D.flip_h = side == Config.TreeSide.Left
		$AnimatedSprite2D.animation_finished.connect(func(): Animate(Config.AnimationState.Idle, side))

	elif state == Config.AnimationState.Hit:
		$AnimatedSprite2D.play("hit")
		$AnimatedSprite2D.animation_finished.connect(func(): Animate(Config.AnimationState.Idle, side))


func _on_area_2d_area_entered(area: Area2D) -> void:
	area.process_mode = Node.PROCESS_MODE_DISABLED
	Animate(Config.AnimationState.Hit, Config.TreeSide.None)
	emit_signal('player_got_hit')

	life -= 1

	if life > 0 and get_tree():
		get_tree().paused = true
		await get_tree().create_timer(Config.HIT_FREEZE_TIME).timeout
		get_tree().paused = false


func _on_hud_player_is_dead() -> void:
	if position.x > 640:
		position.x = position.x + 110
	else:
		position.x = position.x - 110

	position.y = 545.0

	Animate(Config.AnimationState.Dead, Config.TreeSide.None)
