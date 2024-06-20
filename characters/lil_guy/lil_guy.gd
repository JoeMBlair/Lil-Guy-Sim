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
	if task_list:
		task_list[0][0].call(task_list[0][1])
	pass


func _physics_process(delta):
	if not path_find.is_navigation_finished():
		var path_pos = path_find.get_next_path_position()
		look_at(Vector3(path_pos.x, 0, path_pos.z))
		velocity = -transform.basis.z * SPEED
	else:
		velocity = Vector3.ZERO
	move_and_slide()


func chop(tree : StaticBody3D):
	update_target(tree.global_position)
	
	if path_find.is_navigation_finished():
		tree.hit()
		task_list.remove_at(0)

func update_target(target : Vector3):
	if target != current_target:
		path_find.target_position = target
		current_target = target


func _on_click(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		update_target(click_position)
		marker_mesh.global_position = click_position


func _on_area_detect_body_entered(body):
	if body.is_in_group("tree"):
		var callable = [Callable(self, "chop"), body]
		
		task_list.append(callable)
	pass # Replace with function body.
