results = zeros(500,1);

for i = 1:length(results)
    disp(i)
    source = sample_curve(1000, 2 , 1);
    a = vary_curve_noise(source, .1);
    b = vary_curve_noise(source, .1);
    %a = sample_curve(500000, 2 ,1);
    %b = sample_curve(500000, 2 ,1);
    [corr, lags] = xcorr(a, b);
    [~, index] = max(corr);
    %lag = lags( corr == max(corr));
    lag = lags(index);
    results(i) = lag;
end