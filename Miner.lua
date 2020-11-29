local SLOT_COUNT = 16
local xPos,zPos = 0,0
local depth = 0

-- TODO: some way for user to input what items to ignore
-- hardcodding items to ignore for now
function Set (list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end 
local DROPPED_ITEMS = Set{
    "minecraft:stone",
    "minecraft:dirt",
    "minecraft:cobblestone",
    "minecraft:sand",
    "minecraft:gravel",
    "railcraft:ore_metal"
}

-- User input to modify width, height, depth
write("Input width of tunnel: ")
local width = tonumber(read()) or 3

write("Input height of tunnel: ")
local height = tonumber(read()) or 3

write("Input depth of tunnel: ")
local depth = tonumber(read()) or 10


-- Drop Item if it isn't in the list of items to drop 
function dropItems()
    print("Purging Inventory...")
    for slot = 1, SLOT_COUNT, 1 do
        local item = turtle.getItemDetail(slot)
        if(item ~= nil and DROPPED_ITEMS[item["name"]]) then
            print("Dropping - " .. item["name"])
            turtle.select(slot)
            turtle.dropDown()
        end
    end
end

function getChestIndex()
    for slot = 1, SLOT_COUNT, 1 do
        local item = turtle.getItemDetail(slot)
    end
end

function manageInventory()
    dropItems()

end

-- Refuel with anything that can be used in inventory
-- return true if there is still fuel, false if not enough to return home
function refuel( ammount )
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel == "unlimited" then
        return true
    end
    local needed = ammount or (xPos + zPos + depth + 2)
    if (turtle.getFuelLevel() < needed) then
        print("Attempting Refuel...")
        for slot = 1, SLOT_COUNT, 1 do
            turtle.select(slot)
            if turtle.refuel(1) then
                while turtle.getItemCount(slot) > 0 and turtle.getFuelLevel < needed do
                    turtle.refuel(1)
                end
                if turtle.getFuelLevel() >= needed then
                    turtle.select(1)
                    return true
                end
            end
        end
       turtle.select(1)
       return false
    end
    return true
end

-- Because of gravel and others, continue digging until it is clear
function detectForwardAndDig()
    while(turtle.detect()) do
        turtle.dig()
    end
end

function detectDownwardAndDig()
    while(turtle.detectDown()) do
        turtle.digDown()
    end
end

function detectUpwardAndDig()
    while(turtle.detectUp()) do
        turtle.digUp()
    end
end

function forward()
    detectAndDig()
    turtle.forward()
end

function digDown()
    detectDownwardAndDig()
    turtle.detectDown()
end

function digUp()
    detectUpwardAndDig()
    turtle.detectUp()
end

function leftTurn()
    turtle.turnLeft()
    detectAndDig()
    turtle.forward()
    turtle.turnRight()
end

function rightTurn()
    turtle.turnRight()
    detectAndDig()
    turtle.forward()
    turtle.turnLeft()
end

