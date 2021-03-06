EESchema Schematic File Version 4
LIBS:reciver_board-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector:RJ45 J1
U 1 1 5BFC883D
P 1800 3500
F 0 "J1" H 1855 4167 50  0000 C CNN
F 1 "RJ45" H 1855 4076 50  0000 C CNN
F 2 "Connector_RJ:RJ45_Wuerth_7499010121A_Horizontal" V 1800 3525 50  0001 C CNN
F 3 "~" V 1800 3525 50  0001 C CNN
	1    1800 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2200 3100 2350 3100
Entry Wire Line
	2350 3100 2450 3200
Wire Wire Line
	2200 3200 2350 3200
Entry Wire Line
	2350 3200 2450 3300
Wire Wire Line
	2200 3300 2350 3300
Entry Wire Line
	2350 3300 2450 3400
Wire Wire Line
	2200 3400 2350 3400
Entry Wire Line
	2350 3400 2450 3500
Wire Wire Line
	2200 3500 2350 3500
Entry Wire Line
	2350 3500 2450 3600
Wire Wire Line
	2200 3600 2350 3600
Entry Wire Line
	2350 3600 2450 3700
Wire Wire Line
	2200 3700 2350 3700
Entry Wire Line
	2350 3700 2450 3800
Wire Wire Line
	2200 3800 2350 3800
Entry Wire Line
	2350 3800 2450 3900
$Comp
L Connector:Screw_Terminal_01x02 J2
U 1 1 5BFC8C47
P 2000 4300
F 0 "J2" H 1920 3975 50  0000 C CNN
F 1 "Screw_Terminal_01x02" H 1920 4066 50  0000 C CNN
F 2 "TerminalBlock:TerminalBlock_Altech_AK300-2_P5.00mm" H 2000 4300 50  0001 C CNN
F 3 "~" H 2000 4300 50  0001 C CNN
	1    2000 4300
	-1   0    0    1   
$EndComp
$Comp
L Connector_Generic:Conn_01x04 J3
U 1 1 5BFC9223
P 2000 4850
F 0 "J3" H 1920 4425 50  0000 C CNN
F 1 "Conn_01x04" H 1920 4516 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical" H 2000 4850 50  0001 C CNN
F 3 "~" H 2000 4850 50  0001 C CNN
	1    2000 4850
	-1   0    0    1   
$EndComp
Entry Wire Line
	2350 4750 2450 4850
Wire Wire Line
	2200 4850 2350 4850
Entry Wire Line
	2350 4850 2450 4950
Wire Wire Line
	2200 4950 2350 4950
Entry Wire Line
	2350 4950 2450 5050
Wire Wire Line
	2200 4650 2350 4650
Entry Wire Line
	2350 4650 2450 4750
Wire Wire Line
	2200 4750 2350 4750
Entry Wire Line
	2350 4750 2450 4850
Wire Wire Line
	2200 4200 2350 4200
Entry Wire Line
	2350 4200 2450 4300
Wire Wire Line
	2200 4300 2350 4300
Entry Wire Line
	2350 4300 2450 4400
Text Label 2350 4200 2    50   ~ 0
5V
Text Label 2350 4300 2    50   ~ 0
LIMX
Wire Bus Line
	2450 3200 2450 5050
Text Label 2350 3800 2    50   ~ 0
2A
Text Label 2350 3700 2    50   ~ 0
2B
Text Label 2350 3400 2    50   ~ 0
1A
Text Label 2350 3200 2    50   ~ 0
1B
Text Label 2350 3100 2    50   ~ 0
5V
Text Label 2350 3300 2    50   ~ 0
LIMX
Text Label 2350 4650 2    50   ~ 0
2B
Text Label 2350 4750 2    50   ~ 0
2A
Text Label 2350 4850 2    50   ~ 0
1A
Text Label 2350 4950 2    50   ~ 0
1B
$EndSCHEMATC
