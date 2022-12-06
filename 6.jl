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
  function first_occ(str)
    i = 1
    while i <= length(str)
      if i - 3 >= 1
        buff = collect(str[i-3:i])
        mat = false
        while length(buff) > 0
          a = pop!(buff)
          for b in buff
            if a == b
              mat = true
              break
            end
          end
          if mat == true
            break
          end
        end
        if mat == false
          return i
        end
      end
      i += 1
    end

    return nothing
  end

  inp = get_inp(is_test)
  inp = inp[1]
  index = first_occ(inp)

  println(index)

end

function p2()
  function first_occ(str, N)
    i = 1
    while i <= length(str)
      st = i - N
      if st >= 1
        buff = collect(str[st:i])
        mat = false
        while length(buff) > 0
          a = pop!(buff)
          for b in buff
            if a == b
              mat = true
              break
            end
          end
          if mat == true
            break
          end
        end
        if mat == false
          return i
        end
      end
      i += 1
    end

    return nothing
  end

  inp = get_inp(is_test)
  inp = inp[1]
  index = first_occ(inp, 13)

  println(index)
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end