------------
-- DataViz plugin
-- Description can continue after simple tags, if you
-- like - but to keep backwards compatibility, say 'not_luadoc=true'
-- @module plugin.dataviz
-- @author hockley, david
-- @copyright Kodaps 2018
-- @alias lib
-- @release 0.2

local Library = require "CoronaLibrary"

-- Create library
-- @class plugin
local lib = Library:new({ name='plugin.dataviz', publisherId='com.kodaps' })


local colors = require "plugin.dataviz.colors"

display.setDefault( "isAnchorClamped", false )

-------------------------------------------------------------------------------
-- BEGIN (Insert your implementation starting here)
-------------------------------------------------------------------------------

local function deg2rad(angle)
	--angle = angle or 0
    --return math.pi * (angle/180 - .5)
    return math.rad(angle - 90)
end

local cos = math.cos
local sin = math.sin

--- cosine with degress
-- you may document an indefinite number of extra arguments!
-- @int dangle
local function dcos(dangle)
    return cos(deg2rad(dangle))
end

local function dsin(dangle)
    return sin(deg2rad(dangle))
end


local function reverse(start_angle, end_angle, radius)

    local x1 = -dcos(start_angle)*radius
    local y1 = -dsin(start_angle)*radius

    local x2 = -dcos(end_angle)*radius
    local y2 = -dsin(end_angle)*radius
    return (x1+x2)/2, (y1+y2)/2

end


local function arc(start_angle, end_angle, radius, step, offset)

    offset = offset or 0
    radius = radius or 1
    step = step or 5

    if (end_angle - start_angle) * step < 0 then
        step = step * -1
    end

    local min_x = 1
    local min_y = 1
    local max_x = -1
    local max_y = -1


    local points = {}

    local _count = 1

    local function check(x,y)

        if x < min_x then min_x = x end
        if x > max_x then max_x = x end
        if y < min_y then min_y = y end
        if y > max_y then max_y = y end
    end

    for deg = start_angle, end_angle, step do
        local _x = radius*dcos(deg + offset)
        local _y = radius*dsin(deg + offset)
        check(_x,_y)
        points[_count] = _x
        points[_count + 1] = _y
        _count = _count + 2
    end

    return points, min_x, min_y, max_x, max_y

end


local function manage(mat, data)

    if data.strokeWidth then
        mat.strokeWidth = data.strokeWidth
    end

    mat.x = data.x or 0
    mat.y = data.y or 0
    mat.anchorX = data.anchorX or 0.5
    mat.anchorY = data.anchorY or 0.5

    if data.alpha then mat.alpha = data.alpha end 

    if data.color then
        mat:setFillColor(colors(data.color))
    end

    if data.strokeColor then
        mat:setStrokeColor(colors(data.strokeColor))
    end

    if data.parent then
        data.parent:insert(mat)
    end

    return mat

end


--[[

     [ 1, 2, 3, 4] => [1 , 2, 3, 4, 3', 4', 1', 2']
     pt idx = 1 .. 2 / max_idx = 2 
     idx bis = (idx - 1)* 2 + 1 ou 2 => (1-1)* 2 + 1 = 1
     idx ter = (max_idx * 2 + (max_idx - idx - 1)*2 + 1 or 2 )
]]

--- color function
--@return an unpacked set of floats
function lib.color(...)
    return color(...)
end

--- create a circle segment
-- @tparam table data a table with : `radius`, `start_angle` (in degrees), `end_angle` (in degrees), and `inner_radius`
-- @return a polygon DisplayObject anchored arc in the center of the circle
-- @usage local segment = dataviz.newCircleSegment({
--	  start_angle = 0,
--	  end_angle = 60,
--	  radius = 100,
--	  stroke = 5,
--	  inner_radius = 50,
--	  color = "#222F",
--	  strokeColor = "#0FF",
--	  strokeWidth = 1
--})

function lib.newCircleSegment(data)

	data = data or {}

    local ret1, min_x, min_y, max_x, max_y  = arc(data.start_angle, data.end_angle, 1)

    local radius = data.radius
    local radius2 = data.inner_radius or data.radius * .9


    min_x = math.min(min_x * radius, min_x * radius2)
    min_y = math.min(min_y * radius, min_y * radius2)
    max_x = math.max(max_x * radius, max_x * radius2)
    max_y = math.max(max_y * radius, max_y * radius2)

    local ret = {}
    local pts = (#ret1) / 2

    for i = 1, pts do

        local idx1 = (i-1) * 2 + 1
        local idy1 = (i-1) * 2 + 2
        local idx2 = pts * 2 + (pts - i - 1) * 2 + 1
        local idy2 = pts * 2 + (pts - i - 1) * 2 + 2

        local x0 = ret1[ idx1 ]
        local y0 = ret1[ idy1 ]

        ret[idx1] = x0 * radius
        ret[idy1] = y0 * radius
        ret[idx2] = x0 * radius2
        ret[idy2] = y0 * radius2
    end


    local anchorX, anchorY

    local bcenter_x = (min_x + max_x)/2
    local bcenter_y = (min_y + max_y)/2

    local width = max_x - min_x
    local height = max_y - min_y

    if min_x < 0 and max_x > 0 then
        anchorX = - min_x / width
    else
        anchorX = 1 - 1 * (width/(2 * bcenter_x))
    end

    if min_y < 0 and max_y > 0 then
        anchorY = - min_y / height
    else
        anchorY = 1 - 1 * (height/(2 * bcenter_y))
    end

    data.anchorX = anchorX
    data.anchorY = anchorY

    local mat = display.newPolygon(0,0, ret)

	return manage(mat,data)

end



function lib.newVector(data)
    --

    if #data == 1 then
        table.insert(data, 1, {0,0})
    end

    local bits = {
        data[1][1],
        data[1][2],
        data[2][1],
        data[2][2]
    }

	local line = display.newLine(unpack(bits))
    line.strokeWidth = 1
    line:setStrokeColor(1,0,1)
	return line

end


--- create a dot
-- @tparam table data a table 
-- @return a small circle DisplayObject 
-- @usage local segment = dataviz.newDot({
--	  x = 100,
--	  y = 30
--})

function lib.newDot(data)

	data = data or {}

    local mat = display.newCircle(data.x or 0, data.y or 0, 1)
    mat:setFillColor(1,0,0)

	return manage(mat,data)

end

--- create an arc anchored in the center of the circle
-- @tparam table data a table
-- First Header  | Second Header
-- ------------- | -------------
-- Content Cell  | Content Cell
-- Content Cell  | Content Cell
-- @return a DisplayObject group containing a Line and a Dot
-- @usage local arc = dataviz.newArc({
--	start_angle = 20,
--	end_angle = 90,
--	radius = 200,
--	strokeWidth = 5,
--	strokeColor = "#A00"
--})

function lib.newArc (data)

    local mat = display.newGroup()

    local center = lib.newDot({parent = mat, x=0, y=0})
    center.alpha = 0

	local ret = arc(data.start_angle, data.end_angle, data.radius)

    local line = display.newLine(mat, unpack(ret))
    line.strokeWidth = data.strokeWidth or 1

    if data.parent then
        data.parent:insert(mat)
    end

    function mat:setStrokeColor(...)
        return line:setStrokeColor(...)
    end

	return manage(mat,data)

end

--- create an pie slice anchored in the center of the circle
-- @tparam table data a table
-- @return a DisplayObject polygon 
-- @usage local pie = dataviz.newPie({
--    start_angle = 20,
-- 	  end_angle = 60,
-- 	  radius = radius*1.3,
-- 	  stroke = 5,
-- 	  color = "#f492a5"
-- })

function lib.newPie (data)

	data = data or {}

    if data.start_angle > data.end_angle then
        local _ = data.end_angle
        data.end_angle = data.start_angle
        data.start_angle = _
    end

	local ret, min_x, min_y, max_x, max_y = arc(data.start_angle, data.end_angle, data.radius)

    local anchorX, anchorY

    if min_y < 0 and max_y < 0 then
        anchorY = 1
    end

    if min_y > 0 and max_y > 0 then
        anchorY = 0
    end

    if min_x < 0 and max_x < 0 then
        anchorX = 1
    end

    if min_x > 0 and max_x > 0 then
        anchorX = 0
    end

    if anchorX == nil then
        anchorX = - min_x / (max_x - min_x)
    end


    if anchorY == nil then
        anchorY = - min_y / (max_y - min_y)
    end


	table.insert(ret, 1, 0)
    table.insert(ret, 1, 0)


    local mat = display.newPolygon(0,0, ret)

    data.anchorX, data.anchorY = anchorX, anchorY


	return manage(mat,data)


end

--- create an n-sided regular polygon
-- @tparam table data a table with
-- `nb` : number of sides, 
-- `radius` : radius of the circle that would contain the polygon 
-- @return a DisplayObject polygon 
-- @usage local pie = dataviz.newRegularPolygon({
--    nb = 5, -- let's make a pentagon
--	  radius = radius,
--	  color = "#6e82b7"
-- })

function lib.newRegularPolygon(data)

	data = data or {}

	local nb = (data.nb or 3)

	-- if nb < 3 then not a polygon

	local step = 360/nb

	local ret = arc(0, 359, data.radius, step)

    local mat = display.newPolygon(0,0, ret)

    return manage(mat, data)

end

--- create an n-pointed star
-- @tparam table data a table with
-- `nb`     : number of sides, 
-- `radius` : length of the star arms
-- `inner_radius` : the distance of the "valleys" of the star from the center
-- @return a DisplayObject polygon
-- @usage local str = dataviz.newStar({
--	 nb = 6, -- it's a star of David. sort of.
--	 radius =  100,
--	 inner_radius = 50,
--	 color = '#f7e8d8',
-- })

function lib.newStar(data)

	data = data or {}

	local nb = (data.nb or 3)

	-- if nb < 3 then not a polygon

	local step = 360/(2*nb)
	local ret1 = arc(0, 359, 1, step)


    local ret = {}
    

    for k,v in ipairs(ret1) do 

        local idx = (k-1) % 4

        if idx == 0 or idx == 1 then
            v = v * data.radius
        else
            v = v * (data.inner_radius or data.radius*.5)
        end
        table.insert(ret,v)

    end


    local mat = display.newPolygon(0,0, ret)
    return manage(mat, data)


end


-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------


return lib
