function [Population,DFDF] = EnvironmentalSelectionB(Population,N,a)
% The environmental selection of ACMCA

    %% Calculate the fitness of each solution
 DFDF = CalDFDF(Population,N,a);

    %% Environmental selection
    [~,Rank] = sort(DFDF);
    Population = Population(Rank(1:N));
    DFDF = 1 : N;
end


