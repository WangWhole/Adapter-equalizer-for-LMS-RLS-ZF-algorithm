# Adapter-equalizer-for-LMS-RLS-ZF-algorithm
There are some MATLAB simulations for implementing adapter equalizer，but，to be honest， ZF algorithm is not a
adaper filter algorithm. LMS and RLS are adapter filter algorithms which I used them perform the simulations.

In folders, the "random_binary.m" can product some "±1" info-sequeeces, the "channel.m", "ISI_generation.m"and "gngauss.m" create
a channel with ISI and awgn, three "main_plot_" are the main program for three algorithms' simulations, "lms_equalizer.m",
"rls_equalizer.m" and "force_zero.m" are implements for three algorithms. Besides, I provide the mliti-iteration versions for
two adapter algorithms.

