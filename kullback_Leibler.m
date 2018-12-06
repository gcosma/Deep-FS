Apdf = normpdf([-10:0.1:10], -1, 1);
figure
plot([-10:0.1:10],Apdf)
Bpdf = normpdf([-10:0.1:10],  1, 1);
hold on
plot([-10:0.1:10],Bpdf)
KL = 0.1 * sum(Apdf .* (log(Apdf)-log(Bpdf)))
% KL =   2.000000000000000