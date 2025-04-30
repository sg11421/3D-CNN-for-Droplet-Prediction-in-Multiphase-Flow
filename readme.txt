# Droplet Prediction in Multiphase Flow via 3D CNN

## Repository Structure

### `simulation/`
This folder contains the COMSOL file of our simulation.

### `data generation codes/`
This folder contains the MATLAB scripts used to automatically generate data from the COMSOL file for both use cases.

### `data/`
This folder contains all the image data generated during the project, along with the labels obtained using the simulation file.

### `model codes/`
This folder contains the Jupyter notebooks with code for extracting the generated data, training, and evaluating 3D CNN models on the train and test datasets for both use cases.

### `models/`
This folder contains the trained 3D CNN models.

### `results/`
This folder contains the final results, showing both the actual values and the predictions made by the model.

### `plots/`
This folder contains all the plots created for visualizing the results.


