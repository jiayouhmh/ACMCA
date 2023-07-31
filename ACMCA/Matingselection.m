function MatingPool = Matingselection(Population,ArcPopulation,N)

% MatingSelection

    MatingPool = [];
    if length(ArcPopulation) < N
        SelectedIndex = TournamentSelection(2,N,-sum(max(0,Population.cons),2));
        MatingPool    = Population(SelectedIndex);
    else
        AllPopulation = [ Population,ArcPopulation]; 
        Z_min       = min(AllPopulation.objs,[],1);
        PopObj = (AllPopulation.objs-repmat(Z_min,length(AllPopulation.objs),1))./(repmat(max(AllPopulation.objs),length(AllPopulation.objs),1)-repmat(Z_min,length(AllPopulation.objs),1)+1e-10)+1e-10;
        Cosine   = 1 - pdist2(PopObj,PopObj,'cosine');
        Cosine   = Cosine.*(1-eye(size(PopObj,1)));

        Temp     = sort(-Cosine,2);
        [~,Rank] = sortrows(Temp);

        CV1 = sum(max(0,Population.cons),2);
        CV2 = sum(max(0,ArcPopulation.cons),2);

        AngleA = Rank(1:N);
        AngleB = Rank(N+1:length(AllPopulation));

        Index1 = randi(N,1,N);
        Index2 = randi(length(ArcPopulation),1,N);

        i = 0;
        while length(MatingPool)< N  
            if CV1(Index1(i+1))< CV2(Index2(i+1))     
                MatingPool = [MatingPool,Population(Index1(i+1))];
            else
                MatingPool = [MatingPool,ArcPopulation(Index2(i+1))];
            end
            if AngleA(Index1(i+2))< AngleB(Index2(i+2))
                MatingPool = [MatingPool,Population(Index1(i+2))];
            else
                MatingPool = [MatingPool,ArcPopulation(Index2(i+2))];
            end    
            i = i + 2 ;
        end
    end
end