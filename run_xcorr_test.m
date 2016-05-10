clear;
trials = 50;
results = zeros(trials, 2);
global c;
c = 299792458;
max_noise = 20;
points = 1000000;
avglags = zeros(max_noise, 1);
stdlags = zeros(max_noise, 1);
lagcounts = zeros(max_noise, 1);

for k = 1:max_noise        
    tic
    for i=1:trials     
        disp(i)
        [lag, lag_count] = xcorr_noiseonly(points, k, .3);
        results(i, 1) = lag;
        results(i, 2) = lag_count;
    end
    avglags(k) = mean(results(:, 1));
    stdlags(k) = std(results(:, 1));
    lagcounts(k) = sum(results(:, 2));
    disp(avglags(k));
    toc
end
