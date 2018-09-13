local Library = require "CoronaLibrary"

-- Create library
local lib = Library:new{ name='plugin.shapes', publisherId='com.kodaps' }

display.setDefault( "isAnchorClamped", false )

-------------------------------------------------------------------------------
-- BEGIN (Insert your implementation starting here)
-------------------------------------------------------------------------------

local function deg2rad(angle)
	angle = angle or 0
    return math.pi * (angle/180 - .5)
end

local cos = math.cos
local sin = math.sin

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


function manage(mat, data)

    if data.strokeWidth then
        mat.strokeWidth = data.strokeWidth
    end

    mat.x = data.x or 0
    mat.y = data.y or 0
    mat.anchorX = data.anchorX or 0.5
    mat.anchorY = data.anchorY or 0.5

    if data.parent then
        data.parent:insert(mat)
    end

    return mat

end


function lib.newCircleSegment(data)

	data = data or {}

    local ret, min_x, min_y, max_x, max_y  = arc(data.start_angle, data.end_angle, data.radius)

    local ret2,  min_x2, min_y2, max_x2, max_y2  = arc(data.end_angle, data.start_angle, data.inner_radius, -5)

    min_x =math.min(min_x, min_x2)
    min_y =math.min(min_y, min_y2)
    max_x =math.max(max_x, max_x2)
    max_y =math.min(max_y, max_y2)

    local anchorX, anchorY

    local bcenter_x = (min_x+max_x)/2
    local bcenter_y = (min_y+max_y)/2

    local width = max_x - min_x
    local height = max_y - min_y

    if min_x < 0 and max_x > 0 then
        anchorX = - min_x / (max_x - min_x)
    else
        anchorX = 1 -1*(width/(2 * bcenter_x))
    end

    if min_y < 0 and max_y > 0 then
        anchorY = - min_y / (max_y - min_y)
    else
        anchorY = 1 -1*(height/(2 * bcenter_y))
    end

    data.anchorX = anchorX
    data.anchorY = anchorY

    local idx = #ret

    for k,v in ipairs(ret2) do
        ret[idx+k] = v
    end

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

function lib.newDot(data)

	data = data or {}

    local mat = display.newCircle(data.x or 0, data.y or 0, 1)
    mat:setFillColor(1,0,0)

    if data.parent then
        data.parent:insert(mat)
    end

	return mat

end

function lib.newArc (data)

    local mat = display.newGroup()

    local center = lib.newDot({x=0, y=0})
    center.alpha = 0

	local ret = arc(data.start_angle, data.end_angle, data.radius)

    local line = display.newLine(mat, unpack(ret))
    line.strokeWidth = data.stroke or 1

    if data.parent then
        data.parent:insert(mat)
    end

	return mat

end

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

    mat.anchorX, mat.anchorY = anchorX, anchorY

    if data.parent then
        data.parent:insert(mat)
    end

	return mat

end


function lib.newRegularPolygon(data)

	data = data or {}

	local nb = (data.nb or 3)

	-- if nb < 3 then not a polygon

	local step = 360/nb

	local ret = arc(0, 359, data.radius, step)

    local mat = display.newPolygon(0,0, ret)
    mat.x = data.x or 0
    mat.y = data.y or 0

    if data.parent then
        data.parent:insert(mat)
    end

	return mat

end

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
            v = v * (data.radius2 or data.radius*.5)
        end
        table.insert(ret,v)

    end


    local mat = display.newPolygon(0,0, ret)
    mat.x = data.x or 0
    mat.y = data.y or 0

    if data.parent then
        data.parent:insert(mat)
    end

	return mat

end


-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------

-- Return library instance
return lib
