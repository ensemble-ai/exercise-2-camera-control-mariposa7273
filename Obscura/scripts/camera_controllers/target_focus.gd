class_name TargetFocus
extends CameraControllerBase

@export var lead_speed:float = 60.0
@export var catchup_delay_duration: float = 0.3
@export var catchup_speed: float = 70.0
@export var leash_distance: float = 10.0
var catchup_timer: float = 0.0  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	global_position = Vector3(target.global_position.x, global_position.y, target.global_position.z)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !current:
		return

	# toggle doesn't work if I dont recheck it within each camera for some reason
	if Input.is_action_just_pressed("fire1"):
		draw_camera_logic = !draw_camera_logic

	if draw_camera_logic:
		draw_logic()

	var tpos = Vector3(target.global_position.x, global_position.y, target.global_position.z)
	var distance = global_position.distance_to(tpos)
	var lead_pos = tpos + (target.velocity.normalized() * leash_distance)
	
	if target.velocity.length() > 0:
		global_position = global_position.move_toward(lead_pos, lead_speed * delta)
		catchup_timer = 0.0
	else:
		if catchup_timer < catchup_delay_duration:
			catchup_timer += delta
		else:
			global_position = global_position.move_toward(tpos, catchup_speed * delta)

	if distance > leash_distance:
		global_position = global_position.move_toward(tpos, catchup_speed * delta)

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
