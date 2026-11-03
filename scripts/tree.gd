extends Node2D

signal current_position_updated

const Config = preload("res://scripts/config.gd")

const TREE_PART_SIZE: float = 311;
const TREE_POSITION_ARRAY: Array[float] = [-298, -609, -920, -1231, -1542, -1853, -2164]

const BRANCH_X_OFFSET: float = 735.0

var TREE_PARTS: Array[Sprite2D]
var CURRENT_BRANCH_INDEX := 0
var LAST_SIDE := Config.TreeSide.None

@export var CURRENT_POSITION := Config.TreeSide.None

func _ready() -> void:
	TREE_PARTS = [$tree_1, $tree_2, $tree_3, $tree_4, $tree_5, $tree_6, $tree_7]
	GenerateBranchesSideArray()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CutLeft", true) or Input.is_action_just_pressed("CutRight", true):
		MoveAllLogsDown()
		AddRandomBranchSide()
	
# All logs down :: Drops all logs one level
func MoveAllLogsDown():
	for treePart in TREE_PARTS:
		if (treePart.position.y + TREE_PART_SIZE > 0):
			treePart.position.y = TREE_POSITION_ARRAY.back()
			if treePart.get_child_count() > 0:
				var branches := treePart.get_children()
				for branch in branches:
					branch.free()
		else:
			treePart.position.y = treePart.position.y + TREE_PART_SIZE

# Generate Random Branch: Generates a random log at the top
func GenerateBranchesSideArray():
	for i in 7:
		AddRandomBranchSide()
	
func AddRandomBranchSide():
	var randomGenerator := RandomNumberGenerator.new()
	var tempFloat := floori(randomGenerator.randf_range(1.0, 100.00))
	var rest := tempFloat % 3
	
	if (rest == 0 and LAST_SIDE != Config.TreeSide.Left): # Left
		var branch := Sprite2D.new()
		branch.texture = load("res://assets/branches/branch_left_1.png")
		branch.position = Vector2(-BRANCH_X_OFFSET, 0)
		TREE_PARTS[CURRENT_BRANCH_INDEX].add_child(branch)
		LAST_SIDE = Config.TreeSide.Left
	elif (rest == 1 and LAST_SIDE != Config.TreeSide.Right): # Right		
		var branch := Sprite2D.new()
		branch.texture = load("res://assets/branches/branch_right_1.png")
		branch.position = Vector2(BRANCH_X_OFFSET, 0)
		TREE_PARTS[CURRENT_BRANCH_INDEX].add_child(branch)
		LAST_SIDE = Config.TreeSide.Right
	else:
		LAST_SIDE = Config.TreeSide.None

	ShiftCurrentIndex()

func ShiftCurrentIndex():
	CURRENT_BRANCH_INDEX += 1
	
	if CURRENT_BRANCH_INDEX >= TREE_PARTS.size():
		CURRENT_BRANCH_INDEX = 0
	
	CURRENT_POSITION = GetCurrentPosition()

func GetCurrentPosition() -> Config.TreeSide:
	if TREE_PARTS[CURRENT_BRANCH_INDEX].get_child_count() > 0:
		if TREE_PARTS[CURRENT_BRANCH_INDEX].get_children()[0].position.x > 0:
			return Config.TreeSide.Right
		else:
			return Config.TreeSide.Left
	return Config.TreeSide.None

# Tossing Log (Direction: Left, Right) :: Make a log sprite launch like on a projectile arc
