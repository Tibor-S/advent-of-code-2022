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

  inp_path = dir * "\\2.inp"
  if test == true
    inp_path = dir * "\\2.test.inp"
  end
  io = open(inp_path, "r")
  inp_s = read(io, String)
  inp_s = split(inp_s, "\r\n")
  # inp_s = map(s -> parse(Int, "0" * s), inp_s) # to int
  close(io)
  return inp_s
end

function p1()
  function to_val(s)
    if s == "A" || s == "X"
      return 1
    elseif s == "B" || s == "Y"
      return 2
    elseif s == "C" || s == "Z"
      return 3
    end

    return 0
  end

  function cond(a, b)
    a = a % 3
    b = b % 3
    if a == b
      return 1
    elseif b - a == 1 || b - a == -2
      return 2
    else
      return 0
    end
  end

  inp = get_inp(is_test)
  inp = map(s -> map(to_val, split(s, " ")), inp)

  println(sum(map(act -> act[2] + 3 * cond(act[1], act[2]), inp)))
end

function p2()
  function to_val(s)
    if s == "A" || s == "Y"
      return 1
    elseif s == "B" || s == "Z"
      return 2
    elseif s == "C"
      return 3
    elseif s == "Z"
      return 0
    end
    return 0
  end

  function inv_res(res)
    new_res = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
    for a in range(1, 3)
      for b in range(1, 3)
        c = res[a][b]
        new_res[a][c+1] = b
      end
    end
    return new_res
  end

  inp = get_inp(is_test)
  inp = map(s -> map(to_val, split(s, " ")), inp)

  RES = [
    [1, 2, 0],
    [0, 1, 2],
    [2, 0, 1],
  ]
  INV_RES = inv_res(RES)
  println(sum(map(tup -> tup[2] + tup[3] * 3, map(act -> [act[1], INV_RES[act[1]][act[2]+1], act[2]], inp))))

end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end