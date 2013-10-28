using BlackBoxOptim
using BlackBoxOptim.Problems

function fitness_for_opt(problem, numDimensions, populationSize, numSteps, 
  optFunc = de_rand_1_bin_radiuslimited)
  problem = BlackBoxOptim.Problems.set_numdims!(numDimensions, problem)

  ss = search_space(problem)

  pop = BlackBoxOptim.rand_individuals_lhs(ss, populationSize)

  opt = optFunc(pop, ss)

  println("\n$(problem.name), n = $(numdims(problem)), optimizer = $(opt.name)")

  best, fitness = BlackBoxOptim.run_optimizer_on_problem(opt, problem, numSteps)
  fitness
end

facts("Optimize single objective problems in 5, 10, and 30 dimensions with DE") do
  simple_problems = ["Sphere", "Schwefel2.22", "Schwefel2.22"]
  for(problem in simple_problems)
    context(problem) do
      p = BlackBoxOptim.Problems.examples[problem]

      @fact fitness_for_opt(p, 5, 20,  5e3, de_rand_1_bin) < 0.01 => true
      @fact fitness_for_opt(p, 5, 20,  5e3, de_rand_1_bin_radiuslimited) < 0.01 => true

      @fact fitness_for_opt(p, 10, 20, 1e4, de_rand_1_bin) < 0.01 => true
      @fact fitness_for_opt(p, 10, 20, 1e4, de_rand_1_bin_radiuslimited) < 0.01 => true

      @fact fitness_for_opt(p, 30, 25, 3e4, de_rand_1_bin) < 0.01 => true
      @fact fitness_for_opt(p, 30, 25, 3e4, de_rand_1_bin_radiuslimited) < 0.01 => true
    end
  end

  context("Schwefel1.2") do
    problem = "Schwefel1.2"
    p = BlackBoxOptim.Problems.examples[problem]
    @fact fitness_for_opt(p, 5, 20,  5e3) < 0.01 => true
    @fact fitness_for_opt(p, 10, 50, 5e4) < 0.01 => true

    #DE/rand/1/bin seems to have troubles...
    #@fact fitness_for_opt(p, 30, 50, 2e5, de_rand_1_bin) < 100.0 => true
    @fact fitness_for_opt(p, 30, 50, 2e5, de_rand_1_bin_radiuslimited) < 10.0 => true
    @fact fitness_for_opt(p, 30, 50, 2e5, adaptive_de_rand_1_bin) < 10.0 => true
    @fact fitness_for_opt(p, 30, 50, 2e5, adaptive_de_rand_1_bin_radiuslimited) < 10.0 => true
  end

  context("Rosenbrock") do
    problem = "Rosenbrock"
    p = BlackBoxOptim.Problems.examples[problem]
    @fact fitness_for_opt(p, 5, 20,   1e4) < 100.0 => true
    @fact fitness_for_opt(p, 10, 20,  5e4) < 100.0 => true
    @fact fitness_for_opt(p, 30, 40, 2e5) < 100.0 => true

    @fact fitness_for_opt(p, 30, 40, 2e5, adaptive_de_rand_1_bin) < 100.0 => true
    @fact fitness_for_opt(p, 30, 40, 2e5, adaptive_de_rand_1_bin_radiuslimited) < 100.0 => true

    @fact fitness_for_opt(p, 50, 40, 3e5, adaptive_de_rand_1_bin_radiuslimited) < 100.0 => true
  end
end