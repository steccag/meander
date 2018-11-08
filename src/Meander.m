clear all
close all
clc

%1 -read input
filename = '../data/data.ini'
fileID = fopen(filename);
data_cell = textscan(fileID, '%f %*s', 'delimiter', ';');
data = cell2mat(data_cell);

Centerline_Length = data(1,1) % Meander wavelength
c_Fat = data(2,1)
c_Skew = data(3,1)
Radius0 = data(4,1)
sinuosity_obj= data(5,1)
valley_slope = data(6,1)
nmeanders = data(7,1)
imax = data(8,1)
jmax = data(9,1)
width = data(10,1)
baselevel = data(11,1)
mode = data(12,1)
bankfull_depth = data(13,1)
floodplain_mode = data(14,1)
bank_width= data(15,1)
bank_height= data(16,1)
create_floodplain_topography=data(17,1)
floodplain_imax = data(18,1)
floodplain_jmax = data(19,1)
n_x_cells = data(20,1)
n_y_cells = data(21,1)

fclose(fileID);

theta0 = Centerline_Length/(Radius0*2*pi);


%2 - integrate meander centerline and project it along the three cartesian
%directions (x - along the plain, downwards; y - in the transverse
%direction, towards the left if looking along x; z - upwards)
if mode ==1
    %call integration of center line line
    [svec, xvec, yvec, zvec] = integrate_meander_centerline(Centerline_Length, nmeanders, imax, baselevel, theta0, c_Fat, c_Skew, valley_slope);
    sinuosity = svec(end)/xvec(end)
elseif mode==2
%delta_sinuosity = sinuosity_function(Centerline_Length, nmeanders, imax, baselevel, theta0, c_Fat, c_Skew, valley_slope, sinuosity_obj);

    theta0_ini = 1.E-5;
    fun = @(theta0)delta_sinuosity_function(Centerline_Length, nmeanders, imax, baselevel, theta0, c_Fat, c_Skew, valley_slope, sinuosity_obj);
    theta0 = fsolve(fun,theta0_ini);
    Radius0 = Centerline_Length/(theta0*2*pi);
    
    [svec, xvec, yvec, zvec] = integrate_meander_centerline(Centerline_Length, nmeanders, imax, baselevel, theta0, c_Fat, c_Skew, valley_slope);
    sinuosity = svec(end)/xvec(end);
    Radius0
    theta0
end

figure(1)
plot(xvec, yvec)
grid on
axis equal

figure(2)
plot3(xvec, yvec, zvec)
grid on
view(-10,45)
%axis equal%




% 3 - Create a 3d object
n_add=0; %useless parameter as long as floodplain_mode is 1 or 2
[nvec, xmatr, ymatr, zmatr] = threeD_structure(svec, xvec, yvec, zvec, width, imax, jmax, theta0, Centerline_Length, c_Fat, c_Skew, valley_slope, bank_height, floodplain_mode, bank_width, n_add);






figure(3)
plot(xmatr, ymatr)
grid on
axis equal

figure(4)
plot3(xmatr, ymatr, zmatr)
grid on
view(-10,45)



% 4 - Create a bar structure
Theta = 0.225;
f_ds = 10;
bar_ampl = 0.5*bankfull_depth * width / Radius0 * sqrt(Theta)*f_ds;
zbars = forced_bars(bar_ampl, Centerline_Length, width, nvec, svec, imax, jmax, floodplain_mode, n_add);

% convert to vectors for scatter plots
[xmatr_vec, ymatr_vec, zmatr_vec, zbars_vec] = convert_to_vec(xmatr, ymatr, zmatr, zbars);


%now add the bar structure to the 3D structure
zmatr = zmatr + zbars;
zmatr_vec = zmatr_vec + zbars_vec;

figure(6)
scatter3(xmatr_vec, ymatr_vec, zbars_vec, 10*ones(size(zbars_vec)), zbars_vec)
grid on
view(-10,45)

figure(7)
scatter3(xmatr_vec, ymatr_vec, zeros(size(zbars_vec)), 10*ones(size(zbars_vec)), zbars_vec)
grid on
axis equal
view(0,90)

figure(8)
scatter3(xmatr_vec, ymatr_vec, zmatr_vec, 7*ones(size(zbars_vec)), zbars_vec)
grid on
view(-10,45)

if create_floodplain_topography==1 
% 4 - Create full DEM (plus floodplain)

    floodplain_left_margin = max(max(ymatr_vec));
    floodplain_right_margin = min(min(ymatr_vec));
    fp_upstr_bound = min(min(xmatr_vec));
    fp_downstr_bound = max(max(xmatr_vec));

    [xvec_fp, yvec_fp, zvec_fp] = create_floodplain(floodplain_left_margin, floodplain_right_margin, fp_upstr_bound, fp_downstr_bound, floodplain_imax, floodplain_jmax, valley_slope, baselevel);
    [x_fp, y_fp, z_fp] = create_floodplain2(xvec_fp, yvec_fp, zvec_fp, xmatr, ymatr);
    %	[x_fp_riv, y_fp_riv, z_fp_riv] = create_floodplain_river(xmatr, ymatr, xmatr_vec, ymatr_vec, zmatr_vec, xvec_fp, yvec_fp, zvec_fp);
    
    figure(9)
    scatter3(x_fp, y_fp, z_fp, 25*ones(size(z_fp)), z_fp)
    grid on
    hold on 
    
    plot3(xmatr, ymatr, -ones(size(zmatr)), '-k')
    view(0,90)

   xmatr_vec = [xmatr_vec' x_fp']';
   ymatr_vec = [ymatr_vec' y_fp']';
   zmatr_vec = [zmatr_vec' z_fp']';
   zbars_vec = [zbars_vec' zeros(size(z_fp'))]';
    
   figure(10)
   scatter3(xmatr_vec, ymatr_vec, zmatr_vec, 7*ones(size(zbars_vec)), zbars_vec)
   grid on
    view(-10,45)
    
end


if create_floodplain_topography==0 
    addpath C:\Users\steccag\Documents\OpenEarth\matlab\
    oetsettings 

    [svec_grid, xvec_grid, yvec_grid, zvec_grid] = integrate_meander_centerline(Centerline_Length, nmeanders, n_x_cells, baselevel, theta0, c_Fat, c_Skew, valley_slope);
    bank_width_grid = bank_width;
    n_add = floor(bank_width_grid / width * n_y_cells); %keep grid_spacing
    floodplain_mode3 = 3; %use the most flexible mode with multiple bank lines
    [nvec_grid, Xmesh, Ymesh, Zmesh] = threeD_structure(svec_grid, xvec_grid, yvec_grid, zvec_grid, width, n_x_cells, n_y_cells, theta0, Centerline_Length, c_Fat, c_Skew, valley_slope, bank_height, floodplain_mode3, bank_width_grid, n_add);
    zbars_mesh = forced_bars(bar_ampl, Centerline_Length, width, nvec_grid, svec_grid, n_x_cells, n_y_cells, floodplain_mode3, n_add);
    Zmesh = Zmesh + zbars_mesh;
    %[Xmesh, Ymesh, ~, ~] = convert_to_vec(xmatr_grid, ymatr_grid, zmatr_grid, zeros(size(zmatr_grid)));
   % zbars = forced_bars(bar_ampl, Centerline_Length, width, nvec, svec, imax, jmax, floodplain_mode, n_add);
    

    OK = wlgrid('write','FileName','..\grid_topo\MeanderGrid.grd','X',Xmesh,'Y',Ymesh,'AutoEnclosure');
    
    %MATRIX= [zmatr_vec];
    OK=wldep('write','..\grid_topo\MeanderTopo.dep',Zmesh)
elseif create_floodplain_topography==1 
    addpath C:\Users\steccag\Documents\OpenEarth\matlab\
    oetsettings 
    

    
    
    x_grid_spac = ( fp_downstr_bound - fp_upstr_bound) / n_x_cells;
    y_grid_spac = ( floodplain_right_margin - floodplain_left_margin) / n_y_cells;
    
    [Xmesh,Ymesh] = meshgrid(fp_upstr_bound:x_grid_spac:fp_downstr_bound, floodplain_left_margin:y_grid_spac:floodplain_right_margin);
    OK = wlgrid('write','FileName','..\grid_topo\MeanderGrid.grd','X',Xmesh,'Y',Ymesh,'AutoEnclosure');
    
        MATRIX= [xmatr_vec, ymatr_vec, zmatr_vec];
    OK=wldep('write','FileName','..\grid_topo\MeanderTopo.dep','',MATRIX)
end

%OK = WLGRID('write','PropName1',PropVal1,'PropName2',PropVal2, ...)
%   writes a grid file. The following property names are accepted when
%   following the write command
%     'FileName'        : Name of file to write
%     'X'               : X-coordinates (can be a 1D vector 'stick' of an
%                         orthogonal grid)
%     'Y'               : Y-coordinates (can be a 1D vector 'stick' of an
%                         orthogonal grid)
%     'Enclosure'       : Enclosure array
%     'AutoEnclosure'   : Use this keyword to automatically generate an
%                         enclosure from the fields 'X and 'Y' if you don't
%                         specify one.
%     'CoordinateSystem': Coordinate system 'Cartesian' (default) or
%                         'Spherical'
%     'Format'          : 'NewRGF'   - keyword based, double precision file
%                                      (default)
%                         'OldRGF'   - single precision file
%                         'SWANgrid' - SWAN formatted single precision file
%     'MissingValue'    : Missing value MV to be used for NaN coordinates.
%                         Any (X,Y) pair that matches (MV,MV) will be
%                         shifted slightly to avoid clipping, hence don't
%                         use MV to already mark clipped points in the X,Y
%                         datasets provided.
%
%   Accepted without property name: x-coordinates, y-coordinates and
%   enclosure array (in this order), file name, file format, coordinate
%   system strings 'Cartesian' and 'Spherical' (non-abbreviated).
%



