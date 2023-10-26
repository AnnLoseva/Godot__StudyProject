extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var speed = 100
var chase = false
var alive = true
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	if alive == true:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
		var player = $"../../Player/Player"
		var direction = (player.position - self.position).normalized()
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		if chase == true:
			velocity.x = direction.x * speed
			anim.play("Run")
		else:
			velocity.x = 0
			anim.play("Idle")
		move_and_slide()


func _on_detector_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_detector_body_exited(body):
	if body.name == "Player":
		chase = false

func death():
	alive = false
	anim.play("Death")
	await anim.animation_finished
	queue_free()

func _on_death_box_body_entered(body):
	if body.name == "Player" and alive == true:
		body.velocity.y = -300
		$CollisionShape2D.queue_free()
		death()


func _on_hit_enemy_box_body_entered(body):
	if body.name == "Player" and alive == true:
		var direction = (body.position - self.position).normalized()
		body.velocity.x = direction.x * 1000
		body.hp -= 40
		$CollisionShape2D.queue_free()
		death()
