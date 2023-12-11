class_name Cam
extends Camera3D

@onready var ball: Ball = get_parent()

const ray_length = 100
const ray_collision_layer = 2

func _ready() -> void:
	# set the camera as top level to ignore parent's transformations. 
	self.set_as_top_level(true)

func _process(delta) -> void:
	transform.origin = transform.origin.lerp(Vector3(ball.transform.origin.x, position.y, ball.transform.origin.z), 1)

# translates the screen position into 3d world position.
func raycast() -> Dictionary:
	var screen_pos: Vector2 = get_viewport().get_mouse_position()
	var from: Vector3 = project_ray_origin(screen_pos) 
	var to: Vector3 = from + project_ray_normal(screen_pos) * ray_length
	var space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to, ray_collision_layer)
	return space.intersect_ray(query)
