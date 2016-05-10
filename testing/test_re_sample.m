%testing re_sample_curve.m

trials = 15;
time_res = .064;
a = sample_curve(500, 2, 1);
curves = cell(trials, 1);
curves{1} = a;
b = a;

for i = 2:trials    
    b = vary_curve_noise(b, 1);    
    curves{i} = b;    
end

