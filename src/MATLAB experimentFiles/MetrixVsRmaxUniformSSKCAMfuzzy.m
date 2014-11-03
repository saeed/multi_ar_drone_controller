% uniform distribution
% termination coverage ratio varied 0.1 and 0.2
% vary Rmax

%termination ratio = 0.1

close all;
R = [20 25 30 35 40 45 50];

%termination ratio = 0.1
camNum_algo1_ratio1 = [ 12.2000    8.8000    8.0000    7.4000    6.4000    4.5000    2.4000];
algo1_CTR_ratio1 = camNum_algo1_ratio1./50; 
camNum_algo2_ratio1 = [ 10.7000    7.6000    5.9000    5.1000    3.5000    3.2000    2.7000];
algo2_CTR_ratio1= camNum_algo2_ratio1./50;

%termination ratio = 0.2
camNum_algo1_ratio2 = [  10.1000    7.6000    6.3000    5.8000    4.4000    2.8000    1.6000];
algo1_CTR_ratio2 = camNum_algo1_ratio2./50; 
camNum_algo2_ratio2 = [  9.0000    6.0000    4.7000    3.6000    2.9000    2.7000    1.7000];
algo2_CTR_ratio2= camNum_algo2_ratio2./50;


%fuzzy, ratio = 0.1
camNum_fuzzy_ratio1 = [ 9.2000    7.6000    6.2000    4.8000    4.4000    3.7000    3.0000];
fuzzy_CTR_ratio1 = camNum_fuzzy_ratio1./50; 
fuzzy_exec_time_ratio1 = [0.4273    0.3161    0.2370    0.1620    0.1416    0.1058    0.0760];
uncovered_fuzzy_ratio1 = [ 3.0000    1.8000    2.2000    2.3000    1.2000    1.5000    1.3000];
coverage_fuzzy_ratio1 = 1 - (1/50).*uncovered_fuzzy_ratio1;


%fuzzy, ratio = 0.2
camNum_fuzzy_ratio2 = [8.4000    6.5000    5.0000    4.1000    3.5000    3.0000    2.5000];
fuzzy_CTR_ratio2 = camNum_fuzzy_ratio2./50; 
fuzzy_exec_time_ratio2 = [ 0.3750    0.2548    0.1739    0.1275    0.0976    0.0759    0.0561];
uncovered_fuzzy_ratio2 = [ 5.7000    6.5000    5.9000    5.0000    5.6000    4.7000    4.0000];
coverage_fuzzy_ratio2 = 1 - (1/50).*uncovered_fuzzy_ratio2;



%hybrid kdtree, ratio = 0.1
camNum_hybridt_ratio1 = [ 11.4000    8.5000    7.2000    6.6000    5.6000    4.7000    2.7000];
hybridt_CTR_ratio1 = camNum_hybridt_ratio1./50; 
hybridt_exec_time_ratio1 = [17.7118   11.4465    9.2268    7.6102    5.6951    4.2868    1.6938];
uncovered_hybridt_ratio1 = [ 3.5000    2.6000    3.5000    3.1000    2.8000    3.1000    2.9000];
coverage_hybridt_ratio1 = 1 - (1/50).*uncovered_hybridt_ratio1;

%hybrid kdtree, ratio = 0.2
camNum_hybridt_ratio2 = [9.5000    6.7000    5.9000    5.0000    4.3000    2.8000    1.6000];
hybridt_CTR_ratio2 = camNum_hybridt_ratio2./50; 
hybridt_exec_time_ratio2 = [ 13.7018    8.0972    6.4882    4.9406    3.8255    1.8640    0.5732];
uncovered_hybridt_ratio2 = [ 8.2000    7.6000    7.9000    7.8000    7.2000    8.3000    7.1000];
coverage_hybridt_ratio2 = 1 - (1/50).*uncovered_hybridt_ratio2;

%hybrid, kmeans, ratio = 0.1
camNum_hybrid_ratio1 = [9.8000    7.5000    5.9000    4.5000    3.5000    3.1000    2.4000];
hybrid_CTR_ratio1 = camNum_hybrid_ratio1./50; 
hybrid_exec_time_ratio1 = [ 14.9259    9.7581    6.7101    4.3475    2.8368    2.2838    1.4557];
uncovered_hybrid_ratio1 = [ 2.7000    2.5000    2.6000    2.2000    2.6000    1.6000    2.1000];
coverage_hybrid_ratio1 = 1 - (1/50).*uncovered_hybrid_ratio1;


%hybrid kmeans, ratio = 0.2
camNum_hybrid_ratio2 = [ 8.6000    5.9000    4.6000    3.6000    2.9000    2.5000    1.6000];
hybrid_CTR_ratio2 = camNum_hybrid_ratio2./50; 
hybrid_exec_time_ratio2 = [ 12.3112    6.8259    4.5186    2.9943    2.0729    1.5789    0.6264];
uncovered_hybrid_ratio2 = [ 7.0000    7.1000    7.1000    5.8000    5.3000    4.9000    6.2000];
coverage_hybrid_ratio2 = 1 - (1/50).*uncovered_hybrid_ratio2;




camNum_greedy = [7.6000, 6.0000, 5.0000, 4.4000, 3.8000, 3.2000, 3.0000];
algo3_CTR = camNum_greedy./50;
camNum_dual = [ 7.6000, 6.4000, 5.0000, 4.2000, 3.6000, 3.2000, 3.0000];
algo4_CTR = camNum_dual./50

algo1_exec_time_ratio1 = [ 20.1611   12.8576   10.9665    9.1365    7.1108    4.0467    1.3461];
algo2_exec_time_ratio1 = [  1.6271    0.9278    0.6371    0.5274    0.3043    0.2714    0.2165];

algo1_exec_time_ratio2 = [  15.6247   10.1318    7.6679    6.4247    4.0300    1.8382    0.5553];
algo2_exec_time_ratio2 = [ 1.2242    0.6594    0.4561    0.3147    0.2363    0.2159    0.1227 ];



algo3_exec_time = [ 221.9980,  186.5737,  170.1636,  151.5693,  138.9349,  127.1570,  121.1231 ];
algo4_exec_time = [ 72.7286,   77.4390,   79.3779,   76.3830,   75.3069,  70.1233,   66.5334];



uncovered_algo1_ratio1 = [3.6000    2.6000    3.9000    3.0000    3.6000    3.4000    3.0000];
coverage_algo1_ratio1 = 1 - (1/50).*uncovered_algo1_ratio1;
uncovered_algo2_ratio1 = [2.8000    2.6000    2.6000    1.7000    2.6000    1.5000    1.7000];
coverage_algo2_ratio1 = 1 - (1/50).*uncovered_algo2_ratio1;


uncovered_algo1_ratio2 = [   7.7000    7.6000    7.6000    8.4000    7.9000    7.9000    5.9000];
coverage_algo1_ratio2 = 1 - (1/50).*uncovered_algo1_ratio2;
uncovered_algo2_ratio2 = [ 6.4000    6.6000    6.2000    5.8000    5.3000    3.9000    5.8000];
coverage_algo2_ratio2 = 1 - (1/50).*uncovered_algo2_ratio2;
coverage_greedy = [1, 1, 1, 1, 1, 1, 1];
coverage_dual = [1, 1, 1, 1, 1, 1, 1];

figure;
%plot(R, algo1_CTR_ratio1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo1_CTR_ratio2, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo1_CTR_ratio2, '-rd'); hold on;
%plot(R, algo2_CTR_ratio1, '-cs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo2_CTR_ratio2, '-cd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo2_CTR_ratio2, '-c+'); hold on;
plot(R, hybrid_CTR_ratio1, '-gs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, hybrid_CTR_ratio2, '-gd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, hybridt_CTR_ratio1, '-ms', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, hybridt_CTR_ratio2, '-md', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, fuzzy_CTR_ratio1, '-bs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, fuzzy_CTR_ratio2, '-bd', 'LineWidth',2,'MarkerSize',8); hold on;

plot(R, algo3_CTR, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo4_CTR, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('SSKCAM@CTC=0.9', 'SSKCAM@CTC=0.8', 'Fuzzy@CTC=0.9', 'Fuzzy@CTC=0.8','Greedy', '2-Smp','FontName','Times New Roman');

xlabel('Rmax(m)','FontSize', 24,'FontName','Times New Roman');
ylabel('CTR', 'FontSize', 24,'FontName','Times New Roman');

figure;
%plot(R, coverage_algo1_ratio1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, coverage_algo1_ratio2, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo1_CTR_ratio2, '-rd'); hold on;
%(R, coverage_algo2_ratio1, '-cs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, coverage_algo1_ratio2, '-cd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo2_CTR_ratio2, '-c+'); hold on;
plot(R, coverage_hybrid_ratio1, '-gs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, coverage_hybrid_ratio2, '-gd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, coverage_hybridt_ratio1, '-ms', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, coverage_hybridt_ratio2, '-md', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, coverage_fuzzy_ratio1, '-bs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, coverage_fuzzy_ratio2, '-bd', 'LineWidth',2,'MarkerSize',8); hold on;

plot(R, coverage_greedy, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, coverage_dual, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend('SSKCAM@CTC=0.9', 'SSKCAM@CTC=0.8', 'Fuzzy@CTC=0.9', 'Fuzzy@CTC=0.8','Greedy', '2-Smp','FontName','Times New Roman');



xlabel('Rmax(m)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('coverage fraction', 'FontSize', 24,'FontName','Times New Roman');


figure;
%plot(R, algo1_exec_time_ratio1, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo1_exec_time_ratio2, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo2_exec_time_ratio1, '-cs', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, algo2_exec_time_ratio2, '-cd', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, hybrid_exec_time_ratio1, '-gs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, hybrid_exec_time_ratio2, '-gd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, hybridt_exec_time_ratio1, '-ms', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(R, hybrid_exec_time_ratio2, '-md', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, fuzzy_exec_time_ratio1, '-bs', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, fuzzy_exec_time_ratio2, '-bd', 'LineWidth',2,'MarkerSize',8); hold on;

plot(R, algo3_exec_time, '-ko', 'LineWidth',2,'MarkerSize',8); hold on;
plot(R, algo4_exec_time, '--kd', 'LineWidth',2,'MarkerSize',8); 
legend( 'SSKCAM@CTC=0.9', 'SSKCAM@CTC=0.8', 'Fuzzy@CTC=0.9', 'Fuzzy@CTC=0.8','Greedy', '2-Smp','FontName','Times New Roman');
xlabel('Rmax(m)', 'FontSize', 24,'FontName','Times New Roman');
ylabel('execution time(sec)', 'FontSize', 24,'FontName','Times New Roman');
