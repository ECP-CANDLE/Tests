### Genetic Algorithm

The Genetic Algorithm is made to model evolution and natural selection by applying crossover (mating), mutation, and selection to a population in many iterations
(generations).

In the "simple" strategy, offspring are created with crossover AND mutation, and the selection for the next population happens from ONLY the offspring. In
the "mu_plus_lambda" strategy, offspring are created with crossover OR mutation, and the selection for the next population happens from BOTH the offpsring
and parent generation. Also in the mu_plus_lambda strategy, the number of offspring in each generation is a chosen parameter, which can be controlled by the
user through offspring_prop.

Mutation intakes two parameters: mut_prob and mut_indpb. The parameter mut_prob represents the probability that an individual will be mutated. Then, once an
individual is selected as mutated, mut_indpb is the probability that each gene is mutated. For example, if an individual is represented by the array
[11.4, 7.6, 8.1] where mut_prob=1 and mut_indpb=0.5, there's a 50 percent chance that 11.4 will be mutated, a 50 percent chance that 7.6 will be mutated,
and a 50 percent chance that 8.1 will be mutated. Also, if either of mut_prob or mut_indpb equal 0, no mutations will happen. The type of mutation we apply
depends on the data type because we want to preserve data type under mutation and 'closeness' may or may not represent similarity. For example, gaussian
mutation is rounded for integers to preserve their data type, and mutation is a random draw for categorical variables because being close in a list doesn't
equate to similarity.

Crossover intake two parameters: cx_prob and cx_indpb, which operate much in the same way as cx_prob and cx_indpb. For example, given two individuals
represented by the arrays [1, 2, 3] and [4, 5, 6] where cx_prob=1 and cx_indpb=0.5, there's a 50% chance that 1 and 4 will be 'crossed', a 50% chance that
2 and 5 will be 'crossed', and a 50% chance that 3 and 6 will be 'crossed'. Also, if either mut_prov or mut_indpb equal 0, no crossover will happen. The definition
of 'crossed' depends on the crossover function, which must be chosen carefully to protect data types. We use cx_Uniform, which swaps values such that [4, 2, 3],
[1, 5, 6] is a possible result from crossing the previously defined individuals. One example of a crossover function which doesn't preserve data types would be
cx_Blend, which averages values.

Selection has various customizations, with tournaments being our implementation. In tournament selection, 'tournsize' individuals are chosen, and the individual
with the best fitness score is selected. This repeats until the desired number of individuals are selected. Note that choosing individuals is done with replacement,
which introduces some randomness to who is selected. Although unlikely, it's possible for one individual to be the entire next population. It's also possible for
the best individual to not be selected as long as tournsize is smaller than the population. However, it is guaranteed that the worst 'tournsize-1' individuals are
not selected for the next generation. Tournsize can be thought of as the selection pressure on the population.

Notes:
- In the mu_plus_lambda strategy, cx_prob+mut_prob must be less than or equal to 1. This stems from how mutation OR crossover is applied in mu_plus_lambda, as
  opposed to mutation AND crossover in the simple strategy.
- GPUs can often sit waiting in most implementations of the Genetic Algorithm because the number of evaluations in each generation is usually variable. However,
  with a certain configuration, the number of evaluations per generation can be kept at a constant number of your choosing. By using mu_plus_lambda, the size
  of the offspring population is made through the chosen parameter of offspring_prop. Then, by choosing cx_prob and mut_prob such that cx_prob+mut_prob=1, every
  offspring is identified as a 'crossed' or mutated individual and evaluated. Hence, the number of evaluations in each generation equals lambda. Note that because
  of cx_indpb and mut_indpb, an individual may be evaluated with actually having different hyperparameters. This also means that by adjusting mut_indpb and cx_indpb,
  the level of mutation and crossover can be kept low despite cx_prob+mut_prob being high (if desired). Note that the number of evaluations per generation can be
  kept constant in the simple strategy as well, but the number of evals has to be the population size.
- Genetic Algorithms usually have mutation and crossover probabilites around 0.1. However, they also usually have population~500 and generations~100, which gives a lot
  of opportunity for mutation and crossover to happen. In the case of smaller populations and/or generations, it may be advantageous to increase mutation and crossover
  probabilites to larger than ordinary. In this case, the mu_plus_lambda strategy may be advantageous because of it's ability to select a parent for the next generation.
  Also, when there's a smaller number of generations (i.e. less number of times selection pressure is applied), it may be advantageous to increase tournament size (i.e.
  increase selection pressure strength) to compensate.
- The default values are: NUM_ITERATIONS=5  |  POPULATION_SIZE=16  |  GA_STRATEGY=mu_plus_lambda  |  OFFSPRING_PROP=0.5  |  MUT_PROB=0.8  |  CX_PROB=0.2  |
                          MUT_INDPB=0.5  |  CX_INDPB=0.5  |  TOURNSIZE=4

See https://deap.readthedocs.io/en/master/api/algo.html?highlight=eaSimple#module-deap.algorithms for more information.
