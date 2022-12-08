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
  frst = map(s -> map(c -> parse(Int, c), collect(s)), inp)
  println(typeof(frst))
  pushfirst!(frst, [-1 for _ in range(1, length(frst))])
  push!(frst, [-1 for _ in range(1, length(frst))])
  for row in frst
    pushfirst!(row, -1)
    push!(row, -1)
  end

  tb = range(2, length(frst) - 1)
  lr = range(2, length(frst[1]) - 1)
  bt = reverse(tb)
  rl = reverse(lr)

  is_hidden = [[false for _ in range(1, length(frst[1]))] for _ in range(1, length(frst))]

  for x in lr
    tallest = -1
    for y in tb
      if frst[y][x] > tallest
        tallest = frst[y][x]
        is_hidden[y][x] = true
      end
    end
    tallest = -1
    for y in bt
      if frst[y][x] > tallest
        tallest = frst[y][x]
        is_hidden[y][x] = true
      end
    end
  end

  for y in tb
    tallest = -1
    for x in lr
      if frst[y][x] > tallest
        tallest = frst[y][x]
        is_hidden[y][x] = true
      end
    end
    tallest = -1
    for x in rl
      if frst[y][x] > tallest
        tallest = frst[y][x]
        is_hidden[y][x] = true
      end
    end
  end
  println(sum(sum, is_hidden))

end

function p2()
  inp = get_inp(is_test)
  frst = map(s -> map(c -> parse(Int, c), collect(s)), inp)
  pushfirst!(frst, [-1 for _ in range(1, length(frst))])
  push!(frst, [-1 for _ in range(1, length(frst))])
  for row in frst
    pushfirst!(row, -1)
    push!(row, -1)
  end

  v_min = 2
  v_max = length(frst) - 1
  h_min = 2
  h_max = length(frst[1]) - 1

  vals = [[[0, 0, 0, 0] for _ in range(1, length(frst[1]))] for _ in range(1, length(frst))]

  for y in range(v_min, v_max)
    for x in range(h_min, h_max)
      org = frst[y][x]

      # to right
      tx = 0
      while true
        tx += 1
        trg = frst[y][x+tx]
        if trg >= org
          vals[y][x][1] = tx
          break
        elseif trg == -1
          vals[y][x][1] = tx - 1
          break
        end
      end


      # to left
      tx = 0
      while true
        tx += 1
        trg = frst[y][x-tx]
        if trg >= org
          vals[y][x][2] = tx
          break
        elseif trg == -1
          vals[y][x][2] = tx - 1
          break
        end
      end

      # to bottom
      ty = 0
      while true
        ty += 1
        trg = frst[y+ty][x]
        if trg >= org
          vals[y][x][3] = ty
          break
        elseif trg == -1
          vals[y][x][3] = ty - 1
          break
        end
      end

      # to right
      ty = 0
      while true
        ty += 1
        trg = frst[y-ty][x]
        if trg >= org
          vals[y][x][4] = ty
          break
        elseif trg == -1
          vals[y][x][4] = ty - 1
          break
        end
      end

    end
  end

  println(maximum(map(row -> maximum(map(prod, row)), vals)))
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end