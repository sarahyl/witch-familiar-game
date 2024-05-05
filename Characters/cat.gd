extends CharacterBody2D

@export var speed : float = 200.0
@export var jump_velocity : float = -200.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var all_interactions = []
@onready var interact_label = $"Interaction/InteractLabel"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var last_action : String = "none"
var held_item = null
var force_coefficient = 0.001

func _ready():
	update_interactions()

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		last_action = "jump"
		velocity.y = jump_velocity
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if Input.is_action_just_pressed("Interact"):
		execute_interaction()
		
	if held_item:
		held_item.position.y = 6


	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * force_coefficient)

	update_animation()
	update_facing_direction()
	move_and_slide()
	

func update_animation():
	if not animation_locked:
		if direction.x != 0:
			last_action = "move"
			animated_sprite.play("Run")
		elif last_action == "cuddle":
			animated_sprite.play("Loaf")
		else:
			animated_sprite.play("Idle")
			
func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
		if held_item:
			held_item.position.x = 5
	elif direction.x < 0:
		animated_sprite.flip_h = true
		if held_item:
			held_item.position.x = -5


#Interaction
func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	update_interactions()


func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interactions()

func update_interactions():
	if all_interactions:
		interact_label.text = all_interactions[0].interact_label #display text for interaction
	else: 
		interact_label.text = ""
		
func execute_interaction():
	#idea: if held_item != "none" then drop item (reparent). elif all_interactions;
	if held_item:
		#drop item
		held_item.get_node("CollisionShape2D").disabled = false
		held_item.reparent($"/root/Scene1")
		held_item.position.x = self.position.x
		held_item.position.y = self.position.y
		held_item = null
	elif all_interactions:
		var current_interaction = all_interactions[0]
		match current_interaction.interact_type:
			"animation":
				last_action = current_interaction.interact_value
			"pick up":
				held_item = get_node("../" + current_interaction.interact_value)
				get_node("../" + current_interaction.interact_value + "/CollisionShape2D").disabled = true
				held_item.reparent(self) #held_item becomes child of player node
				held_item.position.x = -5
				held_item.position.y = 6

				
