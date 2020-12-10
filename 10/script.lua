-- read the input into a list
-- sort the list

function max(list)
    max = list[1] 
    for i=1,#list do
        if list[i] > max then
            max = list[i]
        end 
    end
    return max
end

function part_1(data)
    table.sort(data)

    diffs_by_1 = 0
    diffs_by_3 = 0
    
    for i=2, #data do
        diff = data[i] - data[i-1]
        if diff == 1 then
            diffs_by_1 = diffs_by_1 + 1
        else
            diffs_by_3 = diffs_by_3 + 1
        end
    end
    
    print("d1 ", diffs_by_1)
    print("d3 ", diffs_by_3)
    print("d1*d3 ", diffs_by_1 * diffs_by_3)
end

function part_2(data)
    table.sort(data)
    dp = {}
    dp[1] = 1
    dp[2] = 1
    
    if data[3]-data[1] < 3 then
        dp[3] = 2
    else
        dp[3] = 1
    end
    

    for i=4, #data do
        dp[i] = 0
        dp[i] = dp[i] + dp[i-1]
        if data[i]-data[i-2] <= 3 then
            dp[i] = dp[i] + dp[i-2]
        end
        if data[i]-data[i-3] <= 3 then
            dp[i] = dp[i] + dp[i-3]
        end
    end
    
    print(dp[#data])

    return dp[#data]
end

data = {0}

for line in io.lines("./input.txt") do
    data[#data+1] = tonumber(line)
end

table.insert(data,max(data)+3)

-- part_1(data)
part_2(datatest_input)
