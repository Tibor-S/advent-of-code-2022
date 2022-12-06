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

  inp_path = dir * "\\1.inp"
  if test == true
    inp_path = dir * "\\1.test.inp"
  end
  io = open(inp_path, "r")
  inp_s = read(io, String)
  inp_s = split(inp_s, "\r\n")
  inp_s = map(s -> parse(Int, "0" * s), inp_s) # to int
  close(io)
  return inp_s
end

function p1()
  inp = get_inp(is_test)

  elves = [[]]

  for cal in inp
    if cal == 0
      append!(elves, [[]])
    else
      append!(elves[length(elves)], cal)
    end
  end

  m = maximum(map(sum, elves))
  println(m)
end

function p2()
  inp = get_inp(is_test)

  elves = [[]]

  for cal in inp
    if cal == 0
      append!(elves, [[]])
    else
      append!(elves[length(elves)], cal)
    end
  end

  s = sum(sort(map(sum, elves))[length(elves)-2:length(elves)])
  println(s)

end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end