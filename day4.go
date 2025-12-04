package main

import (
	"bufio"
	"fmt"
	"os"
)

func readLines(path string) ([]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines, scanner.Err()
}

func is_roll_string(lines []string, x int, y int) bool {
	if x >= 0 && x < len(lines) && y >= 0 && y < len(lines[0]) {
		return lines[x][y] == '@'
	} else {
		return false
	}
}

func is_roll_bytes(lines [][]byte, x int, y int) bool {
	if x >= 0 && x < len(lines) && y >= 0 && y < len(lines[0]) {
		return lines[x][y] == '@'
	} else {
		return false
	}
}

func count_rolls[T []string | [][]byte](lines T, x int, y int) int {
	var count int = 0

	// Walk through 3x3 square, except for (x, y)
	var x_start = x - 1
	var y_start = y - 1

	for x_i := 0; x_i < 3; x_i++ {
		for y_i := 0; y_i < 3; y_i++ {
			var res bool

			switch v := any(lines).(type) {
			case []string:
				res = is_roll_string(v, x_start+x_i, y_start+y_i)
			case [][]byte:
				res = is_roll_bytes(v, x_start+x_i, y_start+y_i)
			default:
				panic("")
			}

			if res {
				count += 1
			}
		}
	}

	return count - 1
}

func part1() int {
	lines, err := readLines("in")

	if err != nil {
		fmt.Println("Failed to read file", err)
		return -1
	}

	var count = 0

	for x_i := 0; x_i < len(lines); x_i++ {
		for y_i := 0; y_i < len(lines[0]); y_i++ {
			if lines[x_i][y_i] == '@' {
				var cur_count = count_rolls(lines, x_i, y_i)

				if cur_count < 4 {
					count += 1
				}
			}
		}
	}

	return count
}

func stringSliceToByteSlice(strings []string) [][]byte {
	bytes := make([][]byte, len(strings))
	for i, s := range strings {
		bytes[i] = []byte(s)
	}
	return bytes
}

func remove(bytes [][]byte) int {
	var count = 0

	for x_i := 0; x_i < len(bytes); x_i++ {
		for y_i := 0; y_i < len(bytes[0]); y_i++ {
			if bytes[x_i][y_i] == '@' {
				var cur_count = count_rolls(bytes, x_i, y_i)

				if cur_count < 4 {
					count += 1
					bytes[x_i][y_i] = '.'
				}
			}
		}
	}

	return count
}

func part2() int {
	lines, err := readLines("in")
	bytes := stringSliceToByteSlice(lines)

	if err != nil {
		fmt.Println("Failed to read file", err)
		return -1
	}

	var count = 0

	for {
		var current = remove(bytes)

		if current == 0 {
			break
		}

		count += current
	}

	return count
}

func main() {
	fmt.Println("Ans = ", part2())
}
