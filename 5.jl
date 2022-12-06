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
  # inp_s = map(s -> parse(Int, "0" * s), inp_s) # to int
  close(io)
  return inp_s
end

function p1()
  inp = get_inp(is_test)

  cargo = []
  for _ in range(1, Int(ceil(length(inp[1]) / 4)))
    append!(cargo, [[]])
  end
  insts = []

  mode = "start"
  for line in inp
    if mode == "start"
      if line == ""
        mode = "inst"
        continue
      elseif tryparse(Int, string(line[2])) === nothing
        s = -2
        i = 1
        while s + i * 4 < length(line)
          type = line[s+i*4]
          if type != ' '
            prepend!(cargo[i], [type])
          end
          i += 1
        end
      else
        continue
      end
    elseif mode == "inst"
      q = parse(Int, match(r"move (\d+)", line)[1])
      f = parse(Int, match(r"from (\d+)", line)[1])
      t = parse(Int, match(r"to (\d+)", line)[1])
      append!(insts, [(q, f, t)])

    end
  end

  for (q, f, t) in insts
    for _ in range(1, q)
      append!(cargo[t], [pop!(cargo[f])])
    end
  end

  res = ""
  for pos in cargo
    res = res * last(pos)
  end

  println(res)
end

function p2()
  inp = get_inp(is_test)

  cargo = []
  for _ in range(1, Int(ceil(length(inp[1]) / 4)))
    append!(cargo, [[]])
  end
  insts = []

  mode = "start"
  for line in inp
    if mode == "start"
      if line == ""
        mode = "inst"
        continue
      elseif tryparse(Int, string(line[2])) === nothing
        s = -2
        i = 1
        while s + i * 4 < length(line)
          type = line[s+i*4]
          if type != ' '
            prepend!(cargo[i], [type])
          end
          i += 1
        end
      else
        continue
      end
    elseif mode == "inst"
      q = parse(Int, match(r"move (\d+)", line)[1])
      f = parse(Int, match(r"from (\d+)", line)[1])
      t = parse(Int, match(r"to (\d+)", line)[1])
      append!(insts, [(q, f, t)])

    end
  end

  for (q, f, t) in insts
    buffer = []
    for _ in range(1, q)
      append!(buffer, [pop!(cargo[f])])
    end
    append!(cargo[t], reverse(buffer))
  end

  res = ""
  for pos in cargo
    res = res * last(pos)
  end

  println(res)
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end