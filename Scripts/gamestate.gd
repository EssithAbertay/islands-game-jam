extends Node

var player_score: int = 0
enum Mode {ATTACK, DEFEND}
var mode: Mode = Mode.ATTACK
var current_stage: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getRandomSpawnLocation() -> Vector3:
	return  Vector3(randf_range(-10.0, 10.0), 0, randf_range(-10, 10))
