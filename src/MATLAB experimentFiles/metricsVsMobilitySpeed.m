%effect of mobility prediction
%TargetCount = 50;
%Rmax = 30; AOV = 90;
%RUN_PERIOD = 5;
%MAX_PREDICTION = RUN_PERIOD;
%CTC = 0.9
%Using Fuzzy
% speed_vec = [0.25 0.5 1 2 3 4 5];
% 
% uncovered_ratio_with_prediction = [1.9364 2.5818 3.4364 6.2000 9.0545 14.2909 18.9273]/50;
% cam_num_with_prediction = [5.6400    5.7600    5.7200    5.4800    5.7200    5.7200    6.0400];
% exec_time_with_prediction = [0.3426    0.3549    0.3419    0.3215    0.3439    0.3588    0.3940];
% 
% uncovered_ratio_basic = [ 2.5000 2.9636 3.9364 6.9273 10.4000 14.7182 19.8545]/50;
% cam_num_basic = [5.6800    5.5200    5.8000    5.7200    5.6400    5.8000    5.8000];
% exec_time_with_prediction = [ 0.0577    0.0545    0.0597    0.0582    0.0579    0.0584    0.0584];

speed_vec = [0.05 0.1 0.25 0.5 1 2 3 4 5];
%10 scenarios:
%RUN_PERIOD = 5;
uncovered_ratio_with_prediction = [ 1.2136  1.4409  1.8182  2.5000  3.7409  6.8227  9.4318 14.3591 18.6682]/50;
cam_num_with_prediction = [ 5.5800    5.5400    5.6200    5.7000    5.7800    5.7200    5.7200    5.7800 5.9000];
exec_time_with_prediction = [ 0.3341    0.3415    0.3334    0.3419    0.3531    0.3556    0.3573    0.3745    0.3893];

uncovered_ratio_basic = [  1.5636  1.936   2.5636 3.0955 4.2864 7.4000 10.977  15.1500  19.6500]/50;
cam_num_basic = [ 5.7800    5.6800    5.7600    5.5600    5.6800    5.7600    5.6600    5.7400   5.9000];
exec_time_basic = [0.0594    0.0584    0.0584    0.0564    0.0595    0.0605    0.0590    0.0600    0.0619];

% figure; 
% plot(speed_vec, uncovered_ratio_with_prediction, '-rs', 'LineWidth',2,'MarkerSize',8); hold on;
% plot(speed_vec, uncovered_ratio_basic, '-ks', 'LineWidth',2,'MarkerSize',8); hold on;

%RUN_PERIOD = 10;
uncovered_ratio_with_prediction = [ 1.3455  1.5636  2.4364  4.0227  7.4227  16.3000  22.9364  25.1091  22.6273]/50;
cam_num_with_prediction = [5.7000    5.6333    5.9000    5.5000    5.9000    5.8000    5.6333    6.0000  6.1667];
exec_time_with_prediction = [ 0.5043    0.4836    0.5162    0.4644    0.5278    0.5213    0.5085    0.5863    0.6046];

uncovered_ratio_basic = [ 1.7727 2.4545  2.9682  4.5409  7.922  17.4136  24.3864  25.7091  22.7636]/50;
cam_num_basic = [5.7667    5.7333    5.7000    5.8333    5.7333    5.9333    5.7667    5.8000    5.8333];
exec_time_basic = [ 0.0364    0.0373    0.0353    0.0361    0.0352    0.0373    0.0347    0.0345   0.0353];



%XSPEED = 0, YSPEED varies in the above range
uncovered_ratio_with_prediction = [ 0.0331 0.0325  0.0657   0.0888  0.1513  0.2779  0.3980  0.4225  0.3754];
cam_num_with_prediction = [5.8667    5.8667    5.6000    5.6000    5.8333    5.9333    5.6333    5.9667 5.9333];
exec_time_with_prediction = [ 0.5121    0.4893    0.4658    0.4618    0.4838    0.5171    0.4879    0.5357  0.5576];

uncovered_ratio_basic = [ 0.0363    0.0388    0.0635    0.0875    0.1481    0.2898    0.4091    0.4445 0.3901];


cam_num_basic = [ 5.8667    5.8333    5.7333    5.6333    5.6333    5.8000    5.8000    5.8333 5.8667];
exec_time_basic = [ 0.0386    0.0365    0.0352    0.0343    0.0342    0.0352    0.0353    0.0355  0.0360];

speed_vec = [0.1 0.25 0.5 1 2 3 4];

%RUN_PERIOD = 5
uncovered_ratio_with_prediction = [  0.0334    0.0430    0.0601    0.0583    0.0771    0.0930    0.0945];
%camNum_with_prediction = [ 8.4000    8.1000    7.8600    8.1400    8.0400    8.2200    8.0600];
uncovered_ratio_basic = [ 0.0402    0.0524    0.0624    0.0828    0.1485    0.2193    0.3083];
%cam_num_basic= [ 5.7600    5.6400    5.6000    5.6400    5.6000    5.7000    5.6800];

%Rmax = 25, RUN_PERIOD = 5;
%uncovered_ratio_basic = [0.0438    0.0395    0.0525    0.0721    0.0945    0.1640    0.2372    0.3315   0.4135];
%uncovered_ratio_with_prediction = [0.0389  0.0403 0.0495 0.0678   0.0951  0.1564  0.2350  0.3197  0.3954];

%Rmax=20, AOV =60, RUN_PERIOD = 5;
%uncovered_ratio_basic = [ 0.0785    0.0903    0.1121    0.1526    0.1985    0.3171    0.4349    0.5275   0.5879];
%uncovered_ratio_with_prediction = [0.0732    0.0835    0.1156    0.1565    0.1948    0.2963    0.4153    0.5251  0.5901];

%RUN PERIOD = 10, speed_vec = [0.1 0.25 0.5 1 2 3 4];
%speed_vec = [0.1 0.25 0.5 1 2 3 4];
%uncovered_ratio_basic = [0.1053    0.1475    0.2185    0.3578    0.5695    0.6711    0.7145];
%uncovered_ratio_with_prediction = [0.1139    0.1664    0.2081    0.3275    0.5700    0.6712    0.7131];


figure;
plot(speed_vec, uncovered_ratio_with_prediction, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
plot(speed_vec, uncovered_ratio_basic, '-kd', 'LineWidth',2,'MarkerSize',8); hold on;

%figure;
%plot(speed_vec, camNum_with_prediction, '-rd', 'LineWidth',2,'MarkerSize',8); hold on;
%plot(speed_vec, cam_num_basic, '-kd', 'LineWidth',2,'MarkerSize',8); hold on;





