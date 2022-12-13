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
  inp = filter(v -> length(v) > 0, map(s -> convert(Vector{Union{Char,AbstractString,Int}}, collect(s)), inp))
  for row in inp
    i = 1
    while i <= length(row)
      if row[i] == '1' && row[i+1] == '0'
        popat!(row, i + 1)
        row[i] = "10"
      end
      if row[i] != '[' && row[i] != ']' && row[i] != ','
        row[i] = parse(Int, row[i])
      end
      i += 1
    end
    filter!(c -> c != ',', row)
  end
  i = 1
  s = 0
  while i <= length(inp)
    X = inp[i]
    Y = inp[i+1]
    depth = 0
    order = nothing
    j = 1
    while true
      x = X[j]
      y = Y[j]
      if x == '[' && y == '['
        depth += 1
      elseif x == ']' && y == ']'
        depth -= 1
      elseif x == ']'
        order = true
        break
      elseif y == ']'
        order = false
        break
      elseif x == '['
        insert!(Y, j, '[')
        insert!(Y, j + 2, ']')
      elseif y == '['
        insert!(X, j, '[')
        insert!(X, j + 2, ']')
      elseif x == y
      elseif x > y
        order = false
        break
      elseif x < y
        order = true
        break
      else
        println("shit")
      end
      j += 1
    end
    if order
      s += (i + 1) / 2
    end
    i += 2
  end
  println(Int(s))
end

function p2()
  function compare(X, Y)
    NX = deepcopy(X)
    NY = deepcopy(Y)
    order = nothing
    j = 1
    while true
      x = NX[j]
      y = NY[j]
      if x == '[' && y == '['
      elseif x == ']' && y == ']'
      elseif x == ']'
        order = true
        break
      elseif y == ']'
        order = false
        break
      elseif x == '['
        insert!(NY, j, '[')
        insert!(NY, j + 2, ']')
      elseif y == '['
        insert!(NX, j, '[')
        insert!(NX, j + 2, ']')
      elseif x == y
      elseif x > y
        order = false
        break
      elseif x < y
        order = true
        break
      else
        println("shit")
      end
      j += 1
    end
    return order
  end

  inp = get_inp(is_test)
  inp = filter(v -> length(v) > 0, map(s -> convert(Vector{Union{Char,AbstractString,Int}}, collect(s)), inp))
  for row in inp
    i = 1
    while i <= length(row)
      if row[i] == '1' && row[i+1] == '0'
        popat!(row, i + 1)
        row[i] = "10"
      end
      if row[i] != '[' && row[i] != ']' && row[i] != ','
        row[i] = parse(Int, row[i])
      end
      i += 1
    end
    filter!(c -> c != ',', row)
  end
  i = 1
  l1 = 0
  l2 = 0
  while i <= length(inp)
    X = inp[i]
    Y = ['[', '[', 2, ']', ']']
    Z = ['[', '[', 6, ']', ']']
    if compare(X, Y)
      l1 += 1
    end
    if compare(X, Z)
      l2 += 1
    end
    i += 1
  end
  println((l1 + 1) * (l2 + 2))
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end