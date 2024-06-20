extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fall():
	$AnimationPlayer.play("tree_fall")

func hit():
	$AnimationPlayer.play("tree_hit")
	await get_tree().create_timer(3).timeout
	fall()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
