function nodeIndex= b_k_spectral_clustering(G, C)
n=size(G.Nodes,1);
m=size(G.Edges,1);
for k=1:m
    G.Edges.Cost(k,1)=min(G.Nodes.Cost(G.Edges.EndNodes(k,1)),G.Nodes.Cost(G.Edges.EndNodes(k,2)));
end
k=max(ceil(n./C),2);
% 邻接矩阵W 度矩阵D 拉普拉斯矩阵L
%WV=diag(G.Nodes.Weight);WV = sqrt(1./WV);
W = adjacency(G,G.Edges.Cost);
D=diag(sqrt(1./sum(W,2)));
L=D*W*D;

%

[V,~  ] = eigs(L,k);
sq_sum = sqrt(sum(V.*V, 2)) + 1e-20;
U = V ./ repmat(sq_sum, 1, k);

idx = kmeans(U, k);

m=max(G.Nodes.Cost);in=1;aver=zeros(n,1);dver=zeros(n,1);
while in~=m
    for h=1:length(idx)
        if idx(h~=0)
            indpar1=(idx==idx(h));
            indpar22=find(ismember(find(indpar1==0),neighbors(G,h))==1);
            if ~isempty(indpar22)
                aver(h)=G.Nodes.Cost(h)./length(indpar22);
            else
                aver(h)=m;
            end
        else
            aver(h)=m;
        end
    end
    [in,po]=min(aver);
    idx(po)=0;dver(po)=1;
end
nodeIndex=G.Nodes.Index(dver==1);
