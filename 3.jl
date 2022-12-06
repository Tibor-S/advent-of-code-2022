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

  inp_path = dir * "\\3.inp"
  if test == true
    inp_path = dir * "\\3.test.inp"
  end
  io = open(inp_path, "r")
  inp_s = read(io, String)
  inp_s = split(inp_s, "\r\n")
  # inp_s = map(s -> parse(Int, "0" * s), inp_s) # to int
  close(io)
  return inp_s
end

function p1()
  function char_to_prio(ch)
    if ch == lowercase(ch)
      return -32 + Int(ch) - 64
    else
      return Int(ch) - 38
    end
  end

  inp = get_inp(is_test)
  inp = map(r -> map(s -> char_to_prio(only(s)), collect(r)), inp)
  inp = map(el -> [el[1:Int(length(el) / 2)], el[Int(length(el) / 2)+1:length(el)]], inp)

  s = 0
  for rug in inp
    for prio in rug[1]
      if prio in rug[2]
        s += prio
        break
      end
    end
  end

  println(s)
end

function p2()
  function char_to_prio(ch)
    if ch == lowercase(ch)
      return -32 + Int(ch) - 64
    else
      return Int(ch) - 38
    end
  end

  inp = get_inp(is_test)
  inp = map(r -> map(s -> char_to_prio(only(s)), collect(r)), inp)

  s = 0
  i = 1
  while i <= length(inp)
    rugs = inp[i:i+2]
    for prio in rugs[1]
      if prio in rugs[2] && prio in rugs[3]
        s += prio
        break
      end
    end
    i += 3
  end
  println(s)
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end