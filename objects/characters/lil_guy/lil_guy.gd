extends CharacterBody3D

var clickables : Array
var current_target : Vector3
var new_target : Vector3
var task_list : Array
@export var marker_mesh : MeshInstance3D
@onready var path_find : NavigationAgent3D = get_node("NavigationAgent3D")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	clickables = get_tree().get_nodes_in_group("clickable")
	for clickable : CollisionObject3D in clickables:
		clickable.input_event.connect(_on_click)


func _process(delta):
	
	pass
	

func _physics_process(delta):
	if new_target != current_target:
		path_find.target_position = new_target
		current_target = new_target
	
	if not path_find.is_navigation_finished():
		var path_pos = path_find.get_next_path_position()
		look_at(path_pos)
		velocity = -transform.basis.z * SPEED
	else:
		velocity = Vector3.ZERO
	move_and_slide()
	


func _on_click(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		new_target = click_position
		marker_mesh.global_position = click_position
		print(click_position)


func _on_area_detect_body_entered(body):
	if body.is_in_group("tree") and not task_list.find(Callable(self, "chop")):
		var callable = Callable(self, "chop")
		
		task_list.append(callable)
	pass # Replace with function body.
