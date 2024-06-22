warning('off', 'all')

modelTypes = ["nonlinear", "improved nonlinear"];
feedbackTypes = ["normal", "trajectory"];
resultNames = ["nonlin_feedback_trajectory_1", "advanced_3d_trajectory_1"];

modelTypes = ["improved nonlinear"];
feedbackTypes = ["normal"];
resultNames = ["advanced_flexible_normal_strong"];

cycleTypes = ["flexible"];

modelTypes = ["linear", "nonlinear", "improved nonlinear"];
feedbackTypes = ["normal", "normal", "normal"];
resultNames = ["linear_flexible_normal_weak", "nonlinear_flexible_normal_weak", "advanced_flexible_normal_weak"];
%resultNames = ["lin_feedback_1", "nonlinear_flexible_normal_weak", "advanced_flexible_normal_weak"];

feedbackTypes = ["trajectory", "trajectory", "trajectory"];
resultNames = ["linear_flexible_trajectory_R10", "nonlin_feedback_1", "advanced_flexible_trajectory_R10"];

cycleTypes = ["flexible", "flexible", "flexible"];


feedbackTypes = ["normal", "normal", "normal"];
resultNames = ["linear_vander_normal_normal", "nonlin_feedback_normal_1", "advanced_feedback_normal_1"];
cycleTypes = ["vander", "vander", "vander"];
% 
% %%% 3d
% 
% feedbackTypes = ["normal", "normal", "normal"];
% resultNames = ["lin_3d_normal_1", "nonlin_3d_normal_1", "advanced_3d_normal_1"];
% cycleTypes = ["3d", "3d", "3d"];

note = "";
%noteText = "weak regular feedback";

interrupts = [600, 600, 600];
sampleTimes = [0.002, 0.001, 0.001];


resultNo = length(modelTypes);


for rn = 1:resultNo
    loadString = resultNames(rn);
    cycle = cycleTypes(rn);
    feedbackType = feedbackTypes(rn);
    modelType = modelTypes(rn);
    interrupt = interrupts(rn);
    sampleTime = sampleTimes(rn);

    loadResultData;

    cycle_detection;
end

disp(" ")
disp(append("The table for the experiments with ", note, " ", feedbackType, " feedback control are found in Table \ref{tab:", append("all_", feedbackType, "_", note,"_", cycle), "}."))
disp(" ")

disp(" ")
disp("\begin{table}[]")
disp("\centering")
disp("\begin{tabular}{|c|c|c|c|c|c|}")
fprintf(append("\\hline\nModel & State ", unitType," & RMSE & MAE & Center & CA curve \\\\ \n\\hline \n"))
for rn = 1:resultNo
    for stt = 1:statesNo
        metricString = append(modelTypes(rn), " & ", stateNames(stt), " ", stateType, " & %.4g & %.4g & %.4g & %.4g \\\\ \n\\hline \n");
        fprintf(metricString, indices(-3 + rn*4, stt), indices(-2 + rn*4, stt), indices(-1 + rn*4, stt), indices(0 + rn*4, stt));
    end
end
disp("\end{tabular}")
disp(append("\caption{Error metrics, center position and cyclic analysis curvature, for imitation inputs designed with each model and using ", note, " ", feedbackType, " feedback at R = ", num2str(R(1)),"I}"))
disp(append("\label{tab:", append("all_", feedbackType, "_", note,"_", cycle), "}"))
disp("\end{table}")