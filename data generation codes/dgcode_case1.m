% Load COMSOL model
import com.comsol.model.*
import com.comsol.model.util.*

% Initialize COMSOL and load the model file
model = mphload('F:\COMSOL\2_copy.mph'); % Replace with your COMSOL model filename

% Set the folder where to save the animations
targetFolder = 'F:/COMSOL/data3/'; % Replace with the actual target folder path

% Setting velocity ranges
velocityRange1 = linspace(0.005, 0.05, 10);  
velocityRange2 = linspace(0.0005, 0.005, 10);  

% Initialize the CSV file
csvFileName = fullfile(targetFolder, 'simulation_data.csv');
fileID = fopen(csvFileName, 'w');

% Write the header to the CSV file
header = 'v1 (m/s),v2 (m/s),Surface Tension (N/m),v1/v2,Weber Number,Capillary Number\n';
fprintf(fileID, header);

% Loop over each combination of v1, v2, and surface tension
loopno = 0;
for i = 1:length(velocityRange1)
    for j = 1:length(velocityRange2)
        loopno = loopno + 1;

        % Setting current values of v1, v2, and surface tension
        v1 = velocityRange1(i);
        v2 = velocityRange2(j);
        surfaceTension = 0.005*v2/0.002;
        
        % Setting the inlet velocities and surface tension in the model and
        % running the simulation for current values
        model.physics('spf').feature('inl1').set('U0in', sprintf('%g[m/s]', v1));
        model.physics('spf').feature('inl2').set('U0in', sprintf('%g[m/s]', v2));
        model.multiphysics('tpf1').set('sigma',sprintf('%g[m/s]', surfaceTension));
        model.study('std1').run();
        
        %Defining material properties of simulation
        rho = 1000; % Density of fluid (kg/m^3)
        L = 0.003;   % Characteristic length (m)
        mu = 0.00124; % Dynamic viscosity of fluid (Pa.s)

        % Calculate flow rate ratio, Weber number, and Capillary number and
        % storing them in CSV file
        flowRateRatio = v1 / v2;
        weberNumber = (rho * (v1-v2)^2 * L) / surfaceTension;
        capillaryNumber = (mu * v2) / surfaceTension;
        fprintf(fileID, '%g,%g,%g,%g,%g,%g\n', v1, v2, surfaceTension, flowRateRatio, weberNumber, capillaryNumber);
        
        % Exporting the simulation results as set of images
        animation = model.result.export('anim1');
        imageFileName = fullfile(targetFolder, sprintf('%04d_v1_%g_v2_%g_tension_%g.png',loopno, v1, v2, surfaceTension));
        animation.set('imagefilename', imageFileName);
        animation.run;
        
        % Log progress
        fprintf('Exported animation for v1: %g m/s, v2: %g m/s, Surface tension: %g N/m\n', v1, v2, surfaceTension);  
    end
end

% Close the CSV file
fclose(fileID);

% Finish up and clear the model
% mphsave(model, 'your_model_file_modified.mph'); % Save the model if needed
ModelUtil.disconnect;
