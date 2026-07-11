extends Node

var pickup = preload("res://Scenes/points_pickup.tscn")
var timerMax: float = 3
var timer: float = 0
var spawnLocation: Vector3 = Vector3(0,0,0)
var spawnSize: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	timer += delta
	if (timer >= timerMax):
		timer = 0
		spawnPickup()
	
	pass


func spawnPickup():
	var new_pickup = pickup.instantiate()
	spawnLocation = Vector3(randf_range(-10.0, 10.0), 0, randf_range(-10.0, 10.0))
	spawnSize = randf_range(1, 10.0)
	new_pickup.global_position = spawnLocation
	new_pickup.scale = Vector3(spawnSize, spawnSize, spawnSize)
	add_child(new_pickup)
