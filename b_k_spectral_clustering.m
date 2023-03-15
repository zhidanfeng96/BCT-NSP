function nodeIndex= b_k_spectral_clustering(G,C)
n=size(G.Nodes,1);
m=size(G.Edges,1);
for k=1:m
    G.Edges.Cost(k,1)=min(G.Nodes.Cost(G.Edges.EndNodes(k,1)),G.Nodes.Cost(G.Edges.EndNodes(k,2)));
end
k=2;
W = adjacency(G,G.Edges.Cost);
D=diag(sqrt(1./sum(W,2)));
L=D*W*D;
[V,~  ] = eigs((L+L')/2,k);
sq_sum = sqrt(sum(V.*V, 2)) + 1e-20;
U = V ./ repmat(sq_sum, 1, k);

idx = kmeans(U, k);

aver=zeros(n,1);dver=zeros(n,1);
while sum(aver~=inf)
    for h=1:n
        if idx(h)~=0
            aver(h)=G.Nodes.Cost(h)./(sum(idx(neighbors(G,h))~=idx(h)&idx(neighbors(G,h))~=0));
        end
    end
    if sum(aver~=inf)
        [~,po]=min(aver);
        idx(po)=0;dver(po)=1;aver(po)=inf;
    end
end

nodeIndex=G.Nodes.Index(dver==1);
