-- Utilizza le courutine per far muovere i sempai nella tabella
-- Come passiamo una tabella? Utilizziamo le copy con table.pack e table.unpack, e le deep-copy?

-- local N = 14 -- dimensione della tabella
-- local D = {
--     S = {
--         {2,4,0,0,0,0},
--         {3,8,0,0,0,0},
--         {4,1,0,0,0,0},
--         {9,6,0,0,0,0}
--     },
--     U = {
--         {7,7},
--         {1,1}
--     },
--     C = {
--         {5,1},
--         {9,9}
--     },
--     G = {
--         {4,3}
--     },
--     R = {
--         {8,7},
--         {6,1},
--         {4,5}
--     }
-- }

-- local D = {
--     S = {
--         {5,7,0,0,0,0},
--         {3,8,0,0,0,0},
--         {4,11,0,0,0,0},
--         {9,6,0,0,0,0},
--         {14,14,0,0,0,0},
--         {1,13,0,0,0,0},
--         {12,2,0,0,0,0},
--     },
--     U = {
--         {7,7},
--         {1,1},
--         {8,2}
--     },
--     C = {
--         {5,1},
--         {9,9},
--         {10,3}
--     },
--     G = {
--         {4,3},
--         {8,11}
--     },
--     R = {
--         {8,7},
--         {6,1},
--         {4,5},
--         {13,13}
--     }
-- }

N = 10
D = {
    S = {{8, 8, 0, 0, 0, 0}},
    U = {},
    C = {{4, 8}},
    G = {{9, 7}, {5, 7}},
    R = {{6, 4}, {9, 8}}
}



-- function to check if the table is correct, if the coordinates are in the table and if the coordinates are not repeated
-- @param: table (the whole table D)
-- @param: N (the dimension of the table)
-- @return: true if the table is correct, false otherwise
local function checkTable(tabella, N)
    for key_table, inner_table in pairs(tabella) do
        -- checks if the coordinates are in the table
        for index, item in ipairs(inner_table) do
            if (key_table == 'S') then
                if (#item ~= 6) then return false end
            else
                if (#item ~= 2) then return false end
            end
            if (item[1] > N or item[2] > N or item[1] < 1 or item[2] < 1) then return false
            else
                -- checks if the coordinates are repeated in the same table
                for index2, item2 in ipairs(inner_table) do
                    if (index ~= index2 and item[1] == item2[1] and item[2] == item2[2]) then return false end
                end
                -- checks if the coordinates are repeated in the other tables
                for key_table_2, other_table in pairs(tabella) do
                    if (key_table ~= key_table_2) then
                        for _, item2 in ipairs(other_table) do
                            if (item[1] == item2[1] and item[2] == item2[2]) then return false end
                        end
                    end
                end
            end
        end
    end
    return true
end

-- function to print the table (the whole table with sempai and attributes)
local function printTable(tabella)
    local local_table = {}
    for i = 1, N, 1 do
        local_table[i] = {}
        for j = 1, N, 1 do
            local_table[i][j] = 0
        end
    end
    for index, value in ipairs(tabella.S) do
        local_table[value[1]][value[2]] = index
    end
    for _, value in ipairs(tabella.U) do
        local_table[value[1]][value[2]] = "U"
    end
    for _, value in ipairs(tabella.G) do
        local_table[value[1]][value[2]] = "G"
    end
    for _, value in ipairs(tabella.C) do
        local_table[value[1]][value[2]] = "C"
    end
    for _, value in ipairs(tabella.R) do
        local_table[value[1]][value[2]] = "R"
    end
    for _, value in ipairs(local_table) do
        print(table.unpack(value))
    end
end

-- function to deep copy the whole table (not only the first level) and it can be either S or D
-- @param: table (the whole table D or S)
-- @return: copy of the table (the whole table D or S) with different reference
local function deepcopy(t)
    local copy
    if type(t) == "table" then
        copy = {}
        for k, v in next, t, nil do
            copy[deepcopy(k)] = deepcopy(v)
        end
        setmetatable(copy, deepcopy(getmetatable(t)))
    else -- number , string , boolean , etc
        copy = t
    end
    return copy
end

-- function to get the index of the sempai from the coordinates
-- @param: table (the whole table D)
-- @param: sempai_x (the x coordinate of the sempai)
-- @param: sempai_y (the y coordinate of the sempai)
-- @return: the index of the sempai
local function getSempaiFromCoordinates(tabella, sempai_x, sempai_y)
    for sempai_index, sempai in ipairs(tabella.S) do
        if (sempai[1] == sempai_x and sempai[2] == sempai_y) then return sempai_index end
    end
    return 0
end

--[[ 
    function to move the sempai
    (to use as a black box)
    @param: table (the whole table D)
    @param: num_sempai (the index of the sempai)
    @return: the table with the sempai moved (but with different reference)
--]]
local function move(tabella_D, num_sempai)

    -- auxiliar function to sum the properties of the sempai
    -- @param: tabella_S (the whole table S)
    -- @param: num_sempai (the index of the sempai)
    local function sum_prop(tabella_S, num_sempai)
        local function sum_prop_recursive(tabella_S, num_sempai, num_prop)
            if (num_prop == 5) then return 0 else return tabella_S[num_sempai][num_prop + 2] + sum_prop_recursive(tabella_S, num_sempai, num_prop + 1) end
        end
        return sum_prop_recursive(tabella_S, num_sempai, 1)
    end


    -- auxiliar function to move the sempai to the closest object
    -- @param: tabella (the whole table D)
    -- @param: num_sempai (the index of the sempai)
    -- @return: the table with the sempai moved (but with different reference)
    local function moveToClosestObject(tabella, num_sempai)
        local temporary_table = {}

        -- TODO: Ricorda di mettere insieme tutti i for
        -- auxiliar function to get the coordinates of the closest object to the sempai of the given coordinates
        -- @param: tabella (the whole table D)
        -- @param: sempai_x (the x coordinate of the sempai)
        -- @param: sempai_y (the y coordinate of the sempai)
        -- @return: the coordinates of the closest object
        local function getCoordinatesOfClosestObject(tabella, sempai_x, sempai_y)
            -- auxiliar function to calculate the distance between the sempai and the object
            -- @param: sempai_x (the x coordinate of the sempai)
            -- @param: sempai_y (the y coordinate of the sempai)
            -- @param: obj_x (the x coordinate of the object)
            -- @param: obj_y (the y coordinate of the object)
            -- @return: the distance between the sempai and the object
            local function diff_dist(sempai_x, sempai_y, obj_x, obj_y)
                return math.abs(sempai_x - obj_x) + math.abs(sempai_y - obj_y)
            end
            local min_dist = 1000000 -- una tantum
            local min_x = 1
            local min_y = 1

            -- This for are needed because the function "pairs" doesn't have an order with which the tables are iterated
            for _, object in ipairs(tabella.U) do
                local dist_from_current_object = diff_dist(sempai_x, sempai_y, object[1], object[2])
                if (dist_from_current_object < min_dist) then
                    min_dist = dist_from_current_object
                    min_x = object[1]
                    min_y = object[2]
                end
            end
            for _, object in ipairs(tabella.C) do
                local dist_from_current_object = diff_dist(sempai_x, sempai_y, object[1], object[2])
                if (dist_from_current_object < min_dist) then
                    min_dist = dist_from_current_object
                    min_x = object[1]
                    min_y = object[2]
                end
            end
            for _, object in ipairs(tabella.G) do
                local dist_from_current_object = diff_dist(sempai_x, sempai_y, object[1], object[2])
                if (dist_from_current_object < min_dist) then
                    min_dist = dist_from_current_object
                    min_x = object[1]
                    min_y = object[2]
                end
            end
            for _, object in ipairs(tabella.R) do
                local dist_from_current_object = diff_dist(sempai_x, sempai_y, object[1], object[2])
                if (dist_from_current_object < min_dist) then
                    min_dist = dist_from_current_object
                    min_x = object[1]
                    min_y = object[2]
                end
            end
            return min_x, min_y
        end

        -- auxiliar function to move the sempai to the closest object
        -- @param: tabella (the whole table D)
        -- @param: sempai_x (the x coordinate of the sempai)
        -- @param: sempai_y (the y coordinate of the sempai)
        -- @param: obj_x (the x coordinate of the object)
        -- @param: obj_y (the y coordinate of the object)
        -- @return: the table with the sempai moved closer to the object (but with different reference)
        local function moveSempaiToObject(tabella, sempai_x, sempai_y, obj_x, obj_y)
            local temp_table = deepcopy(tabella)
            local dist_x = obj_x - sempai_x
            local dist_y = obj_y - sempai_y
            -- this sequence of ifs make the sempai move in diagonal
            if ((dist_x > 0 and dist_x % 2 ~= 0) or (dist_x > 0 and dist_y == 0)) then
                sempai_x = sempai_x + 1
            elseif ((dist_x < 0 and dist_x % 2 ~= 0) or (dist_x < 0 and dist_y == 0)) then
                sempai_x = sempai_x - 1
            elseif (dist_y > 0) then sempai_y = sempai_y + 1 elseif (dist_y < 0) then sempai_y = sempai_y - 1 end
            -- changes the coordinates of the sempai in the table
            temp_table.S[num_sempai][1] = sempai_x
            temp_table.S[num_sempai][2] = sempai_y
            return temp_table
        end

        -- auxiliar function to calculate the rewards of the sempai after the move if it reached an object
        -- @param: tabella (the whole table D)
        -- @param: x (the x coordinate of the sempai)
        -- @param: y (the y coordinate of the sempai)
        -- @return: the table with the rewards of the sempai updated (but with different reference)
        local function calculateRewards(tabella, sempai_x, sempai_y)
            local temp_table = deepcopy(tabella)
            for key, prop_table in pairs(temp_table) do
                if (key ~= "S") then
                    for index, value in ipairs(prop_table) do
                        -- search the object where the sempai moved to
                        if (value[1] == sempai_x and value[2] == sempai_y) then
                            table.remove(prop_table, index)
                            if(key == 'U') then temp_table.S[num_sempai][3] = temp_table.S[num_sempai][3] + 1 end
                            if(key == 'C') then temp_table.S[num_sempai][4] = temp_table.S[num_sempai][4] + 1 end
                            if(key == 'G') then temp_table.S[num_sempai][5] = temp_table.S[num_sempai][5] + 1 end
                            if(key == 'R') then temp_table.S[num_sempai][6] = temp_table.S[num_sempai][6] + 1 end
                        end
                    end
                end
            end
            return temp_table
        end

        -- firstly it moves the sempai to the closest object, then it calculates the rewards of the sempai
        temporary_table = moveSempaiToObject(tabella, tabella.S[num_sempai][1], tabella.S[num_sempai][2], getCoordinatesOfClosestObject(tabella, tabella.S[num_sempai][1], tabella.S[num_sempai][2]))
        -- returns the table in which the sempai moved and the rewards of the same sempai are updated
        return calculateRewards(temporary_table, temporary_table.S[num_sempai][1], temporary_table.S[num_sempai][2])
    end

    -- auxiliar function that moves the sempai to the closest object or the closest sempai (if the sum of the properties is more than 0),
    -- there is no difference between objects and sempai, but if he can't win against the sempai, he won't consider that sempai to move
    -- @param: tabella (the whole table D)
    -- @param: num_sempai (the index of the sempai)
    -- @return: the table after the sempai moved (but with different reference)
    local function moveGeneral(tabella_D, num_sempai)
        local temporary_table = {}

        -- TODO: Ricorda di mettere insieme tutti i for
        -- auxiliar function to get the coordinates of the closest item to the sempai of the given coordinates
        -- (it can be either an object or a sempai, but it is a sempai if the given sempai can win against it)
        -- @param: tabella (the whole table D)
        -- @param: sempai_x (the x coordinate of the sempai)
        -- @param: sempai_y (the y coordinate of the sempai)
        -- @return: the coordinates of the closest item
        local function getCoordinatesOfClosestItem(tabella, sempai_x, sempai_y)
            -- auxiliar function to calculate the distance between the sempai and the object
            -- @param: sempai_x (the x coordinate of the sempai)
            -- @param: sempai_y (the y coordinate of the sempai)
            -- @param: item_x (the x coordinate of the object/sempai)
            -- @param: item_y (the y coordinate of the object/sempai)
            -- @return: the distance between the sempai and the object
            local function diff_dist(sempai_x, sempai_y, item_x, item_y)
                return math.abs(sempai_x - item_x) + math.abs(sempai_y - item_y)
            end

            -- CHECK if Copilot got it right and if to do it with coordinates of indexes
            -- auxiliar function to check if the sempai can win against the other sempai
            -- @param: tabella (the whole table D)
            -- @param: moving_sempai (the index of the sempai that is moving)
            -- @param: current_sempai (the index of the sempai that is being checked)
            -- @return: true if the moving sempai can win against the current sempai, false otherwise
            local function check_win(tabella, moving_sempai, current_sempai)
                local function calculatePower(tabella, sempai_x, sempai_y)
                    return sum_prop(tabella.S, getSempaiFromCoordinates(tabella, sempai_x, sempai_y))
                end
                -- auxiliar function to calculate the power of the sempai in case of equal sum of properties
                local function calculatePowerEqual(sempai_x, sempai_y)
                    return (((sempai_x + sempai_y)*(sempai_x + sempai_y - 1))/2 + sempai_x - sempai_y)
                end
                if (calculatePower(tabella, tabella.S[moving_sempai][1], tabella.S[moving_sempai][2]) > calculatePower(tabella, tabella.S[current_sempai][1], tabella.S[current_sempai][2])) then return true
                elseif (calculatePower(tabella, tabella.S[moving_sempai][1], tabella.S[moving_sempai][2]) < calculatePower(tabella, tabella.S[current_sempai][1], tabella.S[current_sempai][2])) then return false
                else
                    -- case in which their power is the same
                    if(calculatePowerEqual(tabella.S[moving_sempai][1], tabella.S[moving_sempai][2]) > calculatePowerEqual(tabella.S[current_sempai][1], tabella.S[current_sempai][2])) then return true
                    else return false
                    end
                end
            end

            local min_dist = 1000000 -- una tantum
            local min_x = 1 -- x coordinate of the closest item
            local min_y = 1 -- y coordinate of the closest item
            
            -- checks (the 'and' has a specific order because it's lazy):
            -- 1) if the distance is more than 0 (so it's not the same object/sempai)
            -- 2) if the distance is less than the current minimum distance
            -- 3) if the moving sempai can win against the current sempai iterated
            for _, item in ipairs(tabella.S) do
                local dist_from_current_object = diff_dist(sempai_x, sempai_y, item[1], item[2])
                if ((dist_from_current_object > 0) and (dist_from_current_object < min_dist) and check_win(tabella, getSempaiFromCoordinates(tabella, sempai_x, sempai_y), getSempaiFromCoordinates(tabella, item[1], item[2]))) then
                    min_dist = dist_from_current_object
                    min_x = item[1]
                    min_y = item[2]
                end
            end
            for _, item in ipairs(tabella.U) do
                local dist_from_current_object = diff_dist(sempai_x, sempai_y, item[1], item[2])
                if (dist_from_current_object < min_dist) then
                    min_dist = dist_from_current_object
                    min_x = item[1]
                    min_y = item[2]
                end
            end
            for _, item in ipairs(tabella.C) do
                local dist_from_current_object = diff_dist(sempai_x, sempai_y, item[1], item[2])
                if (dist_from_current_object < min_dist) then
                    min_dist = dist_from_current_object
                    min_x = item[1]
                    min_y = item[2]
                end
            end
            for _, item in ipairs(tabella.G) do
                local dist_from_current_object = diff_dist(sempai_x, sempai_y, item[1], item[2])
                if (dist_from_current_object < min_dist) then
                    min_dist = dist_from_current_object
                    min_x = item[1]
                    min_y = item[2]
                end
            end
            for _, item in ipairs(tabella.R) do
                local dist_from_current_object = diff_dist(sempai_x, sempai_y, item[1], item[2])
                if (dist_from_current_object < min_dist) then
                    min_dist = dist_from_current_object
                    min_x = item[1]
                    min_y = item[2]
                end
            end
            return min_x, min_y
        end

        -- auxiliar function to move the sempai to the closest object or the closest sempai, calculated from the getCoordinatesOfClosestItem function
        -- (If the distance is 0, then the sempai is already on the object/sempai and it doesn't move)
        -- @param: tabella (the whole table D)
        -- @param: sempai_x (the x coordinate of the sempai)
        -- @param: sempai_y (the y coordinate of the sempai)
        -- @param: item_x (the x coordinate of the object/sempai)
        -- @param: item_y (the y coordinate of the object/sempai)
        -- @return: the table with the sempai moved closer to the object/sempai (but with different reference)
        local function moveSempaiToItem(tabella, sempai_x, sempai_y, item_x, item_y)
            local temp_table = deepcopy(tabella)
            local dist_x = item_x - sempai_x
            local dist_y = item_y - sempai_y
            -- this sequence of ifs make the sempai move in diagonal
            if ((dist_x > 0 and dist_x % 2 ~= 0) or (dist_x > 0 and dist_y == 0)) then
                sempai_x = sempai_x + 1
            elseif ((dist_x < 0 and dist_x % 2 ~= 0) or (dist_x < 0 and dist_y == 0)) then
                sempai_x = sempai_x - 1
            elseif (dist_y > 0) then sempai_y = sempai_y + 1 elseif (dist_y < 0) then sempai_y = sempai_y - 1 end
            -- changes the coordinates of the sempai in the table
            temp_table.S[num_sempai][1] = sempai_x
            temp_table.S[num_sempai][2] = sempai_y
            return temp_table
        end

        -- auxiliar function to calculate the rewards of the sempai after the move if it reached an object
        -- @param: tabella (the whole table D)
        -- @param: x (the x coordinate of the sempai)
        -- @param: y (the y coordinate of the sempai)
        -- @return: the table with the rewards of the sempai updated (but with different reference)
        local function calculateRewards(tabella, sempai_x, sempai_y)
            local temp_table = deepcopy(tabella)
            for key, prop_table in pairs(temp_table) do
                if (key ~= "S") then
                    for index, value in ipairs(prop_table) do
                        -- search the object where the sempai moved to
                        if (value[1] == sempai_x and value[2] == sempai_y) then
                            table.remove(prop_table, index)
                            if(key == 'U') then temp_table.S[num_sempai][3] = temp_table.S[num_sempai][3] + 1 end
                            if(key == 'C') then temp_table.S[num_sempai][4] = temp_table.S[num_sempai][4] + 1 end
                            if(key == 'G') then temp_table.S[num_sempai][5] = temp_table.S[num_sempai][5] + 1 end
                            if(key == 'R') then temp_table.S[num_sempai][6] = temp_table.S[num_sempai][6] + 1 end
                        end
                    end
                end
            end
            return temp_table
        end

        -- firstly it moves the sempai to the closest object, then it calculates the rewards of the sempai
        temporary_table = moveSempaiToItem(tabella_D, tabella_D.S[num_sempai][1], tabella_D.S[num_sempai][2], getCoordinatesOfClosestItem(tabella_D, tabella_D.S[num_sempai][1], tabella_D.S[num_sempai][2]))
        -- returns the table in which the sempai moved and the rewards of the same sempai are updated
        return calculateRewards(temporary_table, temporary_table.S[num_sempai][1], temporary_table.S[num_sempai][2])

        -- TODO: If the sempai moved to near a sempai does it needs to fight?
    end

    -- auxiliar function that makes the sempai fight with another sempai and returns the winner
    -- @param: tabella (the whole table D)
    -- @param: sempai1_x (the x coordinate of the first sempai)
    -- @param: sempai1_y (the y coordinate of the first sempai)
    -- @param: sempai2_x (the x coordinate of the second sempai)
    -- @param: sempai2_y (the y coordinate of the second sempai)
    -- @return: the table with the sempai after the fight (the loser is cancelled from the table while the winner has the rewards updated)
    local function fight(tabella_D, sempai1_x, sempai1_y, sempai2_x, sempai2_y)
        -- Function that given the coordinates of the sempai, returns the coordinates of the winner
        return (function(tabella, sempai1_x, sempai1_y, sempai2_x, sempai2_y)
            local function calculatePower(tabella, sempai_x, sempai_y)
                return sum_prop(tabella.S, getSempaiFromCoordinates(tabella, sempai_x, sempai_y))
            end
            -- auxiliar function to calculate the power of the sempai in case of equal sum of properties
            local function calculatePowerEqual(sempai_x, sempai_y)
                return (((sempai_x + sempai_y)*(sempai_x + sempai_y - 1))/2 + sempai_x - sempai_y)
            end
            -- auxiliar function to calculate the rewards of the winning sempai and returns the table with the modified sempai
            local function calculateRewardsOfWinner(tabella, sempai_winner_x, sempai_winner_y, sempai_loser_x, sempai_loser_y)
                local temp_table = deepcopy(tabella)
                for i = 3, 6, 1 do
                    if temp_table.S[getSempaiFromCoordinates(temp_table, sempai_winner_x, sempai_winner_y)][i] > temp_table.S[getSempaiFromCoordinates(temp_table, sempai_loser_x, sempai_loser_y)][i] then
                        temp_table.S[getSempaiFromCoordinates(temp_table, sempai_winner_x, sempai_winner_y)][i] = temp_table.S[getSempaiFromCoordinates(temp_table, sempai_winner_x, sempai_winner_y)][i] + 1
                    end
                end
                return temp_table
            end

            if (calculatePower(tabella, sempai1_x, sempai1_y) > calculatePower(tabella, sempai2_x, sempai2_y)) then
                local temp_table = calculateRewardsOfWinner(tabella, sempai1_x, sempai1_y, sempai2_x, sempai2_y)
                table.remove(temp_table.S, getSempaiFromCoordinates(temp_table, sempai2_x, sempai2_y))
                return temp_table
            elseif (calculatePower(tabella, sempai1_x, sempai1_y) < calculatePower(tabella, sempai2_x, sempai2_y)) then
                local temp_table = calculateRewardsOfWinner(tabella, sempai2_x, sempai2_y, sempai1_x, sempai1_y)
                table.remove(temp_table.S, getSempaiFromCoordinates(temp_table, sempai1_x, sempai1_y))
                return temp_table
            else
                -- case in which their power is the same
                if(calculatePowerEqual(sempai1_x, sempai1_y) > calculatePowerEqual(sempai2_x, sempai2_y)) then
                    local temp_table = calculateRewardsOfWinner(tabella, sempai1_x, sempai1_y, sempai2_x, sempai2_y)
                    table.remove(temp_table.S, getSempaiFromCoordinates(temp_table, sempai2_x, sempai2_y))
                    return temp_table
                else
                    local temp_table = calculateRewardsOfWinner(tabella, sempai2_x, sempai2_y, sempai1_x, sempai1_y)
                    table.remove(temp_table.S, getSempaiFromCoordinates(temp_table, sempai1_x, sempai1_y))
                    return temp_table
                end
            end
        end)(tabella_D, sempai1_x, sempai1_y, sempai2_x, sempai2_y)
    end

    -- Save the coordinates of the sempai in case it has to fight with another sempai and the index of the sempai changes
    local sempai_x = tabella_D.S[num_sempai][1]
    local sempai_y = tabella_D.S[num_sempai][2]

    -- TODO: deve farlo prima o dopo? Secondo me prima, perché se partono che sono vicini devono già combattere
    -- checks if the sempai have to fight with another sempai and if it's true, it calls the fight function, otherwise returns the sempai coordinates
    -- @param: sempai_x (the x coordinate of the sempai)
    -- @param: sempai_y (the y coordinate of the sempai)
    -- @return: the table with the sempai moved (but with different reference)
    local temp_table = (function (sempai_x, sempai_y)
        if (getSempaiFromCoordinates(tabella_D, sempai_x + 1, sempai_y) ~= 0) then return fight(tabella_D, sempai_x, sempai_y, sempai_x + 1, sempai_y)
        elseif (getSempaiFromCoordinates(tabella_D, sempai_x - 1, sempai_y) ~= 0) then return fight(tabella_D, sempai_x, sempai_y, sempai_x - 1, sempai_y)
        elseif (getSempaiFromCoordinates(tabella_D, sempai_x, sempai_y + 1) ~= 0) then return fight(tabella_D, sempai_x, sempai_y, sempai_x, sempai_y + 1)
        elseif (getSempaiFromCoordinates(tabella_D, sempai_x, sempai_y - 1) ~= 0) then return fight(tabella_D, sempai_x, sempai_y, sempai_x, sempai_y - 1)
        else return deepcopy(tabella_D)
        end
    end)(tabella_D.S[num_sempai][1], tabella_D.S[num_sempai][2])

    -- correct the index of the sempai if it changed after a fight
    local new_num_sempai = getSempaiFromCoordinates(temp_table, sempai_x, sempai_y)

    -- checks if the sempai has lost and has been eliminated from the table
    if (new_num_sempai == 0) then
        return temp_table
    end

    -- check if the sempai has to move to the closest object or not (so if the sum of the properties is 0 or not)
    if(sum_prop(temp_table.S, new_num_sempai) == 0) then return moveToClosestObject(temp_table, new_num_sempai) else return moveGeneral(temp_table, new_num_sempai) end
end





-- OUTPUT

print("\n")


if checkTable(D, N) then
    print("\n")
    print("The table is correct")
else
    print("\n")
    print("The table is not correct")
end

printTable(D)

local function output(temp_table)

    for i = 1, 10, 1 do
        for index, _ in pairs(temp_table.S) do
            if (index <= #temp_table.S) then
                temp_table = move(temp_table, index)
            end
        end
        print("\n")
        printTable(temp_table)
    end

    print("\n")

    local table_names = {'X', 'Y', 'U', 'C', 'G', 'R'}
    print(table.unpack(table_names))
    for _, sempai in ipairs(temp_table.S) do
        print(table.unpack(sempai))
    end
end

-- output(deepcopy(D))

local function start(tabella_D)
    if #tabella_D.S == 1 and #tabella_D.U == 0 and #tabella_D.C == 0 and #tabella_D.G == 0 and #tabella_D.R == 0 then
        print("\n")

        local table_names = {'X', 'Y', 'U', 'C', 'G', 'R'}
        print(table.unpack(table_names))
        for _, sempai in ipairs(tabella_D.S) do
            print(table.unpack(sempai))
        end
        return tabella_D
    else
        local temporary_table = deepcopy(tabella_D)
        for index, value in pairs(temporary_table.S) do
            if (index <= #temporary_table.S) then
                temporary_table = move(temporary_table, index)
            end
        end
        print("\n")
        printTable(temporary_table)
        return start(temporary_table)
    end
end

start(deepcopy(D))