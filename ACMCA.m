classdef ACMCA < ALGORITHM
% <constrained>
% An adaptive constrained multi-objective co-evolutionary algorithm 

    methods
       function main(Algorithm,Problem)
           %% Generate random population
           Population = Problem.Initialization();
           ArcPopulation  = [];
           
           %% Optimization
           while Algorithm.NotTerminated(Population)
               %%first reproduction
               Offspring1  = DEgenerator(Problem,Population);  
               f  = 2./(1+exp(1).^(-Problem.FE*10/Problem.maxFE))-1;              
               [Population,~] = EnvironmentalSelectionB([Population,Offspring1],Problem.N,f);               
               %% second reproduction            
               AllPopulation = [Population,ArcPopulation];
               MatingPool = Matingselection(Population,ArcPopulation,Problem.N);
               Offspring  = OperatorGA(Problem,MatingPool(1:Problem.N));
               ArcPopulation  = UpdateArcPopulation([AllPopulation,Offspring],Problem.N);
               Population = EnvironmentalSelectionA([Population,Offspring],Problem.N);
           end
       end
    end
end