# Ovo

Ovo is hosted by Elixir.
It is now used as a data scripting language in Alzo.archi and the weird features of the previous toy implementation ( https://github.com/lucassifoni/ovo ) will be deleted. This means proper error handling is also coming.

## Current state

Ovo in its current state is capable of correctly running small programs :

```elixir
fibs = \a ->
  if a >= 2 then
    b = a - 1
    c = a - 2
    fibs(b) + fibs(c)
  else
    1
  end
end

fibs(10)
```

## Unusual features

Ovo has a distinguishing feature : the ability to be ran as a global stateful system. **This will be deprecated very soon**.

### A global stateful system

You can run Ovo programs as shown above, by writing code and calling `Ovo.run/2` with your code and some input. But you can also run programs as independent `Runners` inside a stateful system, like so :

```elixir
# Start an Ovo.Registry
Ovo.Registry.start()
# Start some Ovo.Runners
{:ok, ovo_adder} = Ovo.Runner.register("""
add(arg(0), arg(1))
""")
{:ok, ovo_times2} = Ovo.Runner.register("""
multiply(arg(0), 2)
""") # ovo_times2 is 0ceaimhlh, which is this runner's ID and this program's hash
```

You can then call those runners with input :

```elixir
Ovo.Runner.run(ovo_adder, [2, 3])
Ovo.Runner.run(ovo_times2, [5])
```

You can also chain calls to programs, by giving their hashes to the registry, like so :

```elixir
Ovo.Registry.run_chain([ovo_adder, ovo_times2], [2, 3])
```

If you know some program's hash (which is deterministic), you can also call it from another program with `invoke/2` :

```elixir
{:ok, dependent_program} = Ovo.Runner.register("""
invoke(`0ceaimhlh`, [2])
""")

Ovo.Runner.run(dependent_program, []) # %Ovo.Ast{value: 4}
```
