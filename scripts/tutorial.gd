extends Control

@onready var chopLeft := $Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/TextureRectLeft
@onready var chopRight := $Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/TextureRectRight

const tweenSpeed := 0.2
const tweenInterval := 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree():
		move_buttons(true)


func move_buttons(up: bool):
	if get_tree():
		await get_tree().create_timer(tweenInterval).timeout

	var tween := get_tree().create_tween().set_parallel(true)

	if up:
		tween.tween_property(chopLeft, "offset_transform_position", Vector2(0, 0), tweenSpeed).set_trans(Tween.TRANS_SINE)
		tween.tween_property(chopRight, "offset_transform_position", Vector2(0, -10), tweenSpeed).set_trans(Tween.TRANS_SINE)
		tween.tween_property(chopLeft, "offset_transform_scale", Vector2(1, 1), tweenSpeed).set_trans(Tween.TRANS_SINE)
		tween.tween_property(chopRight, "offset_transform_scale", Vector2(1.1, 1.1), tweenSpeed).set_trans(Tween.TRANS_SINE)
		
		tween.chain().tween_callback(move_buttons.bind(false))
	else:
		tween.tween_property(chopLeft, "offset_transform_position", Vector2(0, -10), tweenSpeed).set_trans(Tween.TRANS_SINE)
		tween.tween_property(chopRight, "offset_transform_position", Vector2(0, 0), tweenSpeed).set_trans(Tween.TRANS_SINE)
		tween.tween_property(chopLeft, "offset_transform_scale", Vector2(1.1, 1.1), tweenSpeed).set_trans(Tween.TRANS_SINE)
		tween.tween_property(chopRight, "offset_transform_scale", Vector2(1, 1), tweenSpeed).set_trans(Tween.TRANS_SINE)
		
		tween.chain().tween_callback(move_buttons.bind(true))
