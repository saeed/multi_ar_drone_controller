%metrics vs Rmax
%case of 4 line clusters
% 50 targets
% 5 scenarios
close all;
R = [20 25 30 35 40 45 50];

camNum_algo1 = [17.8, 11.5, 8, 5.4, 3.5, 2.4, 2];
algo1_CTR = camNum_algo1./50; 
camNum_algo2 = [16.6, 8.1, 5.7, 5.6, 3.25, 3.4, 3];
algo2_CTR = camNum_algo2./50;
camNum_greedy = [6, 5.1, 4, 3.8, 4, 3.2, 3.2];
algo3_CTR = camNum_greedy./50;
camNum_dual = [6.2, 4.9, 4, 3.6, 4, 3.2, 3];
algo4_CTR = camNum_dual./50

algo1_exec_time = [18.7, 9.5, 5.5, 3.1, 1.4, 0.9, 0.5]
algo2_exec_time = [2.7, 0.9, 0.52, 0.5, 0.23, 0.26, 0.22];
algo3_exec_time = [188, 163, 155, 153, 147, 140, 134];
algo4_exec_time = [65, 67, 74, 87, 87.5, 84.5, 78];

coverage_algo1 = [(50 - 9.8)/50, (50-7.2)/50, (50-7.75)/50, (50-8.2)/50, (50-8.5)/50, (50-7.6)/50, (50-6.6)/50];
coverage_algo2 = [(50 - 7.8)/50, (50-7.5)/50, (50-5.75)/50, (50-4.8)/50, (50-6.25)/50, (50-4)/50, (50-4)/50];
coverage_greedy = [1, 1, 1, 1, 1, 1, 1];
coverage_dual = [1, 1, 1, 1, 1, 1, 1];


figure;
plot(R, algo1_CTR, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo2_CTR, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo3_CTR, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo4_CTR, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy', '2-Smp','FontName','Times New Roman');
xlabel('Rmax(m)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('CTR', 'FontSize', 24,'FontName','Times New Roman');

figure;
plot(R, coverage_algo1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, coverage_algo2, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, coverage_greedy, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, coverage_dual, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy','2-Smp','FontName','Times New Roman');
xlabel('Rmax(m)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('coverage ratio', 'FontSize', 24,'FontName','Times New Roman');

figure;
plot(R, algo1_exec_time, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo2_exec_time, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo3_exec_time, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo4_exec_time, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy', '2-Smp','FontName','Times New Roman');
xlabel('Rmax(m)','FontSize', 24,'FontName','Times New Roman');
ylabel('execution time(sec)', 'FontSize', 24,'FontName','Times New Roman');