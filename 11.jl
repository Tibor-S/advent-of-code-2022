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

mutable struct Monkey
  inspected::Int
  items::Vector{Int}
  op::Function
  divisor::Int
  t_dest::Int
  f_dest::Int
end

function p1()
  inp = get_inp(is_test)
  monkeys::Vector{Monkey} = []
  items::Vector{Int} = []
  op::Function = x -> x
  divisor::Int = 1
  t_dest::Int = 0
  f_dest::Int = 0

  for line in inp
    if contains(line, "  Starting items: ")
      pred = line[19:length(line)]
      items = map(x -> parse(Int, x), split(pred, ", "))
    end
    if contains(line, "  Operation: new = old ")
      pred = line[24:length(line)]
      o, t = split(pred, " ")
      n_t = tryparse(Int, t)
      t = n_t === nothing ? t : n_t
      if o == "+"
        if t == "old"
          op = x -> x + x
        else
          op = x -> x + t
        end
      elseif o == "*"
        if t == "old"
          op = x -> x * x
        else
          op = x -> x * t
        end
      end
    end
    if contains(line, "  Test: divisible by ")
      pred = line[21:length(line)]
      divisor = parse(Int, pred)
    end
    if contains(line, "    If true: throw to monkey ")
      pred = line[29:length(line)]
      t_dest = parse(Int, pred)
    end
    if contains(line, "    If false: throw to monkey ")
      pred = line[30:length(line)]
      f_dest = parse(Int, pred)
      push!(monkeys, Monkey(0, items, op, divisor, t_dest, f_dest))
    end
  end

  for _ in range(1, 20)
    for monkey in monkeys
      # println("\nnew monkey")
      while length(monkey.items) > 0
        monkey.inspected += 1
        item = pop!(monkey.items)
        # println("monkey inspects ", item)
        item = monkey.op(item)
        # println("new worry level: ", item)
        item = floor(item / 3)
        # println("new worry level: ", item)
        if item / monkey.divisor == floor(item / monkey.divisor)
          # println("item to ", monkey.t_dest)
          push!(monkeys[monkey.t_dest+1].items, item)
        else
          # println("item to ", monkey.f_dest)
          push!(monkeys[monkey.f_dest+1].items, item)
        end
      end
    end
    # for m in monkeys
    #   println(m.items, " ", m.inspected)
    # end
    # println("------------")
  end

  inspected = reverse(sort(map(m -> m.inspected, monkeys)))
  println(inspected[1] * inspected[2])

end


mutable struct Monkey2
  inspected::Int
  items::Vector{Union{Int,Vector{Vector{Int}}}}
  op::Function
  divisor::Int
  t_dest::Int
  f_dest::Int
end

function p2()
  inp = get_inp(is_test)
  monkeys::Vector{Monkey2} = []
  items::Vector{Union{Int,Vector{Vector{Int}}}} = []
  op::Function = x -> x
  divisor::Int = 1
  t_dest::Int = 0
  f_dest::Int = 0

  for line in inp
    if contains(line, "  Starting items: ")
      pred = line[19:length(line)]
      items = map(x -> parse(Int, x), split(pred, ", "))
    end
    if contains(line, "  Operation: new = old ")
      pred = line[24:length(line)]
      o, t = split(pred, " ")
      n_t = tryparse(Int, t)
      t = n_t === nothing ? t : n_t
      if o == "+"
        op = item -> begin
          for i in range(1, length(item))
            item[i] = [(item[i][1] + t) % item[i][2], item[i][2]]
          end
        end
      elseif o == "*"
        if t == "old"
          op = item -> begin
            for i in range(1, length(item))
              item[i] = [(item[i][1] * item[i][1]) % item[i][2], item[i][2]]
            end
          end
        else
          op = item -> begin
            for i in range(1, length(item))
              item[i] = [(item[i][1] * t) % item[i][2], item[i][2]]
            end
          end
        end
      end
    end
    if contains(line, "  Test: divisible by ")
      pred = line[21:length(line)]
      divisor = parse(Int, pred)
    end
    if contains(line, "    If true: throw to monkey ")
      pred = line[29:length(line)]
      t_dest = parse(Int, pred)
    end
    if contains(line, "    If false: throw to monkey ")
      pred = line[30:length(line)]
      f_dest = parse(Int, pred)
      push!(monkeys, Monkey2(0, items, op, divisor, t_dest, f_dest))
    end
  end

  for monkey in monkeys
    n_items::Vector{Vector{Vector{Int}}} = []
    for item in monkey.items
      n_item::Vector{Vector{Int}} = []
      for i in range(1, length(monkeys))
        t_monkey = monkeys[i]
        push!(n_item, [item % t_monkey.divisor, t_monkey.divisor])
      end
      push!(n_items, n_item)
    end
    monkey.items = n_items
  end
  for _ in range(1, 10000)
    for i in range(1, length(monkeys))
      monkey = monkeys[i]
      while length(monkey.items) > 0
        monkey.inspected += 1
        item = pop!(monkey.items)
        monkey.op(item)
        if item[i][1] == 0
          push!(monkeys[monkey.t_dest+1].items, item)
        else
          push!(monkeys[monkey.f_dest+1].items, item)
        end
      end
    end
  end

  inspected = reverse(sort(map(m -> m.inspected, monkeys)))
  println(inspected[1] * inspected[2])

end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end