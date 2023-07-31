function [DFDF] = CalDFDF(Population,PopObj,a)
% Calculate the fitness of each solution

    [N1,~]       = size(Population.objs);   
    [FrontNo1,~] = NDSort(Population.objs,Population.cons,inf);
    
    CrowdDis1 = CrowdingDistance(Population.objs,FrontNo1);
  
    [~,r1] = sortrows([FrontNo1',-CrowdDis1']);
    Rc(r1) = 1 : N1;   %基于CDP获得的ranking

   [FrontNo2,~] = NDSort(Population.objs,0,inf);
    
    CrowdDis2 = CrowdingDistance(Population.objs,FrontNo2);
    
   [~,r2]  = sortrows([FrontNo2',-CrowdDis2']);
    Rp(r2) = 1 : N1;   %基于非支配排序获得的ranking
    R_sum = a*Rc+(1-a)*Rp;
    
    %%Calculate SDE
     N      = size(PopObj,1);
    f_max   = max(PopObj,[],1);
    f_min   = min(PopObj,[],1);
    PopObj = (PopObj-repmat(f_min,N,1))./repmat(f_max-f_min,N,1);
    Dis    = inf(N);
    for i = 1 : N
        SPopObj = max(PopObj,repmat(PopObj(i,:),N,1));
        for j = [1:i-1,i+1:N]
            Dis(i,j) = norm(PopObj(i,:)-SPopObj(j,:));
        end
    end
    SDE = 1./(min(Dis,[],2)+2);
   %% Calculate the fitnesses
    DFDF =  R_sum + SDE';%%较小的排名值表示较好的性能
end