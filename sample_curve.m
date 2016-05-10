function curve = sample_curve(points, sine_exp, e_exp, varargin)
% varargin{1}: noise_factor: default is .01

domain = 3.2;
step = domain/points;
x = 0:step:domain;

noise_factor = .01; % set defualt

if (~isempty(varargin)) 
    noise_factor = varargin{1}; % set custom
end

intersect = 1;
%frequency = pi/points;

fun = @(x) ( (sin(x).^sine_exp).*((x.^2).*( x <= intersect) + exp(-e_exp.*(x-intersect)).*( x > (intersect))));
curve = fun(x)';

photons = 50000;
%noise_rate = 100; % 100 photons/sec
count = 0;

for i = 1:length(curve) %get sum for scaling calculation
    count = count + curve(i);    
end

scale_factor = photons/count;
%curve = floor(curve.*scale_factor);
curve = curve.*scale_factor;

count = 0;


for i = 1:length(curve)
    gaus = round(randn * noise_factor * scale_factor);
    curve(i) = curve(i) + gaus;
end

%{
for i = 1:length(curve)
    count = count + curve(i);
    prob = randn;
    if (prob >= 0)
        curve(i) = ceil(curve(i));
        prob2 = randn;
        if (prob2 >= 0)
            gaus = ceil(prob*noise_factor*scale_factor);
        else
            gaus = floor(prob*noise_factor*scale_factor);
        end
    else
        curve(i) = floor(curve(i));
        prob2 = randn;
        if (prob2 >= 0)            
            gaus = ceil(prob*noise_factor*scale_factor);
        else
            gaus = floor(prob*noise_factor*scale_factor);
        end
    end
    curve(i) = curve(i) + gaus;
end
%}
end