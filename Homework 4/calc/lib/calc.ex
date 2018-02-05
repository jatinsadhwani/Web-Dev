defmodule Calc do

  #this is the main funtion
  #takes input from the user and evaluates the value
  #calls itself for continuous input
  def main do
    expression = IO.gets(">") |> String.trim
    eval(expression)
    main()
  end


  #converts the string into list of tokens
  def eval(expression) do
    exp = String.split(expression," ")
    modifylist(exp,[],0)
  end

  #function to modify the given list to include brackets
  def modifylist([head|tail],final,size) do
    if(String.contains?(head,"(")) do
      exp  = String.split(head, "(")
      nfinal = insert_bracket1(final, size, exp)
      nsize=length(nfinal)
      modifylist(tail,nfinal,nsize)
    end

    if(!String.contains?(head,"(")) do
      if(!String.contains?(head,")")) do
        nfinal = List.insert_at(final,size,head)
        nsize = size+1
        modifylist(tail,nfinal,nsize)
      end
    end


    if(String.contains?(head,")")) do
      exp2 = String.split(head, ")")
      nfinal = insert_bracket2(final, size, exp2)
      nsize=length(nfinal)
      modifylist(tail,nfinal,nsize)
    end
  end

  #displays the final result by evaluating the result
  def modifylist([],final,size) do
    operatorStack = []
    outputStack = []
    operatorSize = 0
    outputSize = 0
    x=evaluate(final, size , operatorStack, operatorSize, outputStack, outputSize)
    IO.puts x
  end

#function to include the starting brackets
  def insert_bracket1(final, size, [head|tail]) do
  if(head=="") do
  nfinal = List.insert_at(final,size,"(")
  nsize=size+1
  insert_bracket1(nfinal,nsize,tail)
  else
  nfinal = List.insert_at(final, size, head)
  nsize=size+1
  insert_bracket1(nfinal,nsize,tail)
  end
end

  def insert_bracket1(final,size,[]) do
    final
  end


#function to include the closing brackets
  def insert_bracket2(final, size, [head|tail]) do
    if(head=="") do
    nfinal = List.insert_at(final,size,")")
    else
    nfinal = List.insert_at(final, size, head)
    end
    nsize=size+1
    insert_bracket2(nfinal,nsize,tail)
  end

  def insert_bracket2(final,size,[]) do
    final
  end


#checks if a given list is empty
  def empty?([]), do: true
  def empty?(list) when is_list(list) do
    false
  end

#executes the operation in the stack based on the operators
  def executeOperation([head|tail],result,resultSize,"+") do
    x=List.last(result)
    y=List.delete_at(result,resultSize-1) |> List.last
    nresultSize = resultSize-1
    z=y+x
    nresult = List.delete_at(result,resultSize-1) |> List.delete_at(nresultSize-1) |> List.insert_at(nresultSize-1,z)
    calculate(tail,nresult,nresultSize)
  end

  def executeOperation([head|tail],result,resultSize,"-") do
    x=List.last(result)
    y=List.delete_at(result,resultSize-1) |> List.last
    nresultSize = resultSize-1
    z=y-x
    nresult = List.delete_at(result,resultSize-1) |> List.delete_at(nresultSize-1) |> List.insert_at(nresultSize-1,z)
    calculate(tail,nresult,nresultSize)
  end

  def executeOperation([head|tail],result,resultSize,"*") do
    x=List.last(result)
    y=List.delete_at(result,resultSize-1) |> List.last
    nresultSize = resultSize-1
    z=y*x
    nresult = List.delete_at(result,resultSize-1) |> List.delete_at(nresultSize-1) |> List.insert_at(nresultSize-1,z)
    calculate(tail,nresult,nresultSize)
  end

  def executeOperation([head|tail],result,resultSize,"/") do
    x=List.last(result)
    y=List.delete_at(result,resultSize-1) |> List.last
    nresultSize = resultSize-1
    z=Integer.floor_div(y,x)
    nresult = List.delete_at(result,resultSize-1) |> List.delete_at(nresultSize-1) |> List.insert_at(nresultSize-1,z)
    calculate(tail,nresult,nresultSize)
  end

#displats the final result
  def calculate([],result,resultSize) do
    List.first(result)
  end

#calculates the final result after converting into postfix expression
  def calculate([head|tail],result,resultSize) do
    if(Enum.member?(["+","-","*","/"],head)) do
        executeOperation([head|tail],result,resultSize,head)
    else
      x=String.to_char_list(head) |> List.to_integer
      nresult = List.insert_at(result,resultSize,x)
      nresultSize = resultSize + 1
      calculate(tail,nresult,nresultSize)
    end
  end

#converts the given infix expression into postfix expression
  def evaluate([head|tail], size, operatorStack, operatorSize, outputStack, outputSize) do
    if(Enum.member?(["+","-","*","/","(",")"], head)) do
      operatorCheck([head|tail],size,operatorStack,operatorSize,outputStack,outputSize, head)
    else
      operatorCheck([head|tail],size,operatorStack,operatorSize,outputStack,outputSize)
    end
  end

  def evaluate([], size, operatorStack, operatorSize, outputStack, outputSize) do
    if(empty?(operatorStack)) do
      x=calculate(outputStack,[],0)
      x
    else
      noutputStack=List.insert_at(outputStack,outputSize,List.last(operatorStack))
      noperatorStack=List.delete_at(operatorStack,operatorSize-1)
      noperatorSize = operatorSize-1
      noutputSize = outputSize + 1
      evaluate([],size,noperatorStack,noperatorSize,noutputStack,noutputSize)
  end
end

#checks the conditions for converting into postfix expression based on the priority of the operator
  def operatorCheck([head|tail],size,operatorStack,operatorSize,outputStack,outputSize,"/") do
    if(List.last(operatorStack) === "*" ) do
      noutputStack=List.insert_at(outputStack,outputSize,"*")
      noperatorStack=List.delete_at(operatorStack,operatorSize-1)
      noperatorSize = operatorSize-1
      noutputSize = outputSize + 1
      operatorCheck([head|tail],size,noperatorStack,noperatorSize,noutputStack,noutputSize,"/")
    else
      if(List.last(operatorStack) === "/" ) do
        noutputStack=List.insert_at(outputStack,outputSize,"/")
        noperatorStack=List.delete_at(operatorStack,operatorSize-1)
        noperatorSize = operatorSize-1
        noutputSize = outputSize + 1
        operatorCheck([head|tail],size,noperatorStack,noperatorSize,noutputStack,noutputSize,"/")
      else
        noperatorStack=List.insert_at(operatorStack, operatorSize, "/")
        noutputStack=outputStack
        noperatorSize = operatorSize + 1
        noutputSize = outputSize
        evaluate(tail, size , noperatorStack, noperatorSize, noutputStack, noutputSize)
      end
    end
  end

  def operatorCheck([head|tail],size,operatorStack,operatorSize,outputStack,outputSize,"*") do
    if(List.last(operatorStack) === "*" ) do
      noutputStack=List.insert_at(outputStack,outputSize,"*")
      noperatorStack=List.delete_at(operatorStack,operatorSize-1)
      noperatorSize = operatorSize-1
      noutputSize = outputSize + 1
      operatorCheck([head|tail],size,noperatorStack,noperatorSize,noutputStack,noutputSize,"*")
    else
      if(List.last(operatorStack) === "/" ) do
        noutputStack=List.insert_at(outputStack,outputSize,"/")
        noperatorStack=List.delete_at(operatorStack,operatorSize-1)
        noperatorSize = operatorSize-1
        noutputSize = outputSize + 1
        operatorCheck([head|tail],size,noperatorStack,noperatorSize,noutputStack,noutputSize,"*")
      else
        noperatorStack=List.insert_at(operatorStack, operatorSize, "*")
        noutputStack=outputStack
        noperatorSize = operatorSize + 1
        noutputSize = outputSize
        evaluate(tail, size , noperatorStack, noperatorSize, noutputStack, noutputSize)
      end
    end
  end

  def operatorCheck([head|tail],size,operatorStack,operatorSize,outputStack,outputSize,"+") do
    if(List.last(operatorStack) === "(" || empty?(operatorStack)) do
      noperatorStack=List.insert_at(operatorStack,operatorSize,"+")
      noutputStack=outputStack
      noperatorSize = operatorSize+1
      noutputSize = outputSize
      evaluate(tail, size , noperatorStack, noperatorSize, noutputStack, noutputSize)
    else
        noutputStack=List.insert_at(outputStack,outputSize,List.last(operatorStack))
        noperatorStack=List.delete_at(operatorStack,operatorSize-1)
        noperatorSize = operatorSize-1
        noutputSize = outputSize + 1
        operatorCheck([head|tail],size,noperatorStack,noperatorSize,noutputStack,noutputSize,"+")
    end
  end

  def operatorCheck([head|tail],size,operatorStack,operatorSize,outputStack,outputSize,"-") do
    if(List.last(operatorStack) === "(" || empty?(operatorStack)) do
      noperatorStack=List.insert_at(operatorStack,operatorSize,"-")
      noutputStack = outputStack
      noperatorSize = operatorSize+1
      noutputSize = outputSize
      evaluate(tail, size , noperatorStack, noperatorSize, noutputStack, noutputSize)
    else
        noutputStack=List.insert_at(outputStack,outputSize,List.last(operatorStack))
        noperatorStack=List.delete_at(operatorStack,operatorSize-1)
        noperatorSize = operatorSize-1
        noutputSize = outputSize + 1
        operatorCheck([head|tail],size,noperatorStack,noperatorSize,noutputStack,noutputSize,"-")
    end
  end

  def operatorCheck([head|tail],size,operatorStack,operatorSize,outputStack,outputSize,"(") do
      noperatorStack=List.insert_at(operatorStack,operatorSize,"(")
      noutputStack = outputStack
      noperatorSize = operatorSize+1
      noutputSize = outputSize
      evaluate(tail, size , noperatorStack, noperatorSize, noutputStack, noutputSize)
  end

  def operatorCheck([head|tail],size,operatorStack,operatorSize,outputStack,outputSize,")") do
    if(List.last(operatorStack) == "(") do
      noperatorStack=List.delete_at(operatorStack, operatorSize-1)
      noperatorSize = operatorSize-1
      noutputStack=outputStack
      noutputSize = outputSize
      evaluate(tail, size , noperatorStack, noperatorSize, noutputStack, noutputSize)
    else
        noutputStack=List.insert_at(outputStack,outputSize,List.last(operatorStack))
        noperatorStack=List.delete_at(operatorStack,operatorSize-1)
        noperatorSize = operatorSize-1
        noutputSize = outputSize + 1
        operatorCheck([head|tail],size,noperatorStack,noperatorSize,noutputStack,noutputSize,")")
    end
  end

  def operatorCheck([head|tail],size,operatorStack,operatorSize,outputStack,outputSize) do
      noutputStack = List.insert_at(outputStack,outputSize,head)
      noperatorStack = operatorStack
      noperatorSize = operatorSize
      noutputSize = outputSize + 1
      evaluate(tail, size , noperatorStack, noperatorSize, noutputStack, noutputSize)
    end
  @moduledoc """
  Documentation for Calc.
  """
end
