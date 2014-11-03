%Results
%This file contains the results of the simulations.
%Comparison between several methods in Coverage, CTR(Coverage to Target
%Number ration) and complexity
N = [10 20 30 40 50 60 70 80 90 100];

%scenario 1
Dim1 = 100; Dim2 = 100;
Rmax = 10;
Coverage1_kcam = [6/10,11/20,20/30,];
execTime_kcam = [194816, 907010, 2449446];
CTR1_kcam = [4/10,8/20,12/30 ];

Coverage1_greedy = [9/10,20/20,30/30];
execTime_greedy = [5.0644e+06,7.8315e+06, 9.7052e+06,];
CTR1_greedy = [5/10,8/20,10/30];

Coverage1_dualSampl = [8/10,20/20,30/30];
execTime_dualSampl = [6.0597e+05, 1.0642e+06];
CTR1_dualSampl = [5/10,7/20,10/30];


%scenario 2
Dim1 = 50; Dim2 = 50;
Rmax = 20;

Coverage1_kcam = [6/10,18/20,24/30];
execTime_kcam = [ 178352,  612784, 2705960 ];
CTR1_kcam = [4/10,7/20,14/30 ];

Coverage1_greedy = [10/10,20/20,30/30];
execTime_greedy = [ 4.1757e+06, 5.1375e+06, 6.1186e+06];
CTR1_greedy = [4/10,5/20,10/30, 6/30];

Coverage1_dualSampl = [10/10,20/20,30/30];
execTime_dualSampl = [0,2.5796e+06];
CTR1_dualSampl = [4/10,5/20,7/30];



%big scenarios:
%Dim1 = 50; Dim2 = 50;
%Rmax = 25;

N = [10 20 30 40 50 60 70 80 90 100 200 400 600 800 1000]

Coverage1_kcam = [8/10, 19/20, 27/30, 37/40, 48/50, 55/60, 65/70, 74/80, 83/90, 82/100, 182/200, 352/400, 542/600, 726/800, 904/1000];
execTime_kcam = [ 1, 2.94, 4.92, 14.52, 20.26, 21.75, 21.47, 25.80, 24.71, 36.27, 116.19, 464.76, 963.81,  1.7242e+03, 2000 ];
CTR1_kcam = [4/10, 7/20, 9/30, 17/40, 20/50, 18/60, 18/70, 16/80, 19/90, 18/100, 25/200, 41/400, 49/600, 62/800, 101/1000];

Coverage1_algo2 = [9/10, 20/20, 27/30, 38/40, 46/50, 58/60, 64/70, 76/80, 82/90, 82/100, 191/200, 360/400, 543/600, 755/800, 992/1000,];
execTime_algo2 = [ 0.1, 0.42, 0.54, 1.52, 2.26, 2.34, 3.40, 3.87, 3.94, 7.90, 10.67, 31.09, 46.69, 56.20, 93.22 ];
CTR1_algo2= [4/10, 8/20, 8/30, 16/40, 11/50, 13/60, 16/70, 15/80, 21/90, 15/100, 16/200, 20/400, 20/600, 19/800, 22/1000];

Coverage1_greedy = [10/10, 20/20, 30/30, 40/40, 50/50, 60/60, 70/70, 80/80, 90/90, 100/100, 200/200, 400/400, 600/600, 800/800, 1000/1000];
execTime_greedy = [ 33.39, 77.47, 115.40, 173.79,  226.35, 284.08, 334.60, 385.28, 450.95, 514.7971, 1.0616e+03, 2.2226e+03, 3.3761e+03, 4.5726e+03,5.6885e+03];
CTR1_greedy = [3/10,4/20, 5/30, 5/40, 6/50, 7/60, 6/70, 7/80, 7/90, 7/100, 9/200, 11/400, 11/600, 13/800, 12/1000];

Coverage1_dualSampl = [10/10, 20/20, 30/30, 40/40, 50/50, 60/60, 70/70, 80/80, 90/90, 100/100, 200/200, 400/400, 600/600, 800/800, 1000/1000];
execTime_dualSampl = [15.78, 33.29, 45.11, 67.76, 91.42, 131.89, 135.22, 179.51, 196.83, 265, 519.44,  856.8278, 1.5835e+03, 1.8844e+03, 2.6711e+03 ];
CTR1_dualSampl = [3/10,4/20, 5/30, 6/40, 5/50, 7/60, 8/70, 7/80, 8/90, 8/100, 9/200, 11/400, 12/600, 13/800, 14/1000];

close all;
% figure;
% plot(N,Coverage1_kcam,'-rs');
% xlabel('#targets');
% ylabel('#covered targets');
% %title('Algorithm 1 ');
% hold on;
% plot(N,Coverage1_algo2, '-cd'); hold on;
% plot(N,Coverage1_greedy,'-ko'); hold on;
% plot(N,Coverage1_dualSampl,'-k+');
% legend('KCam', 'CF', 'Greedy', '2-Sampling');
% 
% 
% figure;
% plot(N,execTime_kcam,'-rs');
% xlabel('#targets');
% ylabel('execution time');
% %title('Algorithm 1 ');
% hold on;
% plot(N,execTime_algo2, '-cd'); hold on;
% plot(N,execTime_greedy,'-ko'); hold on;
% plot(N,execTime_dualSampl,'-k+');
% legend('KCam', 'CF', 'Greedy', '2-Sampling');
% 
% 
% 
% figure;
% plot(N,CTR1_kcam,'-rs');
% xlabel('#targets');
% ylabel('Camera to Target Ratio');
% %title('Algorithm 1 ');
% hold on;
% plot(N,CTR1_algo2, '-cd'); hold on;
% plot(N,CTR1_greedy, '-ko'); hold on;
% plot(N,CTR1_dualSampl, '-k+');
% legend('KCam', 'CF', 'Greedy', '2-Sampling');



%seed = 2;
N = [10 20 30 40 50 60 70 80 90 100 200 400 600 800 1000]

Coverage1_kcam = [9/10, 20/20, 27/30, 36/40, 48/50, 56/60, 64/70, 73/80, 81/90, 91/100, 182/200, 371/400, 543/600, 752/800, 904/1000];
execTime_kcam = [  0.83, 2.73, 4.92, 9.06, 10.76, 16.27, 20.11, 23.47, 24.71, 34.02, 113.33, 315.53,  1.5887e+03,  1.3283e+03, 2000 ];
CTR1_kcam = [3/10, 8/20, 9/30, 12/40, 13/50, 15/60, 16/70, 17/80, 18/90, 19/100, 27/200, 33/400, 47/600, 54/800, 101/1000];

Coverage1_algo2 = [7/10, 20/20, 27/30, 36/40, 45/50, 57/60, 68/70, 72/80, 82/90, 89/100, 180/200, 380/400, 544/600, 732/800, 992/1000,];
execTime_algo2 = [ 0.1, 0.42, 0.54, 0.84, 1.09, 1.93, 4.94, 2.23, 4.11, 4.03, 14.59,  26.57, 30.30, 63.54, 93.22 ];
CTR1_algo2= [4/10, 5/20, 8/30, 9/40, 9/50, 12/60, 19/70, 11/80, 15/90, 11/100, 20/200, 17/400, 16/600, 21/800, 22/1000];

Coverage1_greedy = [10/10, 20/20, 30/30, 40/40, 50/50, 60/60, 70/70, 80/80, 90/90, 100/100, 200/200, 400/400, 600/600, 800/800, 1000/1000];
execTime_greedy = [ 29.01, 65.44, 115.40, 137.04,  183.40, 247.68, 304.00, 357.68, 404.61, 445.00, 973.19,  2.1009e+03,  3.2079e+03, 4.2820e+03,5.6885e+03];
CTR1_greedy = [2/10,4/20, 4/30, 5/40, 6/50, 6/60, 6/70, 7/80, 7/90, 7/100, 9/200, 12/400, 11/600, 11/800, 12/1000];

Coverage1_dualSampl = [10/10, 20/20, 30/30, 40/40, 50/50, 60/60, 70/70, 80/80, 90/90, 100/100, 200/200, 400/400, 600/600, 800/800, 1000/1000];
execTime_dualSampl = [12.39, 31.77, 53.24, 67.76, 98.96, 110.00, 169.29, 199.36, 170.43, 265, 511.92,   1.1754e+03, 1.5887e+03, 2.2221e+03, 2.6711e+03 ];
CTR1_dualSampl = [2/10,5/20, 5/30, 5/40, 7/50, 6/60, 7/70, 8/80, 7/90, 7/100, 11/200, 11/400, 11/600, 11/800, 14/1000];


% Fill the gap for repeated experiments:

coverage_kcam_avg = Coverage1_kcam;
execTime_kcam_avg = execTime_kcam;
CTR2_kcam_avg = CTR1_kcam;

Coverage2_algo2_avg = Coverage1_algo2;
execTime2_algo2_avg = execTime_algo2;
CTR2_algo2_avg = CTR1_algo2;

execTime2_greedy_avg = execTime_greedy;
CTR2_greedy_avg = CTR1_greedy;

Coverage2_dualSampl_avg = Coverage1_dualSampl;
execTime2_dualSampl_avg = execTime_dualSampl;
CTR2_dualSampl_avg = CTR1_dualSampl;


n = 10;
%seed changes 
Coverage_kcam2 = [6/10, 6/10, 7/10, 7/10, 6/10, 8/10, 8/10, 6/10, 7/10, 7/10];
coverage_kcam_avg(1) = mean(Coverage_kcam2)
execTime_kcam2 = [0.93, 0.90, 1.00, 1.10, 1.01, 0.93, 0.97, 1.09, 0.98, 0.98 ] ;
execTime_kcam_avg(1) = mean(execTime_kcam2)
CTR2_kcam = [4/10,3/10,4/10, 4/10, 4/10, 4/10, 4/10, 3/10, 4/10, 4/10];
CTR2_kcam_avg(1) = mean(CTR2_kcam);


Coverage2_algo2 = [8/10,6/10,9/10,6/10, 8/10, 7/10, 8/10, 9/10, 10/10, 7/10 ];
Coverage2_algo2_avg(1) = mean(Coverage2_algo2);
execTime2_algo2 = [0.14, 0.12, 0.16, 0.15, 0.26, 0.26, 0.11, 0.14, 0.11, 0.11] ;
execTime2_algo2_avg(1) = mean(execTime2_algo2);
CTR2_algo2 = [4/10,4/10,4/10, 4/10, 4/10, 3/10, 3/10, 4/10, 4/10, 3/10];
CTR2_algo2_avg(1) = mean(CTR2_algo2);

Coverage2_greedy = [10/10,10/10,10/10,10/10,10/10, 10/10, 10/10];
execTime2_greedy = [34.22, 30.01, 28.16, 33.46, 32.34, 31.15, 33.46, 31.33, 32.45, 31.11] ;
execTime2_greedy_avg(1) = mean(execTime2_greedy);
CTR2_greedy = [3/10, 3/10, 2/10, 3/10, 3/10, 3/10, 3/10, 3/10];
CTR2_greedy_avg(1) = mean(CTR2_greedy);
Coverage2_dualSampl = [10/10, 10/10,10/10, 10/10, 10/10, 10/10, 10/10];
Coverage2_dualSampl_avg(1) = mean(Coverage2_dualSampl);
execTime2_dualSampl = [10.46, 12.02, 11.97, 10.38, 11.03, 10.74, 13.00, 10.28, 9.16, 11.83];
execTime2_dualSampl_avg(1) = mean(execTime2_dualSampl);
CTR2_dualSampl = [3/10, 3/10, 3/10, 3/10, 3/10, 3/10, 3/10];
CTR2_dualSampl_avg(1) = mean(CTR2_dualSampl);


n = 20;
Coverage_kcam2 = [18/20, 20/20, 19/20, 16/20, 15/20, 17/20, 14/20, 20/20, 18/20, 18/20];
coverage_kcam_avg(2) = mean(Coverage_kcam2)
execTime_kcam2 = [3.85, 2.80, 3.35, 3.53, 3.80, 3.57, 3.97, 2.52, 3.57, 3.94 ] ;
execTime_kcam_avg(2) = mean(execTime_kcam2)
CTR2_kcam = [9/20,8/20,9/20, 8/20, 8/20, 6/20, 7/20, 7/20, 9/20, 9/20];
CTR2_kcam_avg(2) = mean(CTR2_kcam);


Coverage2_algo2 = [18/20,15/20, 19/20, 18/20, 19/20, 18/20, 18/20, 18/20, 18/20, 18/20 ];
Coverage2_algo2_avg(2) = mean(Coverage2_algo2);
execTime2_algo2 = [0.33, 0.45, 0.32, 0.40, 0.26, 0.26, 0.32, 0.34, 0.46, 0.28, 0.33] ;
execTime2_algo2_avg(2) = mean(execTime2_algo2);
CTR2_algo2 = [7/20,8/20,7/20, 8/20, 6/20, 7/20, 7/20, 9/20, 6/20, 7/20];
CTR2_algo2_avg(2) = mean(CTR2_algo2);

Coverage2_greedy = [20/20,20/20,20/20,20/20,20/20, 20/20, 20/20 20/20];
execTime2_greedy = [75.07, 71.62, 66.37, 67.29, 69.38, 66.31, 67.96, 63.08, 61.15, 63.50] ;
execTime2_greedy_avg(2) = mean(execTime2_greedy);
CTR2_greedy = [5/20, 5/20, 4/20, 4/20, 4/20, 4/20, 4/20, 4/20, 3/20, 3/20];
CTR2_greedy_avg(2) = mean(CTR2_greedy);


Coverage2_dualSampl = [20/20, 20/20,20/20, 20/20, 20/20, 20/20, 20/20, 20/20, 20/20];
Coverage2_dualSampl_avg(2) = mean(Coverage2_dualSampl);
execTime2_dualSampl = [23.52, 28.94, 24.70, 16.78, 20.00, 30.69, 20.17, 18.21, 19.81, 30.18];
execTime2_dualSampl_avg(2) = mean(execTime2_dualSampl);
CTR2_dualSampl = [4/20, 5/20, 4/20, 4/20, 4/20, 5/20, 4/20, 4/20, 3/20, 4/20];
CTR2_dualSampl_avg(2) = mean(CTR2_dualSampl);


n = 30;
Coverage_kcam2 = [29/30, 27/30, 28/30, 27/30, 27/30];
coverage_kcam_avg(3) = mean(Coverage_kcam2)
execTime_kcam2 = [5.8, 6.6, 5.4 ] ;
execTime_kcam_avg(3) = mean(execTime_kcam2)
CTR2_kcam = [10/30,11/30,10/30, 9/30, 8/30];
CTR2_kcam_avg(3) = mean(CTR2_kcam);


Coverage2_algo2 = [27/30,29/30, 28/30, 27/30, 27/30 ];
Coverage2_algo2_avg(3) = mean(Coverage2_algo2);
execTime2_algo2 = [0.86, 0.6, 0.7] ;
execTime2_algo2_avg(3) = mean(execTime2_algo2);
CTR2_algo2 = [10/30,8/30,9/30, 9/30, 8/30, 8/30];
CTR2_algo2_avg(3) = mean(CTR2_algo2);

Coverage2_greedy = [20/20,20/20,20/20,20/20,20/20, 20/20, 20/20 20/20];
execTime2_greedy = [120, 113, 100] ;
execTime2_greedy_avg(3) = mean(execTime2_greedy);
CTR2_greedy = [4/30, 5/30, 4/30, 5/30, 4/30];
CTR2_greedy_avg(3) = mean(CTR2_greedy);


Coverage2_dualSampl = [20/20, 20/20,20/20, 20/20, 20/20, 20/20, 20/20, 20/20, 20/20];
Coverage2_dualSampl_avg(3) = mean(Coverage2_dualSampl);
execTime2_dualSampl = [44, 35, 24.70];
execTime2_dualSampl_avg(3) = mean(execTime2_dualSampl);
CTR2_dualSampl = [4/30, 5/30, 4/30, 5/30, 5/30];
CTR2_dualSampl_avg(3) = mean(CTR2_dualSampl);



n = 40;
Coverage_kcam2 = [36/40, 40/40, 37/40, 37/40, 37/40, 37/40, 36/40, 36/40, 37/40];
coverage_kcam_avg(4) = mean(Coverage_kcam2)
execTime_kcam2 = [11.03, 10.47, 10.14, 10.2, 9.9, 10.37, 13.31, 9.06, 14.52, 3.94,  ] ;
execTime_kcam_avg(4) = mean(execTime_kcam2)
CTR2_kcam = [14/40,14/40, 10/40, 14/40, 13/40, 14/40, 17/40, 12/40, 17/40];
CTR2_kcam_avg(4) = mean(CTR2_kcam);


Coverage2_algo2 = [38/40,35/40, 38/40, 36/40, 36/40, 37/40, 37/40, 36/40, 38/40];
Coverage2_algo2_avg(4) = mean(Coverage2_algo2);
execTime2_algo2 = [1.36, 1.16, 1.00, 0.99, 1.17, 1.37, 0.72, 0.84, 1.52, 0.28, 0.33] ;
execTime2_algo2_avg(4) = mean(execTime2_algo2);
CTR2_algo2 = [12/40,6/40,11/40, 10/40, 11/40, 12/40, 8/40, 9/40];
CTR2_algo2_avg(4) = mean(CTR2_algo2);

Coverage2_greedy = [40/40,40/40,40/40,40/40,40/40, 40/40, 40/40 40/40];
execTime2_greedy = [171.71, 143.65, 160.54, 141.94, 179.01, 163.91, 160.55, 137.04, 173.79] ;
execTime2_greedy_avg(4) = mean(execTime2_greedy);
CTR2_greedy = [5/40, 6/40, 5/40, 5/40, 7/40, 5/40, 5/40, 5/40, 5/40, 3/20];
CTR2_greedy_avg(4) = mean(CTR2_greedy);


Coverage2_dualSampl = [40/40,40/40,40/40, 40/40, 40/40, 40/40, 40/40, 40/40, 40/40];
Coverage2_dualSampl_avg(4) = mean(Coverage2_dualSampl);
execTime2_dualSampl = [71.85, 50.8, 66.03, 72.18, 55.6, 61.18, 71.64, 67.76, 67];
execTime2_dualSampl_avg(4) = mean(execTime2_dualSampl);
CTR2_dualSampl = [6/40, 6/40, 6/40, 6/40, 6/40, 7/40, 6/40, 5/40, 5/40];
CTR2_dualSampl_avg(4) = mean(CTR2_dualSampl);


n = 50;
Coverage_kcam2 = [47/50, 46/50, 46/50, 48/50, 48/50];
coverage_kcam_avg(5) = mean(Coverage_kcam2)
%execTime_kcam2 = [11.03, 10.47, 10.14, 10.2, 9.9, 10.37, 13.31, 9.06, 14.52, 3.94,  ] ;
%execTime_kcam_avg(5) = mean(execTime_kcam2)
CTR2_kcam = [14/50,16/50, 13/50, 20/50, 13/50 ];
CTR2_kcam_avg(5) = mean(CTR2_kcam);


Coverage2_algo2 = [49/50,47/50, 44/50, 46/50, 45/50 ];
Coverage2_algo2_avg(5) = mean(Coverage2_algo2);
execTime2_algo2 = [1.36, 1.16, 1.00, 0.99, 1.17, 1.37, 0.72, 0.84, 1.52, 0.28, 0.33] ;
%execTime2_algo2_avg(5) = mean(execTime2_algo2);
CTR2_algo2 = [13/50,11/50,12/50, 11/50, 9/50];
CTR2_algo2_avg(5) = mean(CTR2_algo2);

% Coverage2_greedy = [40/40,40/40,40/40,40/40,40/40, 40/40, 40/40 40/40];
% execTime2_greedy = [171.71, 143.65, 160.54, 141.94, 179.01, 163.91, 160.55, 137.04, 173.79] ;
% execTime2_greedy_avg(5) = mean(execTime2_greedy);
% CTR2_greedy = [5/40, 6/40, 5/40, 5/40, 7/40, 5/40, 5/40, 5/40, 5/40, 3/20];
% CTR2_greedy_avg(5) = mean(CTR2_greedy);
% 
% 
% Coverage2_dualSampl = [40/40,40/40,40/40, 40/40, 40/40, 40/40, 40/40, 40/40, 40/40];
% Coverage2_dualSampl_avg(5) = mean(Coverage2_dualSampl);
% execTime2_dualSampl = [71.85, 50.8, 66.03, 72.18, 55.6, 61.18, 71.64, 67.76, 67];
% execTime2_dualSampl_avg(5) = mean(execTime2_dualSampl);
% CTR2_dualSampl = [6/40, 6/40, 6/40, 6/40, 6/40, 7/40, 6/40, 5/40, 5/40];
% CTR2_dualSampl_avg(5) = mean(CTR2_dualSampl);




n = 60;
Coverage_kcam2 = [56/60, 56/60, 54/60, 55/60, 57/60, 55/60, 56/60 ];
coverage_kcam_avg(6) = mean(Coverage_kcam2)
execTime_kcam2 = [ 16.28, 22.15, 15.17, 11.94, 9.9  ] ;
execTime_kcam_avg(6) = mean(execTime_kcam2)
CTR2_kcam = [15/60,19/60, 14/60, 16/60, 12/60, 18/60, 15/60];
CTR2_kcam_avg(6) = mean(CTR2_kcam);


Coverage2_algo2 = [55/60,54/60, 56/60, 56/60, 56/60, 58/60, 56/60];
Coverage2_algo2_avg(6) = mean(Coverage2_algo2);
execTime2_algo2 = [1.50, 2.26,  2.07, 2.9, 1.17, 1.37, 0.72, 0.84, 1.52, 0.28, 0.33] ;
execTime2_algo2_avg(6) = mean(execTime2_algo2);
CTR2_algo2 = [7/60,10/60,12/60, 15/60, 15/60, 13/60, 15/60 ];
CTR2_algo2_avg(6) = mean(CTR2_algo2);

Coverage2_greedy = [60/60,60/60,60/60,40/40,40/40, 40/40, 40/40 40/40];
execTime2_greedy = [ 229.27, 287.130, 218.3, 266.48, 179.01] ;
execTime2_greedy_avg(6) = mean(execTime2_greedy);
CTR2_greedy = [6/60, 7/60, 7/60, 5/40, 7/60, 6/60, 7/60, 6/60];
CTR2_greedy_avg(6) = mean(CTR2_greedy);


Coverage2_dualSampl = [60/60,60/60,60/60, 60/60, 60/60, 40/40, 40/40, 40/40, 40/40];
Coverage2_dualSampl_avg(6) = mean(Coverage2_dualSampl);
execTime2_dualSampl = [85.9, 117.94, 74.52, 72.18, 97.4];
execTime2_dualSampl_avg(6) = mean(execTime2_dualSampl);
CTR2_dualSampl = [5/60, 6/60, 7/60, 6/60, 7/60, 7/60, 6/60];
CTR2_dualSampl_avg(6) = mean(CTR2_dualSampl);


n = 70;
Coverage_kcam2 = [64/70, 65/70, 66/70, 65/70, 64/70 ];
coverage_kcam_avg(7) = mean(Coverage_kcam2)
%execTime_kcam2 = [ 16.28, 22.15, 15.17, 11.94, 9.9  ] ;
%execTime_kcam_avg(7) = mean(execTime_kcam2)
CTR2_kcam = [13/70,17/70, 14/70, 18/70, 16/70];
CTR2_kcam_avg(7) = mean(CTR2_kcam);


Coverage2_algo2 = [64/70,62/70, 65/70, 64/70, 68/70];
Coverage2_algo2_avg(7) = mean(Coverage2_algo2);
%execTime2_algo2 = [1.50, 2.26,  2.07, 2.9, 1.17, 1.37, 0.72, 0.84, 1.52, 0.28, 0.33] ;
%execTime2_algo2_avg(7) = mean(execTime2_algo2);
CTR2_algo2 = [16/70,9/70,14/70, 16/70, 19/70 ];
CTR2_algo2_avg(7) = mean(CTR2_algo2);

% Coverage2_greedy = [60/60,60/60,60/60,40/40,40/40, 40/40, 40/40 40/40];
% execTime2_greedy = [ 229.27, 287.130, 218.3, 266.48, 179.01] ;
% execTime2_greedy_avg(7) = mean(execTime2_greedy);
% CTR2_greedy = [6/60, 7/60, 7/60, 5/40, 7/60, 6/60, 7/60, 6/60];
% CTR2_greedy_avg(7) = mean(CTR2_greedy);
% 
% 
% Coverage2_dualSampl = [60/60,60/60,60/60, 60/60, 60/60, 40/40, 40/40, 40/40, 40/40];
% Coverage2_dualSampl_avg(6) = mean(Coverage2_dualSampl);
% execTime2_dualSampl = [85.9, 117.94, 74.52, 72.18, 97.4];
% execTime2_dualSampl_avg(6) = mean(execTime2_dualSampl);
% CTR2_dualSampl = [5/60, 6/60, 7/60, 6/60, 7/60, 7/60, 6/60];
% CTR2_dualSampl_avg(6) = mean(CTR2_dualSampl);



n = 80;
Coverage_kcam2 = [73/80, 73/80, 74/80, 74/80, 73/80];
coverage_kcam_avg(8) = mean(Coverage_kcam2)
execTime_kcam2 = [ 25.47, 32.88, 20.22, 23.47, 25.80 ] ;
execTime_kcam_avg(8) = mean(execTime_kcam2)
CTR2_kcam = [14/80, 20/80, 15/80, 16/80, 17/80];
CTR2_kcam_avg(8) = mean(CTR2_kcam);


Coverage2_algo2 = [76/80, 75/80, 75/80, 76/80, 72/80 ];
Coverage2_algo2_avg(8) = mean(Coverage2_algo2);
execTime2_algo2 = [3.32 2.59, 4.14, 2.9, 3.87, 2.23] ;
execTime2_algo2_avg(8) = mean(execTime2_algo2);
CTR2_algo2 = [14/80, 12/80, 15/80, 15/80, 11/80 ];
CTR2_algo2_avg(8) = mean(CTR2_algo2);

Coverage2_greedy = [60/60,60/60,60/60,40/40,40/40, 40/40, 40/40 40/40];
execTime2_greedy = [ 373.5, 363, 376.75, 266.48, 179.01] ;
execTime2_greedy_avg(8) = mean(execTime2_greedy);
CTR2_greedy = [7/80, 7/80, 7/80, 7/80, 7/80, 6/60, 7/60, 6/60];
CTR2_greedy_avg(8) = mean(CTR2_greedy);


Coverage2_dualSampl = [80/80,80/80,80/80, 80/80, 60/60, 40/40, 40/40, 40/40, 40/40];
Coverage2_dualSampl_avg(8) = mean(Coverage2_dualSampl);
execTime2_dualSampl = [112.32, 126.15, 146.7, 72.18, 97.4];
execTime2_dualSampl_avg(8) = mean(execTime2_dualSampl);
CTR2_dualSampl = [7/80, 7/80, 8/80, 7/80, 8/80];
CTR2_dualSampl_avg(8) = mean(CTR2_dualSampl);


n = 90;
Coverage_kcam2 = [81/90, 85/90, 84/90, 83/90, 81/90];
coverage_kcam_avg(9) = mean(Coverage_kcam2)
%execTime_kcam2 = [ 25.47, 32.88, 20.22, 23.47, 25.80 ] ;
%execTime_kcam_avg(9) = mean(execTime_kcam2)
CTR2_kcam = [18/90, 16/90, 15/90, 19/90, 18/90];
CTR2_kcam_avg(9) = mean(CTR2_kcam);


Coverage2_algo2 = [84/90, 84/90, 85/90, 82/90 ];
Coverage2_algo2_avg(9) = mean(Coverage2_algo2);
%execTime2_algo2 = [3.32 2.59, 4.14, 2.9, 3.87, 2.23] ;
%execTime2_algo2_avg(9) = mean(execTime2_algo2);
CTR2_algo2 = [16/90, 15/90, 13/90, 15/90];
CTR2_algo2_avg(9) = mean(CTR2_algo2);

% Coverage2_greedy = [60/60,60/60,60/60,40/40,40/40, 40/40, 40/40 40/40];
% execTime2_greedy = [ 373.5, 363, 376.75, 266.48, 179.01] ;
% execTime2_greedy_avg(9) = mean(execTime2_greedy);
% CTR2_greedy = [7/80, 7/80, 7/80, 7/80, 7/80, 6/60, 7/60, 6/60];
% CTR2_greedy_avg(9) = mean(CTR2_greedy);
% 
% 
% Coverage2_dualSampl = [80/80,80/80,80/80, 80/80, 60/60, 40/40, 40/40, 40/40, 40/40];
% Coverage2_dualSampl_avg(9) = mean(Coverage2_dualSampl);
% execTime2_dualSampl = [112.32, 126.15, 146.7, 72.18, 97.4];
% execTime2_dualSampl_avg(9) = mean(execTime2_dualSampl);
% CTR2_dualSampl = [7/80, 7/80, 8/80, 7/80, 8/80];
% CTR2_dualSampl_avg(9) = mean(CTR2_dualSampl);
% 




n = 100;
Coverage_kcam2 = [92/100, 92/100, 91/100, 91/100, 82/100, 91/100];
coverage_kcam_avg(10) = mean(Coverage_kcam2)
execTime_kcam2 = [ 30.32, 41.04, 20.22, 23.47, 25.80, 36.27, 34 ] ;
execTime_kcam_avg(10) = mean(execTime_kcam2)
CTR2_kcam = [17/100, 20/100, 19/100, 16/100, 18/100, 19/100];
CTR2_kcam_avg(10) = mean(CTR2_kcam);


Coverage2_algo2 = [92/100, 91/100, 90/100, 91/100, 82/100, 89/100 ];
Coverage2_algo2_avg(10) = mean(Coverage2_algo2);
execTime2_algo2 = [5.16 3.2, 4.14, 5.1, 3.87, 2.23, 7.9, 4] ;
execTime2_algo2_avg(10) = mean(execTime2_algo2);
CTR2_algo2 = [16/100, 12/100, 16/100, 17/100, 15/100, 11/100 ];
CTR2_algo2_avg(10) = mean(CTR2_algo2);

Coverage2_greedy = [100/100,100/100, 100/100,40/40,40/40, 40/40, 40/40 40/40];
execTime2_greedy = [ 472.2, 479.22, 376.75, 383, 179.01] ;
execTime2_greedy_avg(10) = mean(execTime2_greedy);
CTR2_greedy = [8/100, 7/100, 7/100, 7/100, 7/80, 6/60, 7/60, 6/60];
CTR2_greedy_avg(10) = mean(CTR2_greedy);


Coverage2_dualSampl = [100/100,100/100,80/80, 80/80, 60/60, 40/40, 40/40, 40/40, 40/40];
Coverage2_dualSampl_avg(10) = mean(Coverage2_dualSampl);
execTime2_dualSampl = [222.2, 165.1, 146.7, 170.42, 150];
execTime2_dualSampl_avg(10) = mean(execTime2_dualSampl);
CTR2_dualSampl = [9/100, 8/100, 8/100, 7/100, 8/80];
CTR2_dualSampl_avg(10) = mean(CTR2_dualSampl);


n = 200;
Coverage_kcam2 = [180/200, 180/200, 182/200, 182/200, 82/100, 91/100];
coverage_kcam_avg(11) = mean(Coverage_kcam2)
execTime_kcam2 = [ 115.4, 101, 20.22, 23.47, 25.80, 36.27, 34 ] ;
execTime_kcam_avg(11) = mean(execTime_kcam2)
CTR2_kcam = [27/200, 25/200, 25/200, 27/200, 18/100, 19/100];
CTR2_kcam_avg(11) = mean(CTR2_kcam);


Coverage2_algo2 = [190/200, 180/200, 90/100, 91/100, 82/100, 89/100 ];
Coverage2_algo2_avg(11) = mean(Coverage2_algo2);
execTime2_algo2 = [15.9 9 4.14, 5.1, 3.87, 2.23, 7.9, 4] ;
execTime2_algo2_avg(11) = mean(execTime2_algo2);
CTR2_algo2 = [21/200, 13/200, 16/200, 20/200 ];
CTR2_algo2_avg(11) = mean(CTR2_algo2);

Coverage2_greedy = [100/100,100/100, 100/100,40/40,40/40, 40/40, 40/40 40/40];
execTime2_greedy = [ 996] ;
execTime2_greedy_avg(11) = mean(execTime2_greedy);
CTR2_greedy = [8/200, 8/200, 9/200, 9/200, 7/80, 6/60, 7/60, 6/60];
CTR2_greedy_avg(11) = mean(CTR2_greedy);


Coverage2_dualSampl = [100/100,100/100,80/80, 80/80, 60/60, 40/40, 40/40, 40/40, 40/40];
Coverage2_dualSampl_avg(11) = mean(Coverage2_dualSampl);
execTime2_dualSampl = [519];
execTime2_dualSampl_avg(11) = mean(execTime2_dualSampl);
CTR2_dualSampl = [9/200, 9/200, 9/200, 11/200];
CTR2_dualSampl_avg(11) = mean(CTR2_dualSampl);



n = 600;
Coverage_kcam2 = [554/600, 555/600, 542/600, 543/600 ];
coverage_kcam_avg(13) = mean(Coverage_kcam2);
execTime_kcam2 = [ 961.6, 792, 963.81, 1588] ;
execTime_kcam_avg(13) = mean(execTime_kcam2);
CTR2_kcam = [51/600, 45/600, 49/600, 47/600 ];
CTR2_kcam_avg(13) = mean(CTR2_kcam);


Coverage2_algo2 = [564/600, 541/600, 543/600, 544/600 ];
Coverage2_algo2_avg(13) = mean(Coverage2_algo2);
execTime2_algo2 = [46.52 31.66 ] ;
execTime2_algo2_avg(13) = mean(execTime2_algo2);
CTR2_algo2 = [20/600, 16/600, 20/600, 16/600 ];
CTR2_algo2_avg(13) = mean(CTR2_algo2);

% Coverage2_greedy = [100/100,100/100, 100/100,40/40,40/40, 40/40, 40/40 40/40];
% execTime2_greedy = [ 996] ;
% execTime2_greedy_avg(13) = mean(execTime2_greedy);
% CTR2_greedy = [8/200, 8/200, 9/200, 9/200, 7/80, 6/60, 7/60, 6/60];
% CTR2_greedy_avg(13) = mean(CTR2_greedy);
% 
% 
% Coverage2_dualSampl = [100/100,100/100,80/80, 80/80, 60/60, 40/40, 40/40, 40/40, 40/40];
% Coverage2_dualSampl_avg(13) = mean(Coverage2_dualSampl);
% execTime2_dualSampl = [519];
% execTime2_dualSampl_avg(13) = mean(execTime2_dualSampl);
% CTR2_dualSampl = [9/200, 9/200, 9/200, 11/200];
% CTR2_dualSampl_avg(13) = mean(CTR2_dualSampl);


n = 800;
Coverage_kcam2 = [738/800, 734/800, 726/800, 752/800 ];
coverage_kcam_avg(14) = mean(Coverage_kcam2);
execTime_kcam2 = [  1.1695e+03,  1.4530e+03, 1.7242e+03] ;
execTime_kcam_avg(14) = mean(execTime_kcam2);
CTR2_kcam = [47/800, 56/800, 62/800, 54/800 ];
CTR2_kcam_avg(14) = mean(CTR2_kcam);


Coverage2_algo2 = [774/800, 757/800, 755/800, 732/800 ];
Coverage2_algo2_avg(14) = mean(Coverage2_algo2);
execTime2_algo2 = [57 31.66 73] ;
execTime2_algo2_avg(14) = mean(execTime2_algo2);
CTR2_algo2 = [19/800, 22/800, 19/800, 21/800 ];
CTR2_algo2_avg(14) = mean(CTR2_algo2);


n = 1000;
Coverage_kcam2 = [904/1000, 907/1000, 726/800, 752/800 ];
coverage_kcam_avg(15) = mean(Coverage_kcam2);
execTime_kcam2 = [   2.0637e+03,  1.8457e+03, 1.7242e+03] ;
execTime_kcam_avg(15) = mean(execTime_kcam2);
CTR2_kcam = [58/1000, 55/1000, 62/800, 54/800 ];
CTR2_kcam_avg(15) = mean(CTR2_kcam);


Coverage2_algo2 = [900/1000, 943/1000, 992/1000 ];
Coverage2_algo2_avg(15) = mean(Coverage2_algo2);
execTime2_algo2 = [143 90] ;
execTime2_algo2_avg(15) = mean(execTime2_algo2);
CTR2_algo2 = [22/1000, 28/1000, 22/1000 ];
CTR2_algo2_avg(15) = mean(CTR2_algo2);


close all;
figure;
plot(N,coverage_kcam_avg,'-rs');
xlabel('#targets');
ylabel('ratio of covered targets');
%title('Algorithm 1 ');
hold on;
plot(N,Coverage2_algo2_avg, '-cd'); hold on;
plot(N,Coverage1_greedy,'-ko'); hold on;
plot(N,Coverage1_dualSampl,'-k+');
legend('KCam', 'CF', 'Greedy', '2-Sampling');


figure;
plot(N,execTime_kcam_avg,'-rs');
xlabel('#targets');
ylabel('execution time');
%title('Algorithm 1 ');
hold on;
plot(N,execTime2_algo2_avg, '-cd'); hold on;
plot(N,execTime2_greedy_avg,'-ko'); hold on;
plot(N,execTime2_dualSampl_avg,'-k+');
legend('KCam', 'CF', 'Greedy', '2-Sampling');



figure;
plot(N,CTR2_kcam_avg,'-rs');
xlabel('#targets');
ylabel('Camera to Target Ratio');
%title('Algorithm 1 ');
hold on;
plot(N,CTR2_algo2_avg, '-cd'); hold on;
plot(N,CTR2_greedy_avg, '-ko'); hold on;
plot(N,CTR2_dualSampl_avg, '-k+');
legend('KCam', 'CF', 'Greedy', '2-Sampling');

