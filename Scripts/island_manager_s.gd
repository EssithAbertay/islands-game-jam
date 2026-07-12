extends Node

@export var islandScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n in GameState.numIslandsToSpawn:
		spawnIsland()

func _process(delta: float) -> void:
	if GameState.spawnIslands:
		for n in GameState.numIslandsToSpawn:
			spawnIsland()

func spawnIsland():
	var islandSceneInstance = islandScene.instantiate()
	islandSceneInstance.position = GameState.getRandomSpawnLocation()
	islandSceneInstance.position.y +=2
	add_child(islandSceneInstance)
