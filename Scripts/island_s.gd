extends Node

@export var enemy_spawn_rate:float = 1
var enemy_spawn_cd = 0

@export var boat: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	enemy_spawn_cd += delta
	if(enemy_spawn_cd >= enemy_spawn_rate):
		enemy_spawn_cd = 0
	
		var boat_instance = boat.instantiate()
		boat_instance.global_position.y=0
		add_child(boat_instance)
		
	
	pass
