extends Node2D 

const Config = preload("res://scripts/config.gd")

const maxPitchVariation := 1.15
const minPitchVariation := 0.9

const maxVolumeDB := -10.0
const minVolumeDB := -16.0

const volumeDecreaseAmount := 4
const volumeIncreaseAmount := 0.8

var volumeDB := -16.0

var dashAudioArray: Array = [
		preload("res://assets/sfx/dash/sfx_tc_dash_noecho_5.wav"),
		preload("res://assets/sfx/dash/sfx_tc_dash_noecho_6.wav"),
		preload("res://assets/sfx/dash/sfx_tc_dash_noecho_7.wav"),
		preload("res://assets/sfx/dash/sfx_tc_dash_noecho_8.wav")
	]

var hitAudioArray: Array = [
		preload("res://assets/sfx/hit/sfx_tc_hit_1.wav"),
		preload("res://assets/sfx/hit/sfx_tc_hit_2.wav"),
		preload("res://assets/sfx/hit/sfx_tc_hit_3.wav"),
		preload("res://assets/sfx/hit/sfx_tc_hit_4.wav"),
		preload("res://assets/sfx/hit/sfx_tc_hit_5.wav")
	]

signal player_got_hit

@export var CURRENT_POSITION := Config.TreeSide.None

var canReceiveInput := true
var life := 3
var originalPosition: Vector2 = Vector2(0,0)

func _ready() -> void:
	originalPosition = position
	Animate(Config.AnimationState.Idle, Config.TreeSide.None)
	$AudioStreamPlayerDash.max_polyphony = 30
	$AudioStreamPlayerHit.max_polyphony = 30


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CutLeft", true) and canReceiveInput:
		MoveToPosition(Config.TreeSide.Left)
		canReceiveInput = false
		ResetInputCooldown()
		PlaySounds()

	if Input.is_action_just_pressed("CutRight", true) and canReceiveInput:
		MoveToPosition(Config.TreeSide.Right)
		canReceiveInput = false
		ResetInputCooldown()
		PlaySounds()

	if volumeDB > minVolumeDB:
		volumeDB -= volumeDecreaseAmount * delta
		
		if volumeDB < minVolumeDB:
			volumeDB = minVolumeDB


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

func PlaySounds():
	dashAudioArray.shuffle()
	hitAudioArray.shuffle()

	if !$AudioStreamPlayerDash.playing:
		$AudioStreamPlayerDash.play()

	if !$AudioStreamPlayerHit.playing:
		$AudioStreamPlayerHit.play()

	var dashPlayback:AudioStreamPlayback = $AudioStreamPlayerDash.get_stream_playback()
	var hitPlayback:AudioStreamPlayback = $AudioStreamPlayerHit.get_stream_playback()
	
	$AudioStreamPlayerDash.pitch_scale = randf_range(minPitchVariation, maxPitchVariation)
	$AudioStreamPlayerHit.pitch_scale = randf_range(minPitchVariation, maxPitchVariation)
	
	$AudioStreamPlayerDash.volume_db = volumeDB - 4.0
	$AudioStreamPlayerHit.volume_db = volumeDB
	
	dashPlayback.play_stream(dashAudioArray[0])
	hitPlayback.play_stream(hitAudioArray[0])
	
	if volumeDB < maxVolumeDB:
		volumeDB += volumeIncreaseAmount
		
		if volumeDB > maxVolumeDB:
			volumeDB = maxVolumeDB


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
