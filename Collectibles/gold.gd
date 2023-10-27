extends Area2D



func _on_body_entered(body):
	if body.name == "Player":
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0, 25), 0.3)
		body.gold += 1
		tween.tween_callback(queue_free)
		
