extends Node3D

@export var damage = 10
@export var fireCd:float = 1
@export var fireRadius = 5

var fireCdRemaining = 0

var enemies: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D/CollisionShape3D.shape.radius = fireRadius

func draw_range_circle():
	var mesh = ImmediateMesh.new()
	var mat = StandardMaterial3D.new()
	
	mat.albedo_color = Color(0, 1, 0)
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, mat)

	for i in range(65):
		var angle = TAU * i / 64
		mesh.surface_add_vertex(Vector3(
			cos(angle) * fireRadius,
			0.05,
			sin(angle) * fireRadius
		))

	mesh.surface_end()

	$RangeIndicator.mesh = mesh


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fireCdRemaining += delta
	
	# check if can fire, if so deal damage to closest enemy and reset timer
	if(fireCdRemaining >= fireCd):
		fireCdRemaining = 0
		var target = get_closest_enemy()
		if target is Enemy:
			target.takeDamage(damage)
			shoot(target)
			
	draw_range_circle()


func get_closest_enemy():
	var closest_enemy = null
	var closest_distance = INF

	for enemy in enemies:
		if is_instance_valid(enemy):
			var distance = global_position.distance_squared_to(enemy.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy

	return closest_enemy

func shoot(body: Node3D):
	var start = global_position
	var end = body.global_position
	
	var startrot: Vector3 = Vector3(start.x,0,start.z)
	var endtrot: Vector3 = Vector3(end.x,0,end.z)
	
	look_at(endtrot,startrot)
	rotation.z -= PI/2
	rotation.x-= PI
	
	
	spawn_tracer(start,end)
	
	
func spawn_tracer(start: Vector3, end: Vector3):
	var mesh_instance = MeshInstance3D.new()
	var immediate_mesh = ImmediateMesh.new()
	var material = StandardMaterial3D.new()

	material.albedo_color = Color.YELLOW
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(start)
	immediate_mesh.surface_add_vertex(end)
	immediate_mesh.surface_end()

	mesh_instance.mesh = immediate_mesh
	get_tree().current_scene.add_child(mesh_instance)

	await get_tree().create_timer(0.05).timeout
	mesh_instance.queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		enemies.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		enemies.erase(body)
