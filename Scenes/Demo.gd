extends Spatial

func _ready():
	randomize()
	$Camera/GUI.change_label("0")
	get_node("Camera/GUI").connect("roll_dice", self, "_on_roll_dice")
	pass # Replace with function body.

func _on_roll_dice(mouse_down, mouse_up):
	if $RigidBody.roll == false and $RigidBody.dice_moving == false and $RigidBody2.dice_moving == false:
		$RigidBody.roll = true
		$RigidBody.power = (mouse_up - mouse_down).normalized()
		
	if $RigidBody2.roll == false and $RigidBody.dice_moving == false and $RigidBody2.dice_moving == false:
		$RigidBody2.roll = true
		$RigidBody2.power = (mouse_up - mouse_down).normalized()
		
func _process(delta):
	$Camera/GUI.change_label("" + str($RigidBody.dice_result) + " + " + str($RigidBody2.dice_result))

func _dice_physics(body):
	if body.get_angular_velocity().length_squared() + body.get_linear_velocity().length_squared() < 0.01: 
		body.dice_moving = false
		if body.transform.basis.y.y>0.99:    body.dice_result = 2 # top
		elif body.transform.basis.y.y<-0.99: body.dice_result = 5 # bottom
		elif body.transform.basis.x.y>0.99:  body.dice_result = 1 # right
		elif body.transform.basis.x.y<-0.99: body.dice_result = 6 # left
		elif body.transform.basis.z.y>0.99:  body.dice_result = 3 # front
		elif body.transform.basis.z.y<-0.99: body.dice_result = 4 # back
		else: body.dice_result = 0
	else:
		body.dice_moving = true
		body.dice_result = 0
	if body.roll:
		#$RigidBody.global_transform = _initial_transform
		body.roll = false
		body.apply_central_impulse(Vector3(-body.translation.x*0.33, 0, -body.translation.z*0.33))
		body.apply_central_impulse(Vector3(0, randf()*10.0+5.0, 0))
		body.apply_torque_impulse(Vector3(body.power.y*(randf()*10.0+5.0),0,-body.power.x*(randf()*10.0+5.0)))

func _physics_process(delta):
	_dice_physics($RigidBody)
	_dice_physics($RigidBody2)
