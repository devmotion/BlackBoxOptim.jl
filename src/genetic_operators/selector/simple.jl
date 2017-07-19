"""
  Simple random `IndividualsSelector`.

  The probabilties of all candidates are equal.
"""
immutable SimpleSelector <: IndividualsSelector
end

select(::SimpleSelector, population, numSamples::Int) =
    rand_indexes(1:popsize(population), numSamples)
