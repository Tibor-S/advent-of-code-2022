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

rocks = [
  [
    ['.', '.', '@', '@', '@', '@', '.',]
  ],
  [
    ['.', '.', '.', '@', '.', '.', '.',],
    ['.', '.', '@', '@', '@', '.', '.',],
    ['.', '.', '.', '@', '.', '.', '.',],
  ],
  [
    ['.', '.', '.', '.', '@', '.', '.',],
    ['.', '.', '.', '.', '@', '.', '.',],
    ['.', '.', '@', '@', '@', '.', '.',],
  ],
  [
    ['.', '.', '@', '.', '.', '.', '.',],
    ['.', '.', '@', '.', '.', '.', '.',],
    ['.', '.', '@', '.', '.', '.', '.',],
    ['.', '.', '@', '.', '.', '.', '.',],
  ],
  [
    ['.', '.', '@', '@', '.', '.', '.',],
    ['.', '.', '@', '@', '.', '.', '.',],
  ],
]

function p1()
  inp = get_inp(is_test)
  controls = map(c -> c == '<' ? -1 : 1, collect(inp[1]))
  cont_i = 0
  println(controls)
  game::Vector{Vector{Char}} = [
    ['.', '.', '.', '.', '.', '.', '.'],
    ['.', '.', '.', '.', '.', '.', '.'],
    ['.', '.', '.', '.', '.', '.', '.'],
  ]

  mv_left(vec::Vector{Char}) = begin
    new_vec = ['.']
    for c in reverse(vec[2:length(vec)])
      pushfirst!(new_vec, c)
    end

    return new_vec
  end
  mv_right(vec::Vector{Char}) = begin
    new_vec = ['.']
    for c in vec[1:length(vec)-1]
      push!(new_vec, c)
    end

    return new_vec
  end

  for r in range(1, 10)
    while '#' in game[length(game)] || '#' in game[length(game)-1] || '#' in game[length(game)-2]
      push!(game, ['.', '.', '.', '.', '.', '.', '.'])
    end

    rock = reverse(deepcopy(rocks[(r-1)%length(rocks)+1]))
    height = length(game)
    while true
      println(height)
      for row in reverse(rock)
        println(row)
      end
      println(" - - - - - - - - ")
      cont_i += 1
      cont_i %= length(controls)
      cont_i += cont_i == 0 ? 1 : 0
      # mv left or right
      move = controls[cont_i]
      for i in range(1, length(rock))
        
        all_ind = findall(c -> c == '@', rock[i])
        predict = map(ind -> ind + move, all_ind)
        if 0 in predict || 8 in predict
          move = 0
          break
        end

        if height + i > length(game)
          continue
        end

        obst = map(ind -> game[height+i][ind], all_ind)
        if '#' in obst
          move = 0
          break
        end
      end
      for i in range(1, length(rock))
        if move == 1
          rock[i] = mv_right(rock[i])
        elseif move == -1
          rock[i] = mv_left(rock[i])
        end
      end

      # drop
      is_drop = true
      for i in range(1, length(rock))
        all_ind = findall(c -> c == '@', rock[i])
        predict = map(ind -> ind, all_ind)

        if height + i - 1 > length(game)
          continue
        end

        obst = map(ind -> game[height+i-1][ind], all_ind)
        if '#' in obst
          println('#', " in ", "obst")
          is_drop = false
          break
        end
      end
      if !is_drop
        break
      end
      height -= 1

      if height < 1
        println("last check")
        # Last mv check
        cont_i += 1
        cont_i %= length(controls)
        cont_i += cont_i == 0 ? 1 : 0
        move = controls[cont_i]
        for i in range(1, length(rock))
          all_ind = findall(c -> c == '@', rock[i])
          predict = map(ind -> ind + move, all_ind)
          if 0 in predict || 8 in predict
            move = 0
            break
          end

          if height + i > length(game)
            continue
          end

          obst = map(ind -> game[height+i][ind], all_ind)
          if '#' in obst
            move = 0
            break
          end
        end
        for i in range(1, length(rock))
          if move == 1
            rock[i] = mv_right(rock[i])
          elseif move == -1
            rock[i] = mv_left(rock[i])
          end
        end
        break
      end
    end

    for row in reverse(rock)
      println(row)
    end
    println(" - - - - - - - - ")
    ###


    for i in range(1, length(rock))
      for j in range(1, length(rock[i]))
        if rock[i][j] == '@'
          game[height+i][j] = '#'
        end
      end
    end
    for row in reverse(game)
      println(row)
    end
    println(" - - - - - - - - ")


    # for y in range(1, length(game))
    #   for x in range(1, length(game[y]))
    #     if game[y][x] == '@'
    #       game[y][x] = '#'
    #     end
    #   end
    # end

  end

  for row in reverse(game)
    println(row)
  end
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