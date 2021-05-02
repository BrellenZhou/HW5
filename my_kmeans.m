function [Y, C] = my_kmeans(X, K, n_iter, spectral_relax)
% N: # of samples.
% k: # of clusters.
% D: Dimension of data.
% X shape: [N, D], data matrix
% Y shape: [N, 1], cluster indicator matrix
% C shape: [D, k], center matrix

if ~exist('spectral_relax', 'var')
    spectral_relax = false;
end

[N, D] = size(X);

C = X(randi([1, N], K, 1), :)';

if spectral_relax
    [Y, ~, ~] = svd(X);
    Y = Y(:, 1:K);
    % Do kmeans on the reduced space
    [Y, ~] = my_kmeans(Y, K, n_iter, false);
    % Compute the real centers.
    for k=1:K
        C(:, k) = mean(X(Y==k, :), 1)';
    end
    disp(C);
else
    for i=1:n_iter
        % Assign clusters
        % Distance = (X-C)'*(X-C) = (X*X) - 2*X*C + C*C for vector X and C.
        Dist = bsxfun(@plus, - 2 .* X * C, sum(C .* C, 1)); % [N, k] + [1, k] = [N, k]
        [~, Y] = min(Dist, [], 2);
        
        % Update centers
        for k=1:K
            C(:, k) = sum(X(Y==k, :), 1)' / sum(Y==k);
        end
    end
end

end
