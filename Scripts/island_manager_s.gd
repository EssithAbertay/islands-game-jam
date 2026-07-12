extends Node

@export var islandScene: PackedScene

@export var islandSpawnCD: int = 10
var islandSpawnCdRemaining: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	islandSpawnCdRemaining += delta
	
	if(islandSpawnCdRemaining >= islandSpawnCD):
		islandSpawnCdRemaining = 0
		spawnIsland()


func spawnIsland():
	var islandSceneInstance = islandScene.instantiate()
	islandSceneInstance.position = GameState.getRandomSpawnLocation()
	
	add_child(islandSceneInstance)
	pass
