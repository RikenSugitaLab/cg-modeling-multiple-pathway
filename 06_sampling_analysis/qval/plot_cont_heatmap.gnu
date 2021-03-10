##!/usr/bin/gnuplot
set encoding iso_8859_1
set term pngcairo font 'Verdana,13'
#set xlabel "pc1 [280-1microsec]"
#set ylabel "pc2 [280-1microsec]"
#set key outside
#set key below
#set size square
set xrange [-5:220]
set yrange [-5:220]
set trange [-5:220]
set size square
set xtics 30 
set ytics 30 
#set key font ",15"
#set palette rgbformula -7,2,-7
#set palette rgb 7,5,15
#set title "qval-Dome-common-Bstate-Bsim"
set cbrange [0:1]
set cbtics 
set cblabel "frac_{native}" 
#set palette defined ( -1 '#000030', 0 '#000090',1 '#000fff',2 '#0090ff',3 '#0fffee',4 '#90ff70',5 '#ffee00',6 '#ff7000',7 '#ee0000',8 '#7f0000')
set palette defined ( -1 'black', 0 'blue',1 'red',2 'orange')
set grid front mxtics mytics linecolor rgb "black"
f(x)=x>0 ? x : 1/0
set parametric
plot "qval-ind-uniq-grotop_DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_both_10850_m59p5_0_m13p8-74-75-77-basin3_basin3_heatmap.out" using 1:2:(1):(f($3)) w points pt 5 ps 0.9 lc palette notitle,\
"domlines.txt" using 1:2 with lines lt 1 linecolor rgb "black" title "",\
"domlines.txt" using 3:4 with lines lt 1 linecolor rgb "black" title "",\
"domlines.txt" using 5:6 with lines lt 1 linecolor rgb "black" title "",\
"domlines.txt" using 7:8 with lines lt 1 linecolor rgb "black" title "",\
"domlines.txt" using 9:10 with lines lt 1 linecolor rgb "black" title "",\
"domlines.txt" using 11:12 with lines lt 1 linecolor rgb "gray" title "",\
"domlines.txt" using 13:14 with lines lt 1 linecolor rgb "gray" title "",\
"domlines.txt" using 15:16 with lines lt 1 linecolor rgb "black" title "",\
6, t with lines lt 1 linecolor rgb "black" title "",\
13, t with lines lt 1 linecolor rgb "black" title "",\
29, t with lines lt 1 linecolor rgb "black" title "",\
59, t with lines lt 1 linecolor rgb "black" title "",\
114, t with lines lt 1 linecolor rgb "black" title "",\
120, t with lines lt 1 linecolor rgb "gray" title "",\
158, t with lines lt 1 linecolor rgb "gray" title "",\
174, t with lines lt 1 linecolor rgb "black" title ""
set term png font ",15"
#set terminal postscript eps font 'Helvetcia,30' 
set output "qval-ind-uniq-grotop_DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_both_10850_m59p5_0_m13p8-74-75-77-basin3_basin3_heatmap.png"
replot
set term x11
pause -1 "Hit any key to continue"


#set palette rgb -33,-13,-10




