## Setup - Install Nx
Mix.install([
  {:nx, "~> 0.1.0-dev", github: "elixir-nx/nx", branch: "main", sparse: "nx"}
])

## Define the algorithm structure

defmodule GeneticAlgorithmAbc do
  @moduledoc false

  # Hardcoded values, it would be better to create a structure and store them into
  @chromosomes_per_pop 20
  @num_genes 26
  @mutation_rate 0.1

  @perfect_chromosome ?A..?Z |> Enum.to_list() |> Nx.tensor(type: {:u, 32})

  def random_population() do
    Nx.random_uniform({@chromosomes_per_pop, @num_genes}, ?A, ?Z + 1, type: {:u, 32})
  end

  def random_chromosome() do
    Nx.random_uniform({@num_genes}, ?A, ?Z + 1, type: {:u, 32})
  end

  def fit_population(population) do
    population
    |> Nx.equal(@perfect_chromosome)
    |> Nx.sum(axes: [1])
  end

  def select_mating_pool(population, fitness, num_parents_mating) do
    fitness
    |> Nx.to_flat_list()
    |> Enum.with_index()
    # Sort by fitness score
    |> Enum.sort_by(&elem(&1, 0), :desc)
    # Take the first num_parents_mating best scores
    |> Enum.take(num_parents_mating)
    # Keep only indexes
    |> Enum.map(&elem(&1, 1))
    # Get chromosomes by index
    |> Enum.map(&population[&1])
    # Joint the list of tensors
    |> Nx.stack()
  end

  def crossover(parents, num_offspring) do
    first_parents =
      parents
      |> Nx.to_batched_list(1)
      |> Enum.map(&Nx.squeeze(&1))
      |> Stream.cycle()

    second_parents = Stream.drop(first_parents, 1)
    parents_zip = Stream.zip(first_parents, second_parents)

    parents_zip
    |> Enum.take(num_offspring)
    |> Enum.map(&do_crossover/1)
    # Joint the list of tensors
    |> Nx.stack()
  end

  defp do_crossover({parent1, parent2}) do
    mask = random_mask(parent1)

    # Apply mask on both parents:
    #   - if a 0 is found, take the gene from parent2
    #   - if a 1 is found, take the gene from parent1
    Nx.add(
      mask |> Nx.multiply(parent1),
      mask |> Nx.logical_not() |> Nx.multiply(parent2)
    )
  end

  defp random_mask(tensor) do
    # Create a random mask composed by 0 and 1
    tensor
    |> Nx.shape()
    |> elem(0)
    |> then(&{&1})
    |> Nx.random_uniform(0, 2)
  end

  def mutate(offspring_crossover) do
    offspring_crossover
    |> Nx.to_batched_list(1)
    |> Enum.map(&Nx.squeeze(&1))
    |> Enum.map(&do_mutate/1)
    |> Nx.stack()
  end

  defp do_mutate(chromosome) do
    # Get the number of genes to mutate
    num_genes_mut =
      chromosome
      |> Nx.shape()
      |> elem(0)
      |> then(&(&1 * @mutation_rate))
      |> then(&round/1)

    mask = random_mask_max(chromosome, num_genes_mut)
    random_genes = random_chromosome()

    # Apply mask on chromosome and random_genes:
    #   - if a 0 is found, take the gene from random_genes
    #   - if a 1 is found, take the gene from chromosome
    Nx.add(
      mask |> Nx.multiply(chromosome),
      mask |> Nx.logical_not() |> Nx.multiply(random_genes)
    )
  end

  defp random_mask_max(tensor, max_zeros) do
    # Create a random mask composed by 0 and 1
    # There can be only max_zeros zeros
    tensor
    |> Nx.shape()
    |> elem(0)
    |> then(&(0..(&1 - 1)))
    |> Enum.map(&if(&1 < max_zeros, do: 0, else: 1))
    |> Enum.shuffle()
    |> Nx.tensor()
  end
end

## Run it

max_generations = 5000
num_parents_mating = 10

initial_population = GeneticAlgorithmAbc.random_population()

Enum.reduce(1..max_generations, initial_population, fn i, population ->
  # Calculate fitness score for each chromosome in the population
  fitness = GeneticAlgorithmAbc.fit_population(population)
  best_chromosome_idx = Nx.argmax(fitness) |> Nx.to_scalar()
  best_chromosome_fit = fitness[best_chromosome_idx] |> Nx.to_scalar()
  best_chromosome = population[best_chromosome_idx] |> Nx.to_flat_list()

  IO.puts(
    "Generation #{i}: the best chromosome is #{inspect(best_chromosome)} " <>
      "(fitness score: #{best_chromosome_fit})"
  )

  # Selecting the best parents in the population for mating
  parents = GeneticAlgorithmAbc.select_mating_pool(population, fitness, num_parents_mating)

  # Generating next generation using crossover
  num_offspring = population |> Nx.shape() |> elem(0) |> then(&(&1 - num_parents_mating))
  offspring_crossover = GeneticAlgorithmAbc.crossover(parents, num_offspring)

  # Adding some variations to the offsrping using mutation
  offspring_mutation = GeneticAlgorithmAbc.mutate(offspring_crossover)

  # Return the new population based on the parents and offspring
  Nx.concatenate([parents, offspring_mutation])
end)
