% first need to calculate the theoretical TDOA from the positions of two
% vehicles using cartesian coordinates. dist_proj is the distance light
% travels in the time tdoa
% tdoa can be negative if vehicle a is closer to burst than vehicle b

function [tdoa, dist_proj] = tdoa_compute(coords_a, coords_b, burst)
% coords should be 3d vectors in cartesian centered on earth
% burst is a vector giving the direction of the burst's origin. will be
% converted to a unit vector anyway

c = 299792458; %m/s
distance_vec = coords_a - coords_b;
burst_length = sqrt(burst(1)^2 + burst(2)^2 + burst(3)^2);
burst = burst./burst_length;

dist_proj = dot(distance_vec, burst);
tdoa = dist_proj/c;
% if b is closer to burst, tdoa/dist will be negative
end