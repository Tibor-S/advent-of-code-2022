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

struct file
  name::String
  size::Int
end

struct dir
  name::String
  parent::Union{dir,Nothing}
  cont::Array{Union{file,dir}}
end


function p1()

  cd(trg::AbstractString) = dir(trg, nothing, [])
  cd(curr::dir, trg::AbstractString) = begin
    if trg == ".."
      return curr.parent
    elseif trg == "/"
      cd(trg::Val{false}) = dir(trg, nothing, [])
    else
      new = dir(trg, curr, [])
      append!(curr.cont, [new])
      return new
    end
  end

  tree(fil::file) = println("- fil ", fil.name, " ", fil.size)
  tree(curr::dir) = begin
    println("- dir ", curr.name)
    for el in curr.cont
      tree(el)
    end
    println("--")
  end

  siz(fil::file) = fil.size
  siz(curr::dir) = sum(x -> siz(x), curr.cont)

  compSiz!(arr::Array{Int}, _::file) = arr
  compSiz!(arr::Array{Int}, curr::dir) = begin
    append!(arr, [siz(curr)])
    for el in curr.cont
      compSiz!(arr, el)
    end
    return arr
  end

  inp = get_inp(is_test)
  root = cd("/")
  curr = root

  for line in inp
    is_cmd = line[1] == '$'
    if is_cmd
      if contains(line, "\$ cd")
        trg = match(r"(?:[$] )(?:cd )(.+)", line)[1]
        if trg != "/"
          curr = cd(curr, trg)
        end
      else
        continue
      end
    else
      if line[1:3] != "dir"
        size, name = split(line, " ")
        size = parse(Int, size)
        append!(curr.cont, [file(name, size)])
      end
    end
  end

  sizes = [0]
  compSiz!(sizes, root)
  println(sum(filter(x -> x > 0 && x <= 100000, sizes)))
end

function p2()

  cd(trg::AbstractString) = dir(trg, nothing, [])
  cd(curr::dir, trg::AbstractString) = begin
    if trg == ".."
      return curr.parent
    elseif trg == "/"
      cd(trg::Val{false}) = dir(trg, nothing, [])
    else
      new = dir(trg, curr, [])
      append!(curr.cont, [new])
      return new
    end
  end

  tree(fil::file) = println("- fil ", fil.name, " ", fil.size)
  tree(curr::dir) = begin
    println("- dir ", curr.name)
    for el in curr.cont
      tree(el)
    end
    println("--")
  end

  siz(fil::file) = fil.size
  siz(curr::dir) = sum(x -> siz(x), curr.cont)

  compSiz!(arr::Array{Int}, _::file) = arr
  compSiz!(arr::Array{Int}, curr::dir) = begin
    append!(arr, [siz(curr)])
    for el in curr.cont
      compSiz!(arr, el)
    end
    return arr
  end

  inp = get_inp(is_test)
  root = cd("/")
  curr = root

  for line in inp
    is_cmd = line[1] == '$'
    if is_cmd
      if contains(line, "\$ cd")
        trg = match(r"(?:[$] )(?:cd )(.+)", line)[1]
        if trg != "/"
          curr = cd(curr, trg)
        end
      else
        continue
      end
    else
      if line[1:3] != "dir"
        size, name = split(line, " ")
        size = parse(Int, size)
        append!(curr.cont, [file(name, size)])
      end
    end
  end

  max_siz = 70000000
  trg_siz = 30000000
  use_siz = siz(root)
  ava_siz = max_siz - use_siz
  ned_siz = trg_siz - ava_siz
  println(max_siz, " ", trg_siz, " ", ned_siz)

  sizes = [0]
  compSiz!(sizes, root)
  println(minimum(filter(x -> x >= ned_siz, sizes)))
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end