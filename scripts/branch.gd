extends Node2D

const Config = preload("res://scripts/config.gd")

@export var BranchSide := Config.TreeSide.None

var Rest := 99

func _ready() -> void:
	if Rest == 99:
		var randomGenerator := RandomNumberGenerator.new()
		var tempFloat := floori(randomGenerator.randf_range(1.0, 100.00))
		Rest = (tempFloat % 5)+1
	
	if BranchSide == Config.TreeSide.Left:
		var branchTexture: Texture2D = load("res://assets/branches/branch_left_%s.png"%Rest)
		$Sprite2D.texture = branchTexture
	
	if BranchSide == Config.TreeSide.Right:
		var branchTexture: Texture2D = load("res://assets/branches/branch_right_%s.png"%Rest)
		$Sprite2D.texture = branchTexture
	
	$CollisionShape2D.shape.set("size", Vector2($Sprite2D.texture.get_size().x, 125.0))

func GetBranchSize() -> float:
	return $Sprite2D.texture.get_size().x
