set xlabel "t-step"
set ylabel "dRMS-ref, Angstrom"
set key top
plot "morph_lidmix_1akea_11000_150_0_m55.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "black" title "11000-150-0-m55",\
"morph_lidmix_1akea_12000_150_0_m55.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "red" title "12000-150-0-m55",\
"morph_lidmix_1akea_13000_150_0_m55.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "green" title "13000-150-0-m55",\
"morph_lidmix_1akea_14000_150_0_m55.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "blue" title "14000-150-0-m55",\
"morph_lidmix_1akea_2000_150_0_20.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "grey" title "2000-150-0-20",\
"morph_lidmix_1akea_3000_150_0_20.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "purple" title "3000-150-0-20",\
"morph_lidmix_1akea_4000_150_0_20.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "orange" title "4000-150-0-20",\
"morph_lidmix_1akea_4000_150_0_35.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "magenta" title "4000-150-0-35",\
"morph_lidmix_1akea_4000_150_0_m10.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "brown" title "4000-150-0-m10",\
"morph_lidmix_1akea_5000_150_0_m25.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "cyan" title "5000-150-0-m25",\
"morph_lidmix_1akea_6000_150_0_m25.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "yellow" title "6000-150-0-m25",\
"morph_lidmix_1akea_7000_150_0_m40.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "web-green" title "7000-150-0-m40",\
"morph_lidmix_1akea_8000_150_0_m40.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "web-blue" title "8000-150-0-m40",\
"morph_lidmix_1akea_9000_150_0_m40.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "gold" title "9000-150-0-m40"
set term pngcairo
set output "plot_GO_DoME_TB_4akea_1akea_0p6dc_2p6cr_lid_intra_mixed_lidmix_1akea_03.png"
replot
set term x11
pause -1 "Hit any key to continue"
