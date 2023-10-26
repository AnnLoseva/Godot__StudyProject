extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var double_jump = false
var is_flying = false
var flying_force = -200
var hp = 100
var alive = true

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
			is_flying = false

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim.play("Jump")
			
		elif Input.is_action_just_pressed("ui_accept") and !double_jump:
			velocity.y = JUMP_VELOCITY
			double_jump = true
			anim.play("Jump")

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			
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
