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

struct Valve
  name::Tuple{Char,Char}
  fr::Int
  to::Vector{Tuple{Char,Char}}
end

mutable struct Player
  opened::Vector{Valve}
  current_valve::Tuple{Char,Char}
  current_path::Vector{Tuple{Char,Char}}
  score::Int
  finished::Bool
end


function p1()
  inp = get_inp(is_test)
  valves::IdDict{Tuple{Char,Char},Valve} = IdDict()
  for line in inp
    name = match(r"(?:Valve )(\w+) ", line)[1]
    fr = parse(Int, match(r"(?:flow rate=)(\d+);", line)[1])
    to = map(s -> (s[1], s[2]), split(match(r"(?:valve[s ]+)([\w, ]+)", line)[1], ", "))
    valves[(name[1], name[2])] = Valve((name[1], name[2]), fr, to)
  end

  look(p::Player) = begin
    visited = [p.current_valve]
    paths::Vector{Vector{Tuple{Char,Char}}} = [[p.current_valve]]
    while length(visited) < length(valves)
      new_paths = []
      for path in paths
        push!(new_paths, path)
        val = valves[path[length(path)]]
        for t_char in val.to
          if count(c -> c == t_char, visited) < 1
            push!(visited, t_char)
            push!(new_paths, vcat(path, t_char))
          end
        end
      end
      paths = new_paths
    end

    for path in paths[2:length(paths)]
      popfirst!(path)
    end
    paths = filter(path -> count(v -> v.name == path[length(path)], p.opened) < 1, paths)
    avg = sum(path -> valves[path[length(path)]].fr, paths) / length(paths)
    # println(avg)
    paths = filter(path -> valves[path[length(path)]].fr >= avg, paths)
    return map(path -> Player(deepcopy(p.opened), deepcopy(p.current_valve), path, deepcopy(p.score), length(path) == 0), paths)
  end

  action(p::Player) = begin

    for val in p.opened
      p.score += val.fr
    end

    if p.finished
      return [p]
    end

    if length(p.current_path) == 0
      push!(p.opened, valves[p.current_valve])
      ps = look(p)
      if length(ps) == 0
        p.finished = true
        return [p]
      end
      return ps
    end

    next_valve = popfirst!(p.current_path)
    # if next_valve == p.current_valve
    #   push!(p.opened, valves[next_valve])
    #   return look(p)
    # end
    p.current_valve = next_valve
    player = deepcopy(p)
    ps = [player]

    return ps
  end
  println(0)
  players = look(Player([], ('A', 'A'), [], 0, false))
  look(players[1])
  for i in range(1, 30)
    # println(" - - - - - NEW ROUND - - - - - - - ")
    println(i)
    new_players = []
    for player in players
      append!(new_players, action(player))
    end
    players = new_players
    # println(" - - - - - END OF ROUND - - - - - - - ")
    # println(reverse(sort(map(p -> p.score, players)))[1])
    # println("PLAYERS:")
    # if i < 11
    #   for p in players
    #     println(" - ", p)
    #   end
    # end
  end
  # println(" - - - - - END - - - - - - - ")
  # println("PLAYERS:")
  # for p in players
  #   println(" - ", p)
  # end
  println(reverse(sort(map(p -> p.score, players)))[1:10])
end

mutable struct Player2
  opened::Vector{Valve}
  current_valve::Vector{Tuple{Char,Char}}
  current_path::Vector{Vector{Tuple{Char,Char}}}
  score::Int
  finished::Vector{Bool}
end

function p2()
  inp = get_inp(is_test)
  valves::IdDict{Tuple{Char,Char},Valve} = IdDict()
  for line in inp
    name = match(r"(?:Valve )(\w+) ", line)[1]
    fr = parse(Int, match(r"(?:flow rate=)(\d+);", line)[1])
    to = map(s -> (s[1], s[2]), split(match(r"(?:valve[s ]+)([\w, ]+)", line)[1], ", "))
    valves[(name[1], name[2])] = Valve((name[1], name[2]), fr, to)
  end

  look(p::Player2) = begin
    ret_path = []
    ret_finished = []

    for index in range(1, 2)
      if length(p.current_path[index]) != 0 || p.finished[index]
        push!(ret_path, p.current_path[index])
        push!(ret_finished, p.finished[index])
      end

      visited = [p.current_valve[index]]
      paths::Vector{Vector{Tuple{Char,Char}}} = [[p.current_valve[index]]]
      while length(visited) < length(valves)
        new_paths = []
        for path in paths
          push!(new_paths, path)
          val = valves[path[length(path)]]
          for t_char in val.to
            if count(c -> c == t_char, visited) < 1
              push!(visited, t_char)
              push!(new_paths, vcat(path, t_char))
            end
          end
        end
        paths = new_paths
      end

      for path in paths[2:length(paths)]
        popfirst!(path)
      end
      paths = filter(path -> count(v -> v.name == path[length(path)], p.opened) < 1, paths)
      avg = sum(path -> valves[path[length(path)]].fr, paths) / length(paths)
      # println(avg)
      paths = filter(path -> valves[path[length(path)]].fr >= avg, paths)
      if length(p.current_path[index%2+1]) != 0
        paths = filter(path -> path[length(path)] != p.current_path[index%2+1][length(p.current_path[index%2+1])], paths)
      end
      push!(ret_path, paths)
      push!(ret_finished, length(path) == 0)
    end

    return map(path -> Player2(deepcopy(p.opened), deepcopy(p.current_valve), deepcopy(ret_path), deepcopy(p.score), deepcopy(ret_finished)), paths)
  end

  action(p::Player2) = begin
    for val in p.opened
      p.score += val.fr
    end
    ps = []
    for i in range(1, 2)
      if p.finished[i]
        push!(ps, p)
      end

      if length(p.current_path[i]) == 0
        push!(p.opened, valves[p.current_valve[i]])
        lp = look(p)
        if length(lp) == 0
          p[i].finished = true
          push!(ps, p)
        end
        push!(ps, lp)
      end

      next_valve = popfirst!(p.current_path[i])
      # if next_valve == p.current_valve
      #   push!(p.opened, valves[next_valve])
      #   return look(p)
      # end
      p.current_valve[i] = next_valve
    end
    ps = map(p -> deepcopy(p), ps)

    return ps
  end
  println(0)
  players = look(Player2([], [('A', 'A'), ('A', 'A')], [[], []], 0, [false, false]))
  for i in range(1, 26)
    # println(" - - - - - NEW ROUND - - - - - - - ")
    println(i)
    new_players = []
    for player in players
      append!(new_players, action(player))
    end
    players = new_players
    # println(" - - - - - END OF ROUND - - - - - - - ")
    # println(reverse(sort(map(p -> p.score, players)))[1])
    # println("PLAYERS:")
    # if i < 11
    #   for p in players
    #     println(" - ", p)
    #   end
    # end
  end
  # println(" - - - - - END - - - - - - - ")
  # println("PLAYERS:")
  # for p in players
  #   println(" - ", p)
  # end
  println(reverse(sort(map(p -> p.score, players)))[1:10])
end

if p == 1
  println("Part 1")
  p1()
elseif p == 2
  println("Part 2")
  p2()
end