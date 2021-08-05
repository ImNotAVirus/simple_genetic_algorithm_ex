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
    Generation 1: the best chromosome is 'QNODDBHODXABXEEOTRFNSJMXNL' (fitness score: 3)
    Generation 2: the best chromosome is 'QNODDBHODXABXEEOTRFNSJMXNL' (fitness score: 3)
    Generation 3: the best chromosome is 'QNUCEBHYDXAUXREPTRONNQMXNL' (fitness score: 4)
    Generation 4: the best chromosome is 'QNUCEBHYDXAUXREPTRONNQMXNL' (fitness score: 4)
    Generation 5: the best chromosome is 'QNUCEBHYDXAUXREPTRONNQMXNL' (fitness score: 4)
    Generation 6: the best chromosome is 'QPTIHWKHWXATTEENORSBSVXXNL' (fitness score: 5)
    [ ... ]
    Generation 3371: the best chromosome is 'ABCDEFZHIJKLMNOPQRSTUVWXYZ' (fitness score: 25)
    Generation 3372: the best chromosome is 'ABCDEFZHIJKLMNOPQRSTUVWXYZ' (fitness score: 25)
    Generation 3373: the best chromosome is 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' (fitness score: 26)
    Generation 3374: the best chromosome is 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' (fitness score: 26)
    Generation 3375: the best chromosome is 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' (fitness score: 26)

## Notes

Currently all variables are hardcoded but I plan to create a basic library for Genetic Algoithms when I'll have more knowledge about Nx.

Any contribution (PR, issues, ....) to improve my code is welcome!
