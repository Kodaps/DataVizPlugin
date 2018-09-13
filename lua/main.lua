-- 
-- Abstract: dataviz Library Plugin Test Project
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2015 Corona Labs Inc. All Rights Reserved.
--
------------------------------------------------------------

-- Load plugin library
local dataviz = require "plugin.dataviz"

-------------------------------------------------------------------------------
-- BEGIN (Insert your sample test starting here)
-------------------------------------------------------------------------------
local screenW, screenH = display.contentWidth, display.contentHeight
local halfW, halfH = display.contentCenterX, display.contentCenterY

local elements = {}

local w, h = 50, 50
local x, y = display.contentCenterX, display.contentCenterY
local radius = screenH*.1

local arc = dataviz.newArc({
	start_angle = 20,
	end_angle = 90,
	radius = radius*2,
	strokeWidth = 2,
	strokeColor = "#A00"
})

arc.speed = 0.3
arc.x, arc.y = halfW, screenH*.25


elements.arc = arc

local dot1 = dataviz.newDot({x=arc.x, y=arc.y})

local hexagon = dataviz.newRegularPolygon({
	nb = 5,
	radius = radius,
	color = "#AB0"
})

elements.hexogon = hexagon

hexagon.x, hexagon.y = halfW, screenH*.25
hexagon.speed = 2

local dot3 = dataviz.newDot({x=hexagon.x, y=hexagon.y})

local pie = dataviz.newPie({
	start_angle = 20,
	end_angle = 60,
	radius = radius*1.3,
	stroke = 5,
})

pie.x, pie.y = halfW, screenH*.25
pie.speed = 4
elements.pie = pie

local dot3 = dataviz.newDot({x=pie.x, y=pie.y})


local segment = dataviz.newCircleSegment({
	start_angle = 0,
	end_angle = 60,
	radius = radius,
	stroke = 5,
	inner_radius = radius*.5,
	color = "#222F",
	strokeColor = "#0FF",
	strokeWidth = 1
})

segment.speed = 1.8

segment.x, segment.y = halfW, screenH*.75
elements.segment = segment
local dot4 = dataviz.newDot({x=segment.x, y=segment.y})

local star = dataviz.newStar({
	nb = 6,
	radius =  radius * 2,
	radius2 = radius * .75,
	color = "#0AF7"
})

star.x, star.y = halfW, screenH*.25
star.speed = -1.2

elements.star = star

local dot5 = dataviz.newDot({x=star.x, y=star.y})


local myListener = function( event )
	for k,v in pairs(elements) do
		v.rotation = v.rotation + (v.speed or 2)
	end
end

Runtime:addEventListener( "enterFrame", myListener )


-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------