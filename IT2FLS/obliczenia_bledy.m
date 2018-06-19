val_pid = simout.signals.values(:,1);
val_ob = simout.signals.values(:,2);
val_fuzzy = simout.signals.values(:,3);

%blad wzgledny
N = length(val_pid);

val_zadany = ones(N,1);
blad_ob = sum(val_zadany-val_ob)/N;
blad_pid = sum(val_zadany-val_pid)/N;
blad_fuzzy = sum(val_zadany-val_fuzzy)/N;

plot(tout,val_zadany-val_ob);
hold on;
plot(tout,val_zadany-val_fuzzy);
hold on;
plot(tout,val_zadany-val_pid);