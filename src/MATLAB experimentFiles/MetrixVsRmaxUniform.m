% uniform distribution
% termination coverage ratio varied 0.1 and 0.2
% vary Rmax


R = [20 25 30 35 40 45 50];

%termination ratio = 0.1

close all;
R = [20 25 30 35 40 45 50];

%termination ratio = 0.1
camNum_algo1_ratio1 = [16.4, 14, 13.1, 9.8, 7.5, 5.6, 3.4];
algo1_CTR_ratio1 = camNum_algo1_ratio1./50; 
camNum_algo2_ratio1 = [17.5, 14.1, 10, 8.3, 6.6, 5.6, 3.8];
algo2_CTR_ratio1= camNum_algo2_ratio1./50;

%termination ratio = 0.2
camNum_algo1_ratio2 = [13.9, 12, 10.4, 8.2, 5.4, 3.8, 2.6];
algo1_CTR_ratio2 = camNum_algo1_ratio2./50; 
camNum_algo2_ratio2 = [13.8, 9.4, 8.2, 5.8, 5, 3.8, 2.8];
algo2_CTR_ratio2= camNum_algo2_ratio2./50;


camNum_greedy = [7.7, 6, 4.8, 4.4, 4.2, 4.4, 4.2];
algo3_CTR = camNum_greedy./50;
camNum_dual = [7.8, 6.2, 5, 4.6, 4.8, 4.4, 4];
algo4_CTR = camNum_dual./50

algo1_exec_time_ratio1 = [16.5, 12.7, 11.3, 7.3, 4.9, 3, 1.4];
algo2_exec_time_ratio1 = [3.1, 2.2, 1.2, 0.92, 0.67, 0.5, 0.3];

algo1_exec_time_ratio2 = [13.1, 10.5, 8.1, 5.7, 3, 1.9, 0.9];
algo2_exec_time_ratio2 = [2, 1.1, 0.9, 0.54, 0.45, 0.3, 0.2 ];



algo3_exec_time = [252, 193, 173, 164, 165, 156, 152 ];
algo4_exec_time = [82, 84, 88, 93, 102, 101, 96];

coverage_algo1_ratio1 = [(50 - 4.1)/50, (50-4.1)/50, (50-3.6)/50, (50-3.7)/50, (50-3.6)/50, (50-3.7)/50, (50-3.8)/50];
coverage_algo2_ratio1 = [(50 - 2.7)/50, (50-2.1)/50, (50-2.3)/50, (50-2.1)/50, (50-1.9)/50, (50-2.1)/50, (50-2.2)/50];

coverage_algo1_ratio2 = [(50 - 8.9)/50, (50-7.8)/50, (50-8.6)/50, (50-9)/50, (50-7.4)/50, (50-8.6)/50, (50-6.4)/50];
coverage_algo2_ratio2 = [(50 - 7.4)/50, (50-6.2)/50, (50-4.6)/50, (50-7)/50, (50-5.2)/50, (50-8)/50, (50-5.8)/50];

coverage_greedy = [1, 1, 1, 1, 1, 1, 1];
coverage_dual = [1, 1, 1, 1, 1, 1, 1];


figure;
plot(R, algo1_CTR_ratio1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo1_CTR_ratio2, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo2_CTR_ratio1, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo2_CTR_ratio2, '-c+', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo3_CTR, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo4_CTR, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam1', 'KCam2', 'CF1', 'CF2', 'Greedy', '2-Smp','FontName','Times New Roman');
xlabel('Rmax(m)','FontSize', 24,'FontName','Times New Roman');
ylabel('CTR', 'FontSize', 24,'FontName','Times New Roman');

figure;
plot(R, coverage_algo1_ratio1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, coverage_algo1_ratio2, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, coverage_algo2_ratio1, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, coverage_algo2_ratio2, '-c+', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, coverage_greedy, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, coverage_dual, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam1', 'KCam2', 'CF1', 'CF2', 'Greedy', '2-Smp','FontName','Times New Roman');
xlabel('Rmax(m)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('coverage ratio', 'FontSize', 24,'FontName','Times New Roman');

figure;
plot(R, algo1_exec_time_ratio1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo1_exec_time_ratio2, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo2_exec_time_ratio1, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo2_exec_time_ratio2, '-c+', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo3_exec_time, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo4_exec_time, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam1', 'KCam2', 'CF1', 'CF2', 'Greedy', '2-Smp','FontName','Times New Roman');
xlabel('Rmax(m)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('execution time(sec)', 'FontSize', 24,'FontName','Times New Roman');
