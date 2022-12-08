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
end

function p2()
  inp = get_inp(is_test)
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end