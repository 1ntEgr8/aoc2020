import Foundation

// reads the input from a file
func readInput(path: String) -> [[Character]] {
    var data: [[Character]] = []
    do {
        let contents = try String(contentsOfFile: path)
        for line in contents.split(separator: "\n") {
            data.append(Array(line))
        }
    } catch {
        print("contents could not be loaded")
        exit(-1)
    }
    return data
}

let directions = [
    (0,-1),
    (0,1),
    (-1,0),
    (1,0),
    (-1,-1),
    (-1,1),
    (1,-1),
    (1,1)
]
func numOccupied(around: (Int,Int), _ state: [[Character]]) -> Int {
    var numOccupied = 0
    let (i,j) = around 
    for (dx,dy) in directions {
        let (x,y) = (i+dx,j+dy)
        if x < 0 || y < 0 || x >= state.count || y >= state[0].count { continue }
        if state[x][y] == "#" { numOccupied += 1 }
    }
    return numOccupied 
}

func nextState_pt1(from: [[Character]]) -> [[Character]] {
    var state = from
    
    for i in 0..<from.count {
        for j in 0..<from[0].count {
            if from[i][j] == "L" && numOccupied(around:(i,j),from) == 0 {
                state[i][j] = "#"
            } else if from[i][j] == "#" && numOccupied(around:(i,j),from) >= 4 {
                state[i][j] = "L"
            }
        }
    }

    return state
}

func numOccupiedSpread(around: (Int, Int), _ state: [[Character]]) -> Int {
    var numOccupied = 0
    let (i,j) = around 
    for (dx,dy) in directions {
        var (x,y) = (i+dx,j+dy)
        while true {
            if x < 0 || y < 0 || x >= state.count || y >= state[0].count { break }
            if state[x][y] != "." {
                if state[x][y] == "#" { numOccupied += 1 }
                break
            }
            (x,y) = (x+dx,y+dy)
        }
    }

    return numOccupied 
}

func nextState_pt2(from: [[Character]]) -> [[Character]] {
    var state = from
    
    for i in 0..<from.count {
        for j in 0..<from[0].count {
            if from[i][j] == "L" && numOccupiedSpread(around:(i,j),from) == 0 {
                state[i][j] = "#"
            } else if from[i][j] == "#" && numOccupiedSpread(around:(i,j),from) >= 5 {
                state[i][j] = "L"
            }
        }
    }

    return state
}


func run(start: [[Character]], transition: (_: [[Character]]) -> [[Character]]) {
    var currState = start
    var nextState = transition(start)
    
    while nextState != currState {
        currState = nextState
        nextState = transition(currState)
    }
    
    let result = currState.reduce(0, { (acc,row) -> Int in
        return acc + row.filter({ $0 == "#"}).count
    })
    
    print(result)
}

let data = readInput(path: "input.txt")
// part 1
// run(start: data, transition: nextState_pt1)

// part 2
run(start: data, transition: nextState_pt2)

