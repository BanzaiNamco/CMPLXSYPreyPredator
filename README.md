# PreyPredatorEcosystem


The fox-rabbit ecosystem is a classic predator-prey relationship in an ecological system. In this scenario, foxes are the predators, while rabbits are the prey. The dynamics of this ecosystem involve interactions between these two species, shaping the populations of both and influencing the overall balance of the ecosystem.

Our objective is to investigate the long-term population dynamics of rabbits within an ecosystem, considering their notable reproductive capacity compared to other herbivores. We aim to observe how the rabbit population stabilizes over time in relation to its abundance within the ecosystem.


Submitted By PROJECT GROUP 1:  
CORPUZ, DAVID JOSHUA
<br>SANTIAGO, PHILIP ANTHON 
<br>TAN, JUSTINE JOSHUA
<br>UY, ORRIN LANDON
<br>UY, WESLEY KING

## Environment
The study environment encompasses grasslands, where both foxes and rabbits coexist. Abundant grass serves as a crucial resource, facilitating the feeding and reproduction of rabbits. As rabbits thrive on the available grass and reproduce rapidly, foxes capitalize on this dynamic by preying on them. 
* Patches grow up to 5 amount of grass
* In each tick, a certain number of patches grow 1 unit of grass determined by `grass-growth`

## Agents
The agents in this model consider several variables.
* `Energy gain from food`:  This variable quantifies the amount of energy obtained by rabbits and foxes when they consume food.
* `Hunger threshold`: This represents the level of hunger an agent can tolerate before it initiates the search for food. It serves as a trigger for foraging behavior and influences the movement patterns of the agents within the ecosystem.
* `Move cost`: This parameter denotes the energy expenditure associated with the movement of agents across the environment.
* `Reproduce cost`: This factor represents the energy investment required for agents to engage in reproductive activities, alongside the prerequisite of reaching their *reproductive age*.
* `Reproduce precent`: This variable determines the likelihood of agents reproducing. It governs the rate at which new individuals are introduced into the population, thereby influencing population dynamics over time.
* `Max age`: The maximum lifespan of an agent before it dies of natural causes.

## Rabbits
In this simulation, rabbits exhibit behavior tailored to their herbivorous nature, aging and wandering 1 unit each tick. When their energy level drops below the hunger threshold, Rabbits will actively seek out grass within their 330&deg; vision cone and would leap 2 units max. Due to its naturally high reproduction rate, they can produce up to 7 offspring, contributing to the population growth.

## Foxes
Foxes are highly adaptable mammals known for their cunning behavior and remarkable hunting skills. When their energy levels dip below hunger thresholds, they employ their remarkable hunting skills within a 260&deg; vision cone, dashing up to 3 units to seek out rabbits. With the potential to produce up to 5 offspring, these predators exemplify their prowess in maintaining their population while navigating their environment with precision and strategy.
