%results for AOV = 90 and Rmax = 30
%10 scenarios, avged
close all;
target_num = [10 20 30 40 50 60 70 80 90 100 200 400 600 800 1000];

algo1_CTR = [ 3.9000/10    6.1000/20    6.8000/30    7.0000/40    8.2000/50    8.1000/60    9.0000/70    9.0000/80    9.2000/90    9.4000/100   13.7000/200   19.6000/400    27.1000/600   29.0000/800  32.6000/1000];%23.6000   23.7000   23.9000];
algo1_uncovered = [ 0.6000    0.6000    1.3000    1.9000    3.1000    3.4000    5.0000    5.0000    6.4000    7.7000   16.2000   41.0000   49.7000   70.5000   93.7000];%128.7000  235.9000  317.5000];
coverage_algo1 = ones(1,15) - algo1_uncovered./target_num;
algo1_exec_time = [0.6574    1.6871    2.7741    3.5350    5.5517    6.2501    8.2376    8.2538   10.9687   12.5114   41.4715  134.6643   319.7275  470.1134  716.4071];%268.1014  368.5526  472.2407];

algo2_camNum = [4.5000    4.7000    5.2000    5.5000    5.9000    5.9000    6.2000    6.2000    6.0000    6.3000    6.5000    6.9000    6.8000    7.0000    6.8000];
algo2_CTR = algo2_camNum./target_num;
algo2_uncovered = [ 0    0.6000    0.7000    1.5000    2.5000    3.1000    4.2000    4.2000    5.4000    3.9000   10.3000   19.3000   40.5000   47.3000   56.6000];
coverage_algo2 = ones(1,15) - algo2_uncovered./target_num;
algo2_exec_time = [ 0.0913    0.1702    0.2780    0.3879    0.5305    0.6384    0.7863    0.7860    0.9509    1.1313    2.3487    5.0819    7.4211   10.3397   12.3157];



Greedy_cam_count = [ 2.0000    2.0000    2.8000    3.2000    3.4000    3.4000    3.8000    3.8000    4.0000    4.2000    4.8000    5.0000    5.4000    5.6000    5.4000];
algo3_CTR = Greedy_cam_count./target_num;
algo3_exec_time = 1.0e+03 .*[ 0.0306    0.0594    0.0904    0.1215    0.1541    0.1850    0.2207    0.2208    0.2901    0.3192    0.6346    1.3291    1.9956    2.6783    3.3435];
greedy_uncovered = zeros(1,15);

dual_cam_count = [2.0000    2.0000    2.6000    3.2000    3.6000    3.8000    3.8000    3.8000    4.0000    3.8000    4.6000    5.0000    5.2000    5.0000    5.2000];
algo4_CTR = dual_cam_count./target_num;
algo4_exec_time =  1.0e+03 .*[ 0.0128    0.0264    0.0348    0.0526    0.0675    0.0889    0.0981    0.0980    0.1270    0.1378    0.2854    0.6222    0.9749    1.2431    1.6406];
dual_uncovered = zeros(1,15);

coverage_greedy = ones(1,15);
coverage_dual = ones(1,15);

figure;
plot(target_num, algo1_CTR, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo1_CTR_ratio2, '-rd'); hold on;
plot(target_num, algo2_CTR, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo2_CTR_ratio2, '-c+'); hold on;
plot(target_num, algo3_CTR, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, algo4_CTR, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy', '2-Smp','FontName','Times New Roman','FontSize', 24);
xlabel('#targets', 'FontSize', 24,'FontName','Times New Roman');
ylabel('CTR','FontSize', 24,'FontName','Times New Roman');

figure;
plot(target_num, coverage_algo1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, coverage_algo1_ratio2, '-rd'); hold on;
plot(target_num, coverage_algo2, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, coverage_algo2_ratio2, '-c+'); hold on;
plot(target_num, coverage_greedy, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, coverage_dual, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy', '2-Smp','FontName','Times New Roman');
xlabel('#targets','FontSize', 24,'FontName','Times New Roman');
ylabel('coverage ratio','FontSize', 24,'FontName','Times New Roman');

figure;
plot(target_num, algo1_exec_time, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, algo2_exec_time, '-c^', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, algo3_exec_time, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, algo4_exec_time, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('KCam', 'CF', 'Greedy', '2-Smp','FontName','Times New Roman');
xlabel('#targets', 'FontSize', 24,'FontName','Times New Roman');
ylabel('execution time(sec)', 'FontSize', 24,'FontName','Times New Roman');