extends Node2D

signal current_position_updated

const Config = preload("res://scripts/config.gd")
const Branch = preload("res://entities/branch.tscn")

const TREE_PART_SIZE: float = 311;
const TREE_POSITION_ARRAY: Array[float] = [-298, -609, -920, -1231, -1542, -1853, -2164]

var TREE_PARTS: Array[Sprite2D]
var LAST_SIDE := Config.TreeSide.None

func _ready() -> void:
	TREE_PARTS = [$tree_1, $tree_2, $tree_3, $tree_4, $tree_5, $tree_6, $tree_7]
	GenerateBranchesSideArray()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CutLeft", true):
		MoveAllLogsDown(Config.TreeSide.Left)
	if Input.is_action_just_pressed("CutRight", true):
		MoveAllLogsDown(Config.TreeSide.Right)
	
# All logs down :: Drops all logs one level
func MoveAllLogsDown(side: Config.TreeSide):
	var tween := get_tree().create_tween()
	for i in 7:
		if (TREE_PARTS[i].position.y + TREE_PART_SIZE > 0):
			TREE_PARTS[i].position = Vector2(0, TREE_POSITION_ARRAY.back())
			
			if TREE_PARTS[i].get_child_count() > 0:
				var branches := TREE_PARTS[i].get_children()
				for branch in branches:
					branch.free()
		else:
			tween.tween_property(TREE_PARTS[i],"position", Vector2(0, TREE_POSITION_ARRAY[i-1]), 0.05).set_trans(Tween.TRANS_SPRING)

	AddRandomBranchSide(TREE_PARTS.size()-1)
	RelocateTreePartInArray()

# Generate Random Branch: Generates a random log at the top
func GenerateBranchesSideArray():
	for i in range(2, 7, 1):
		AddRandomBranchSide(i)
	
# Attach Random Branch to Tree
func AddRandomBranchSide(index: int):
	var randomGenerator := RandomNumberGenerator.new()
	var tempFloat := floori(randomGenerator.randf_range(1.0, 100.00))
	var rest := tempFloat % 3
	
	const XOffset := 10.0
	const ScaleOffset := 0.88
	
	if (rest == 0 and LAST_SIDE != Config.TreeSide.Left): # Left
		var branch = Branch.instantiate()
		branch.BranchSide = Config.TreeSide.Left
		branch.position = Vector2(-branch.get_node("Sprite2D").texture.get_size().x*ScaleOffset+XOffset, 0)
		TREE_PARTS[index].add_child(branch)
		LAST_SIDE = Config.TreeSide.Left
	
	if (rest == 1 and LAST_SIDE != Config.TreeSide.Right): # Right
		var branch = Branch.instantiate()
		branch.BranchSide = Config.TreeSide.Right
		branch.position = Vector2(branch.get_node("Sprite2D").texture.get_size().x*ScaleOffset+XOffset, 0)
		TREE_PARTS[index].add_child(branch)
		LAST_SIDE = Config.TreeSide.Right

# Move Tree Part from Start to End of Tree Parts Array
func RelocateTreePartInArray():
	var temp:Sprite2D = TREE_PARTS[0]
	
	TREE_PARTS.remove_at(0)
	TREE_PARTS.append(temp)

# Tossing Log (Direction: Left, Right) :: Make a log sprite launch like on a projectile arc
