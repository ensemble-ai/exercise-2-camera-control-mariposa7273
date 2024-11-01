class_name SpeedUpPush
extends CameraControllerBase

@export var push_ratio: float = 1.0
@export var pushbox_top_left : Vector2 = Vector2(-10,10)
@export var pushbox_bottom_right: Vector2 = Vector2(10,-10)
@export var speedup_zone_top_left: Vector2 = Vector2(-5,5)
@export var speedup_zone_bottom_right:Vector2 = Vector2(5,-5)
var box_width:float = 20.0
var box_height:float = 20.0

func _ready() -> void:
	super()
	global_position = Vector3(target.global_position.x, global_position.y, target.global_position.z)


func _process(delta: float) -> void:
	if !current:
		return

	# toggle doesn't work if I dont recheck it within each camera for some reason
	if Input.is_action_just_pressed("fire1"):
		draw_camera_logic = !draw_camera_logic

	if draw_camera_logic:
		draw_logic()

	var tpos = target.global_position 
	

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -box_width / 2
	var right:float = box_width / 2
	var top:float = -box_height / 2
	var bottom:float = box_height / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
