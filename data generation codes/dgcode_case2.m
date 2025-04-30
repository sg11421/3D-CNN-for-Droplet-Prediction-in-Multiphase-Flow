% Load COMSOL model
import com.comsol.model.*
import com.comsol.model.util.*

% Initialize COMSOL and load the model file
model = mphload('F:\COMSOL\2_copy.mph'); % Replace with your COMSOL model filename

% Set the folder where you want to save the animations
targetFolder = 'F:/COMSOL/data5/'; % Replace with the actual target folder path

% Set velocity and surface tension ranges
velocityRange1 = linspace(0.005, 0.05, 10);  % 10 iterations for v1
velocityRange2 = linspace(0.0005, 0.005, 10);  % 10 iterations for v2
surfaceTensionRange = linspace(0.001, 0.01, 10); % 10 iterations for surface tension

% Initialize the CSV file
csvFileName = fullfile(targetFolder, 'simulation_data.csv');
fileID = fopen(csvFileName, 'w');

% Write the header to the CSV file
header = 'v1 (m/s),v2 (m/s),Surface Tension (N/m),v1/v2,Weber Number,Capillary Number\n';
fprintf(fileID, header);

% Loop over each combination of v1, v2, and surface tension
loopno = 50;
for i = 1:length(velocityRange1)
    for j = 1:length(velocityRange2)
        for k = 1:length(surfaceTensionRange)
            loopno = loopno + 1;
            % Set current values of v1, v2, and surface tension
            v1 = velocityRange1(i);
            v2 = velocityRange2(j);
            surfaceTension = surfaceTensionRange(k);
            
            % Set the inlet velocities in the model
            model.physics('spf').feature('inl1').set('U0in', sprintf('%g[m/s]', v1));
            model.physics('spf').feature('inl2').set('U0in', sprintf('%g[m/s]', v2));
            model.multiphysics('tpf1').set('sigma',sprintf('%g[m/s]', surfaceTension));
            
            % Run the simulation for the current values
            model.study('std1').run();
            
            % Calculate flow rate ratio, Weber number, and Capillary number
            flowRateRatio = v1 / v2;
            rho = 1000; % Density of fluid (kg/m^3)
            L = 0.003;   % Characteristic length (m)
            mu = 0.00124; % Dynamic viscosity of fluid (Pa.s)
            % Weber number: We = (rho * v^2 * L) / surface tension
            weberNumber = (rho * (v1-v2)^2 * L) / surfaceTension;
            
            % Capillary number: Ca = (mu * v) / surface tension
            capillaryNumber = (mu * v2) / surfaceTension;
           
            % Store the calculated values in the CSV file
            fprintf(fileID, '%g,%g,%g,%g,%g,%g\n', v1, v2, surfaceTension, flowRateRatio, weberNumber, capillaryNumber);
            
            % Export the simulation results as images with zero-padded filenames
            animation = model.result.export('anim1');
            
            % Use zero-padding for file names
            imageFileName = fullfile(targetFolder, sprintf('%04d_v1_%03d_v2_%03d_tension_%03d.png',loopno, i, j, k));
            animation.set('imagefilename', imageFileName);
            
            
            % Export the animation or image
            animation.run;
            
            % Log progress
            fprintf('Exported animation for v1: %g m/s, v2: %g m/s, Surface tension: %g N/m\n', v1, v2, surfaceTension);
        end
    end
end

% Close the CSV file
fclose(fileID);

% Finish up and clear the model
% mphsave(model, 'your_model_file_modified.mph'); % Save the model if needed
ModelUtil.disconnect;
