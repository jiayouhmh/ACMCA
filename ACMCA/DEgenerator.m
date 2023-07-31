function [Offspring] = DEgenerator(Problem,Population)

%%The DEgeneratorA of BiCO

    cv = sum(max(0,Population.cons),2);       

    FrontNo = NDSort(Population.objs,Population.cons,1);   
    index_1 = find(FrontNo==1);
    r       = floor(rand*length(index_1))+1;
    best    = index_1(r);

    [N,D] = size(Population(1).decs);       
    Trial = zeros(1*Problem.N,D);
       
    for i = 1 : Problem.N   
        % DE/rand-to-bestf/1/bin--Convergence
        if rand > 0.5
            l = rand;
            if l <= 1/3 
            	F = .6;
            elseif l <= 2/3
                F = 0.8;
            else
                F = 1.0;
            end   
            l = rand;
            if l <= 1/3
                CR = .1;
            elseif l <= 2/3
                CR = 0.2;
            else
                CR = 1.0;
            end
            Index_set    = 1 : Problem.N;
            Index_set(i) = [];
            r1  = floor(rand*(Problem.N-1))+1;
            xr1 = Index_set(r1);
            Index_set(r1) = [];
            r2  = floor(rand*(Problem.N-2))+1;
            xr2 = Index_set(r2)  ;
            r3  = floor(rand*(Problem.N-3))+1;
            xr3 = Index_set(r3);
            Best_index = Population(best).decs;
            v      = Population(xr1).decs+rand*(Best_index-Population(xr1).decs)+F*(Population(xr2).decs-Population(xr3).decs);  
            Lower  = repmat(Problem.lower,N,1);
            Upper  = repmat(Problem.upper,N,1);
            v      = min(max(v,Lower),Upper);
            Site   = rand(N,D) < CR;
            J_rand = floor(rand * D) + 1;
            Site(1, J_rand) = 1;
            Site_  = 1-Site;
            Trial(i, :) = Site.*v+Site_.*Population(i).decs;  
        % DE/current-to-rand/1--Diversity
        else
            l = rand;
            if l <= 1/3
                F = .6;
            elseif l <= 2/3
                F = 0.8;
            else
                F = 1.0;
            end
            Index_set    = 1:Problem.N;
            Index_set(i) = [];
            r1  = floor(rand*(Problem.N-1))+1;
            xr1 = Index_set(r1);
            Index_set(r1) = [];
            r2  = floor(rand*(Problem.N-2))+1;
            xr2 = Index_set(r2);
            Index_set(r2) = [];
            r3    = floor(rand*(Problem.N-3))+1;
            xr3   = Index_set(r3);
            v     = Population(i).decs+rand*(Population(xr1).decs-Population(i).decs)+F*(Population(xr2).decs-Population(xr3).decs); 
            Lower = repmat(Problem.lower,N,1);
            Upper = repmat(Problem.upper,N,1); 
            Trial(i, :) = min(max(v,Lower),Upper);   
        end
    end
    Offspring = Trial;
    Offspring = Problem.Evaluation(Offspring);
end