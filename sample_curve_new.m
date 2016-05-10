function output = sample_curve_new(points, sine_exp, e_exp, noise_background, noise_uncorr)
% noise_background is an integer number of total photons
% noise_uncorr is a scale factor of gaussian noise. Usually less than 5

% NOTE: the value of the variable 'photons' is very important to the final results
%%%%%%%%%%%%%%%%%%%%%
photons = 50000;%%%%%
%%%%%%%%%%%%%%%%%%%%%

domain = 3.2;
step = domain/points;
x = 0:step:domain;

intersect = 1;

fun1 = @(x) ( (sin(x).^sine_exp).*((x.^2).*( x <= intersect) + exp(-e_exp.*(x-intersect)).*( x > (intersect))));

a0 = 51.93;
a1 = -59.23;
b1 = 21.52;
a2 = 6.056;
b2 = -19.36;
a3 = 8.61;
b3 = 3.19;
a4 = -2.932;
b4 = 3.55;
a5 = -1.754;
b5 = -1.792;
a6 = 1.581;
b6 = -.3593;
a7 = -.3348;
b7 = 1.43;
a8 = -.6745;
b8 = -.9135;
w = .006475;

fun2 = @(x) a0 + a1*cos(x*w) + b1*sin(x*w) + a2*cos(2*x*w) + b2*sin(2*x*w) + a3*cos(3*x*w) +...
    b3*sin(3*x*w) + a4*cos(4*x*w) + b4*sin(4*x*w) + a5*cos(5*x*w) + b5*sin(5*x*w) + a6*cos(6*x*w) +...
    b6*sin(6*x*w) + a7*cos(7*x*w) + b7*sin(7*x*w) + a8*cos(8*x*w) + b8*sin(8*x*w);

a = fun1(x)';
% add detector gaussian noise
a = 100*a;
curve_length = length(a);


for i = 1:curve_length
    random = randn;    
    gaus = random*noise_uncorr;
    a(i) = a(i)+gaus;
end
%}
    
%a = a./100;
a(a < 0) = 0;
%a = fun2(x);



count = sum(a);
scale_factor = photons/count;
a = a.*scale_factor;
noise_rate = noise_background/points;
noise_rate_inv = 1/noise_rate; % indicies per noise photon    

window = 1;
noise_start = 1;
count = 0;
remainder_noise_photons = zeros(size(a));
output = zeros(size(a));

for i = 1:curve_length
    % photon distribtution section
    count = count + a(i);    
    if (count >= 1)
        remainder = mod(count, 1);        
        count = round(count - remainder);         
        window_avg = sum(a(window:i))/(i-window + 1);
        tmp = abs(a(window:i) - window_avg);
        [~,tmpindex] = min(tmp);
        index = window + tmpindex - 1;
        output(index) = output(index) + count;        
        count = remainder;
        window = i + 1;    
    end
    
    % noise addition section   
    
    if (noise_background > 0)
        if (i - noise_start >= noise_rate_inv)
            random = rand;
            noise_index = noise_start + round(random * noise_rate_inv);
            remainder_noise_photons(noise_index) = remainder_noise_photons(noise_index) + 1; % add a noise photon randomly
            %random = rand;
            %noise_index = noise_start + round(random * noise_rate_inv);
            %remainder_noise_photons(noise_index) = remainder_noise_photons(noise_index) - 1; % subtract a noise photon randomly
            noise_start = noise_start + ceil(noise_rate_inv);
        end
    end
    %}
end

output = output + remainder_noise_photons;

end