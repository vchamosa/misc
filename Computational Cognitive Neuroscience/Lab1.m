%% Computational Cognitive Neuroscience
% Lab Session 1
%
%

% Constants and variables
neur = 50; % number of neurons
V_rest = -70; % resting potential (mV)
V_reset = -70; % reset voltage (mV)
spikeGen = -50; % spike generating threshold (mV)
T_mem = 20; % membrane time constant (ms)
Rm = 1; % membrane input resistance
timestep = 0.1; % timestep size (ms)
timedur = 1000; % total duration (ms)

%neurons = zeros(1,50);
memPot = zeros(timedur,neur);
spikes = zeros(timedur,neur);
input = zeros(timedur,neur);
input_tot = zeros(timedur,neur);

totstep = timedur/timestep; % number of steps in session
memPot = memPot + V_rest; % set resting membrane potential
input = input + 20; % give input value

%% Model

for step = 1:totstep
    noise_common = rand * 100;
    for cell = 1:neur
        input_tot(step,cell) = input(step,cell) + noise_common + (rand*50);
        memPot(step+1,cell) = V_rest - memPot(step,cell) + Rm*input_tot(step,cell);
        if memPot(step,cell) > spikeGen
            spikes(step,cell) = 1;
        else spikes(step,cell) = 0;
        end
    end
end

%% Plots

% raster plot
figure
subplot(2,1,1);
spikeplot = spikes';
colormap(gray);
imagesc(spikeplot)
% input plot
subplot(4,1,4);
plot(mean(input_tot))

