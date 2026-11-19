extends Node

enum AnimationState {Idle, Chop, Hit, Dead}
enum TreeSide {Left, Right, None}

const HIT_FREEZE_TIME = 0.3
const INPUT_COOLDOWN_TIME = 0.03
