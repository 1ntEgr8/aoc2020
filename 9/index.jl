function twosum(window_set, target)
    seen = Set()

    for item in window_set
        complement = target - item
        if complement in seen
            return true
        end
        union!(seen,item)
    end

    false
end

function findslice(data, target)
    left = 1
    right = 1 
    sum = data[begin] 

    while right < length(data)
        # expand window till sum overflows 
        while right <= length(data) && sum < target
            right += 1
            sum += data[right]
        end
        
        if sum == target
            break
        end
        
        # contract window till sum is less
        while left <= right && sum > target
            sum -= data[left]
            left += 1
        end

        if sum == target
            break
        end
    end

    left, right
end


function part1(data)
    preamble_len = 25
    window_start = 1
    window_set = Set(data[window_start:preamble_len])
    
    for target in data[preamble_len+1:end]
        if !twosum(window_set, target)
            # println(target)
            return target
        end
        
        pop!(window_set,data[window_start])
        union!(window_set,target)
        window_start += 1
    end

    -1
end


function part2(data)
    target = part1(data)
    
    left,right = findslice(data,target)
     
    maximum(data[left:right])+minimum(data[left:right])
end


# read input
f = open("input.txt")
data = map(x->parse(Int,x),readlines(f))
close(f)

# solve puzzle
# println(part1(data))
println(part2(data))
