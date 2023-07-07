-- Utilizza le courutine per far muovere i sempai nella tabella
-- Come passiamo una tabella? Utilizziamo le copy con table.pack e table.unpack, e le deep-copy?
-- Dobbiamo utilizzare le metatable? Programmazione ad oggetti?
-- Utilizziamo solo Local nelle funzioni? Mai assegnamenti globali?

N = 10
D = {
    S = {
        {2,4,0,0,0,0},
        {3,8,0,0,0,0},
        {4,1,0,0,0,0},
        {9,6,0,0,0,0}
    },
    U = {
        {7,7},
        {1,1}
    },
    C = {
        {5,1},
        {9,9}
    },
    G = {
        {4,3}
    },
    R = {
        {8,7},
        {6,1},
        {4,5}
    }
}

function getCoordinates(tabella)
    local temp_table = {}
    for index, value in ipairs(tabella.S) do
        temp_table[index] = value
    end
    return temp_table
end
C = getCoordinates(D)

function printTable(tabella) 
    local ltable = {}
    for i = 1, N, 1 do
        ltable[i] = {}
    end
    for _, value in ipairs(tabella.S) do
        ltable[value[1]][value[2]] = 1
    end
    for _, value in ipairs(tabella.S) do
        ltable[value[1]][value[2]] = 1
    end
end

function print_coordinates(tabella)
    for index_sempai, value in ipairs(tabella.S) do
        print("Sempai " .. index_sempai .. ":")
        print("X-Coordinate: " .. value[1])
        print("Y-Coordinate: " .. value[2])
        print()
    end
end
-- print(print_coordinates(D))

-- Function that maps 
function map_matrix(fun, tabella)
    local temp_table = {}
    for index, value in ipairs(tabella) do
        print(index, value, #value)
        for inner_index, inner_value in ipairs(value) do
            temp_table[index + inner_index] = fun(inner_value)
        end
    end
    return temp_table
end

function map_array(fun, tabella)
    local temp_table = {}
    for index, value in ipairs(tabella) do
        temp_table[index] = fun(value)
    end
    return temp_table
end
function inc(x)
    return x + 1
end
-- print(table.unpack(map_array(inc, D.S[1])))

-- slide 26
a = {1, 2, 3}
function copy(table_param)
    local temp = table.pack(table.unpack(table_param))
    return temp
end
-- print(a)
-- print(table.unpack(a))
-- print(copy(a))
-- print(table.unpack(copy(a)))



-- Qui comincia la cosa effettiva

function move(tabella_D, num_sempai)
    local temp_table = {}
    local function sum_prop(tabella_S, num_sempai, num_prop)
        if (num_prop == 7) then return 0 else return tabella_S[num_sempai] + sum_prop(tabella_S, num_sempai, num_prop + 1) end
    end
    local function moveToClosestObject(tabella, num_sempai) 
        local temp_table = {}
        local function diff_dist(sempai_x, sempai_y, obj_x, obj_y)
            return math.abs(sempai_x - obj_x) + math.abs(sempai_y - obj_y)
        end
        local function min_dist(tabella, sempai_x, sempay_y)
            for key, value in pairs(tabella) do
                if (key ~= 'S') then end
            end 
        end
    end
    local function moveGeneral(tabella, num_sempai) end
    if(sum_prop(tabella_D.S, num_sempai, 1)) then temp_table = moveToClosestObject(tabella_D, num_sempai) else temp_table = moveGeneral(tabella_D, num_sempai) end
end
