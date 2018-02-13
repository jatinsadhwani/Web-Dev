defmodule Memory.Game do
  def new do
    #defining a function to make a
    %{
      count: 0,
      possible: ["","","","","","","","","","","","","","","",""],
      sequence: {"B","H","G","A","A","E","F","H","B","C","G","E","C","D","F","D"},
      current_letter: "",
      current_index: "",
      score: 0,
      current_activity: false
    }
  end

  def client_view(game) do
    ps = game.possible
    score = game.score

    %{
      possible: game.possible,
      score: game.score
    }
  end

  def intervalClick(game,x) do
    if game.count == 1 || game.current_activity == false do
      newpossible = game.possible
    else
      current_letter= ""
      current_index=""
      newpossible = List.replace_at(game.possible, game.current_index, "") |> List.replace_at(x,"")
    end

    %{
      count: game.count,
      possible: newpossible,
      sequence: {"B","H","G","A","A","E","F","H","B","C","G","E","C","D","F","D"},
      current_letter: game.current_letter,
      current_index: game.current_index,
      score: game.score,
      current_activity: false
    }

  end

   def buttonClick(game,x) do

     mypossible = game.possible
     mycount = game.count
     mysequence = game.sequence
     mytuple = List.to_tuple(mypossible)

     if elem(mytuple,x) == "" do
       score = game.score + 1
       if mycount == 0 do
         newcount = 1
         current_letter = elem(mysequence,x)
         current_index = x
         newpossible = List.replace_at(mypossible, x, current_letter)
         current_activity = false
       else
         newcount = 0
         current_letter = game.current_letter
         current_index = game.current_index
         if (game.current_letter == elem(mysequence,x)) do
           newpossible = List.replace_at(mypossible, x, "OK") |> List.replace_at(game.current_index, "OK")
           current_activity = false
         else
           newpossible = List.replace_at(mypossible, x, elem(mysequence,x))
           current_activity = true
         end
       end
       %{
         count: newcount,
         possible: newpossible,
         sequence: {"B","H","G","A","A","E","F","H","B","C","G","E","C","D","F","D"},
         current_letter: current_letter,
         current_index: current_index,
         score: score,
         current_activity: current_activity
       }
     end
  end
end
