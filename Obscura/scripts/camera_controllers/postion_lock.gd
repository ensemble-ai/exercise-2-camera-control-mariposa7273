class_name PositionLock
extends CameraControllerBase

@export var box_width:float = 10.0
@export var box_height:float = 10.0
@export var speed: float = 5.0 
var velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	super()
	

func _process(delta: float) -> void:
	if !current:
		return

	if draw_camera_logic:
		draw_logic()
		
	global_transform.origin = Vector3(target.global_transform.origin.x, global_transform.origin.y, target.global_transform.origin.z)

	# Update camera velocity based on the Vessel's velocity
	velocity.x = target.velocity.x * speed
	velocity.z = target.velocity.z * speed

	# Update camera position
	global_transform.origin += velocity * delta
	


func draw_logic():
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	# Calculate the length of the cross arms
	var cross_length: float = 5.0  # You can adjust this as needed

	# Begin drawing lines for the cross
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Draw horizontal line
	immediate_mesh.surface_add_vertex(Vector3(-cross_length, 0, 0))  # Left end of the cross
	immediate_mesh.surface_add_vertex(Vector3(cross_length, 0, 0))   # Right end of the cross

	# Draw vertical line
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -cross_length))  # Bottom end of the cross
	immediate_mesh.surface_add_vertex(Vector3(0, 0, cross_length))   # Top end of the cross

	immediate_mesh.surface_end()

	# Set the material properties
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	# Position the mesh instance at the desired position
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
