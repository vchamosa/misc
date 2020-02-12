%% Computational Cognitive Neuroscience
% Assignment 1
% How the brain represents space around the body (peri-personal space)
%
%

%% Neural models
clearvars

% Variables
I_var = 0.3; % spatial extension (variance) of input
I_time = 200; % length of input (ms)
delta_dist = 0.2; % spatial change

% Tactile neurons
Mt = 40;
Nt = 20;
neurons_tac = zeros(Mt,Nt); % array of neurons
RFdist_tac = 0.5; % receptive field distance, to be multiplied by position
area_tac = zeros((RFdist_tac * Mt),(RFdist_tac * Nt)); % receptive area
RF_tac = zeros(size(area_tac)/delta_dist); % skin area
Io_tac = 2.5; % input amplitude
I_tac = area_tac; % input in space
[x_tac,y_tac] = size(RF_tac); % AREA_TAC OR I/RF_TAC????????
x0_tac = x_tac/2; % centre, x axis
y0_tac = y_tac/2; % centre, y axis

% Auditory neurons
Ma = 20;
Na = 3;
neurons_aud = zeros(Ma,Na); % array of neurons
RFdist_aud = 10; % receptive field distance, to be multiplied by position
area_aud = zeros((RFdist_aud * Ma),(RFdist_aud * Na)); % receptive area
RFvar_aud = 10; % spatial extension (variance) of receptive field
Io_aud = 3.6; % input amplitude
I_aud = neurons_aud; % input to each neuron
[x_aud,y_aud] = size(area_aud);
x0_aud = x_aud/2; % centre, x axis
y0_aud = y_aud/2; % centre, y axis


% Tactile model

% Input Gaussian
for x = 1:((Mt*RFdist_tac)/delta_dist)
    for y = 1:((Nt*RFdist_tac)/delta_dist)
        I_tac(x,y) = Io_tac * exp(-((x - x0_tac)^2 + (y - y0_tac)^2)/2 * I_var^2);
        %RF_tac(x,y) = exp(-((x - ((x*delta_dist)/RFdist_tac))^2 + (y - ((y*delta_dist)/RFdist_tac))^2)/2);
    end
end

% Receptive field Gaussian
for x = 1:(Mt*RFdist_tac)
    for y = 1:(Nt*RFdist_tac)
        RF(x,y) = exp(-((x - (x*delta_dist))^2 + (y - (y*delta_dist))^2)/2);
    end
end


figure
imagesc(I_tac)

figure
imagesc(RF)

       