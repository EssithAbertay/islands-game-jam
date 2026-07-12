extends Node

var pickup = preload("res://Scenes/points_pickup.tscn")
@export var timerMax: float = 3
@export var maxToSpawn: int = 2
@export var minToSpawn: int = 2

var timer: float = 0
var spawnLocation: Vector3 = Vector3(0,0,0)
var spawnSize: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(GameState.mode == GameState.Mode.ATTACK):
		timer += delta
		if (timer >= timerMax):
			timer = 0
			
			var spawning = randi_range(minToSpawn,maxToSpawn)
			for n in spawning:
				spawnPickup()


func spawnPickup():
	var new_pickup = pickup.instantiate()
	add_child(new_pickup)
	spawnLocation = GameState.getRandomSpawnLocation()
	spawnSize = floor(randf_range(1, 5.0))
	new_pickup.global_position = spawnLocation
	new_pickup.scale = Vector3(spawnSize, spawnSize, spawnSize)
	new_pickup.point_value = spawnSize;
	
