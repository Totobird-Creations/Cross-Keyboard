tool
extends Control



func update() -> void:
	var size

	size = self.rect_size
	if (size.x < size.y):
		$Square.rect_size = Vector2(size.x, size.x)
		$Square.rect_position = Vector2(0, (size.y - size.x) / 2)
	else:
		$Square.rect_size     = Vector2(size.y, size.y)
		$Square.rect_position = Vector2((size.x - size.y) / 2, 0)

	size = $Square/Scaling/Cross.rect_size
	$Square/Scaling/Collision/Center.position = Vector2(size.x / 2.0, size.y / 2.0)
	$Square/Scaling/Collision/Center/Circle.shape.radius = size.x * 0.1
	$Square/Scaling/Collision/Center/TopLeft.points = PoolVector2Array([
		Vector2(-size.x * 0.25, -size.y * 0.25),
		Vector2(-size.x * 0.07, -size.y * 0.07)
	])
	$Square/Scaling/Collision/Center/TopRight.points = PoolVector2Array([
		Vector2(size.x * 0.25, -size.y * 0.25),
		Vector2(size.x * 0.07, -size.y * 0.07)
	])
	$Square/Scaling/Collision/Center/BottomRight.points = PoolVector2Array([
		Vector2(size.x * 0.25, size.y * 0.25),
		Vector2(size.x * 0.07, size.y * 0.07)
	])
	$Square/Scaling/Collision/Center/BottomLeft.points = PoolVector2Array([
		Vector2(-size.x * 0.25, size.y * 0.25),
		Vector2(-size.x * 0.07, size.y * 0.07)
	])

	$ControlButton.margin_top   = (-$Square/Scaling/Return.rect_size.y) - 10
	$ControlButton.margin_right =  $Square/Scaling/Return.rect_size.x + 10

	$ShiftButton.margin_top   = (2 * -$Square/Scaling/Return.rect_size.y) - 15
	$ShiftButton.margin_bottom   = (-$Square/Scaling/Return.rect_size.y) - 15
	$ShiftButton.margin_right =  $Square/Scaling/Return.rect_size.x + 10

	$ModButton.margin_top   = (-$Square/Scaling/Return.rect_size.y) - 10
	$ModButton.margin_left   = ($Square/Scaling/Return.rect_size.x) + 15
	$ModButton.margin_right =  (2 * $Square/Scaling/Return.rect_size.x) + 15

	$AlternativeButton.margin_top   = (-$Square/Scaling/Return.rect_size.y) - 10
	$AlternativeButton.margin_left   = (2 * $Square/Scaling/Return.rect_size.x) + 20
	$AlternativeButton.margin_right =  (3 * $Square/Scaling/Return.rect_size.x) + 20
