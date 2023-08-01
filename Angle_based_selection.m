function ArcPopulation = Angle_based_selection(Population,N)


    [FrontNo,~] = NDSort([Population.objs,sum(max(0,Population.cons),2)],1);
    TempA = FrontNo==1;
    Population = Population(TempA==1);
    if length(Population)<N 
        ArcPopulation = Population;
    else
        Zmax = max(Population.objs,[],1);
        Next(1:size(Population,2)) = true;
        % Select the solutions in the last front
        Delete = LastSelection(Population(Next).objs,-sum(max(0,Population.cons),2),sum(Next)-N,Zmax);
        Temp = find(Next);
        Next(Temp(Delete)) = false;
        ArcPopulation = Population(Next);
    end
end


function Delete = LastSelection(PopObj,PopCons,K,Zmax)
% Select part of the solutions in the last front

    [N,M]  = size(PopObj);
    PopObj = (PopObj-repmat(Zmax,N,1))./(repmat(min(PopObj),N,1)-repmat(Zmax,N,1)- 1e-10);
    
    %% Associate each solution with one reference point
    % Calculate the distance of each solution to each reference vector
    Cosine = 1 - pdist2(PopObj,PopObj,'cosine');
    Cosine = Cosine.*(1-eye(size(PopObj,1)));

    %% Environmental selection
    Delete = false(1,N);
    while sum(Delete) < K
        [J_min_row,J_min_column] = find(Cosine==max(max(Cosine)));
        j = randi(length(J_min_row));
        temp_A = J_min_row(j);
        temp_B = J_min_column(j);
        if (PopCons(temp_A)<PopCons(temp_B)) ||(PopCons(temp_A)==PopCons(temp_B) && PopObj(temp_A)<PopObj(temp_B))
            Delete(temp_A) = true;
            Cosine(:,temp_A)=0;
            Cosine(temp_A,:)=0;
        else
            Delete(temp_B) = true;
            Cosine(:,temp_B)=0;
            Cosine(temp_B,:)=0;
        end
    end
end