extends Node

@export var boat: PackedScene
@export var point_value: int = 100
var volume: float = 0
@onready var island_sphere: CollisionShape3D = $"Area3D/Island Sphere"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sphere_shape = island_sphere.shape as SphereShape3D
	var radius = sphere_shape.radius * island_sphere.scale.x
	volume = (4.0 / 3.0) * PI * pow(radius, 3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# only spawn enemies when in defence mode
	if(GameState.spawnWave):
			var boat_instance = boat.instantiate()
			add_child(boat_instance)
			boat_instance.global_position.y = -1
