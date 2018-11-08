function [nvec, xmatr, ymatr, zmatr] = threeD_structure(svec, xvec, yvec, zvec, width, imax, jmax, theta0, Centerline_Length, c_Fat, c_Skew, valley_slope, bank_height, floodplain_mode, bank_width,n_add)

[j1, jend, jfin] = get_j_limits(jmax, floodplain_mode, n_add);


nvec=zeros(1, jfin);
xmatr=zeros(imax, jfin);
ymatr=zeros(imax, jfin);
zmatr=zeros(imax, jfin);

% this part is common to both bank modes
% and sets base bed level in the central river region
%(ouside the banks)

for j = j1: jend
    nvec(1,j) = - 0.5*width + width * (j - j1)/(jend-j1);     
end

for i=1:imax
    s= svec(i,1);
    theta = Kinoshita(s, theta0, Centerline_Length, c_Fat, c_Skew);
    
    for j = j1: jend
      xmatr(i, j) = xvec(i, 1) - sin(theta) * nvec(1,j);
      ymatr(i, j) = yvec(i, 1) + cos(theta) * nvec(1,j);
      zmatr(i, j) = zvec(i, 1) + sin(theta) * nvec(1,j) * valley_slope - bank_height;
    end
end

if floodplain_mode==2
    % set a line of points on each bank's edge
    j=1;
    nvec(1,j) = - 0.5*width - bank_width;     
    for i=1:imax
        s= svec(i,1);
        theta = Kinoshita(s, theta0, Centerline_Length, c_Fat, c_Skew);
        
        xmatr(i, j) = xvec(i, 1) - sin(theta) * nvec(1,j);
        ymatr(i, j) = yvec(i, 1) + cos(theta) * nvec(1,j);
        zmatr(i, j) = zvec(i, 1) + sin(theta) * nvec(1,j) * valley_slope;
    end
        
    j=jfin;
    nvec(1,j) = 0.5*width + bank_width;     
    for i=1:imax
        s= svec(i,1);
        theta = Kinoshita(s, theta0, Centerline_Length, c_Fat, c_Skew);

          xmatr(i, j) = xvec(i, 1) - sin(theta) * nvec(1,j);
          ymatr(i, j) = yvec(i, 1) + cos(theta) * nvec(1,j);
          zmatr(i, j) = zvec(i, 1) + sin(theta) * nvec(1,j) * valley_slope;

    end
end


if floodplain_mode==3
    % set a line of points on each bank's edge
    for j=1:j1-1
        nvec(1,j) = - 0.5*width + width * (j - j1)/(jend-j1);     
        for i=1:imax
            s= svec(i,1);
            theta = Kinoshita(s, theta0, Centerline_Length, c_Fat, c_Skew);
        
            xmatr(i, j) = xvec(i, 1) - sin(theta) * nvec(1,j);
            ymatr(i, j) = yvec(i, 1) + cos(theta) * nvec(1,j);
            zmatr(i, j) = zvec(i, 1) + sin(theta) * nvec(1,j) * valley_slope - bank_height*(j-1)/(j1-1);
        end
         %   j
         %   - bank_height*(j-1)/(j1-1)
         %   pause
    end
    
    for j=jend+1:jfin
        nvec(1,j) = - 0.5*width + width * (j - j1)/(jend-j1);     
        for i=1:imax
            s= svec(i,1);
            theta = Kinoshita(s, theta0, Centerline_Length, c_Fat, c_Skew);

            xmatr(i, j) = xvec(i, 1) - sin(theta) * nvec(1,j);
            ymatr(i, j) = yvec(i, 1) + cos(theta) * nvec(1,j);
            zmatr(i, j) = zvec(i, 1) + sin(theta) * nvec(1,j) * valley_slope + bank_height*(j - jfin )/(jfin - jend );
        end
       %   j
       %   + bank_height*(j - jfin )/(jfin - jend )
       %    pause
     end
end



end