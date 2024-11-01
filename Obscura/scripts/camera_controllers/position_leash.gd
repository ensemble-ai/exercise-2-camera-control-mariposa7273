class_name PositionLeash
extends CameraControllerBase

@export var follow_speed: float = 30.0
@export var catchup_speed: float = 70.0
@export var leash_distance: float = 10.0

func _ready() -> void:
	super()


func _process(delta: float) -> void:
	if !current:
		return

	# toggle doesn't work if I dont recheck it within each camera for some reason
	if Input.is_action_just_pressed("fire1"):
		draw_camera_logic = !draw_camera_logic

	if draw_camera_logic:
		draw_logic()

	# starter variable for target location and distance
	var tpos = Vector3(target.global_position.x, global_position.y, target.global_position.z)
	var distance = global_position.distance_to(tpos)
	
	if distance > leash_distance:
		# if out of leash distance move towards target using catcup speed
		global_position = global_position.move_toward(tpos, catchup_speed * delta)
	else:
		# a check to stop stuttering if target is close enough to camera center and not moving
		if distance < 1 and target.velocity.length() == 0:
			global_position = tpos
		# moves the camera according to the directionm the target is going and follow speed
		var direction = (tpos - global_position).normalized()
		global_position += direction * follow_speed * delta


func draw_logic():
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	var cross_length: float = 5.0 

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	immediate_mesh.surface_add_vertex(Vector3(-cross_length, 0, 0))  
	immediate_mesh.surface_add_vertex(Vector3(cross_length, 0, 0)) 

	immediate_mesh.surface_add_vertex(Vector3(0, 0, -cross_length))  
	immediate_mesh.surface_add_vertex(Vector3(0, 0, cross_length))   

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
