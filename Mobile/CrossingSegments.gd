extends Node
class_name CrossingSegments



func onSegment(p: Vector2, q: Vector2, r: Vector2) -> bool:
	if ((q.x <= max(p.x, r.x)) and (q.x >= min(p.x, r.x)) and (q.y <= max(p.y, r.y)) and (q.y >= min(p.y, r.y))):
		return(true)
	return(false)



func orientation(p: Vector2, q: Vector2, r: Vector2) -> int:
	var val = (float(q.y - p.y) * (r.x - q.x)) - (float(q.x - p.x) * (r.y - q.y))

	if (val > 0):
		return (1)
	elif (val < 0):
		return(2)
	else:
		return(0)



func doIntersect(p1: Vector2, q1: Vector2, p2: Vector2, q2: Vector2) -> bool:
	var o1 = orientation(p1, q1, p2)
	var o2 = orientation(p1, q1, q2)
	var o3 = orientation(p2, q2, p1)
	var o4 = orientation(p2, q2, q1)

	if ((o1 != o2) and (o3 != o4)):
		return(o4)

	if ((o1 == 0) and onSegment(p1, p2, q1)):
		return(o4)

	if ((o2 == 0) and onSegment(p1, q2, q1)):
		return(o4)

	if ((o3 == 0) and onSegment(p2, p1, q2)):
		return(o4)

	if ((o4 == 0) and onSegment(p2, q1, q2)):
		return(o4)

	return(false)
