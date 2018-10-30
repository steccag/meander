function [x_fp, y_fp, z_fp] = create_floodplain2(xvec_fp, yvec_fp, zvec_fp, xmatr, ymatr)
    floodplain_imax  = size(zvec_fp,1)
    floodplain_jmax  = size(yvec_fp,2)
  %  x_fp = zeros(floodplain_imax*floodplain_jmax,1);
  %  y_fp = zeros(floodplain_imax*floodplain_jmax,1);
  %  z_fp = zeros(floodplain_imax*floodplain_jmax,1);
    
    jfin = size(xmatr,2);
    n_sez_river = size(xmatr,1);
    
    k=1;
    for i = 1: floodplain_imax
        for j = 1: floodplain_jmax
            internal = 0;
            for l =1: n_sez_river-1
                quad_points = [xmatr(l,1), ymatr(l,1); xmatr(l+1,1), ymatr(l+1,1); xmatr(l+1,jfin), ymatr(l+1,jfin); xmatr(l,jfin), ymatr(l,jfin)];
                % oggetto (4,2)
                point = [xvec_fp(i,1), yvec_fp(1,j) ];
                % oggetto 1,2
                result = check_internal(point, quad_points);
                internal = max(internal, result);
                %internal
               % if internal ==0
                
 
            end
                if(internal ==0)
                     x_fp (k,1) = xvec_fp(i,1);
                     y_fp (k,1) = yvec_fp(1,j);
                     z_fp (k,1) = zvec_fp(i,1);
             
                     k=k+1;    
                end
%            ! aggiungere correzione con buco dove c'è il fiume
           
        end
    end


end