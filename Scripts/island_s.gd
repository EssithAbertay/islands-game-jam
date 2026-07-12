extends Node

@export var boat: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# only spawn enemies when in defence mode
	if(GameState.spawnWave):
			var boat_instance = boat.instantiate()
			add_child(boat_instance)
			boat_instance.global_position.y = -1
