import std/streams
import sequtils
import deques
import sets
import tables
import heapqueue

proc readFileLines(filename: string): seq[string] =
  result = newSeq[string]()
  for line in lines(filename):
    result.add(line)

proc part1(): int =
  var lines = readFileLines("in")
  var start = lines[0].findIt(it == 'S')
  var deq = initDeque[(int, int)]()
  var set = initHashSet[(int, int)]()
  var result = 0

  deq.addLast((0, start))

  while deq.len > 0:
    let item = deq.popFirst()

    if item[0] >= lines.len or item[1] >= lines[0].len:
       continue

    if item in set:
       continue
    set.incl(item)

    if lines[item[0]][item[1]] == '^':
      result += 1
      deq.addLast((item[0], item[1] + 1))
      deq.addLast((item[0], item[1] - 1))
    else:
      lines[item[0]][item[1]] = '|'
      deq.addLast((item[0] + 1, item[1]))

  result

proc part2(): int =
  var lines = readFileLines("in")
  var start = lines[0].findIt(it == 'S')
  var deq = initHeapQueue[(int, int)]()
  var map = initTable[(int, int), int]()
  var result = 0

  let add = proc(val: (int, int), count: int): void {.closure.} =
    if val in map:
       map[val] += count
    else:
       map[val] = count
       deq.push(val)

  deq.push((0, start))

  while deq.len > 0:
    let item = deq.pop()
    let next = (item[0] + 1, item[1])
    let count = map.mgetOrPut(item, 1);

    if item[0] == lines.len - 1:
       result += count

    if next[0] >= lines.len or next[1] >= lines[0].len:
       continue

    if lines[next[0]][next[1]] == '^':
      let right = (next[0], next[1] + 1)
      let left = (next[0], next[1] -  1)

      add(left, count)
      add(right, count)
    else:
      add(next, count)

  return result

echo(part2())
