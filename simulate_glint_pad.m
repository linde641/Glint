function [tdoa, dist, tdoa_theory, dist_theory] = simulate_glint_pad(time_res, pt_a, pt_b, burst, curve_a, curve_b)
% now need to create two burst profiles that are not identical shifted such
% that their bursts are aligned with theoretical tdoa and run them through
% xcorr to see if the max aligned time shift agrees with theoretical tdoa

format long;
global c;

[tdoa_theory, dist_theory] = tdoa_compute(pt_a, pt_b, burst);


if (tdoa_theory < 0)%swap if b is closer to burst
    temp = curve_b;
    curve_b = curve_a;
    curve_a = temp;
end

tdoa_theory = abs(tdoa_theory);
dist_theory = abs(dist_theory);

%% now set time t = 0 at the beginning of curve_a and aligns curve_b
% such that its peak is set to the correct bin calculated from time_res and
% the theoretical tdoa. Pads zeros as needed to the front of curve_b for
% use with xcorr

% below block is the old method when we don't know the true peak
 
[~,peak_index_a_real] = max(curve_a);
[~, peak_index_b_real] = max(curve_b);
peak_time_b_theory = peak_index_a_real * time_res + tdoa_theory;
peak_index_b_theory = ceil(peak_time_b_theory/time_res);
padding_b = zeros( (peak_index_b_theory - peak_index_b_real) , 1);
pad_length = length(padding_b);
padding_b = [padding_b; curve_b]; % overwriting padding instead of curve for memory sake
[corr, lags] = xcorr(curve_a, padding_b);


[~, index] = max(corr);
lag = lags(index);
%{
if (abs(lag) ~= pad_length);
    string = sprintf('lag and pad not equal: lag = "%d" pad = "%d"', lag, pad_length);
    disp(string)
end
%}
tdoa = abs(time_res * lag);
dist = tdoa*c;

end
