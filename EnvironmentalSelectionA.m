function Population = EnvironmentalSelectionA(Population,N)

%The environmental selection of BiCo

    %% Non-dominated sorting
    [FrontNo,MaxFNo] = NDSort(Population.objs,Population.cons,N);
    Next = FrontNo < MaxFNo;
    
    %% Select the solutions in the last front based on their crowding distances
    Last = find(FrontNo==MaxFNo);
    if sum(Next)+size(Last,2)-N == 0
    	Next(Last)=1;
    else
        Del  = Truncation(Population,Last,sum(Next)+size(Last,2)-N);
        Next(Last(~Del)) = true; 
    end

    %% Population for next generation
    Population = Population(Next);
end


function Del = Truncation(Population,Last,K)
% Select part of the solutions by truncation  

    %% Truncation
    Zmin   = min(Population.objs,[],1);
    PopObj = (Population.objs-repmat(Zmin,length(Population.objs),1))./(repmat(max(Population.objs),length(Population.objs),1)-repmat(Zmin,length(Population.objs),1)+1e-10)+1e-10;
    PopObj = (PopObj(Last,:)); 
    
    Distance = pdist2(PopObj,PopObj);
    Distance(logical(eye(length(Distance)))) = inf;
    Del = false(1,size(PopObj,1));
    while sum(Del) < K
        Remain   = find(~Del);
        Temp     = sort(Distance(Remain,Remain),2);
        [~,Rank] = sortrows(Temp);
        Del(Remain(Rank(1))) = true;
    end
end