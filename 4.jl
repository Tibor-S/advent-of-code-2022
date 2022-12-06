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
  dir = dirname(Base.source_path())

  inp_path = dir * "\\4.inp"
  if test == true
    inp_path = dir * "\\4.test.inp"
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
  inp = map(s -> map(t -> map(u -> parse(Int, u), split(t, "-")), split(s, ",")), inp)
  np = 0
  for pair in inp
    if (pair[1][1] >= pair[2][1] && pair[1][2] <= pair[2][2]) || (pair[1][1] <= pair[2][1] && pair[1][2] >= pair[2][2])
      np += 1
    end
  end

  println(np)
end

function p2()
  inp = get_inp(is_test)
  inp = map(s -> map(t -> map(u -> parse(Int, u), split(t, "-")), split(s, ",")), inp)
  np = 0
  for pair in inp
    if (pair[1][1] <= pair[2][1] && pair[2][1] <= pair[1][2]) || (pair[1][1] <= pair[2][2] && pair[2][2] <= pair[1][2]) || (pair[2][1] <= pair[1][1] && pair[1][1] <= pair[2][2]) || (pair[2][1] <= pair[1][2] && pair[1][2] <= pair[2][2])
      np += 1
    else
      println(pair)

    end
  end

  println(np)
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end