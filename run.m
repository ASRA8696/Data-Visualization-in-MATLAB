%
% Description
% ===========
% 
% This script reads simulation data generated from CFX-Post. The data
% represents a pressure distribution on a rotor surface. The rotor is a
% cylinder. The user should export pressure data on the rotor surface
% together with the geometry information. The exported file could be a CSV
% file. The user can load this CSV file into Microsoft Excel. And then
% copy the columns of pressure and surface geometry data into two separate 
% Matlab scripte files. One is get_node_p.m and the other is get_faces.m.
%
% This scripte reads back the two files and plot a pressure contour. The
% contour is on the unfold 2D x-theta plane, which is originaly a cylinder
% surface. The theta coordinates are calculated from the Cartesian
% coordinates of the surface nodes. Then, the issue of 0/2pi is properly
% handled.
%
% 


clear all
close all
clc

% Set searching directory.
restoredefaultpath;

% Constants.
NUM_NODES_PER_FACE = 4;
ONE_SEC_PI         = pi / 2;
TWO_PI             = 2 * pi;
THREE_SEC_PI       = 1.5 * pi; 
THETA_LEN          = 2*pi/100 * 2;

% ========= Reload the node, presure and faces data. =========

% Load from prepared matlab file.
get_node_p;
get_faces;

% Re-arange the data.
node_x = node_P(:,1); % node_P is from get_node_p.
node_y = node_P(:,2);
node_z = node_P(:,3);
node_p = node_P(:,4);

maxP = max(node_p);
minP = min(node_p);
maxX = max(node_x);
minX = min(node_x);

clear node_P;
x = node_x;
clear node_x;

theta = get_angle(node_y, node_z);
clear node_y;
clear node_z;

faces = faces + 1; % faces is from get_faces.

% ============== Handle the 0/2pi issue. =============

[nFaces] = size(faces, 1);

nChanged      = 0;
idxBuffer     = [];
idxZeroBuffer = [];
rowBuffer     = [];

for I = 1:1:nFaces
    % Get the index
    idx = faces(I, :);
    
    % Get the angles.
    a = theta(idx);
    
    % Check.
    idxZero  = (abs(a) < ONE_SEC_PI);
    idxFirst = (abs(a) < THETA_LEN );
    idxBig   = (a > THREE_SEC_PI);
    
    sIdxZero  = sum(idxZero);
    sIdxFirst = sum(idxFirst);
    sIdxBig   = sum(idxBig);
    
    if ( sIdxZero >0 && sIdxBig > 0 && sIdxBig < 4 && sIdxZero + sIdxBig == 4)
        
        idxBuffer     = [idxBuffer;idx];
        idxZeroBuffer = [idxZeroBuffer;idxZero'];
        rowBuffer     = [rowBuffer;I];
        
        fprintf('I = %d, a = [ %e, %e, %e, %e]\n', I, a(1), a(2), a(3), a(4));
        nChanged = nChanged + 1;
    end 
end % I

fprintf('nChanged = %d\n', nChanged);

for I = 1:1:nChanged
    row = rowBuffer(I,1);
    
    faces(row, :) = faces(1, :);
end % I

vertices = [x, theta / pi];

% ================ Check maximum face area. ========================

maxFaceArea = 0;
maxFaceIdx  = 0;

for I = 1:1:nFaces
    idx      = faces(I, :);
    faceX    = x(idx);
    faceT    = theta(idx);
    maxFaceX = max(faceX);
    minFaceX = min(faceX);
    maxFaceT = max(faceT);
    minFaceT = min(faceT);
    areaFace = ( maxFaceX - minFaceX ) * (maxFaceT - minFaceT);
    
    if ( areaFace > maxFaceArea )
        maxFaceArea = areaFace;
        maxFaceIdx  = I;
    end
end % I

fprintf('maxFaceArea = %e,idx = %d\n', maxFaceArea, maxFaceIdx);

% ==================== Patch plot. ======================

% Create a new figure.
h = figure;

% Patch.
p = patch('Faces', faces, 'Vertices', vertices);
set(gca, 'CLim', [minP, maxP]);
set(p,...
    'FaceColor', 'interp',...
    'FaceVertexCData', node_p,...
    'CDataMapping', 'scaled',...
    'EdgeColor', 'flat',...
    'LineStyle', 'none');
colorbar;

% Set the labels and title of the patch plot.
xlabel('axial location (m)',...
    'Interpreter', 'Latex',...
    'FontSize', 16);
ylabel('circumferential position ($ \pi $)',...
    'Interpreter', 'Latex',...
    'FontSize', 16);
title('Pressure on rotor surface (Pa)',...
    'FontSize', 16,...
    'FontName', 'Time New Rome');


