
function [mapping, idx] = classification(features, opts)
% Function for classification of EOD features
% Input  - features: extracted EOD features
%        - opts: options for t-SNE (e.g., perplexity, ...)
% Output - mapping: FIt-SNE output
%        - idx: corresponding labels from hierarchical clustering

    % dimensionality reduction via Flt-SNE package
    [mapping, ~] = fast_tsne(features, opts);

    % classification via hierarchical clustering
    Y = pdist(mapping);
    Z = linkage(Y, "average"); % we are using average linkage 
    idx = cluster(Z,"maxclust", 2); % clustering into two clusters (two individuals)
end
