function [G_DeIndex,result]=reinsertion(G,G_DeIndex,C)
v=0;
pG=subgraph(G,find(G_DeIndex==0));
[bin,binsize]=conncomp(pG,'OutputForm','vector');
while v<=C    
    de_node=find(G_DeIndex==1);
    value=zeros(length(de_node),1);
    for i=1:length(de_node) 
        N=neighbors(G,de_node(i));
        pG_neighbors_conncomp=unique(bin(ismember(pG.Nodes.Index,N)==1));
        value(i)=sum(binsize(pG_neighbors_conncomp))+1;        
    end
    re_num=max(ceil(0.01*length(de_node)),1);
    [va,pos]=sort(value);
    [v,p]=min(value);
    if sum(va(1:re_num))<=C
        G_DeIndex(de_node(pos(1:re_num)))=0;
    elseif v<=C
        G_DeIndex(de_node(p))=0;
    end
    pG=subgraph(G,find(G_DeIndex==0));
    [bin,binsize]=conncomp(pG,'OutputForm','vector');
end
result=sum(G.Nodes.Cost(G_DeIndex==1));