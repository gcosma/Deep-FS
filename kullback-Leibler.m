Apdf = normpdf([-10:0.1:10], -1, 1);
Bpdf = normpdf([-10:0.1:10],  1, 1);
KL = 0.1 * sum(Apdf .* (log(Apdf)-log(Bpdf)))
KL =
   2.000000000000000