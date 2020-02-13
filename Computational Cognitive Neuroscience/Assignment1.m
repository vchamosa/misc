%% Computational Cognitive Neuroscience
% Assignment 1
% How the brain represents space around the body (peri-personal space)
%
%

%% Variables
clearvars

I_var = 0.3; % spatial extension (variance) of input
I_time = 200; % length of input (ms)
delta_dist = 0.2; % spatial change

% Tactile neurons
Mt = 40;
Nt = 20;
neurons_tac = cell(Mt,Nt); % all neurons + individual receptive fields
RFdist_tac = 0.5; % receptive field distance, to be multiplied by position
area_tac = zeros((RFdist_tac * Mt),(RFdist_tac * Nt)); % receptive areas
RF_tac = zeros(size(area_tac)/delta_dist); % skin area
Io_tac = 2.5; % input amplitude
I_tac = RF_tac; % input in space
[x_tac,y_tac] = size(RF_tac); % dimensions of skin area
x0_tac = x_tac/2; % centre, x axis
y0_tac = y_tac/2; % centre, y axis

% Auditory neurons
Ma = 20;
Na = 3;
neurons_aud = cell(Ma,Na); % all neurons + individual receptive fields
RFdist_aud = 10; % receptive field distance, to be multiplied by position
area_aud = zeros((RFdist_aud * Ma),(RFdist_aud * Na)); % receptive area
RFvar_aud = 10; % spatial extension (variance) of receptive field
RF_aud = area_aud;
%RF_aud = zeros(size(area_aud)/delta_dist); % skin area
Io_aud = 3.6; % input amplitude
I_aud = area_aud; % input in space
[x_aud,y_aud] = size(RF_aud); % dimensions of auditory area
x0_aud = x_aud/2; % centre, x axis
y0_aud = y_aud/2; % centre, y axis


%% Tactile model

% Stimulus Gaussian
for x = 1:x_tac
    for y = 1:y_tac
        I_tac(x,y) = Io_tac * exp(-((x - x0_tac)^2 + (y - y0_tac)^2)/2 * I_var^2);
    end
end
figure
imagesc(I_tac)

% Receptive field Gaussians
RFall_tac = RF_tac
for x = 1:Mt
    x_i = x*RFdist_tac/delta_dist;
    for y = 1:Nt
        y_j = y*RFdist_tac/delta_dist;
        for xarea = 1:x_tac
            for yarea = 1:y_tac
                RF_tac(xarea,yarea) = exp(-((x_i - xarea)^2 + (y_j - yarea)^2)/2 * RFvar_aud^2);
                RFall_tac = RFall_tac + RF_tac;
                neurons_tac{x,y} = RF_tac;
            end
        end
    end
end

% Convolved input & RFs - input as received by the neurons
IR_tac = RFall_tac .* I_tac;
figure
imagesc(IR_tac)


%% Auditory model

% Stimulus Gaussian
for x = 1:x_aud
    for y = 1:y_aud
        I_aud(x,y) = Io_aud * exp(-((x - x0_aud)^2 + (y - y0_aud)^2)/2 * I_var^2);
    end
end
figure
imagesc(I_aud)

% Receptive field Gaussians
RFall_aud = RF_aud
for x = 1:Ma
    x_i = (x*RFdist_aud - 5);
    for y = 1:Na
        y_j = (y*RFdist_aud - 15);
        for xarea = 1:x_aud
            for yarea = 1:y_aud
                RF_aud(xarea,yarea) = exp(-((x_i - xarea)^2 + (y_j - yarea)^2)/2);
                RFall_aud = RFall_aud + RF_aud;
                neurons_aud{x,y} = RF_aud;
            end
        end
    end
end

% Convolved input & RFs - input as received by the neurons
IR_aud = RFall_aud .* I_aud;
figure
imagesc(IR_aud)


