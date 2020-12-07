# build an adjacency list representation of the graph
#
# vertex -> color
# edge -> (edge_weight, color)
#
# if you see shiny gold, don't explore further
#
# don't worry about cycles
# don't worry about visited stuff
#
# note: another pretty jank solution, should refactor

def getKeyValues(line)
  words = line.split " "

  key = words[0] + words[1]
  values = []
  i = 4

  while i < words.length 
    num = words[i]
    if num == "no"
      values << [0,nil]
    else
      color = words[i+1] + words[i+2]
      values << [num.to_i,color]
    end
    i += 4
  end

  return [key,values]
end

def buildAdjList(s)
  adjList = {}
  s.lines().each do |line|
    key,values = getKeyValues line
    adjList[key] = values 
  end

  return adjList
end

def explore_pt1(g,n,k)
  if n == k
    return 1
  elsif n == nil
    return 0
  else
    count = 0
    g[n].each do |_,neighbor| 
      count |= explore_pt1(g,neighbor,k)
    end
    return count
  end
end

def explore_pt2(g,n)
  if n == nil
    return 0  
  end

  count = 1
  g[n].each do |cnt,neighbor|
    count += (cnt * (explore_pt2(g,neighbor)))
  end
  return count
end

def dfs(g,k)
  count = 0
  g.keys
    .filter { |key| key != k }
    .each { |key| count += explore_pt1(g,key,k) }
  count
end

def numPathsToShinyGold(inp)
  g = buildAdjList inp
  dfs(g,"shinygold")
end

def numRequiredBags(inp, key)
  g = buildAdjList inp
  explore_pt2(g,key)-1
end

file = File.open("./input.txt")
data = file.read

# puts(numPathsToShinyGold(data))
puts(numRequiredBags(data,"shinygold"))

