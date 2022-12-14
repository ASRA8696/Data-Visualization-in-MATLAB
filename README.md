# Import-external-simulation-data-in-MATLAB

Computational Fluid Dynamics [CFD] Simulations often result in huge data sets which needs to be visualized. Proprietary packages come with an inbuilt post processing
engine for visualization. However here we explore how one can port an external simulation data onto MATLAB to prepare a surface plot over a given topology

In order to generate the contour 'patch' function is utilized which requires the topological structure of the grid and geometry. Thus, geometrical data is exported from 
from ANSYS CFX-Post. This data holds the coordinate of each node and the connections among nodes for each element face. 

CONTOUR PLOT

![contour](https://user-images.githubusercontent.com/79316741/201527446-3d3d8a1d-d296-4b70-be53-036092731e0e.jpg)
