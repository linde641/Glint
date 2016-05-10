% script to test the gaussian noise of curves

a = sample_curve(1000, 6);
b = sample_curve(1000000, 6);
diffs_a = zeros(length(a), 1);
diffs_b = zeros(length(b), 1);

for i = 1:length(a) - 1
    diff = a(i+1) - a(i);
    diffs_a(i) = diff;
end

for i = 1:length(b) - 1
    diff = b(i+1) - b(i);
    diffs_b(i) = diff;
end
