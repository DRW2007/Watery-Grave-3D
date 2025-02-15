extends KinematicBody


export var mouse_sensitivity = 0.03

export var speed = 15

export var swim_up_divider = 1.5 #this value was originally in like 34 but i changed it to an export variable for quick moving

onready var head = $Head

var h_acceleration = 2

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _physics_process(delta):
	
	direction = Vector3()
	
	direction += head.global_transform.basis.z * ((-Input.get_action_strength("move_forward")) + Input.get_action_strength("move_backward"))
	direction += head.global_transform.basis.x * (-Input.get_action_strength("move_left")) + head.global_transform.basis.x * Input.get_action_strength("move_right")
	
	direction.y += (Input.get_action_strength("swim_up") - Input.get_action_strength("swim_down"))/swim_up_divider #I believed that all possible adjustable values should not be magic numbers
	
	direction = direction.normalized()
	
	h_velocity += direction * speed * delta
	h_velocity = h_velocity.linear_interpolate(Vector3.ZERO, h_acceleration*delta)
	movement.z = h_velocity.z
	movement.x = h_velocity.x
	movement.y = h_velocity.y
	
	move_and_slide(movement, Vector3.UP)
