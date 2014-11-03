%results
close all;
Rmax_vec = [25 30 35 40 45 50];

cluster_count_avg_algo1 = [5.9000    4.6000    3.9000    2.8000    1.4000    1.0000];
algo1_CTR = (1/50).*cluster_count_avg_algo1;

uncovered_avg_algo1 = [7.5000    6.4000    7.9000    7.9000    6.4000    5.5000];
algo1_coverage_ratio = (50 - uncovered_avg_algo1)./50;
algo1_exec_time = [3.4954    2.2774    1.8286    0.9193    0.1962    0.0150];

uncovered_avg_algo2 = [7.2000    6.3000    3.9000    5.5000    4.5000    5.5000];
algo2_coverage_ratio = (50 - uncovered_avg_algo2)./50;
algo2_exec_time = [0.4708    0.3610    0.2910    0.1662    0.0998    0.0549];
camNum_avg = [5.3000    4.4000    3.8000    2.5000    1.6000    1.0000];
algo2_CTR = (1/50).*camNum_avg;

algo3_exec_time = [134.9446  129.9045  128.8924  124.4024  120.1524  114.4695];


Greedy_uncovered_avg = [0     0     0     0     0     0];
algo3_coverage_ratio = ones(1,6);

Greedy_camNum_avg = [3.8000    3.2000    2.6000    2.0000    2.0000    2.0000];
algo3_CTR = (1/50).*Greedy_camNum_avg;

algo4_exec_time = [46.7993   53.7547   61.7882   65.5055   63.6555   59.0503];


Dual_uncovered_avg = [0     0     0     0     0     0];
algo4_coverage_ratio = ones(1,6);

Dual_camNum_avg = [3.6000    2.8000    2.6000    2.2000    2.0000    2.0000];
algo4_CTR = (1/50).*Dual_camNum_avg;

%figure;
%subplot(3,1,1);
plot(Rmax_vec, algo1_CTR, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(Rmax_vec, algo2_CTR, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
plot(Rmax_vec, algo3_CTR, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(Rmax_vec, algo4_CTR, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy', '2-Smp','FontName','Times New Roman','FontSize', 24);
xlabel('Rmax(m)', 'FontSize', 24, 'FontName','Times New Roman');
ylabel('CTR', 'FontSize', 24,'FontName','Times New Roman');

figure;
%subplot(3,1,2);
plot(Rmax_vec, algo1_coverage_ratio, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(Rmax_vec, algo2_coverage_ratio, '-c^', 'LineWidth',2','MarkerSize',8); hold on;
plot(Rmax_vec, algo3_coverage_ratio, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(Rmax_vec, algo4_coverage_ratio, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy', '2-Smp','FontName','Times New Roman','FontSize', 24);
xlabel('Rmax(m)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('coverage ratio', 'FontSize', 24,'FontName','Times New Roman');

figure;
%subplot(3,1,3);
plot(Rmax_vec, algo1_exec_time, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(Rmax_vec, algo2_exec_time, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
plot(Rmax_vec, algo3_exec_time, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(Rmax_vec, algo4_exec_time, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy','2-Smp','FontName','Times New Roman','FontSize', 24);
xlabel('Rmax(m)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('execution time(sec)', 'FontSize', 24,'FontName','Times New Roman');