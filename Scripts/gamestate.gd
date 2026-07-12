extends Node

var player_score: int = 0
enum Mode {ATTACK, DEFEND, SETUP, SETUPATTACK}
var mode: Mode = Mode.ATTACK
var swapping_mode: bool = false
var current_stage: int = 0
var turretCost:int = 10
var turretCostScaling = 1.1
var spawnWave: bool = false
var numberOfWavesToSpawn: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getRandomSpawnLocation() -> Vector3:
	return  Vector3(randf_range(-294.0,294.0), 0, randf_range(-191, 191))
