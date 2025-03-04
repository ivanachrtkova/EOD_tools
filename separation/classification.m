
function [mapping, idx] = classification(features, opts)
    [mapping, ~] = fast_tsne(features, opts); % dimred via Flt-SNE package

    % classification via hierarchical clustering
    Y = pdist(mapping);
    Z = linkage(Y, "average");
    idx = cluster(Z,"maxclust", 2); 
end