defmodule Ovo.Rewrites do
  def rewrite_node({:infix, [left, right], op}) do
    {
      :call,
      [rw(left), rw(right)],
      {:symbol, [], Ovo.Infix.infix_to_builtin(op)}
    }
  end

  def rewrite_node({k, v, n}),
    do: {k, rw(v), rw(n)}

  def rewrite_node(b), do: b

  def rewrite_node_list([h | t]), do: [rewrite_node(h) | rewrite_node_list(t)]
  def rewrite_node_list([]), do: []

  def rw(a) when is_list(a), do: rewrite_node_list(a)
  def rw(a), do: rewrite_node(a)

  def rewrite({k, v, nodes}) do
    {k, rw(v), rw(nodes)}
  end
end
