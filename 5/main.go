package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"sort"
)

func findLoc(in string, start int, end int) int {
	var mid, hi, lo int
	hi = end
	lo = start

	for _, c := range in {
		mid = (hi + lo) / 2
		switch c {
		case 'F':
			fallthrough
		case 'L':
			hi = mid
		case 'B':
			fallthrough
		case 'R':
			lo = mid + 1
		}
	}

	return lo
}

func getSeatId(in string) int {
	var row, col, seatId int

	rowLoc := in[:7]
	colLoc := in[7:]

	// determine row number
	row = findLoc(rowLoc, 0, 127)
	col = findLoc(colLoc, 0, 7)

	// determine seat id
	seatId = row*8 + col

	return seatId
}

func max(x, y int) int {
	if x < y {
		return y
	} else {
		return x
	}
}

func min(x, y int) int {
	if x > y {
		return y
	} else {
		return x
	}
}

func main() {
	seatIds := make([]int, 824) // 824 lines in input.txt

	// idiomatic way to read a file line by line
	// https://stackoverflow.com/a/16615559/10873829
	file, err := os.Open("./input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for i := 0; scanner.Scan(); i = i + 1 {
		seatIds[i] = getSeatId(scanner.Text())
	}

	sort.Ints(seatIds)
	for i := 1; i < len(seatIds); i += 1 {
		if seatIds[i] != seatIds[i-1]+1 {
			fmt.Printf("missing seat %v\n", seatIds[i-1]+1)
			os.Exit(0)
		}
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
