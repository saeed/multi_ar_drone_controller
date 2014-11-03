% varying AOV at dim =50X50, Rmax = 25, TargetCount = 50
close all;
AOV = [ 45, 60, 92, 120, 150, 180];

%algo1
algo1_coverage_ratio = [(50-4.3)/50, (50-3.6)/50, (50 - 3.8)/50, (50-3.1)/50, (50-3.4)/50, (50-2.9)/50];
algo1_CTR = [14/50, 11.9/50, 8.1/50, 6.5/50, 4.9/50, 4.8/50];
algo1_exec_time = [12.88, 9.95, 5.9, 4.2, 2.62, 2.65];

%algo2
algo2_coverage_ratio = [46/50, 47/50, 45/50, 45.8/50, 46.1/50,45.8/50];
algo2_CTR = [12.2/50, 9.8/50, 7.1/50, 6.1/50, 6.3/50, 5.7/50];
algo2_exec_time = [1.72, 1.19, 0.7, 0.57, 0.6, 0.53];

%algo3(greedy)
algo3_coverage_ratio = [1, 1, 1, 1, 1, 1];
algo3_CTR = [6/50, 5/50, 3.9/50, 3.6/50, 3.2/50, 2.8/50];
algo3_exec_time = [217, 196.2, 169.3, 156.9, 147.86, 140.3];

%algo4(dual-sampling)
algo4_coverage_ratio = [1, 1, 1, 1, 1, 1];
algo4_CTR = [6.3/50, 5.2/50, 3.9/50, 3.9/50, 3.4/50, 2.9/50];
algo4_exec_time = [90.55, 77.71, 61.87, 53.12,45, 40.5];

figure;
plot(AOV, algo1_CTR, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, algo2_CTR, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, algo3_CTR, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, algo4_CTR, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy', '2-Smp','FontName','Times New Roman','FontSize', 24);
xlabel('angle(deg)', 'FontSize', 24, 'FontName','Times New Roman');
ylabel('CTR', 'FontSize', 24,'FontName','Times New Roman');

figure;
plot(AOV, algo1_coverage_ratio, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, algo2_coverage_ratio, '-c^', 'LineWidth',2','MarkerSize',8); hold on;
plot(AOV, algo3_coverage_ratio, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, algo4_coverage_ratio, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy', '2-Smp','FontName','Times New Roman','FontSize', 24);
xlabel('angle(deg)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('coverage ratio', 'FontSize', 24,'FontName','Times New Roman');

figure;
plot(AOV, algo1_exec_time, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, algo2_exec_time, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, algo3_exec_time, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, algo4_exec_time, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy','2-Smp','FontName','Times New Roman','FontSize', 24);
xlabel('angle(deg)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('execution time(sec)', 'FontSize', 24,'FontName','Times New Roman');