defmodule DisjointSetTest do
  use ExUnit.Case
  doctest DisjointSet

  test "creates a set" do
    assert DisjointSet.new() == %DisjointSet{}
  end

  test "inserts a single value" do
    set = DisjointSet.new()
    set = DisjointSet.insert(set, 1)
    assert Enum.count(set.forest) == 1
  end

  test "inserts two values" do
    set = DisjointSet.new()
    set = DisjointSet.insert(set, 1)
    set = DisjointSet.insert(set, 2)
    assert Enum.count(set.forest) == 2
  end

  test "does not insert duplicates" do
    set = DisjointSet.new()
    set = DisjointSet.insert(set, 1)
    set = DisjointSet.insert(set, 1)
    assert Enum.count(set.forest) == 1
  end

  test "has distinct roots for inserted values" do
    set = DisjointSet.new()
    set = DisjointSet.insert(set, 1)
    set = DisjointSet.insert(set, 2)
    one_root = DisjointSet.find(set, 1)
    two_root = DisjointSet.find(set, 2)
    assert one_root != two_root
  end

  test "unions two roots" do
    set = DisjointSet.new()
    set = DisjointSet.insert(set, 1)
    set = DisjointSet.insert(set, 2)
    set = DisjointSet.union(set, 1, 2)
    one_root = DisjointSet.find(set, 1)
    two_root = DisjointSet.find(set, 2)
    assert one_root == two_root
  end

  test "unions several roots" do
    set = Enum.reduce(1..8, DisjointSet.new(), fn x, set -> DisjointSet.insert(set, x) end)

    set = DisjointSet.union(set, 1, 2)
    set = DisjointSet.union(set, 1, 5)
    set = DisjointSet.union(set, 1, 6)
    set = DisjointSet.union(set, 1, 8)
    set = DisjointSet.union(set, 3, 4)

    one_root = DisjointSet.find(set, 1)
    two_root = DisjointSet.find(set, 2)
    three_root = DisjointSet.find(set, 3)
    four_root = DisjointSet.find(set, 4)
    five_root = DisjointSet.find(set, 5)
    six_root = DisjointSet.find(set, 6)
    seven_root = DisjointSet.find(set, 7)
    eight_root = DisjointSet.find(set, 8)

    assert one_root == two_root
    assert one_root == five_root
    assert one_root == six_root
    assert one_root == eight_root
    assert three_root == four_root
    assert one_root != three_root
    assert one_root != seven_root
    assert three_root != seven_root
  end

end
