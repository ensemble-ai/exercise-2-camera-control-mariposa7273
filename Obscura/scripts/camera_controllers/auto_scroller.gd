class_name AutoScroller
extends CameraControllerBase

@export var box_width:float = 10.0
@export var box_height:float = 10.0
@export var top_left: Vector2 = Vector2(-5,5)
@export var bottom_right: Vector2 = Vector2(5,-5)
@export var autoscroll_speed:Vector3 = Vector3(5, 0, 0)


func _ready() -> void:
	super()
	draw_camera_logic = true
	global_position = Vector3(target.global_position.x, global_position.y, target.global_position.z)


func _process(delta: float) -> void:
	if !current:
		return

	if Input.is_action_just_pressed("fire1"):
		draw_camera_logic = !draw_camera_logic

	if draw_camera_logic:
		draw_logic()

	global_position += autoscroll_speed * delta

	top_left = Vector2(global_position.x - box_width / 2, global_position.z + box_height / 2)
	bottom_right = Vector2(global_position.x + box_width / 2, global_position.z - box_height / 2)

	var tpos = target.global_position 

	#left
	if tpos.x < top_left.x + target.WIDTH / 2.0:
		tpos.x = top_left.x + target.WIDTH / 2.0

	#right
	if tpos.x > bottom_right.x - target.WIDTH / 2.0:
		tpos.x = bottom_right.x - target.WIDTH / 2.0
	
	#top
	if tpos.z < bottom_right.y + target.HEIGHT / 2.0:
		tpos.z = bottom_right.y + target.HEIGHT / 2.0

	#bottom
	if tpos.z > top_left.y - target.HEIGHT / 2.0:
		tpos.z = top_left.y - target.HEIGHT / 2.0

	target.global_position = tpos


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
