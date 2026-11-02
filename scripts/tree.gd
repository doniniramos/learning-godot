extends Node2D

const TREE_PART_SIZE: float = 311;
const TREE_POSITION_ARRAY: Array[float] = [-298, -609, -920, -1231, -1542, -1853, -2164]

var TREE_PARTS: Array[Sprite2D]

func _ready() -> void:
	TREE_PARTS = [$tree_1, $tree_2, $tree_3, $tree_4, $tree_5, $tree_6, $tree_7]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CutLeft", true) or Input.is_action_just_pressed("CutRight", true):
		MoveAllLogsDown()

# All logs down :: Drops all logs one level
func MoveAllLogsDown():
	for treePart in TREE_PARTS:
		if (treePart.position.y + TREE_PART_SIZE > TREE_POSITION_ARRAY[0]):
			treePart.position.y = TREE_POSITION_ARRAY[TREE_POSITION_ARRAY.size()-1]
		else:
			treePart.position.y = treePart.position.y + TREE_PART_SIZE
			

# Tossing Log (Direction: Left, Right) :: Make a log sprite launch like on a projectile arc

# Generate Random Log: Generates a random log at the top
