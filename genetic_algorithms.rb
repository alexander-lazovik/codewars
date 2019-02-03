#Binary Genetic Algorithms - https://www.codewars.com/kata/526f35b9c103314662000007
# Genetic algorithms are a useful tool for machine learning. One simple way to find a solution to a problem that would typically be too difficult to brute force is through algorithms such as these.
# For example, say our problem is, given the list [1,2,3,4,5,6,7,8,9,10], find a way to partition the list into two lists such that the sum of one list is 38 and the product of the other list is 210. You could of course brute force it, using the fact that you can find the divisors of 210. But say you have the list of numbers from 1 to 50! That makes it a lot more difficult, and if we are not looking for a sum or product that is actually possible, just close to a given number, it's even harder to do by brute force.

#Binary Genetic Algorithms
GENE_LENGTH = 35
POPULATION_SIZE = 100
MUTATION_PROBABIILITY = 0.002
CROSSOVER_PROBABILITY = 0.6

class GeneticAlgorithm
  @@rand = Random.new

  def generate length
    #the generate method generates a random chromosome of a given length
    @@rand.rand(2**length).to_s(2).rjust(length, '0')
  end

  def sus(population, fitnesses, n)
   # Stochastic universal sampling
    f = fitnesses.reduce(:+) #total fitness of Population
    #n = 2 #number of offspring to keep
    p = f/n #distance between the pointers (F/N)
    start = @@rand.rand(p) #random number between 0 and P
    pointers = Array.new(n) {|i| start + i*p }
    return rws(population, fitnesses, pointers)
  end

  def rws(population, fitnesses, points)
    # roulette wheel selection
    keep = []
    points.each do |p|
      i = 0
      sum = fitnesses[i]
      while sum < p #fitness sum of Population[0..i] < P
        i += 1
        sum += fitnesses[i]
      end
      keep << population[i]
    end
    return keep
  end

  def select population, fitnesses
    #The select method will take a population and a corresponding list of fitnesses
    #and return two chromosomes selected with the roulette wheel method.
    return sus(population, fitnesses, 2)
  end

  def mutate chromosome, p
    #they take in one chromosome and a probability
    #and return a mutated chromosome. With a probability p_m,
    #a mutation can occur at every bit along each new chromosome;
    #the mutation rate is typically very small
    chromosome.chars.map{|bit| @@rand.rand < p ? (bit == "0" ? "1" : "0") : bit}.join
  end

  def crossover chromosome1, chromosome2
    # they take in two chromosomes and return a crossed-over pair
    # With a probability p_c, a crossover occurs between these two new chromosomes.
    # That means at some random bit along the length of the chromosome,
    # we cut off the rest of the chromosome and switch it with the cut off part
    # of the other one.
    bitn = @@rand.rand(GENE_LENGTH - 1) + 1
    new1 = chromosome1[0, bitn] + chromosome2[bitn, GENE_LENGTH - bitn]
    new2 = chromosome2[0, bitn] + chromosome1[bitn, GENE_LENGTH - bitn]
    return new1, new2
  end

  def run fitness, length, p_c, p_m, iterations=100
    population = Array.new(POPULATION_SIZE) {|index| generate(length) }
    fitnesses = Array.new(POPULATION_SIZE) {|index| fitness.call(population[index]) }
    iterations.times do |i|
      new_population = []
      (POPULATION_SIZE/2).times do |j|
        #1. Select two chromosomes from our original population.
        chromosome1, chromosome2 = select(population, fitnesses)
        # puts "#{i}:#{j}: #{chromosome1}, #{chromosome2}"
        #2. With a probability p_c, a crossover occurs between these two new chromosomes.
        chromosome1, chromosome2 = crossover(chromosome1, chromosome2) if @@rand.rand < p_c
        #3. With a probability p_m, a mutation can occur at every bit along each new chromosome
        chromosome1 = mutate(chromosome1, p_m)
        chromosome2 = mutate(chromosome2, p_m)
        #4. Add these two new chromosomes into our new population and repeat steps 1-3
        # until you have a new population the same size as the original one
        new_population << chromosome1 << chromosome2
      end
      population = new_population
      fitnesses = population.map{ |e| fitness.call(e)}
      puts "Iteration: #{i}" if fitnesses.include?(1)
      break if fitnesses.include?(1)
    end
    index = fitnesses.index(1) || fitnesses.index(fitnesses.max)
    population[index]
  end
end

def fitness chromosome
  #compare chromosome with target
  score = chromosome.chars.map.with_index {|b, i| b == $target[i] ? 0 : 1}.reduce(:+)
  return 1.0/(1.0+score)
end
# What the test will do is generate a random binary string of 35 digits
# (a random Integer with 35 bits for Ruby), and your algorithm must discover that string!
# The fitness will be calculated in a way similar to above, where the score
# of a chromosome is the number of bits that differ from the goal string.

ga = GeneticAlgorithm.new
$target = ga.generate(GENE_LENGTH)
solution = ga.run(method(:fitness), GENE_LENGTH, CROSSOVER_PROBABILITY, MUTATION_PROBABIILITY, 100)
puts "#{$target}"
puts "#{solution}"
