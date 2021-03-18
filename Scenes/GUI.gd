extends Node2D

const LABEL_TEXT    = "You have rolled: "
const LABEL_ROLLING = "Rolling... "

var mouse_down      = Vector2.ZERO
var mouse_up        = Vector2.ZERO
var mouse_pressed   = false

signal roll_dice(mouse_down, mouse_up)

func change_label(num):
	if "0" in num: $Label.text = LABEL_ROLLING
	else: $Label.text = LABEL_TEXT + num

func _draw():
	draw_line(mouse_down, mouse_up, Color(255, 0, 0), 1)

func _input(event):
	if event is InputEventMouseButton:
		if mouse_pressed == false:
			mouse_pressed = event.pressed
			mouse_down = event.position
		if not event.pressed:
			mouse_pressed = false
			emit_signal("roll_dice", mouse_down, mouse_up)
			mouse_down = Vector2.ZERO
			mouse_up   = Vector2.ZERO
			update()
	elif event is InputEventMouseMotion:
		if mouse_pressed: 
			mouse_up = event.position
			update()
