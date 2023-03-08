function Tree=bcTreeGenerate(G)
%Tree: Nodes: IsComponent ComponentIndex CutVertexIndex(¼ÇÂ¼Ô­Í¼±êºÅ) Weight
%      Edges: EndNodes Weight
[Tree,id]=bctree(G);
tn=size(Tree.Nodes,1);
for i=1:tn
    Tree.Nodes.Weight(i,1)=sum(id==i);
end
Tree.Edges.Weight(:,1)=G.Nodes.Cost(Tree.Nodes.CutVertexIndex(Tree.Edges.EndNodes(:,2)));
