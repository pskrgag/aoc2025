import sortedcontainers
import re

class Range:
    def __init__(self, start, end):
        self.start = start
        self.end = end

    def __lt__(self, other):
        return self.start < other.start

    def __eq__(self, other):
        return self.start == other.start and other.end == self.end

    def contains(self, value):
        print(f"? {self.start} {self.end} {value} {self.start <= value and value <= self.end}")
        return self.start <= value and value <= self.end

    def overlaps_or_touches(self, value):
        overlaps = self.start <= value.end and value.start <= self.end
        touches_up = self.end + 1 == value.start
        touches_down = self.start == value.end + 1
        return (overlaps or touches_down or touches_up)

    def merge(self, value):
        self.start = min(self.start, value.start)
        self.end = max(self.end, value.end)

class RangeList:
    def __init__(self):
        self.list = sortedcontainers.SortedList()

    def push(self, value):
        lb = self.list.bisect_left(value)

        if lb < len(self.list) and lb > 0:
            if self.list[lb - 1].overlaps_or_touches(value):
                lb -= 1

        while lb >= 0 and lb < len(self.list):
            current = self.list[lb]

            if current.overlaps_or_touches(value):
                value.merge(current)
                self.list.remove(current)
            else:
                break;

        self.list.add(value)

    def is_in_list(self, value):
        lb = self.list.bisect_left(Range(value, 1))

        if lb == len(self.list):
            return self.list[len(self.list) - 1].contains(value)
        else:
            if self.list[lb].start == value:
                return True
            else:
                return self.list[lb - 1].contains(value)

def part1():
    range_re = re.compile(r"(\d+)-(\d+)")

    lst = RangeList()
    count = 0

    with open('in', 'r') as file:
        lines = file.readlines()

        for line in lines:
            res = re.match(range_re, line)
            if res:
                lst.push(Range(int(res.group(1)), int(res.group(2))))
            elif line != "\n":
                if lst.is_in_list(int(line)):
                    count += 1

    print(count)

def part2():
    range_re = re.compile(r"(\d+)-(\d+)")
    lst = RangeList()

    with open('in', 'r') as file:
        lines = file.readlines()

        for line in lines:
            res = re.match(range_re, line)
            if res:
                lst.push(Range(int(res.group(1)), int(res.group(2))))

    res = sum(x.end - x.start + 1 for x in lst.list)
    print(res)

part2()
