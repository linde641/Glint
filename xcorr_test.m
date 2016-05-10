function [lag, lag_count] = xcorr_test(points, noise)

avg_rate = 20; % 1 photon every 20 bins
outer_rate = 1.5*avg_rate;
%inner_rate = 0.5*avg_rate;
inner_rate = outer_rate;
noise = .01*noise; % because its used on both sides of random distribution

a = curve(points, noise, outer_rate, inner_rate);
b = curve(points, noise, outer_rate, inner_rate);

lag_count = 0;
[corr, lags] = xcorr(a, b);
lag = lags(corr == max(corr));
[rows, cols] = size(lag);
if (rows > 1 || cols > 1)
    lag = max(abs(lag));
    lag_count = length(lag);
end

function a = curve(points, noise, outer_rate, inner_rate) 
a = zeros(points, 1);
value = 0;

for i = 1:points
    % distribute burst photons
    if (i < .25 * points || i > .75 * points)
        if (mod(i,outer_rate) == 0)
            a(i) = 1;
        end
    else
        if (mod(i, inner_rate) == 0)
            %a(i) = 1;
            if (i < points/2)
                value = value + 1;                
            else
                value = value - 1;
            end
            a(i) = value;
        end
    end
    % noise
    random = rand;
    if random >= 1 - noise
        a(i) = a(i) + 1;
    end    
end
   
function a = curve2(points)

a = zeros(points, 1);
for i = 1:points
    % distribute burst photons
    if (i < .25 * points || i > .75 * points)
        if (mod(i,outer_rate) == 0)
            a(i) = 1;
        end
    else
        if (mod(i, inner_rate) == 0)
            a(i) = 1;
        end
    end
    % noise
    random = rand;
    if random >= 1 - noise
        a(i) = a(i) + 1;
    end    
end