sudo ifconfig eth0 192.168.200.1 255.255.255.0
g++ calibrator2.cpp -o just_testing `pkg-config --cflags --libs opencv` -lcurl
./just_testing


