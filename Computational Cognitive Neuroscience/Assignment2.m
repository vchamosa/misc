%% Computational Cognitive Neuroscience
% Assignment 2
% Decision-making & the modelling of behavioural data
%
%

%% Drift Diffusion Process
clearvars

% Variables
to = 2000; % timeout in no. of steps
a = 0.12; % separation of boundaries
v = 0.03; % drift rate
s = 0.04; % standard deviation
dt = 0.001; % timestep
z = a/2; % value of starting point W(0)
%W = zeros(1,to); % Wiener diffusion process
%W(1) = z; % starting point
nSim = 10000;

% Simulation
W_sim = cell(1,nSim); % collection of all decisions
W_plus = cell(1,nSim); % collection of hypothesis h^+ decisions
W_min = cell(1,nSim); % collection of hypothesis h^- decisions
W_nd = NaN(nSim,to); % collection of no decision
duration = zeros(1,nSim); % time taken to reach each decision
for sim = 1:nSim
    eta = normrnd(0,sqrt(dt),1,to); % Gaussian noise
    W = z;
    for t = 1:(to - 1)
        if W(t) >= a || W(t) < 0 % end simulation if a decision is made
            break
        end
            W(t + 1) = W(t) + v*dt + s*eta(t);
    end
    W_sim{sim} = W; % all paths
    duration(sim) = t;
    if W(t) >= a % decision outcome
        W_plus{sim} = W; % h^+ paths
    elseif W(t) <= 0
        W_min{sim} = W; % h^- paths
    else
        W_nd(sim,:) = W; % inconclusive paths
    end
end

% Metrics
W_plus = W_plus(~cellfun('isempty',W_plus)); % remove empty spaces
W_min = W_min(~cellfun('isempty',W_min)); % remove empty spaces
W_nd = W_nd(~isnan(W_nd(:,1)),:); % remove empty spaces
hPlus_end = cellfun(@length,W_plus); % h^+ path endpoint
hMin_end = cellfun(@length,W_min); % h^- path endpoint
nodec_val = W_nd(:,to)'; % evidence value at timeout
RT_hPlus = median(hPlus_end); % median reaction time of h^+ drifts 
RT_hMin = median(hMin_end); % median reaction time of h^- drifts
hPlus_num = length(W_plus); % number of drifts to hypothesis h^+
hMin_num = length(W_min); % number of drifts to hypothesis h^-
nodec_num = length(W_nd(:,1)); % number of times no decision is reached before timeout
per_hPlus = (hPlus_num/nSim)*100; % percentage of drifts to hypothesis h^+
per_hMin = (hMin_num/nSim)*100; % percentage of drifts to hypothesis h^-
per_nodec = 100 - (per_hPlus + per_hMin); % percentage of times no decision is reached
%W_plus = cellfun(@(x) padarray(x,[0 (to - length(x))],NaN,'post'),W_plus,'UniformOutput',false); % pad for equal length
%W_min = cellfun(@(x) padarray(x,[0 (to - length(x))],NaN,'post'),W_min,'UniformOutput',false); % pad for equal length


%% Plots

% Example decision paths
figure
hold on
plot(W_plus{1},'Color','b')
plot(W_min{1},'Color','r')
plot(W_nd(1,:),'Color',[0.7 0.7 0.7])
hold off
yline(a,'LineWidth',1.5,'Color','k');
yline(0,'LineWidth',1.5,'Color','k');
yline(z,'--','LineWidth',1,'Color',[0.4 0.4 0.4]);
ylabel("Evidence",'FontSize',12);
xlabel("Time (steps)",'FontSize',12);
ylim([-0.01 0.13]);
xlim([0 2000]);
title("W_t - evidence accumulation path",'FontSize',13,'FontWeight','bold');

% Time distribution histograms
figure % h^+
histogram(hPlus_end,20)
xlabel("Time (steps)",'FontSize',12);
ylabel("Instances of  h^+",'FontSize',12);
xlim([0 2000]);

figure % h^-
histogram(hMin_end,20)
xlabel("Time (steps)",'FontSize',12);
ylabel("Instances of  h^-",'FontSize',12);
xlim([0 2000]);

figure % all decisions, histogram and paths
subplot(2,1,1);
histogram(horzcat(hMin_end,hPlus_end),20)
ylabel("All decision instances",'FontSize',12);
xlim([0 2000]);
subplot(2,1,2);
hold on
cellfun(@(x) plot(x,'Color','b'),W_plus(1:10))
cellfun(@(x) plot(x,'Color','r'),W_min(1:10))
hold off
yline(a,'LineWidth',1.5,'Color','k');
yline(0,'LineWidth',1.5,'Color','k');
yline(z,'--','LineWidth',1,'Color',[0.4 0.4 0.4]);
ylabel("Evidence",'FontSize',12);
xlabel("Time (steps)",'FontSize',12);
yticks([0 z 0.12]);
ylim([-0.01 0.13]);
xlim([0 2000]);

% Evidence at timeout histogram
%figure
%hist(nodec_val)


