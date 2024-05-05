extends CanvasLayer

@onready var textbox_container = $TextboxContainer
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

var text_queue = []

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_textbox()
	
func _process(_delta):
	if !text_queue.is_empty() and Input.is_action_just_pressed("Interact"):
		display_text()
	elif text_queue.is_empty() and Input.is_action_just_pressed("Interact"):
		hide_textbox()

func hide_textbox():
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	textbox_container.show()
	
func display_text():
	var text = text_queue.pop_front()
	label.text = text
	show_textbox()
	
func queue_text(text):
	text_queue.push_back(text)
	
