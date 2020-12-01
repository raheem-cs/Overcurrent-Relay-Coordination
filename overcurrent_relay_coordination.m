% ###### Settings Area - MODIFY ###### %

relaysNum = 4; % Number of relays
loadCurrent = [70 77 100 80 115]; % Load currents from right to left
maxFault = [1000 2000 3000 5000 6000]; % Fault currents from right to left
minTime = 0.15; % Minimum relay operating time
OLF = 1.2; % Overload factor
CTI = 0.2; % Coordination time interval
relayCurves = [1 1 1 1]; % From right to left (0 = SI, 1 = VI, 2 = EI)

% ###### Code Area - DON'T MODIFY ###### %

TD = [];  % [Relay4 Relay3 Relay2 Relay1]
I_pu = [];      % [Relay4 Relay3 Relay2 Relay1]

% Calculating pick-up current array
i = 1;
for r = 1:relaysNum
    totalCurrent = 0;
    for z = 1:i
        totalCurrent = totalCurrent + loadCurrent(z);
    end
    I_pu(r) = OLF * totalCurrent;
    i = i + 1;
end

% Calculating time delay array
t4_start = 0;
TD_1 = 0;
if (relayCurves(1) == 0) % Last relay is SI
    TD_1 = (minTime/0.14) * ((maxFault(2)/I_pu(1))^0.02 - 1);
    t4_start = (0.14*TD_1) / ((maxFault(1)/I_pu(1))^0.02 - 1);
    TD(1) = TD_1;
elseif (relayCurves(1) == 1) % Last relay is VI
    TD_1 = (minTime/13.5) * ((maxFault(2)/I_pu(1))^1 - 1);
    t4_start = (13.5*TD_1) / ((maxFault(1)/I_pu(1))^1 - 1);
    TD(1) = TD_1;
else % Last relay is EI
    TD_1 = (minTime/80) * ((maxFault(2)/I_pu(1))^2 - 1);
    t4_start = (80*TD_1) / ((maxFault(1)/I_pu(1))^2 - 1);
    TD(1) = TD_1;
end

time = [];
time(1) = t4_start;
max_time = 0;
for i = 1:relaysNum-1
    if (relayCurves(i) == 0) % Relay i is SI
        max_time = (0.14*TD(i)) / ((maxFault(i+1)/I_pu(i))^0.02 - 1);
        time(i+1) = CTI + max_time;
        if (relayCurves(i+1) == 0)
            TD(i+1) = (time(i+1)/0.14) * ((maxFault(i+1)/I_pu(i+1))^0.02 - 1);
        elseif (relayCurves(i+1) == 1)
            TD(i+1) = (time(i+1)/13.5) * ((maxFault(i+1)/I_pu(i+1))^1 - 1);
        else
            TD(i+1) = (time(i+1)/80) * ((maxFault(i+1)/I_pu(i+1))^2 - 1);
        end
    elseif (relayCurves(i) == 1) % Relay i is VI
        max_time = (13.5*TD(i)) / ((maxFault(i+1)/I_pu(i))^1 - 1);
        time(i+1) = CTI + max_time;
        if (relayCurves(i+1) == 0)
            TD(i+1) = (time(i+1)/0.14) * ((maxFault(i+1)/I_pu(i+1))^0.02 - 1);
        elseif (relayCurves(i+1) == 1)
            TD(i+1) = (time(i+1)/13.5) * ((maxFault(i+1)/I_pu(i+1))^1 - 1);
        else
            TD(i+1) = (time(i+1)/80) * ((maxFault(i+1)/I_pu(i+1))^2 - 1);
        end
    else % Relay i is EI
        max_time = (80*TD(i)) / ((maxFault(i+1)/I_pu(i))^2 - 1);
        time(i+1) = CTI + max_time;
        if (relayCurves(i+1) == 0)
            TD(i+1) = (time(i+1)/0.14) * ((maxFault(i+1)/I_pu(i+1))^0.02 - 1);
        elseif (relayCurves(i+1) == 1)
            TD(i+1) = (time(i+1)/13.5) * ((maxFault(i+1)/I_pu(i+1))^1 - 1);
        else
            TD(i+1) = (time(i+1)/80) * ((maxFault(i+1)/I_pu(i+1))^2 - 1);
        end
    end
end

% Printing the results
ap_num = 4;
fprintf(2, 'Relays Settings:\n');
for r = 1:relaysNum
    fprintf(2, '\nRelay %d:\n', ap_num);
    x = ['Pick-Up Current: ', num2str(I_pu(r)), ' A'];
    y = ['TD: ', num2str(TD(r)), ' s'];
    disp(x);
    disp(y);
    ap_num = ap_num - 1;
end

called = false;
ap_num = 4;
% Plotting curves
for i = 1:relaysNum
    if (relayCurves(i) == 0) % Relay i is SI
        If = [I_pu(i):50:maxFault(relaysNum)];
        t = (0.14*TD(i)) ./ ((If/I_pu(i)).^0.02 - 1);
        t(t < 0.15) = 0.15;
        plot(If, t, 'LineWidth', 2, 'DisplayName', ['Relay ' num2str(ap_num)]);
    elseif (relayCurves(i) == 1) % Relay i is VI
        If = [I_pu(i):50:maxFault(relaysNum)];
        t = (13.5*TD(i)) ./ ((If/I_pu(i)).^1 - 1);
        t(t < 0.15) = 0.15;
        plot(If, t, 'LineWidth', 2, 'DisplayName', ['Relay ' num2str(ap_num)]);
    else % Relay i is EI
        If = [I_pu(i):50:maxFault(relaysNum)];
        t = (80*TD(i)) ./ ((If/I_pu(i)).^2 - 1);
        t(t < 0.15) = 0.15;
        plot(If, t, 'LineWidth', 2, 'DisplayName', ['Relay ' num2str(ap_num)]);
    end
    
    if (~called)
        hold on;
        called = true;
    end
    
    ap_num = ap_num - 1;
end

title('Time-Current Characteristics');
xlabel('Fault Current (A)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
set(gca, 'YScale', 'log');
grid on;
legend('show');