function curve = detector_noise(curve, varargin)
%% noise_factor (varargin{1}) should be larger than 1 to get a good amount of noise
% adds gaussian random numbers to each element of the array to simulate
% some unknown variation in the reporting of the photon values due to the
% detector. The problem is at high res, this noise will dominate if it is
% added to every array element, but since its gaussian a lot of them will
% be zeros

noise_factor = 1; % default

if (~isempty(varargin))
    noise_factor = varargin{1};
end

curve_length = length(curve);
for i = 1:curve_length
    gaus = randn;
    gaus = round(gaus * noise_factor);
    curve(i) = curve(i) + gaus;
end