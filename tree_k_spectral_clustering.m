function nodeIndex= tree_k_spectral_clustering(SG,G, C)
n=size(G.Nodes,1);ncut=sum(G.Nodes.IsComponent==1);
k=max(ceil(n./C),2);
W = adjacency(G,'weighted'); 
D=diag(sum(W,2)) ;
L=D-W;
WV=diag(G.Nodes.Weight);
[V,~] = eigs(L,sparse(WV),k,'smallestabs');
% [V,D] = eig(L,WV,'qz');
% [~,in]=mink(diag(D),k);
% V=V(:,in);
sq_sum = sqrt(sum(V.*V, 2)) + 1e-20;
U = V ./ repmat(sq_sum, 1, k);
idx = kmeans(U, k);

dver=zeros(n,1);
for h=1:n
    nei=neighbors(G,h);
    denei=find(idx(nei)~=idx(h));
    if ~isempty(denei)&& h>ncut
        dver(h,1)=1;
    elseif ~isempty(denei)&& h<ncut
        dver(nei(denei),1)=1;
    end
end
nodeIndex=SG.Nodes.Index(G.Nodes.CutVertexIndex(dver==1));