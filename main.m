clc, clear
%%================Simulation of BCT-NSP Algorithm=========================

%% data-in & initialize
data=load ('C:\Users\fengzhidan\Desktop\code\Êý¾Ý¼¯\911.txt');     % input format of each line: id1 id2

GRAPH=graph(data(:,1),data(:,2));                                          % object: graph
GRAPH=simplify(GRAPH);                                                     % reduce to simple graph 
N=size(GRAPH.Nodes,1);M=size(GRAPH.Edges,1);                               % N: number of nodes; M: number of edges
GRAPH.Nodes.Index((1:N),1)=1:N;                                            % Node Index of the original network
GRAPH.Nodes.Cost=degree(GRAPH);                                            % degrees as removal cost of nodes
C=max(1,floor(0.01*N));                                                    % threshold constant: default value can be 0.01*N or 1

%% dismantling process
global iter                                                                % global variable: iteration times
iter=1;
[bin,binsize]=conncomp(GRAPH,'OutputForm','cell');
gcc=max(binsize);
while gcc>C
    nodeIndex=[];
    for i=1:length(bin)                                                    % dismanling all connected components whose size exceeds C 
        if binsize(i)>C
            SG=subgraph(GRAPH,bin{i});
            Tree=bcTreeGenerate(SG);                                       % block-cut tree
            if ~isempty(Tree.Edges)
                nodeIndex0=tree_k_spectral_clustering(SG,Tree,C);               
            else
                nodeIndex0=b_k_spectral_clustering(SG,C);
            end
            nodeIndex=[nodeIndex;nodeIndex0];
        end
       
    end
    RemovalNode{iter}=nodeIndex;
    iter=iter+1;
    RemovalCost=RemovalCost+sum(GRAPH.Nodes.Cost(ismember(GRAPH.Nodes.Index,nodeIndex)))./(2*M);
    GRAPH=rmnode(GRAPH,find(ismember(GRAPH.Nodes.Index,nodeIndex)));  
    [bin,binsize]=conncomp(GRAPH,'OutputForm','cell');
    gcc=max(binsize); 
end

%%Output 
filename=['C:\Users\fengzhidan\Desktop\BCT-NSP\RemovalResult.txt'];
fp=fopen(filename1,'a');
line1=char('Overall Removal Cost: ');
fprintf(fp,'%s%g\n',line1,RemovalCost);
line2=char('Removal Nodes: ');
fprintf(fp,'%s\n',line2);
for i=1:iter-1                                                                         
    for j=1:length(RemovalNode{i})
        if j==length(RemovalNode{i})
            fprintf(fp,'%g\n',RemovalNode{i}(j));
        else
            fprintf(fp,'%g\t',RemovalNode{i}(j));
        end
    end
end