function [times, points] = translate_res_to_points(times, total_time)
% points = total_time/time_resolution

len = length(times);
points = zeros(len, 1);

for i = 1:len
    points(i) = total_time/times(i); 
    if mod(points(i), 1) ~= 0
        points(i) = ceil(points(i));
        times(i) = total_time/points(i);
    end
end

end