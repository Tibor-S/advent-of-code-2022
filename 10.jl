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
  inp = map(split, inp)
  add_h = []
  for com in inp
    for num in com
      val = tryparse(Int, num)
      if val === nothing
        push!(add_h, 0)
      else
        push!(add_h, val)
      end
    end
  end
  reg = 1
  reg_h = [1]
  for i in range(1, length(add_h))
    reg += add_h[i]
    push!(reg_h, reg)
    println(i, " ", add_h[i], " ", reg)
  end
  sig_h = []
  for i in range(1, length(reg_h))
    push!(sig_h, i * reg_h[i])
  end
  s = 0
  i = 20
  while i <= length(sig_h)
    s += sig_h[i]
    i += 40
  end
  for i in range(1, length(add_h))
    println(i, " ", add_h[i], " ", reg_h[i], " ", sig_h[i])
  end
  println(s)
end

function p2()
  inp = get_inp(is_test)
  inp = map(split, inp)
  add_h = []
  for com in inp
    for num in com
      val = tryparse(Int, num)
      if val === nothing
        push!(add_h, 0)
      else
        push!(add_h, val)
      end
    end
  end
  reg = 1
  reg_h = [1]
  for i in range(1, length(add_h))
    reg += add_h[i]
    push!(reg_h, reg)
    # println(i, " ", add_h[i], " ", reg)
  end
  vect::Vector{Char} = []
  sprite = 1
  for i in range(1, 240)
    println(sprite)
    push!(vect, sprite <= i % 40 <= sprite + 2 ? '#' : '.')
    println(vect[length(vect)])
    sprite = reg_h[i+1]
  end
  println(reg_h)
  i = 1
  while i <= length(vect)
    println(join(vect[i:i+39]))
    i += 40
  end
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end