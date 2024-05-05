extends Node2D

@onready var game_start_textbox = $"Game Start Textbox"

# Called when the node enters the scene tree for the first time.
func _ready():
	game_start_textbox.queue_text("Directions: arrow keys to move and jump, space bar to interact and move through text boxes")
	game_start_textbox.queue_text("Your witch has been sick and bedridden for some days now.")
	game_start_textbox.queue_text("Today's goal: cheer her up a little!")
	game_start_textbox.display_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
