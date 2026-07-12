extends Area3D

@export var point_value: int
@onready var sand_sphere: MeshInstance3D = $"Sand Sphere"
var volume: float = 0

func _ready() -> void:
	if sand_sphere:
		var radius = sand_sphere.mesh.radius * (point_value/5) #its mult by 5 in manager so div by 5 cos too lazt to fix
		volume = (4.0 / 3.0) * PI * pow(radius, 3)

	
