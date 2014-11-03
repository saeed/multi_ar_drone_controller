% varying AOV at dim =50X50, Rmax = 25, TargetCount = 50
close all;
AOV = [ 45, 60, 92, 120, 150, 180];

%algo1
algo1_uncovered_ratio1= [ 3.7500    3.3500    3.3000    2.4000    3.1000    2.3000];
algo1_coverage_ratio1 = 1 - (1/50).*algo1_uncovered_ratio1;
algo1_CTR_ratio1 = (1/50).*[ 13.0500   11.1000    7.8500    5.6500    3.9500    3.7500];
algo1_exec_time_ratio1 = [ 20.8932   15.7369   10.5792    6.2330    3.7361    3.3223];

algo1_uncovered_ratio2 = [8.0500    8.0000    6.7000    7.5500    6.1500    6.1000];
algo1_coverage_ratio2 = 1 - (1/50).*algo1_uncovered_ratio2;
algo1_CTR_ratio2 = (1/50).*[ 10.3500    9.0500    6.5000    4.4000    3.4000    3.2500];
algo1_exec_time_ratio2 = [14.7153   12.2808    7.5335    4.1893    2.7668    2.3959];


%algo2
algo2_uncovered_ratio1 = [ 1.3260    0.8507    0.5656    0.5358    0.4440    0.3905];
algo2_coverage_ratio1 = 1 - (1/50).*algo2_uncovered_ratio1;
algo2_CTR_ratio1 = (1/50).*[  9.7000    7.0500    5.6000    5.4000    4.7000    4.3000];
algo2_exec_time_ratio1 = [  1.3021    0.8204    0.7253    0.8096    0.7818    0.524];


algo2_uncovered_ratio2 = [ 5.7000    5.6500    6.0000    6.0500    4.9000    4.6000];
algo2_coverage_ratio2 = 1 - (1/50).*algo2_uncovered_ratio2;
algo2_CTR_ratio2 = (1/50).*[  7.7000    5.9500    4.4500    3.9500    3.8000    3.5000];
algo2_exec_time_ratio2 = [ 0.9741    0.6490    0.4273    0.3633    0.3441    0.3078];

%fuzzy
fuzzy_uncovered_ratio1 = [  2.4000    2.3000    2.2000    2.6000    2.0000    1.5000];
fuzzy_coverage_ratio1 = 1 - (1/50).*fuzzy_uncovered_ratio1;
fuzzy_CTR_ratio1 = (1/50).*[ 9.0000    7.3000    6.2000    5.0000    4.6000    4.4000];
fuzzy_exec_time_ratio1 = [   0.4421    0.3151    0.2508    0.1806    0.1587    0.1487];

fuzzy_uncovered_ratio2= [ 6.9000    7.2000    5.9000    3.9000    4.7000    4.7000];
fuzzy_coverage_ratio2 = 1 - (1/50).*fuzzy_uncovered_ratio2;
fuzzy_CTR_ratio2 = (1/50).*[ 7.6000    6.3000    5.0000    4.5000    4.0000    3.6000];
fuzzy_exec_time_ratio2 = [    0.3292    0.2466    0.1758    0.1495    0.1251    0.1047];


%hybrid-kmeans
hybrid_uncovered_ratio1 = [  2.2000    2.6000    2.6000    1.8000    3.2000    2.6000];
hybrid_coverage_ratio1 = 1 - (1/50).*hybrid_uncovered_ratio1;
hybrid_CTR_ratio1 = (1/50).*[ 9.5000    7.1000    5.9000    5.0000    3.5000    3.1000];
hybrid_exec_time_ratio1 = [ 14.0164    8.9304    6.6246    5.3605    3.1065    2.4649];

hybrid_uncovered_ratio2 = [  6.3000    6.6000    7.1000    6.2000    5.4000    4.8000];
hybrid_coverage_ratio2 = 1 - (1/50).*hybrid_uncovered_ratio2;
hybrid_CTR_ratio2 = (1/50).*[ 7.6000    5.9000    4.6000    3.7000    3.2000    3.0000];
hybrid_exec_time_ratio2 = [ 10.1093    6.8338    4.5600    3.2764    2.6030    2.2909];


%hybrid-kdtree
hybridt_uncovered_ratio1 = [ 3.2000    2.3000    3.5000    2.8000    2.8000    1.9000];
hybridt_coverage_ratio1 = 1 - (1/50).*hybridt_uncovered_ratio1;
hybridt_CTR_ratio1 = (1/50).*[  11.6000   10.9000    7.2000    4.8000    4.1000    3.7000];
hybridt_exec_time_ratio1 = [ 19.0472   16.5144    9.3098    5.1926    3.9027    3.2476];




hybridt_uncovered_ratio2 = [   8.5000    8.1000    7.9000    6.3000    6.5000    5.5000];
hybridt_coverage_ratio2 = 1 - (1/50).*hybridt_uncovered_ratio2;
hybridt_CTR_ratio2 = (1/50).*[ 9.3000    7.9000    5.9000    4.3000    3.4000    3.4000];
hybridt_exec_time_ratio2 = [ 13.3977   10.2870    6.5795    4.3186    2.7213    2.7650];



%algo3(greedy)
algo3_coverage = [1, 1, 1, 1, 1, 1];
algo3_CTR = (1/50).*[7.4000    6.0000    5.0000    4.2000    3.6000    3.0000];
algo3_exec_time = [250.1801  224.4571  200.8411  178.8845  165.9310  154.8053];

%algo4(dual-sampling)
algo4_coverage = [1, 1, 1, 1, 1, 1];
algo4_CTR = (1/50).*[7.2000    5.8000    5.0000    4.2000    3.6000    3.2000];

algo4_exec_time = [  141.1602  117.5086   93.6067   78.6103   67.9813   62.7986];


figure;
%plot(AOV, algo1_CTR_ratio1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, algo1_CTR_ratio2, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, algo2_CTR_ratio1, '-cs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, algo2_CTR_ratio2, '-cd', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, hybrid_CTR_ratio1, '-gs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, hybrid_CTR_ratio2, '-gd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, hybridt_CTR_ratio1, '-ms', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, hybridt_CTR_ratio2, '-md', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, fuzzy_CTR_ratio1, '-bs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, fuzzy_CTR_ratio2, '-bd', 'LineWidth',2,'MarkerSize',8); hold on;

plot(AOV, algo3_CTR, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, algo4_CTR, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('SSKCAM@CTC=0.9', 'SSKCAM@CTC=0.8', 'Fuzzy@CTC=0.9', 'Fuzzy@CTC=0.8','Greedy', '2-Smp','FontName','Times New Roman');
xlabel('angle(deg)', 'FontSize', 24, 'FontName','Times New Roman');
ylabel('CTR', 'FontSize', 24,'FontName','Times New Roman');



figure;
%plot(AOV, algo1_coverage_ratio1 , '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, algo1_coverage_ratio2, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, algo2_coverage_ratio1 , '-cs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, algo2_coverage_ratio2, '-cd', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, hybrid_coverage_ratio1, '-gs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, hybrid_coverage_ratio2, '-gd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, hybridt_coverage_ratio1, '-ms', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, hybridt_coverage_ratio2, '-md', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, fuzzy_coverage_ratio1, '-bs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, fuzzy_coverage_ratio2, '-bd', 'LineWidth',2,'MarkerSize',8); hold on;

plot(AOV, algo3_coverage, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, algo4_coverage, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('SSKCAM@CTC=0.9', 'SSKCAM@CTC=0.8','Fuzzy@CTC=0.9', 'Fuzzy@CTC=0.8','Greedy', '2-Smp','FontName','Times New Roman');
xlabel('angle(deg)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('coverage ratio', 'FontSize', 24,'FontName','Times New Roman');


figure;
%plot(AOV, algo1_exec_time_ratio1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, algo1_exec_time_ratio2, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, algo2_exec_time_ratio1, '-cs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, algo2_exec_time_ratio2, '-cd', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, hybrid_exec_time_ratio1, '-gs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, hybrid_exec_time_ratio2, '-gd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, hybridt_exec_time_ratio1, '-ms', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(AOV, hybrid_exec_time_ratio2, '-md', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, fuzzy_exec_time_ratio1, '-bs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, fuzzy_exec_time_ratio2, '-bd', 'LineWidth',2,'MarkerSize',8); hold on;

plot(AOV, algo3_exec_time, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(AOV, algo4_exec_time, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('SSKCAM@CTC=0.9', 'SSKCAM@CTC=0.8', 'Fuzzy@CTC=0.9', 'Fuzzy@CTC=0.8','Greedy', '2-Smp','FontName','Times New Roman');
xlabel('angle(deg)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('execution time(sec)', 'FontSize', 24,'FontName','Times New Roman');