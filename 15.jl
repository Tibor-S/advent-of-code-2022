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

struct Sensor
  x::Int
  y::Int
  bec_x::Int
  bec_y::Int
  dist::Int
end

function p1()
  inp = get_inp(is_test)
  sensors::Vector{Sensor} = []
  bounds::Vector{Union{Nothing,Int}} = [nothing, nothing]
  for line in inp
    x = parse(Int, match(r"(?:Sensor.+x=)(\d+|-\d+)(?:.+:)", line)[1])
    y = parse(Int, match(r"(?:Sensor.+y=)(\d+|-\d+):", line)[1])
    bec_x = parse(Int, match(r"(?:beacon.+x=)(\d+|-\d+)", line)[1])
    bec_y = parse(Int, match(r"(?:beacon.+y=)(\d+|-\d+)", line)[1])
    dist = abs(bec_x - x) + abs(bec_y - y)
    if bounds[1] === nothing || x - dist < bounds[1]
      bounds[1] = x - dist
    end
    if bounds[2] === nothing || x + dist > bounds[2]
      bounds[2] = x + dist
    end
    push!(sensors, Sensor(x, y, bec_x, bec_y, dist))
  end

  in_range(x::Int, y::Int, sen::Sensor) = abs(x - sen.x) + abs(y - sen.y) <= sen.dist

  s = 0
  if is_test
    y = 10
  else
    y = 2000000
  end
  for x in range(bounds[1], bounds[2])
    ran = false
    for sen in sensors
      if in_range(x, y, sen)
        ran = true
      end

      if x == sen.bec_x && y == sen.bec_y
        ran = false
        break
      end
    end
    if ran
      s += 1
    end
  end
  println(s)
end

function p2()
  inp = get_inp(is_test)
  sensors::Vector{Sensor} = []
  for line in inp
    x = parse(Int, match(r"(?:Sensor.+x=)(\d+|-\d+)(?:.+:)", line)[1])
    y = parse(Int, match(r"(?:Sensor.+y=)(\d+|-\d+):", line)[1])
    bec_x = parse(Int, match(r"(?:beacon.+x=)(\d+|-\d+)", line)[1])
    bec_y = parse(Int, match(r"(?:beacon.+y=)(\d+|-\d+)", line)[1])
    dist = abs(bec_x - x) + abs(bec_y - y)
    push!(sensors, Sensor(x, y, bec_x, bec_y, dist))
  end
  if is_test
    bounds = [0, 20]
  else
    bounds = [0, 4000000]
  end

  in_range(x::Int, y::Int, sen::Sensor) = abs(x - sen.x) + abs(y - sen.y) <= sen.dist
  found::Union{Tuple{Int,Int},Nothing} = nothing
  for sen in sensors
    dist = sen.dist + 1
    x = sen.x
    y = sen.y
    dx = dist
    dy = 0
    for _ in range(1, dist + 1)
      dir = [(1, 1), (-1, 1), (-1, -1), (1, -1)]
      for d in dir
        nx = x + d[1] * dx
        ny = y + d[2] * dy
        if bounds[1] <= nx <= bounds[2] && bounds[1] <= ny <= bounds[2]
          is_range = false
          for sen2 in sensors
            if in_range(nx, ny, sen2)
              is_range = true
              break
            end
          end
          if !is_range
            found = (nx, ny)
          end
        end
      end
      dx -= 1
      dy += 1
      if found !== nothing
        break
      end
    end
  end
  println(found[1] * 4000000 + found[2])
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end