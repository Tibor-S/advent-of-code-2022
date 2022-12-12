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
  startPos = (0, 0)
  endPos = (0, 0)

  inp = map(s -> map(Int, collect(s)), inp)
  val_map = map(s -> map(_ -> length(inp) * length(inp[1]), s), inp)

  for y in range(1, length(inp))
    for x in range(1, length(inp[y]))
      c = inp[y][x]
      if c == Int('S')
        startPos = (x, y)
        inp[y][x] = Int('a')
      elseif c == Int('E')
        endPos = (x, y)
        inp[y][x] = Int('z')
      end
    end
  end

  val_map[startPos[2]][startPos[1]] = 0
  reachedEnd = false
  dirrs = [(0, 1), (1, 0), (0, -1), (-1, 0)]
  stack::Vector{Tuple{Int,Int}} = [startPos]
  highest = 0
  while !reachedEnd
    x1, y1 = popfirst!(stack)

    for dirr in dirrs
      x2, y2 = x1 + dirr[1], y1 + dirr[2]
      if (1 <= x2 <= length(inp[1])) && (1 <= y2 <= length(inp))
        hei1, hei2 = inp[y1][x1], inp[y2][x2]
        if hei2 - hei1 <= 1
          if hei2 > highest
            highest = hei2
          end
          val1, val2 = val_map[y1][x1], val_map[y2][x2]
          new_val = val1 + 1
          if new_val < val2
            val_map[y2][x2] = new_val
            push!(stack, (x2, y2))
            if x2 == endPos[1] && y2 == endPos[2]
              reachedEnd = true
              break
            end
          end
        end
      end
    end
  end
  println(val_map[endPos[2]][endPos[1]])
end

function p2()
  inp = get_inp(is_test)
  startPos_s::Vector{Tuple{Int,Int}} = []
  endPos = (0, 0)

  inp = map(s -> map(Int, collect(s)), inp)

  for y in range(1, length(inp))
    for x in range(1, length(inp[y]))
      c = inp[y][x]
      if c == Int('S')
        inp[y][x] = Int('a')
        push!(startPos_s, (x, y))
      elseif c == Int('a')
        push!(startPos_s, (x, y))
      elseif c == Int('E')
        endPos = (x, y)
        inp[y][x] = Int('z')
      end
    end
  end

  trail_len::Vector{Int} = []
  i = 1
  for startPos in startPos_s
    val_map = map(s -> map(_ -> length(inp) * length(inp[1]), s), inp)
    val_map[startPos[2]][startPos[1]] = 0
    reachedEnd = false
    dirrs = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    stack::Vector{Tuple{Int,Int}} = [startPos]
    while !reachedEnd
      if length(stack) > 0
        x1, y1 = popfirst!(stack)

        for dirr in dirrs
          x2, y2 = x1 + dirr[1], y1 + dirr[2]
          if (1 <= x2 <= length(inp[1])) && (1 <= y2 <= length(inp))
            hei1, hei2 = inp[y1][x1], inp[y2][x2]
            if hei2 - hei1 <= 1
              val1, val2 = val_map[y1][x1], val_map[y2][x2]
              new_val = val1 + 1
              if new_val < val2
                val_map[y2][x2] = new_val
                push!(stack, (x2, y2))
                if x2 == endPos[1] && y2 == endPos[2]
                  reachedEnd = true
                  break
                end
              end
            end
          end
        end
      else
        break
      end
    end
    i += 1
    push!(trail_len, val_map[endPos[2]][endPos[1]])
  end
  println(minimum(trail_len))
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end