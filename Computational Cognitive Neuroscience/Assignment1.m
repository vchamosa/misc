%% Computational Cognitive Neuroscience
% Assignment 1
% How the brain represents space around the body (peri-personal space)
%
%

clearvars
%% Variables

I_var = 0.3; % spatial extension (variance) of input
I_time = 200; % length of input (ms)
T = 20; % time constant (ms)
h = 0.4; % time step (ms)
delta_dist = 0.2; % spatial change
Fmax = 1; % upper boundary of sigmoid
Fmin_s = -0.12; % lower boundary of sigmoid
Qc_s = 19.43; % central point of sigmoid
R_s = 0.34; % slope at central point

% Tactile neurons
Mt = 40;
Nt = 20;
neuronsRF_tac = cell(Nt,Mt); % all neurons + individual receptive fields
RFdist_tac = 0.5; % receptive field distance, to be multiplied by position
%area_tac = zeros((RFdist_tac * Mt),(RFdist_tac * Nt)); % receptive areas
area_tac = zeros((RFdist_tac * Nt),(RFdist_tac * Mt)); % receptive areas
RFvar_tac = 1; % spatial extension (variance) of receptive field
RF_tac = zeros(size(area_tac)/delta_dist); % skin area
Io_tac = 2.5; % input amplitude
I_tac = RF_tac; % input in space
[x_tac,y_tac] = size(RF_tac); % dimensions of skin area
x0_tac = x_tac/2; % centre, x axis
y0_tac = y_tac/2; % centre, y axis
Lex_tac = 0.15; % Lateral excitatory synapse strength
Lin_tac = 0.05; % Lateral inhibitory synapse strength
Lvarex_tac = 1; % Variance on synapse strength Gaussian
Lvarin_tac = 4; % Variance on synapse strength Gaussian

% Auditory neurons
Ma = 20;
Na = 3;
neuronsRF_aud = cell(Na,Ma); % all neurons + individual receptive fields
RFdist_aud = 10; % receptive field distance, to be multiplied by position
%area_aud = zeros((RFdist_aud * Ma),(RFdist_aud * Na)); % receptive area
area_aud = zeros((RFdist_aud * Na),(RFdist_aud * Ma)); % receptive area
RFvar_aud = 10; % spatial extension (variance) of receptive field
RF_aud = area_aud;
Io_aud = 3.6; % input amplitude
I_aud = area_aud; % input in space
[x_aud,y_aud] = size(RF_aud); % dimensions of auditory area
x0_aud = x_aud/2; % centre, x axis
y0_aud = 5;%y_aud/2; % centre, y axis
Lex_aud = 0.15; % Lateral excitatory synapse strength
Lin_aud = 0.05; % Lateral inhibitory synapse strength
Lvarex_aud = 20; % Variance on synapse strength Gaussian
Lvarin_aud = 80; % Variance on synapse strength Gaussian

% Multisensory neuron
k1 = 15; % (cm)
k2 = 800; % (cm)
alpha = 0.9;
Lim = 65; % (cm)
W0 = 6.5; % feedforward weight
B0 = 2.5; % feedback weight
Fmin_m = 0; % lower boundary of sigmoid
Qc_m = 12; % central point of sigmoid
R_m = 0.6; % slope at central point


%% Tactile model

% Stimulus Gaussian
for x = 1:x_tac
    for y = 1:y_tac
        I_tac(x,y) = Io_tac * exp(-((x - x0_tac)^2 + (y - y0_tac)^2)/(2 * (I_var/delta_dist)^2));
    end
end

% Receptive field & lateral connectivity functions
RFall_tac = RF_tac; % sum of receptive fields
Lcon_tac = RF_tac; % lateral connectivity of a specific neuron
Lall_tac = Lcon_tac; % sum of lateral connectivity
neuronsL_tac = neuronsRF_tac; % lateral connectivity of all neurons
for x = 1:Nt
    x_i = x*RFdist_tac/delta_dist;
    for y = 1:Mt
        y_j = y*RFdist_tac/delta_dist;
        for xarea = 1:x_tac
            Dx = x_i - xarea; % distance in x axis from neuron
            for yarea = 1:y_tac
                Dy = y_j - yarea; % distance in y axis from neuron
                RF_tac(xarea,yarea) = exp(-((x_i - xarea)^2 + (Dy)^2)/(2 * (RFvar_tac/delta_dist)^2));
                if xarea == x_i && yarea == y_j % auto-excitation is not allowed
                    Lcon_tac(xarea,yarea) = 0;
                else
                    Lcon_tac(xarea,yarea) = Lex_tac * exp(-(Dx^2 + Dy^2)/(2 * (Lvarex_tac/delta_dist)^2)) - Lin_tac * exp(-(Dx^2 + Dy^2)/(2 * (Lvarin_tac/delta_dist)^2));
                end
            end
        end
        RFall_tac = RFall_tac + RF_tac;
        neuronsRF_tac{x,y} = RF_tac;
        Lall_tac = Lall_tac + Lcon_tac;
        neuronsL_tac{x,y} = Lcon_tac;
    end
end
IR_tac = RFall_tac .* I_tac;


%% Auditory model

% Stimulus Gaussian
for x = 1:x_aud
    for y = 1:y_aud
        I_aud(x,y) = Io_aud * exp(-((x - x0_aud)^2 + (y - y0_aud)^2)/(2 * (I_var/delta_dist)^2));
    end
end

% Receptive field & lateral connectivity functions
RFall_aud = RF_aud;
Lcon_aud = RF_aud; % lateral connectivity of a specific neuron
Lall_aud = Lcon_aud; % sum of lateral connectivity
neuronsL_aud = neuronsRF_aud; % lateral connectivity of all neurons
for x = 1:Na
    x_i = (x*RFdist_aud) - 5;
    for y = 1:Ma
        y_j = (y*RFdist_aud) - 15;
        for xarea = 1:x_aud
            Dx = x_i - xarea; % distance in x axis from neuron
            for yarea = 1:y_aud
                Dy = y_j - yarea; % distance in y axis from neuron
                RF_aud(xarea,yarea) = exp(-((x_i - xarea)^2 + (y_j - yarea)^2)/(2 * RFvar_aud^2));
                if xarea == x_i && yarea == y_j % auto-excitation is not allowed
                    Lcon_aud(xarea,yarea) = 0;
                else
                    Lcon_aud(xarea,yarea) = Lex_aud * exp(-(Dx^2 + Dy^2)/(2 * (Lvarex_aud/delta_dist)^2)) - Lin_aud * exp(-(Dx^2 + Dy^2)/(2 * (Lvarin_aud/delta_dist)^2));
                end
            end
        end
        RFall_aud = RFall_aud + RF_aud;
        neuronsRF_aud{x,y} = RF_aud;
        Lall_aud = Lall_aud + Lcon_aud;
        neuronsL_aud{x,y} = Lcon_aud;
    end
end
IR_aud = RFall_aud .* I_aud;


%% Multisensory neuron

% Connections with auditory neurons
W_aud = zeros(size(RF_aud)); % feedforward weight of a specific neuron
B_aud = zeros(size(RF_aud)); % feedback weight of a specific neuron
for x_neur = 1:x_aud
    x_i = (x_neur*RFdist_aud) - 5;
    for y_neur = 1:y_aud
        if Lim >= y_neur
            D_neur = 0;
        else
            y_j = (y_neur*RFdist_aud) - 15;
            D_neur = y_j - Lim;
        end
        W_aud(x_neur,y_neur) = alpha * W0 * exp(-(D_neur/k1)) + (1 - alpha) * W0 * exp(-(D_neur/k2));
        B_aud(x_neur,y_neur) = alpha * B0 * exp(-(D_neur/k1)) + (1 - alpha) * B0 * exp(-(D_neur/k2));
    end
end

% Connections with tactile neurons
W_tac = zeros(size(RF_tac)); % feedforward weight of a specific neuron
W_tac = W_tac + W0;
B_tac = zeros(size(RF_tac)); % feedback weight of a specific neuron
B_tac = B_tac + B0;

% Schizophrenia Poisson pruning
%  lambda = Lim:20:length(RF_aud);
%  for p = 1:30
%      syn = poissrnd(lambda);
%      W_aud(p,syn) = 0;
%  end

%% Neuronal firing - BROKEN

% Q0 = 70; % initialising q (dynamic state variable)
% Qm = zeros(1,(I_time/h + 1));
% Qt = cell(1,(I_time/h + 1));
% Qa = zeros(1,(I_time/h + 1));
% Zm = zeros(1,(I_time/h + 1)); % multisensory neuron rate
% Zt = cell(1,(I_time/h + 1)); % tactile neuron rate
% Za = cell(1,(I_time/h + 1)); % auditory neuron rate
% u_tac = cell(1,(I_time/h + 1));
% for t = 1:(I_time/h) + 1
%     if t == 1
%         Qm(t) = Q0;
%         Qt{t} = Q0;
%         Qa(t) = Q0;
%         Zt{t} = zeros(size(RF_tac));
%         Zt{t} = (Fmin_s + Fmax * exp((Qt{t} - Qc_s)*R_s))/ (1 + exp((Qt{t} - Qc_s)*R_s));
%         Za{t} = zeros(size(RF_aud));
%         Za{t} = (Fmin_s + Fmax * exp((Qa - Qc_s)*R_s))/ (1 + exp((Qa - Qc_s)*R_s));
%     end
%     % multisensory neuron
%     Zm(t+1) = (Fmin_m + Fmax * exp((Qm(t) - Qc_m)*R_m))/ (1 + exp((Qm(t) - Qc_m)*R_m));
%     if Zm(t+1) < 0 % rectifying negative values
%         Zm(t+1) = 0;
%     end
%     u_m = sum(sum(W_tac .* Zt{t})) + sum(sum(W_aud .* Za{t}));
%     Qm(t+1) = ((-Qm(t) + u_m)*h + Qm(t))/T;
%     % tactile neurons
%     u_tac{t} = cell(size(neuronsL_tac));
%     for x = 1:Nt
%         %x_i = x*RFdist_tac/delta_dist;
%         for y = 1:Mt
%            %y_j = y*RFdist_tac/delta_dist;
%             Zt{t+1} = (Fmin_s + Fmax * exp((Qt{t} - Qc_s)*R_s))/ (1 + exp((Qt{t} - Qc_s)*R_s));
%             if Zt{t+1} < 0
%                 Zt{t+1} = 0;
%             end
%             u_tac{t}{x,y} = IR_tac + sum(sum(neuronsL_tac{x,y}*(Zt{t+1}(x,y)))) + B_tac*Zm(t+1);
%             Qt{t+1} = ((-Qt{t} + u_tac{t}{x,y})*h + Qt{t})/T;
%         end
%     end
%     % auditory neurons
%     for x = 1:Na
%         for y = 1:Ma
%             Za{t+1}{x,y} = (Fmin_s + Fmax * exp((Qa(t) - Qc_s)*R_s))/ (1 + exp((Qa(t) - Qc_s)*R_s));
%             if Za{t+1} < 0
%                 Za{t+1} = 0;
%             end
%             u_aud{x,y} = IR_tac + sum(sum(neuronsL_aud{x,y}*(Za{t+1}(x,y)))) + B_tac*Zm(t+1);
%             Qa(t+1) = ((-Qa(t) + u_aud(x,y))*h + Qa(t))/T;
%         end
%     end
% end
 

%% Plots

% Tactile stimulus and sum of receptive fields
figure
subplot(2,1,1);
imagesc(I_tac)
ylabel("tactile space (cm)",'FontSize',12);
yticks([0 25 50]);
set(gca,'YTickLabel',[0 5 10])
xticks([0 50 100]);
set(gca,'XTickLabel',[0 10 20])
title("Tactile stimulus",'FontSize',13,'FontWeight','bold');
subplot(2,1,2);
imagesc(RFall_tac)
ylabel("tactile space (cm)",'FontSize',12);
xlabel("tactile space (cm)",'FontSize',12);
yticks([0 25 50]);
set(gca,'YTickLabel',[0 5 10])
xticks([0 50 100]);
set(gca,'XTickLabel',[0 10 20])
title("Sum of receptive fields",'FontSize',13,'FontWeight','bold');

% Convolved input & RFs - input as received by tactile neurons
figure
imagesc(IR_tac)
daspect([1 1 1])
ylabel("tactile space (cm)",'FontSize',12);
xlabel("tactile space (cm)",'FontSize',12);
yticks([0 25 50]);
set(gca,'YTickLabel',[0 5 10])
xticks([0 50 100]);
set(gca,'XTickLabel',[0 10 20])
title("Input as received",'FontSize',13,'FontWeight','bold');

% Lateral connectivity of central tactile neuron
figure
imagesc(neuronsL_tac{10,20})
daspect([1 1 1])
ylabel("tactile space (cm)",'FontSize',12);
xlabel("tactile space (cm)",'FontSize',12);
yticks([0 25 50]);
set(gca,'YTickLabel',[0 5 10])
xticks([0 50 100]);
set(gca,'XTickLabel',[0 10 20])
title("Lateral connectivity of central neuron",'FontSize',13,'FontWeight','bold');

% Auditory stimulus and sum of receptive fields
figure
subplot(2,1,1);
imagesc(I_aud)
ylabel("auditory space (cm)",'FontSize',12);
yticks([0 15 30]);
xticks([0 100 200]);
title("Auditory stimulus",'FontSize',13,'FontWeight','bold');
subplot(2,1,2);
imagesc(RFall_aud)
ylabel("auditory space (cm)",'FontSize',12);
xlabel("auditory space (cm)",'FontSize',12);
yticks([0 15 30]);
xticks([0 100 200]);
title("Sum of receptive fields",'FontSize',13,'FontWeight','bold');

% Convolved input & RFs - input as received by auditory neurons
figure
imagesc(IR_aud)
daspect([3 1 1])
ylabel("auditory space (cm)",'FontSize',12);
xlabel("auditory space (cm)",'FontSize',12);
yticks([0 15 30]);
xticks([0 100 200]);
title("Input as received",'FontSize',13,'FontWeight','bold');

% Auditory feedforward & feedback weights
figure
subplot(2,1,1);
imagesc(W_aud)
rectangle('Position',[0 10 20 10],'Linewidth',1)
ylabel("auditory space (cm)",'FontSize',12);
yticks([0 10 15 20 30]);
xticks([0 20 65 100 200]);
title("Feedforward weights",'FontSize',13,'FontWeight','bold');
subplot(2,1,2);
imagesc(B_aud)
rectangle('Position',[0 10 20 10],'Linewidth',1)
ylabel("auditory space (cm)",'FontSize',12);
xlabel("auditory space (cm)",'FontSize',12);
yticks([0 10 15 20 30]);
xticks([0 20 65 100 200]);
title("Feedback weights",'FontSize',13,'FontWeight','bold');
% subplot(3,1,3);
% plot(B_aud(1,:))
% ylabel("Weight",'FontSize',12);
% xlabel("auditory space (cm)",'FontSize',12);
% ylim([0 3]);
% %yticks([0 0.5 1 1.5 2 2.5 3]);
% title("Feedback weights",'FontSize',13,'FontWeight','bold');


