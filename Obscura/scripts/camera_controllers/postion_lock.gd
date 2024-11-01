class_name PositionLock
extends CameraControllerBase

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

	# gets the postion of the target and makes it the camera postition and adds in target velocity
	global_position = Vector3(target.global_position.x, global_position.y, target.global_position.z)
	global_position += target.velocity * delta


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
