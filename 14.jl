println(PROGRAM_FILE)
p = 1
is_test = false
for arg in ARGS
  if arg == "2"
    global p = 2
  elseif arg == "test"
    println("Test input")
    global is_test = true
  end
end;

function get_inp(test=false)
  dir = Base.source_path()

  inp_path = dir[1:length(dir)-2] * "inp"
  if test == true
    inp_path = dir[1:length(dir)-2] * "test.inp"
  end
  io = open(inp_path, "r")
  inp_s = read(io, String)
  inp_s = split(inp_s, "\r\n")
  close(io)
  return inp_s
end

function p1()
  inp = get_inp(is_test)
  inp = map(line -> begin
      line = split(line, " -> ")# map(co -> convert(Tuple{Int,Int}, map(x -> parse(Int, x), split(co, ","))), split(line, " -> "))
      line = map(co -> map(x -> parse(Int, x), split(co, ",")), line)
      line = map(co -> (co[1], co[2]), line)
      return line
    end, inp)
  rocks::IdDict{Tuple{Int,Int},Bool} = IdDict()
  lowestRock = 0
  for poly in inp
    i = 1
    while i < length(poly)
      x1, y1 = poly[i]
      x2, y2 = poly[i+1]
      if y1 > lowestRock
        lowestRock = y1
      elseif y1 > lowestRock
        lowestRock = y2
      end
      x, y = x1, y1
      while x != x2 || y != y2
        rocks[(x, y)] = true
        if x2 - x != 0
          x = Int(x + (x2 - x) / abs(x2 - x))
        end
        if y2 - y != 0
          y = Int(y + (y2 - y) / abs(y2 - y))
        end
      end
      rocks[(x2, y2)] = true
      i += 1
    end

  end
  sands::IdDict{Tuple{Int,Int},Bool} = IdDict()
  start = (500, 0)
  while true
    sand = start
    while sand[2] <= lowestRock
      predict = (sand[1], sand[2] + 1)
      if !get(rocks, predict, false) && !get(sands, predict, false)
        sand = predict
        continue
      end
      predict = (predict[1] - 1, predict[2])
      if !get(rocks, predict, false) && !get(sands, predict, false)
        sand = predict
        continue
      end
      predict = (predict[1] + 2, predict[2])
      if !get(rocks, predict, false) && !get(sands, predict, false)
        sand = predict
        continue
      end
      sands[sand] = true
      break
    end
    if sand[2] > lowestRock
      break
    end
  end
  println(length(sands))
end

function p2()
  inp = get_inp(is_test)
  inp = map(line -> begin
      line = split(line, " -> ")# map(co -> convert(Tuple{Int,Int}, map(x -> parse(Int, x), split(co, ","))), split(line, " -> "))
      line = map(co -> map(x -> parse(Int, x), split(co, ",")), line)
      line = map(co -> (co[1], co[2]), line)
      return line
    end, inp)
  rocks::IdDict{Tuple{Int,Int},Bool} = IdDict()
  lowestRock = 0
  for poly in inp
    i = 1
    while i < length(poly)
      x1, y1 = poly[i]
      x2, y2 = poly[i+1]
      if y1 > lowestRock
        lowestRock = y1
      elseif y1 > lowestRock
        lowestRock = y2
      end
      x, y = x1, y1
      while x != x2 || y != y2
        rocks[(x, y)] = true
        if x2 - x != 0
          x = Int(x + (x2 - x) / abs(x2 - x))
        end
        if y2 - y != 0
          y = Int(y + (y2 - y) / abs(y2 - y))
        end
      end
      rocks[(x2, y2)] = true
      i += 1
    end

  end
  sands::IdDict{Tuple{Int,Int},Bool} = IdDict()
  start = (500, 0)
  while true
    sand = start
    while true
      predict = (sand[1], sand[2] + 1)
      if !get(rocks, predict, false) && !get(sands, predict, false) && predict[2] != lowestRock + 2
        sand = predict
        continue
      end
      predict = (predict[1] - 1, predict[2])
      if !get(rocks, predict, false) && !get(sands, predict, false) && predict[2] != lowestRock + 2
        sand = predict
        continue
      end
      predict = (predict[1] + 2, predict[2])
      if !get(rocks, predict, false) && !get(sands, predict, false) && predict[2] != lowestRock + 2
        sand = predict
        continue
      end
      sands[sand] = true
      break
    end
    if get(sands, start, false)
      break
    end
  end
  println(length(sands))
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end