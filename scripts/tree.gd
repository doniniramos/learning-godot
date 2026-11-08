extends Node2D

signal current_position_updated

const Config = preload("res://scripts/config.gd")

const BRANCH_X_OFFSET: float = 735.0
const TREE_PART_SIZE: float = 311;
const TREE_POSITION_ARRAY: Array[float] = [-298, -609, -920, -1231, -1542, -1853, -2164]

var TREE_PARTS: Array[Sprite2D]
var LAST_SIDE := Config.TreeSide.None
@export var CURRENT_POSITION := LAST_SIDE


func _ready() -> void:
	TREE_PARTS = [$tree_1, $tree_2, $tree_3, $tree_4, $tree_5, $tree_6, $tree_7]
	GenerateBranchesSideArray()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CutLeft", true) or Input.is_action_just_pressed("CutRight", true):
		MoveAllLogsDown()
	
# All logs down :: Drops all logs one level
func MoveAllLogsDown():
	var tween = get_tree().create_tween()
	for i in 7:
		if (TREE_PARTS[i].position.y + TREE_PART_SIZE > 0):
			TREE_PARTS[i].position.y = TREE_POSITION_ARRAY.back()
			if TREE_PARTS[i].get_child_count() > 0:
				var branches := TREE_PARTS[i].get_children()
				for branch in branches:
					branch.free()
		else:
			tween.tween_property(TREE_PARTS[i], "position", Vector2(0, TREE_POSITION_ARRAY[i-1]), 0.1).set_trans(Tween.TRANS_SPRING)
			if (i == 1):
				tween.tween_callback(func(): EmitNewPosition())
	
	AddRandomBranchSide(TREE_PARTS.size()-1)
	RelocateTreePartInArray()

# Generate Random Branch: Generates a random log at the top
func GenerateBranchesSideArray():
	for i in range(2, 7, 1):
		AddRandomBranchSide(i)
	
func AddRandomBranchSide(index: int):
	var randomGenerator := RandomNumberGenerator.new()
	var tempFloat := floori(randomGenerator.randf_range(1.0, 100.00))
	var rest := tempFloat % 3
	
	if (rest == 0 and LAST_SIDE != Config.TreeSide.Left): # Left
		var branch := Sprite2D.new()
		branch.texture = load("res://assets/branches/branch_left_1.png") # Randomizar imagens
		branch.position = Vector2(-BRANCH_X_OFFSET, 0)
		TREE_PARTS[index].add_child(branch)
		LAST_SIDE = Config.TreeSide.Left		
	
	if (rest == 1 and LAST_SIDE != Config.TreeSide.Right): # Right	
		var branch := Sprite2D.new()
		branch.texture = load("res://assets/branches/branch_right_1.png") # Randomizar imagens
		branch.position = Vector2(BRANCH_X_OFFSET, 0)
		TREE_PARTS[index].add_child(branch)
		LAST_SIDE = Config.TreeSide.Right

func RelocateTreePartInArray():
	var temp:Sprite2D = TREE_PARTS[0]
	
	TREE_PARTS.remove_at(0)
	TREE_PARTS.append(temp)
	
func EmitNewPosition():
	CURRENT_POSITION = Config.TreeSide.None
	
	if TREE_PARTS[0].get_child_count() > 0:
		if TREE_PARTS[0].get_children()[0].position.x > 0:
			CURRENT_POSITION = Config.TreeSide.Right
		else:
			CURRENT_POSITION = Config.TreeSide.Left
	
	emit_signal("current_position_updated")

# Tossing Log (Direction: Left, Right) :: Make a log sprite launch like on a projectile arc
