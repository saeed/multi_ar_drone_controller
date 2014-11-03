%Results Kmeans Vs CF in large Rmax
Rmax_vec = [50 70 90 100 150];

TargetCount = 200;
dim1 = 100;
dim2 = 100;
cluster_count_avg_algo1 = [ 14.6000   11.8000    8.4000    2.2000    2.0000 ];
algo1_CTR = (1/TargetCount).*cluster_count_avg_algo1;

uncovered_avg_algo1 = [ 14.6000   16.4000   19.0000   17.0000   12.4000];
algo1_coverage_ratio = (TargetCount - uncovered_avg_algo1)./TargetCount;

algo1_exec_time = [91.5874   62.9603   30.8308    4.0603    3.3599];

uncoveredNum_algo2_avg = [ 12.0000    9.6000    8.6000    5.4000    0.4000 ];
algo2_coverage_ratio = (TargetCount - uncoveredNum_algo2_avg)./TargetCount;

algo2_exec_time = [ 7.5315    2.7534    1.6893    1.5703    0.8396 ];

camNum_avg = [ 9.2000    4.8000    3.4000    3.2000    2.0000 ];
algo2_CTR = (1/TargetCount).*camNum_avg;


figure;
plot(Rmax_vec, algo1_CTR, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(Rmax_vec, algo2_CTR, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(Rmax_vec, algo3_CTR, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(Rmax_vec, algo4_CTR, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy', '2-Smp','FontName','Times New Roman','FontSize', 24);
xlabel('Rmax(m)', 'FontSize', 24, 'FontName','Times New Roman');
ylabel('CTR', 'FontSize', 24,'FontName','Times New Roman');

figure;
plot(Rmax_vec, algo1_coverage_ratio, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(Rmax_vec, algo2_coverage_ratio, '-c^', 'LineWidth',2','MarkerSize',8); hold on;
%plot(Rmax_vec, algo3_coverage_ratio, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(Rmax_vec, algo4_coverage_ratio, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy', '2-Smp','FontName','Times New Roman','FontSize', 24);
xlabel('Rmax(m)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('coverage ratio', 'FontSize', 24,'FontName','Times New Roman');

figure;
plot(Rmax_vec, algo1_exec_time, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(Rmax_vec, algo2_exec_time, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(Rmax_vec, algo3_exec_time, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(Rmax_vec, algo4_exec_time, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy','2-Smp','FontName','Times New Roman','FontSize', 24);
xlabel('Rmax(m)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('execution time(sec)', 'FontSize', 24,'FontName','Times New Roman');
