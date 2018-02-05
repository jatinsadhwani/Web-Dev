defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "Test-1" do
    assert Calc.eval("2+7") == 9
  end

  test "Test-2" do
    assert Calc.eval("2+7*2") == 16
  end

  test "Test-3" do
    assert Calc.eval("3*(2+7)/9") == 3
  end

  test "Test-4" do
    assert Calc.eval("3*(2+1)") == 9
  end

  test "Test-5" do
    assert Calc.eval("5*1") == 5
  end

  test "Test-6" do
    assert Calc.eval("1+3*3+1") == 11
  end

  test "Test-7" do
    assert Calc.eval("2-7") == -5
  end

  test "Test-8" do
    assert Calc.eval("7*6/3") == 14
  end
end
