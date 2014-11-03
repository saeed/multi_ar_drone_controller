clear all;
close all;


AOV_degree = 90;
%AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
altitude = 1;
R_min = altitude*10;%0.0001;%0.01; % 0.5m
R_max = 300;%25;%10;%30;%100; % 3m

% Dimensions of the area
Dim1_min = 0;%2;
Dim2_min = 0;%2;
Dim1_max = 700;%700;%50;%60;%200; %maximum in x-axis (m)
Dim2_max = 500%500;%50;%60;%200; %maximum in y-axis (m)
Margin = 10;%10;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GET TARGETS LOCATION FROM INPUT
SERVER_PORT = 5000;

import java.net.ServerSocket
import java.io.*
import java.nio.*

server_socket = ServerSocket(SERVER_PORT);
input_socket = server_socket.accept;

input_stream   = input_socket.getInputStream;
d_input_stream = DataInputStream(input_stream);

output_stream   = input_socket.getOutputStream;
d_output_stream = DataOutputStream(output_stream);
try

    for bigLooper = 1:10

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%% GET TARGETS INFO %%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        NUMBER_OF_TARGETS = (d_input_stream.readInt());
        NUMBER_OF_TARGETS

        TargetCount = NUMBER_OF_TARGETS;%100;
        MAX_CLUSTER = TargetCount; %round(TargetCount/2);

        data = [];
        for kkkkk = 1:NUMBER_OF_TARGETS
                x = [];
                y = [];
            while isempty(x)
                x = (d_input_stream.readInt()/100);
            end
            while isempty(y)
                y = (d_input_stream.readInt()/100);
            end
            data = [data; x y 0]
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%  COVERAGE ALGORITHM %%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        data = data';

        %TargetCount = 1 ;%20;%100;
        %MAX_CLUSTER = TargetCount;
        ClusterNum =  1;
        % fraction of targets below which we allow uncovered targets
        uncovered_fraction_criterion = 0.1;
        max_iteration = 50;

        Result = FinalCoverageMainEnhancedExperiment(data, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, max_iteration, uncovered_fraction_criterion, ClusterNum, MAX_CLUSTER, TargetCount,altitude,Margin);
        Result

        UsedClustersNum = size(Result , 1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%  SEND DRONE INFO %%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        numberOfDrones = int32(UsedClustersNum);
        b1 = ByteBuffer.allocate(4);
        b1.putInt(numberOfDrones);
            r1 = b1.array();
        d_output_stream.write(r1 , 0,4);

        for droneIter = 1:UsedClustersNum
            int32(Result(droneIter,1)*100)
            int32(Result(droneIter,2)*100)
            b1 = ByteBuffer.allocate(4);
            b1.putInt(int32(Result(droneIter,1)*100));
            r1 = b1.array();
            d_output_stream.write(r1 , 0,4);
            b2 = ByteBuffer.allocate(4);
            b2.putInt(int32(Result(droneIter,2)*100));
                r2 = b2.array();
            d_output_stream.write(r2, 0,4);
            b3 = ByteBuffer.allocate(4);
            b3.putInt(int32(Result(droneIter,7)*100));
            r3 = b3.array();
            d_output_stream.write(r3, 0,4);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end

    close(input_socket);
    close(server_socket);

catch err
    display('Controller Terminated');
    close(input_socket);
    close(server_socket);
end