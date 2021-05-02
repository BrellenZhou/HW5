% X = [
%     0,0;
%     -1, 2;
%     -3, 6;
%     1, -2;
%     3, -6
%     ];
% plot(X(:,1), X(:,2), 'o');

load USPS.mat
A = A'; % [D, N]
[U, S, V] = svd(A);
Y = S*V';
i = 1;
figure;
for p = [10, 50, 100, 200, 256]
    subU = U(:, 1:p);
    X = subU * Y(1:p, :);
    err = sum(sqrt(sum((X - A).^2, 1)), 2);
    disp(['p = ', num2str(p), ' total error: ', num2str(err)]);
    
    subplot(5, 2, i);
    imshow(reshape(X(:, 1), 16, 16));
    title(['p = ', num2str(p), ' error = ', num2str(sqrt(sum((X(:, 1)-A(:,1)).^2, 1)))]);
    i = i + 1;
    
    subplot(5, 2, i);
    imshow(reshape(X(:, 2), 16, 16));
    title(['p = ', num2str(p), ' error = ', num2str(sqrt(sum((X(:, 2)-A(:,2)).^2, 1)))]);
    i = i + 1;
end
