function [tdoa, dist, tdoa_theory, dist_theory, distflip, varargout] = simulate_glint_nopad(time_res, pt_a, pt_b, burst, a, b, varargin)
%% function to simulate glint and return the errors of tdoa and distance
% varargin: 'coeff' argument gets passed to xcorr to normalize corr values
% varargout: corr values can be requested as output if 'coeff' passed in
distflip = -1;

if ( ~isempty(varargin) )
    if ( strcmp( varargin{1}, 'coeff') )
        type = 'coeff';
    end
else
    type = '';
end

format long;
global c;
c = 299792458;

[tdoa_theory, dist_theory] = tdoa_compute(pt_a, pt_b, burst);

if (tdoa_theory < 0)%swap if b is closer to burst
    temp = b;
    b = a;
    a = temp;
    tdoa_theory = abs(tdoa_theory);
    dist_theory = abs(dist_theory);
end

offset_b = ceil(tdoa_theory/time_res);
padding = zeros(offset_b, 1);

density_a = sum(a)/length(a);
density_b = sum(b)/length(b);
b = [padding; b];

corrflip = -1;
lagflip = 0;

if (density_a < 1 || density_b < 1)        
    aflip = a;
    aflip(a == 1) = 0;
    aflip(a == 0) = 1;              
    bflip = b;
    bflip(b == 1) = 0;
    bflip(b == 0) = 1;
    [corrflip, lagsflip] = xcorr(aflip, bflip);
    lagflip = lagsflip(corrflip == max(corrflip));
    
    [rows, cols] = size(lagflip);
    if ( rows > 1 || cols > 1)
        lagflip = min(abs(lagflip));
    end
end

[corr, lags] = xcorr(a, b);
lag = lags(corr == max(corr));
[rows, cols] = size(lag);
if ( rows > 1 || cols > 1)
    lag = min(abs(lag));
end

%lag = -offset_b + lag;

%{
if (lag ~= -offset_b)
    string = sprintf('xcorr lag = "%d"', lags(index));
    disp(string)
end
%}

tdoa = abs(time_res * lag);
dist = tdoa*c;
if (corrflip ~= -1)
    lagflip = -offset_b + lagflip;
    tdoaflip = abs(time_res * lagflip);
    distflip = tdoaflip*c;
end

end
