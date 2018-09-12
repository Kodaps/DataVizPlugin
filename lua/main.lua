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

local elements = {}

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

elements.arc = arc

local dot1 = shapes.newDot({x=arc.x, y=arc.y})

local hexagon = shapes.newRegularPolygon({
	nb = 8,
	radius = radius
})

elements.hexogon = hexagon

hexagon.x, hexagon.y = halfW, screenH*.25

local dot3 = shapes.newDot({x=hexagon.x, y=hexagon.y})

local pie = shapes.newPie({
	start_angle = 20,
	end_angle = 60,
	radius = radius,
	stroke = 5,
})

pie.x, pie.y = halfW, screenH*.5

elements.pie = pie

local dot3 = shapes.newDot({x=pie.x, y=pie.y})


local segment = shapes.newCircleSegment({
	start_angle = 0,
	end_angle = 350,
	radius = radius*2,
	stroke = 5,
	inner_radius = radius*1.5
})

segment.x, segment.y = halfW, screenH*.75
elements.segment = segment

local star = shapes.newStar({
	nb = 6,
	radius = radius,
	radius2 = radius*.75
})

star.x, star.y = halfW, screenH*.85

local dot4 = shapes.newDot({x=segment.x, y=segment.y})

local myListener = function( event )
	for k,v in pairs(elements) do
		v.rotation = v.rotation + 5
	end
end

--Runtime:addEventListener( "enterFrame", myListener )


-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------