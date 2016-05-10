function [observers, bursts] = randomize_coordinates(trial_count, max_dist)

bursts = cell(trial_count, 1);
observers = cell(trial_count, 2);

for i = 1:trial_count        
    x1 = rand() * max_dist;
    y1 = rand() * max_dist;
    z1 = rand() * max_dist;
    x2 = rand() * max_dist;
    y2 = rand() * max_dist;
    z2 = rand() * max_dist;
    x3 = rand() * max_dist;
    y3 = rand() * max_dist;
    z3 = rand() * max_dist;
    observers{i, 1} = [x1 y1 z1];
    observers{i, 2} = [x2 y2 z2];
    bursts{i} = [x3 y3 z3];
end