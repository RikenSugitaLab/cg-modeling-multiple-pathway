set xlabel "t-step"
set ylabel "dRMS-ref, Angstrom"
set key top
plot "morph_1akea_lidmix_10000_150_0_m70.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "black" title "10000-150-0-m70",\
"morph_1akea_lidmix_11000_150_0_m70.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "red" title "11000-150-0-m70",\
"morph_1akea_lidmix_12000_150_0_m70.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "green" title "12000-150-0-m70",\
"morph_1akea_lidmix_13000_150_0_m70.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "blue" title "13000-150-0-m70",\
"morph_1akea_lidmix_2000_150_0_m85.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "grey" title "2000-150-0-m85",\
"morph_1akea_lidmix_3000_150_0_m85.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "purple" title "3000-150-0-m85",\
"morph_1akea_lidmix_4000_150_0_m70.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "orange" title "4000-150-0-m70",\
"morph_1akea_lidmix_4000_150_0_m85.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "magenta" title "4000-150-0-m85",\
"morph_1akea_lidmix_5000_150_0_m70.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "brown" title "5000-150-0-m70",\
"morph_1akea_lidmix_5000_150_0_m85.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "cyan" title "5000-150-0-m85",\
"morph_1akea_lidmix_6000_150_0_m70.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "yellow" title "6000-150-0-m70",\
"morph_1akea_lidmix_6000_150_0_m85.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "web-green" title "6000-150-0-m85",\
"morph_1akea_lidmix_7000_150_0_m70.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "web-blue" title "7000-150-0-m70",\
"morph_1akea_lidmix_8000_150_0_m70.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "gold" title "8000-150-0-m70",\
"morph_1akea_lidmix_9000_150_0_m70.log.minlast" using 1:8 every 1 with lines dt 1 lw 3 linecolor rgb "dark-green" title "9000-150-0-m70"
set term pngcairo
set output "plot_GO_DoME_TB_4akea_1akea_0p6dc_2p6cr_lid_intra_mixed_1akea_lidmix_03.png"
replot
set term x11
pause -1 "Hit any key to continue"
