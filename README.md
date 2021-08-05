# Simple Genetic Algorithm

This repo contains my first genetic algorithm in Elixir using [Nx](https://github.com/elixir-nx/nx).

Rules are simple :

- Each chromosome is composed of 26 genes (letters from A to Z)
- Chromosomes are randomly generated for the first generation
- The goal is to obtain a perfect chromosome (the 26 letters of the alphabet in order)

## Requirements

    - Elixir v1.12.0 (for the `Mix.install` function)
    - Tested with OTP 24

## Usage

    > git clone https://github.com/ImNotAVirus/simple_genetic_algorithm_ex
    > cd simple_genetic_algorithm_ex
    > elixir genetic_algorithm.exs

## Notes

Currently all variables are hardcoded but I plan to create a basic library for Genetic Algoithms when I'll have more knowledge about Nx.

Any contribution (PR, issues, ....) to improve my code is welcome!
