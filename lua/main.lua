-- 
-- Abstract: shapes Library Plugin Test Project
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2015 Corona Labs Inc. All Rights Reserved.
--
------------------------------------------------------------

-- Load plugin library
local shapes = require "plugin.shapes"

-------------------------------------------------------------------------------
-- BEGIN (Insert your sample test starting here)
-------------------------------------------------------------------------------
local screenW, screenH = display.contentWidth, display.contentHeight
local halfW, halfH = display.contentCenterX, display.contentCenterY


local w, h = 50, 50
local x, y = display.contentCenterX, display.contentCenterY
local radius = screenH*.1

local arc = shapes.newArc({
	start_angle = 20,
	end_angle = 90,
	radius = radius,
	stroke = 5,
})
arc.anchorX = 0
arc.anchorY = 1
arc.x, arc.y = halfW, screenH*.05

local dot1 = shapes.newDot({x=arc.x, y=arc.y})

local hexagon = shapes.newRegularPolygon({
	nb = 8,
	radius = radius
})

hexagon.x, hexagon.y = halfW, screenH*.25

local dot3 = shapes.newDot({x=hexagon.x, y=hexagon.y})

local pie, vector = shapes.newPie({
	start_angle = 20,
	end_angle = 60,
	radius = radius,
	stroke = 5,
})

pie.x, pie.y = halfW, screenH*.5

if (vector) then
	vector.x = pie.x
	vector.y = pie.y
end

local dot3 = shapes.newDot({x=pie.x, y=pie.y})


local segment = shapes.newCircleSegment({
	start_angle = 20,
	end_angle = 190,
	radius = radius,
	stroke = 5,
	inner_radius = radius*.8
})


segment.x, segment.y = halfW, screenH*.8

local dot4 = shapes.newDot({x=segment.x, y=segment.y})

-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------