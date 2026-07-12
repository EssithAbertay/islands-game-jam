extends Node

@export var islandScene: PackedScene

@export var islandNumbers: int = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n in islandNumbers:
		spawnIsland()

func spawnIsland():
	var islandSceneInstance = islandScene.instantiate()
	islandSceneInstance.position = GameState.getRandomSpawnLocation()
	islandSceneInstance.position.y +=2
	add_child(islandSceneInstance)
