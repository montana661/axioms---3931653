% =====================================================================
% main_multi_parallel.m — Ejecuta DA en paralelo (parfor) con FuzzyFlag
% =====================================================================

clc; clear;
format short g

% --------------------- Parámetros base -------------------------------
SearchAgents_no = 40;
Function_name   = 'F10';
Max_iteration   = 100;
nRuns           = 30;  % Número de ejecuciones paralelas

% --------------------- Configuración Fuzzy ---------------------------
% 0 = Sin lógica difusa
% 1 = Lógica difusa Tipo-1
% 2 = Lógica difusa Tipo-2
% 3 = Lógica difusa Generalizada (GT2)
FuzzyFlag = 3;   % <<< Cambia según tu necesidad

% Cargar detalles de la función
[lb, ub, dim, fobj] = Get_Functions_details(Function_name);

% --------------------- Inicialización de resultados ------------------
Best_scores = inf(1, nRuns);
Best_positions = zeros(dim, nRuns);
cg_curves = zeros(Max_iteration, nRuns);

fprintf('\n=== Ejecutando %d corridas de DA (%s) en paralelo | FuzzyFlag=%d ===\n', ...
        nRuns, Function_name, FuzzyFlag);

% =================== Paralelización =======================
% Verifica si ya hay un pool activo, si no lo crea
p = gcp('nocreate');
if isempty(p)
    cores = feature('numCores');
    parpool('local', min(cores, nRuns));
end

tStart = tic;
parfor r = 1:nRuns
    % Control de semilla reproducible por corrida
    s = RandStream('CombRecursive','Seed',r);
    RandStream.setGlobalStream(s);

    fprintf('Run %02d iniciando...\n', r);

    [Best_score, Best_pos, cg_curve] = DA(SearchAgents_no, Max_iteration, lb, ub, dim, fobj, FuzzyFlag);

    Best_scores(r)      = Best_score;
    Best_positions(:,r) = Best_pos;
    cg_curves(:,r)      = cg_curve(:);

    fprintf('Run %02d -> Best_score = %.6g\n', r, Best_score);
end
elapsed = toc(tStart);

% Cierra el pool (opcional)
delete(gcp('nocreate'));

% =================== Estadísticas =========================
[bestVal, bestIdx] = min(Best_scores);
meanVal   = mean(Best_scores);
medianVal = median(Best_scores);
stdVal    = std(Best_scores);

fprintf('\n===== SUMMARY %s (%d runs, FuzzyFlag=%d) =====\n', Function_name, nRuns, FuzzyFlag);
fprintf('Best   : %.6g (run %d)\n', bestVal, bestIdx);
fprintf('Mean   : %.6g\n', meanVal);
fprintf('Median : %.6g\n', medianVal);
fprintf('Std    : %.6g\n', stdVal);
fprintf('Total time: %.2f s (%.2f s/run)\n', elapsed, elapsed/nRuns);

% =================== Gráficas ==============================
figure('Name','Convergence (Parallel Runs)','Position',[200 200 800 400]);
plot(cg_curves, 'LineWidth', 1); grid on; box on;
xlabel('Iteration'); ylabel('Best score');
title(sprintf('DA %s — %d parallel runs (FuzzyFlag=%d)', Function_name, nRuns, FuzzyFlag));

% =================== Guardado ==============================
Run = (1:nRuns).';
T = table(Run, Best_scores.');
T.Properties.VariableNames = {'Run','BestScore'};

filePrefix = sprintf('DA_%s_Fuzzy%d_%druns_PAR', Function_name, FuzzyFlag, nRuns);

try
    writetable(T, [filePrefix '.csv']);
catch
    xlswrite([filePrefix '.xls'], {'Run','BestScore'}, 'Sheet1', 'A1');
    xlswrite([filePrefix '.xls'], [Run, Best_scores.'], 'Sheet1', 'A2');
end

save([filePrefix '.mat'], 'Best_scores','Best_positions','cg_curves',...
     'SearchAgents_no','Max_iteration','lb','ub','dim','Function_name','FuzzyFlag');

% Mostrar mejor corrida
figure('Name','Best run convergence','Position',[300 300 600 350]);
semilogy(cg_curves(:,bestIdx),'LineWidth',2); grid on; box on;
xlabel('Iteration'); ylabel('Best score');
title(sprintf('Best run = %d | Best score = %.6g | FuzzyFlag=%d', bestIdx, bestVal, FuzzyFlag));
