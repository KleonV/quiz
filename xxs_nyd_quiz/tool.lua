#!/usr/bin/env lua

local tool={}
local function anchor_sum_to(amount, sum, anchor_num, count_min, count_max, res)
    if(count_min == count_max) then
        res[anchor_num] = count_min
        return res
    end
    local middle = math.floor((count_max + count_min)/2)
    if (sum + anchor_num*middle >= amount) then
        return anchor_sum_to(amount, sum, anchor_num, count_min, middle, res)
    else
        return anchor_sum_to(amount, sum, anchor_num,  middle+1, count_max, res)
    end
end
tool.anchor_sum_to = anchor_sum_to

local function sum_to (amount, sum, num, num_count, res)
    if (num_count[num] == nil) then
        if (num > 0) then
            return sum_to(amount, sum, num-1, num_count, res)
        else
            return nil
        end
    elseif (sum + num*num_count[num] < amount) then
        res[num] = num_count[num]
        if (num > 0) then
            return sum_to(amount, sum + num * num_count[num], num-1, num_count, res)
        else
            return nil
        end
    else
        return anchor_sum_to(amount, sum, num, 1, num_count[num], res)
    end
end
tool.sum_to = sum_to

local function pre (a, b) 
    if tonumber(a) == nil or tonumber(b) == nil then
        error("In pre: a and b should be number")
    end
    local sum = 0
    local amount
    local num_count = {}
    for i = 1, string.len(b) do
        local digital = string.sub(b, i, i)
        sum = sum + tonumber(digital)
        if num_count[9 - digital] == nil then
            num_count[9 - digital] = 1
        else
            num_count[9 - digital] = num_count[9 - digital] + 1
        end

        if sum > tonumber(a) then
            return 1, -1, num_count
        end
    end
    amount = a - sum
    return 0, amount, num_count
end
tool.pre = pre

function solve(a, b)
    local flag, amount, num_count = pre(a, b)
    if flag == 1 then
        print("solution: always")
        return 0
    else
        local count = 0
        local res=sum_to(amount, 0, 9, num_count, {})
        if res == nil then
            print("solution: never")
            return nil
        else
            for k, v in pairs(res) do 
                print(string.format(" ! change b's digital %d to 9, %d times", 9-k, v))
                count = count + v
            end
            print(string.format("solution: %d times", count))
            return count
        end
    end
end
tool.solve = solve

return tool
