class_name Ball
extends RigidBody3D

@export var max_speed : int = 8
@export var accel : int = 5

@onready var power_scaler: Marker3D = get_node("power_scaler")
@onready var cam: Cam = get_node("cam")

var selected: bool = false
var distance: float
var direction: Vector3

func _ready() -> void:
	# set as top level to ignore parent's transformations.
	power_scaler.set_as_top_level(true)

func _input(event) -> void:
	if event.is_action_released("left_mb"):
		if selected:
			var impulse: Vector3 = - (direction * distance * accel).limit_length(max_speed)
			apply_impulse(Vector3(impulse.x, 0, impulse.z), Vector3.ZERO)
		selected = false

func _process(delta) -> void:
	power_scaler.transform.origin = power_scaler.transform.origin.lerp(transform.origin,.8)
	display_power_scaler()

# displays power scaler when you click and pull
func display_power_scaler() -> void:
	var result: Dictionary = cam.raycast()
	
	if not result.is_empty():
		var target_pos: Vector3 = result["position"]
		distance = position.distance_to(target_pos)
		direction = transform.origin.direction_to(target_pos)
		power_scaler.look_at(Vector3(target_pos.x, position.y, target_pos.z))
		
		if selected:
			power_scaler.scale.z = clamp(distance, 0, 2)
			return
		power_scaler.scale.z = 0.01

func _on_input_event(camera, event, position, normal, shape_idx) -> void:
	if event.is_action_pressed("left_mb"):
		selected = true
