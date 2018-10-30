function [xvec_floodplain, yvec_floodplain, zvec_floodplain] = create_floodplain(floodplain_left_margin, floodplain_right_margin, fp_upstr_bound, fp_downstrean_bound, floodplain_imax, floodplain_jmax, valley_slope, baselevel)

floodplain_width = floodplain_left_margin - floodplain_right_margin
dy = floodplain_width / (floodplain_jmax-1)
floodplain_length = fp_downstrean_bound - fp_upstr_bound
dx = floodplain_length / (floodplain_imax-1)

xvec_floodplain = zeros(floodplain_imax,1);
zvec_floodplain = zeros(floodplain_imax,1);
yvec_floodplain = zeros(1,floodplain_jmax);

for i = 1:floodplain_imax
    xvec_floodplain(i,1)= fp_upstr_bound +(i-1)*dx;
    zvec_floodplain(i,1)= - xvec_floodplain(i,1)*valley_slope;  
end
zvec_floodplain = zvec_floodplain + baselevel;
for j =1:floodplain_jmax
    yvec_floodplain(1,j)= floodplain_right_margin +(j-1.)*dy;
end
