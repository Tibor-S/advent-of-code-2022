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
  inp = map(x -> (only(split(x)[1]), parse(Int, split(x)[2])), inp)
  hed = [0, 0]
  tai = [0, 0]
  vis::Array{Tuple{Int,Int}} = []
  lim = 1
  for (dir, q) in inp
    dif = (0, 0)
    if dir == 'R'
      dif = (1, 0)
    elseif dir == 'D'
      dif = (0, -1)
    elseif dir == 'L'
      dif = (-1, 0)
    elseif dir == 'U'
      dif = (0, 1)
    end

    for _ in range(1, q)
      hed[1] += dif[1]
      hed[2] += dif[2]

      dx = hed[1] - tai[1]
      dy = hed[2] - tai[2]
      if abs(dx) > lim
        tai[1] += dx / abs(dx)
        tai[2] = hed[2]
      end
      if abs(dy) > lim
        tai[2] += dy / abs(dy)
        tai[1] = hed[1]
      end
      if count(==((tai[1], tai[2])), vis) == 0
        push!(vis, (tai[1], tai[2]))
      end
    end
  end
  println(length(vis))
end

function p2()
  inp = get_inp(is_test)
  inp = map(x -> (only(split(x)[1]), parse(Int, split(x)[2])), inp)
  rope = [[0, 0] for _ in range(1, 10)]
  vis::Array{Tuple{Int,Int}} = []
  lim = 1
  for (dir, q) in inp
    dif = (0, 0)
    if dir == 'R'
      dif = (1, 0)
    elseif dir == 'D'
      dif = (0, -1)
    elseif dir == 'L'
      dif = (-1, 0)
    elseif dir == 'U'
      dif = (0, 1)
    end

    for _ in range(1, q)
      rope[1][1] += dif[1]
      rope[1][2] += dif[2]
      for i in range(2, length(rope))
        dx = rope[i-1][1] - rope[i][1]
        dy = rope[i-1][2] - rope[i][2]
        if abs(dx) > lim || abs(dy) > lim
          dx = dx != 0 ? dx / abs(dx) : 0
          dy = dy != 0 ? dy / abs(dy) : 0
          rope[i][1] += dx
          rope[i][2] += dy
        end
      end
      if count(==((rope[10][1], rope[10][2])), vis) == 0
        push!(vis, (rope[10][1], rope[10][2]))
      end
    end
  end
  println(length(vis))
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end