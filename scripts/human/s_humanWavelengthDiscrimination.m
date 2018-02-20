%% s_HumanWavelengthDiscrimination
%
% We discriminate two lights with different wavelengths by comparing the
% pattern of cones absorptions generated by the lights.  The separation in
% the pattern of cone response depends, in turn, on the photon noise in the
% absorptions.
%
% This script calculates the cone absorptions for lights at different mean
% luminance levels.  The graph shows how the absorption data generated
% by the two wavelengths become better separated, as the mean illumination
% level grows.
%
% This script also shows some of the details of how to create the
% properties of a human cone sensor array.
%
% Copyright ImagEval, LLC 2011

%% 
ieInit
try
    rng('default');  % To achieve the same result each time
catch err
    randn('seed');
end

%%  Create a sample human optics and cone mosaic sensor
% Standard optics and human retina simulations can be created this way. You
% can also change the parameters from the standard, say for simulating the
% periphery or for simulating people with biological variability.

% Human optics
oi = oiCreate('human');

% Create a typical cone mosaic and show a little picture
cSensor = sensorCreate('human');
sensorConePlot(cSensor);

%%  Compute cone absorption as a function of mean signal level 
% We will image uniform fields of monochrome light on a human sensor. Then
% get the photon absorptions in a 100 ms flash.  THen we plot the
% absorptions as a 3D graph in the next cell. 

% These are the two wavelengths and the list of scene luminance levels
wSamples = [520  530]; 
nWave = length(wSamples);
luminance = [10 50 200];
nLevels = length(luminance);
sceneSize = 128;

% We will extract the cone absorptions for plotting into these variables
L = cell(1,length(wSamples));
M = cell(1,length(wSamples));
S = cell(1,length(wSamples));
% The sensor color filters are black (K, a blank spot), L, M and S
% The default human sensor is 0,6,3,1 for K,L,M,S
slot = [2 3 4];   % L,M,S positions in the sensor

% Make a series of scenes at different wavelengths and peak readiances.
% Then, compute the sensor response.
scene  = cell(1,nWave);
sensor = cell(1,nWave);

vcNewGraphWin([],'tall');
for rr = 1:nLevels
    subplot(nLevels,1,rr);
    for ww=1:length(wSamples)

        % Create a monochromatic scene and set the radiance
        % The wavelength is specified in wSamples.
        scene{ww} = sceneCreate('uniform monochromatic',wSamples(ww),sceneSize);
        % scene{ww} = sceneSet(scene{ww},'peak photon radiance',peakRadiance(rr));
        scene{ww} = sceneAdjustLuminance(scene{ww},luminance(rr));

        % Compute the spectral irradiance at the retina
        oi = oiCompute(scene{ww},oi);

        % Create a human sensor that will integrate for 100 ms
        sensor{ww} = sensorCreate('human');
        sensor{ww} = sensorSet(sensor{ww},'exposure time',0.10);
        
        % Compute the sensor absorptions
        sensor{ww} = sensorCompute(sensor{ww},oi);
        sensor{ww} = sensorSet(sensor{ww},'name',sprintf('wave %.0f',wSamples(ww)));
        
        % If you want to have a look at the image, run this line.
        % vcAddAndSelectObject(sensor{ww}); sensorWindow;
    end

    for ww=1:length(wSamples)
        L{ww} = sensorGet(sensor{ww},'electrons',slot(1));
        M{ww} = sensorGet(sensor{ww},'electrons',slot(2));
        S{ww} = sensorGet(sensor{ww},'electrons',slot(3));

        % For simplicity in plotting, make the absorptions same length
        n = min(100,length(L{ww}));
        S{ww} = S{ww}(1:n); M{ww} = M{ww}(1:n); L{ww} = L{ww}(1:n);
    end

    % Plot the absorptions
    sym = {'b.','g.','r.'};
    az = 65.5; el = 30;
    for ww=1:length(wSamples)
        title(sprintf('Luminance (cd/m^2): %.0f',luminance(rr)));
        s = mod(ww,length(sym))+1;
        plot3(L{ww}(:),M{ww}(:),S{ww}(:),sym{s})
        view([az el])
        hold on
    end
    xlabel('L-absorptions'); ylabel('M-Absorptions'); 
    zlabel('S-absorptions'); axis square; grid on

end

