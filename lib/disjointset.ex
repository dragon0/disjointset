defmodule DisjointSet do
  @moduledoc """
  Documentation for `DisjointSet`.
  """

  defstruct forest: %{}, rank: %{}

  @doc """
  Creates a new `DisjointSet`.
  """
  def new() do
    %DisjointSet{}
  end

  @doc """
  Inserts `x` into a `DisjointSet` if it is not already present.
  """
  def insert(set = %DisjointSet{forest: forest, rank: rank}, x) do
    %{set | forest: Map.put_new(forest, x, x), rank: Map.put_new(rank, x, 0)}
  end

  @doc """
  Returns the representative for `x`.
  """
  def find(set = %DisjointSet{forest: forest}, x) do
    parent = Map.get(forest, x)
    if parent != x do
      find(set, parent)
    else
      x
    end
  end

  @doc """
  Returns the representative for `x` and updates all nodes on the path from `x` to its representative to use the same root representative.
  """
  def find_and_compress(set = %DisjointSet{forest: forest}, x) do
    root = find(set, x)
    forest = compress(forest, x, root)
    {root, %{set | forest: forest}}
  end

  #Path compression: Updates all nodes on the path from `x` to `new_root` to all refer to `new_root` as their representative.
  defp compress(forest, x, new_root) do
    parent = Map.get(forest, x)
    if parent != new_root do
      compress(Map.put(forest, x, new_root), parent, new_root)
    else
      forest
    end
  end

  @doc """
  Ensures `x` and `y` are in the same subset by updating them to refer to the same representative. Also compresses paths from `x` and `y` to the new representative.
  """
  def union(set, x, y) do
    x_root = find(set, x)
    y_root = find(set, y)

    if x_root == y_root do
      set
    else
      x_rank = Map.get(set.rank, x_root)
      y_rank = Map.get(set.rank, y_root)

      # Swap so the taller tree will be the new root
      {x_root, y_root} = if x_rank < y_rank do
        {y_root, x_root}
      else
        {x_root, y_root}
      end

      # Set x to be the new root
      forest = Map.put(set.forest, y_root, x_root)

      # Compress paths from x and y to point to the new root
      forest = compress(forest, x, x_root)
      forest = compress(forest, y, x_root)

      # Update upper bounds of new root
      rank = if x_rank == y_rank do
        Map.put(set.rank, x_root, x_rank+1)
      else
        set.rank
      end

      %{set | forest: forest, rank: rank}
    end
  end
end
