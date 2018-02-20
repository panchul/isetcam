% ISET -- Script to start ISET (Image Systems Evaluation Toolbox) 
%
% This script initializes the ISET (Image Systems Evaluation Tool) program.
% The script checks for the existence of an isetSession file (saved from a
% previous session). 
% 
% The script 
%   * Checks  the current version of Matlab, which should be 6.5 or higher
%   * Initiates the ISET Session window
%   * Initiates the vcSESSION (global) variable used by ISET windows
%
% Copyright ImagEval Consultants, LLC, 2003.

%% Initialize variables
% If the user already has a vcSESSION, clear it.  We are going to load the
% new one from the isetSession file.
clear vcSESSION;

% Define vc global variables and structures.  vc[UPPERCASE] are globals.
global vcSESSION;

% thisVersion =  1.001;    % Until October 11, 2005
% this Version = 1.01;     % Started Feb. 20, 2006
% thisVersion = 3.0;       % Started September, 2007
thisVersion = 4.0;         % Started August, 2009

ieSessionSet('version',thisVersion);

%%
version = ver('Matlab');
v = version.Version(1:3);
if v < 7.0
    warning('ISET compatible with version 7.0 or greater.  This version is %f\n',v)
end

disp(['ISET ',num2str(vcSESSION.VERSION),', Matlab ',version.Version]);

clear expectedMatlabVersion version matlabVersion

%% Default session file name.
% We check for a session file named iset-dateTime
%
%   * If one exists, we load it.  
%   * If several exist, we load the latest one
%   * The user can load a sessison file with a different name from the Main
%     Window.

sessionFileName = 'isetSession.mat';
d = dir('iset-*.mat');
if ~isempty(d), sessionFileName = d(end).name; end

% sessionDir = pwd;
year = date; year = year(end-3:end);
fprintf('------------------\n');
fprintf('Copyright ImagEval Consulting, LLC, 2003-%s\n',year);

ieInitSession;
ieSessionSet('dir',pwd);
ieSessionSet('name',sessionFileName);

% wp = ieSessionGet('whitePoint');
% fprintf('White point for Scene/OI rendering set to %s\n',wp);

clear sessionFileName
clear thisVersion
clear sessionDir
clear v

%% Hand off control to the main ISET window
% This window lets the user bring up the scene, optics, and other windows
% This function was named ieMainWindow until December, 2008.
ieMainW

%% End