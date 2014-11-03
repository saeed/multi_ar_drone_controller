%results for AOV = 90 and Rmax = 30
%10 scenarios, avged
close all;
target_num = [10, 20, 40, 60, 80, 100];
N = size(target_num,2);

algo1_CTR_r1 = [2.9000    4.6000    5.7000    6.4000    7.4000    7.7000]./target_num;
algo1_uncovered_r1 = [ 1.7000    2.8000    6.5000   10.5000   12.0000   16.8000];
coverage_algo1_r1 = ones(1,N) - algo1_uncovered_r1./target_num;
algo1_exec_time_r1 = [ 1.1014    2.8713    5.7633    9.0413   14.0937   18.1913];

algo1_CTR_r2 = [ 3.4000    5.6000    7.1000    9.5000    9.1000    9.2000]./target_num;
algo1_uncovered_r2 = [ 1.5000    1.2000    2.4000    3.9000    5.6000    5.7000];
coverage_algo1_r2 = ones(1,N) - algo1_uncovered_r2./target_num;
algo1_exec_time_r2 = [ 1.5297    3.6889    7.9275   16.8034   19.5001   23.2867];



algo2_camNum_r1 = [ 3.6000    4.2000    4.8000    4.9000    4.6000    5.0000];
algo2_CTR_r1 = algo2_camNum_r1./target_num;
algo2_uncovered_r1 = [  0.7000    1.9000    4.0000    6.0000   10.8000   13.6000];
coverage_algo2_r1 = ones(1,N) - algo2_uncovered_r1./target_num;
algo2_exec_time_r1 = [ 0.0815    0.1655    0.3534    0.5202    0.6172    0.8565];

algo2_camNum_r2 = [ 4.8000    5.6000    6.2000    6.2000    6.1000    6.5000];
algo2_CTR_r2 = algo2_camNum_r2./target_num;
algo2_uncovered_r2 = [ 0    0.7000    1.6000    3.5000    2.6000    4.0000];
coverage_algo2_r2 = ones(1,N) - algo2_uncovered_r2./target_num;
algo2_exec_time_r2 = [  0.1136    0.2505    0.5169    0.7501    0.9230    1.2379];


hybrid_CTR_r1 = [ 3.1000    3.8000    4.5000    4.9000    4.6000    5.0000]./target_num;
hybrid_uncovered_r1 = [  0.9000    1.8000    4.0000    6.0000   10.8000   13.6000];
coverage_hybrid_r1 = ones(1,N) - hybrid_uncovered_r1./target_num;
hybrid_exec_time_r1 = [  0.9243    1.9297    3.9360    6.0488    6.8883    9.3143];

hybrid_CTR_r2 = [  4.4000    4.4000    5.4000    5.6000    5.9000    6.4000]./target_num;
hybrid_uncovered_r2 = [  0    0.7000    2.0000    3.7000    3.7000    4.2000];
coverage_hybrid_r2 = ones(1,N) - hybrid_uncovered_r2./target_num;
hybrid_exec_time_r2 = [  1.5873    2.4091    5.1974    7.3843    9.9138   13.4023];


hybridt_CTR_r1 = [ 3.4000    4.7000    6.3000    6.2000    7.3000    7.7000]./target_num;
hybridt_uncovered_r1 = [0.9000    1.9000    5.6000    9.9000   13.9000   13.4000];
coverage_hybridt_r1 = ones(1,N) - hybridt_uncovered_r1./target_num;
hybridt_exec_time_r1 = [ 1.0424    2.5794    6.4005    8.2669   13.7769   17.2494];

hybridt_CTR_r2 = [  4.2000    5.5000    7.7000    7.8000    8.7000    8.9000]./target_num;
hybridt_uncovered_r2 = [ 0    0.7000    2.1000    3.7000    5.8000    6.2000];
coverage_hybridt_r2 = ones(1,N) - hybridt_uncovered_r2./target_num;
hybridt_exec_time_r2 = [1.3796    3.2124    8.4353   11.5247   17.5185   21.8199];



fuzzy_CTR_r2 = [  4.3000    4.9000    5.2000    5.3000    5.7000    5.9000]./target_num;
fuzzy_uncovered_r2 = [   0    1.0000    1.3000    3.1000    4.1000    5.4000];
coverage_fuzzy_r2 = ones(1,N) - fuzzy_uncovered_r2./target_num;
fuzzy_exec_time_r2 = [  0.0627    0.0976    0.1633    0.2146    0.2936    0.3588];

fuzzy_CTR_r1 = [ 3.3000    4.3000    4.4000    4.7000    4.5000    4.9000]./target_num;
fuzzy_uncovered_r1 = [ 0.8000    1.6000    3.9000    6.7000   11.5000   12.6000];
coverage_fuzzy_r1 = ones(1,N) - fuzzy_uncovered_r1./target_num;
fuzzy_exec_time_r1 = [0.0641    0.1069    0.1725    0.2517    0.2905    0.3766];






Greedy_cam_count = [ 2.6000    3.6000    4.6000    4.6000    5.6000    5.6000];
algo3_CTR = Greedy_cam_count./target_num;
algo3_exec_time = [29.2978   60.7402  125.0239  200  265.0059  333.2021];
greedy_uncovered = zeros(1,N);

dual_cam_count = [2.6000    3.4000    5.4000    5.4000    5.4000    5.6000];
algo4_CTR = dual_cam_count./target_num;
algo4_exec_time = [ 13.2108   28.7979   59.5010   95.0165  123.2729  155.3676];
dual_uncovered = zeros(1,N);

coverage_greedy = ones(1,N);
coverage_dual = ones(1,N);

figure;
%plot(target_num, algo1_CTR_r1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, algo1_CTR_r2, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo1_CTR_ratio2, '-rd'); hold on;
%plot(target_num, algo2_CTR_r1, '-cs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, algo2_CTR_r2, '-cd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo2_CTR_ratio2, '-c+'); hold on;
plot(target_num, hybrid_CTR_r1, '-gs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, hybrid_CTR_r2, '-gd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, hybridt_CTR_r1, '-ms', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, hybridt_CTR_r2, '-md', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, fuzzy_CTR_r1, '-bs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, fuzzy_CTR_r2, '-bd', 'LineWidth',2,'MarkerSize',8); hold on;

plot(target_num, algo3_CTR, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, algo4_CTR, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend( 'SSKCAM@CTC=0.8', 'SSKCAM@CTC=0.9', 'Fuzzy@CTC=0.8', 'Fuzzy@CTC=0.9','Greedy', '2-Smp','FontName','Times New Roman');
xlabel('#targets', 'FontSize', 24,'FontName','Times New Roman');
ylabel('CTR','FontSize', 24,'FontName','Times New Roman');

figure;
%plot(target_num, coverage_algo1_r1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, coverage_algo1_r2, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, coverage_algo1_ratio2, '-rd'); hold on;
%plot(target_num, coverage_algo2_r1, '-cs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, coverage_algo2_r2, '-cd', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, coverage_hybrid_r1, '-gs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, coverage_hybrid_r2, '-gd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, coverage_hybridt_r1, '-ms', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, coverage_hybridt_r1, '-md', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, coverage_fuzzy_r1, '-bs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, coverage_fuzzy_r2, '-bd', 'LineWidth',2,'MarkerSize',8); hold on;

%plot(R, coverage_algo2_ratio2, '-c+'); hold on;
plot(target_num, coverage_greedy, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, coverage_dual, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('SSKCam@CTC=0.8', 'SSKCam@CTC=0.9', 'Fuzzy@CTC=0.8', 'Fuzzy@CTC=0.9', 'Greedy', '2-Smp','FontName','Times New Roman');
xlabel('#targets','FontSize', 24,'FontName','Times New Roman');
ylabel('coverage ratio','FontSize', 24,'FontName','Times New Roman');

figure;
%plot(target_num, algo1_exec_time_r1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, algo1_exec_time_r2, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, algo2_exec_time_r1, '-cs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, algo2_exec_time_r2, '-cd', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, hybrid_exec_time_r1, '-gs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, hybrid_exec_time_r2, '-gd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, hybridt_exec_time_r1, '-md', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(target_num, hybridt_exec_time_r2, '-md', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, fuzzy_exec_time_r1, '-bs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, fuzzy_exec_time_r2, '-bd', 'LineWidth',2,'MarkerSize',8); hold on;

plot(target_num, algo3_exec_time, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(target_num, algo4_exec_time, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('SSKCAMmeans@CTC=0.8', 'SSKCAM@CTC=0.9', 'Fuzzy@CTC=0.8', 'Fuzzy@CTC=0.9', 'Greedy', '2-Smp','FontName','Times New Roman');
xlabel('#targets', 'FontSize', 24,'FontName','Times New Roman');
ylabel('execution time(sec)', 'FontSize', 24,'FontName','Times New Roman');