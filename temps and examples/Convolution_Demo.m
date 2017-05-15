function Convolution_Demo()
close all;
clear;

FontSize = 20;

global KEY_IS_PRESSED;
global RUNNING_MODE;
KEY_IS_PRESSED = 0;
RUNNING_MODE   = 1;

%% Signals:
%-- time axis:
t_step      = 0.02;
T_start     = -5;
T_end       = 5;
tau         = T_start : t_step : T_end;
axis_length = length(tau);

delta = @(t, t0) 1 * (abs(t - t0) < (t_step / 100));

z = sin(tau) + 0.1*randn(1, length(tau));

%% 1
CASE = 6;
switch CASE
    case 1
        x = @(t) 1 .* (t >= -1 & t < 1);
        h = @(t) 1 .* (t >= -0.5 & t < 0.5);
    case 2
        x = @(t) (t + 1) .* (t >= -1 & t < 0) + (1 - t) .* (t >= 0 & t < 1);
        h = @(t) delta(t, 1);
    case 3
        x = @(t) (t + 1) .* (t >= -1 & t < 0) + (1 - t) .* (t >= 0 & t < 1);
        h = @(t) delta(t, 0) - delta(t, t_step);
    case 4
        x = @(t) 1 * (t >= 0 & t < 2);
        h = @(t) t .* (t > 0 & t < 2);
    case 5
        x = @(t) exp(5 * -t.^2);
        h = @(t) delta(t, -4) + 2*delta(t, -2) + delta(t, 0) + 2*delta(t, 2) + delta(t, 4);
    case 6
        x = @(t) 1 .* (t >= -0.5 & t < 0.5);
        h = @(t) z(1 : length(t));
end

%% Extra:
% h = @(y) (y - 1) .* (y >= 1 & y < 4);
% x = @(y) h(-y);
% x = @(t) exp(5 * -t.^2);
% h = @(t) delta(t, -4) + 2*delta(t, -2) + delta(t, 0) + 2*delta(t, 2) + delta(t, 4);

% x = @(t) (t - 1) .* (t > 1 & t <= 2);
% x = @(t) (t >= 0 & t <= 1) .* exp(t) + (t > 1 & t < 2) .* exp(2 - t);
% x = @(t) 2 * (t > 0 & t < 3) .* exp(-t);
% x = @(t) t * (t > -1/2 & t < 1/2);

% h = @(t) delta(t, -1) + delta(t, -0.5) + delta(t, 0) + delta(t, 0.5) + delta(t, 1);
% x = @(t) delta(t, -1) + delta(t, -0.5) + delta(t, 0) + delta(t, 0.5) + delta(t, 1) + delta(t, -0.75) + delta(t, -0.25) + delta(t, 0.25) + delta(t, 0.75);
% x = @(t) 1 * (t == -3 | t == -2 | t == -1 | t == 0 | t == 1 | t == 2 | t == 3);
% x = @(t) 1 * (t > -0.5 & t < 0.5);
% x = @(t) exp(-t) .* ( t >= 0 & t <= 4 );
% x = @(t) h(-t);

% h = @(t) x(-t);
% h = @(t) 1 * (t > -1/2 & t < 1/2);
% h = @(t) exp(t) .* ( t >= 0 & t <= 1 ) + exp(2 - t) .* ( t > 1 & t <= 2 );
% h = @(t) (t + 1) .* ( t >= -1 & t < 0 ) + (1 - t) .* ( t >= 0 & t <= 1 );

A = 4;

%% Plotting:
figure;
set(gcf, 'KeyPressFcn', @myKeyPressFcn)
subplot(A,1,1); hold on; set(gca, 'FontSize', FontSize)
title('<-, ->, p, Esc');
h1 = plot(0,   0,      'r', 'LineWidth', 5);
h2 = plot(0,   0,      'k', 'LineWidth', 5);
h3 = plot(tau, h(tau), 'g', 'LineWidth', 5);
h4 = plot(tau, x(tau), 'b', 'LineWidth', 5);
legend([h3, h4, h2, h1], {'h(t)', 'x(t)',...
                          'x(t - \tau)\cdot h(\tau)', 'y(t) = (x * h)_t'});
xlabel('t'); hold off;


%%
subplot(A,1,2); hold on; set(gca, 'FontSize', FontSize)
plot(tau, h(tau), 'g', 'LineWidth', 5);
hX = plot(tau, zeros(1, axis_length), 'b', 'LineWidth', 5);
% legend('h(t)', 'x(t)');
ylim( [ min([x(tau), h(tau)]),  max([x(tau), h(tau)]) ] );
xlabel('\tau'); hold off;

%%
subplot(A,1,3); hold on; set(gca, 'FontSize', FontSize);
hF = fill(tau, zeros(1, axis_length), 'r', 'FaceAlpha', 0.4, 'LineWidth', 3 , 'EdgeColor', 'k');
range = [max(x(tau)) * max(h(tau)), max(x(tau)) * min(h(tau)), ...
         min(x(tau)) * max(h(tau)), min(x(tau)) * min(h(tau))];
axis([T_start, T_end, min(range), max(range)]);
% legend('h(\tau)', 'x(t - \tau)');
xlabel('\tau'); hold off;

%%
subplot(A,1,4); hold on; set(gca, 'FontSize', FontSize);
hY = plot(tau, zeros(1, axis_length), 'r', 'LineWidth', 5);
range = conv(h(tau), x(tau)) * t_step;
axis([T_start, T_end, min(range), max(range)]);
ylabel('Convolutional output y(t)');
xlabel('t'); hold off;

%%
y = zeros(1, axis_length);
global ii;
ii = 0;
while ~KEY_IS_PRESSED && ii < axis_length
% for ii = 1 : axis_length
    if RUNNING_MODE == 1
        ii = ii + 1;
    end

    xlabel(['t = ', num2str(tau(ii))]);
%     pause(0.001);
%     keyboard
    t = tau(ii);
        
    set(hX, 'YData', x(t - tau));
    
    prod = x(t - tau) .* h(tau);
    set(hF, 'YData', prod);
    
    y(ii) = x(t - tau) * h(tau)' * t_step;
    set(hY, 'XData', tau(1:ii), 'YData', y(1:ii));

    drawnow;
    
end

end

function myKeyPressFcn(~, event)

global KEY_IS_PRESSED;
global RUNNING_MODE;
global ii;
if strcmp(event.Key, 'leftarrow');
% if event.Character == 'u'
    ii = ii - 10;
elseif strcmp(event.Key, 'rightarrow');
    ii = ii + 10;
elseif strcmp(event.Key, 'p');
    RUNNING_MODE = 1 - RUNNING_MODE;
elseif strcmp(event.Key, 'escape');
    KEY_IS_PRESSED  = 1;
end
end
