extends Area3D

@export var point_value: int = 10
@onready var sand_sphere: MeshInstance3D = $"Sand Sphere"
var volume: float = 0

func _ready() -> void:
	if sand_sphere:
		var radius = sand_sphere.mesh.radius * point_value
		volume = (4.0 / 3.0) * PI * pow(radius, 3)

	
