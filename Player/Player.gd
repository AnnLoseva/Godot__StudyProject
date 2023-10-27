extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var double_jump = false
var flying_force = 1
var hp = 100
var alive = true
var accept_pressed_time = 0
var gold = 0

@onready var anim = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if alive == true:
			
		if not is_on_floor():
			velocity.y += gravity * delta
			anim.play("Fall")
			
		else:
			double_jump = false

		# Handle Jump.
		if Input.is_action_pressed("ui_accept"):
			accept_pressed_time += delta
			
		
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim.play("Jump")
			
		elif Input.is_action_just_pressed("ui_accept") and !double_jump:
			velocity.y = JUMP_VELOCITY
			double_jump = true
			anim.play("Jump")
			
		if Input.is_action_just_released("ui_accept"):
			accept_pressed_time = 0
			flying_force = 1
			
		if accept_pressed_time >= 0.1:
			velocity.y +=  -0.5 * gravity * delta
			flying_force = 0.8
			


		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED * flying_force
			
			if velocity.y == 0:
				anim.play("Run") 
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim.play("Idle")
			
		if direction == 1:
			$AnimatedSprite2D.flip_h = false
			
		elif direction == -1:
				$AnimatedSprite2D.flip_h = true 

		move_and_slide()
		
		if hp <= 0:
			death()
		
func death():
	alive = false
	anim.play("Death")
	await anim.animation_finished
	queue_free()
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
