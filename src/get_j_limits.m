function [j1, jend, jfin] = get_j_limits(jmax, floodplain_mode,n_add)

if floodplain_mode==1
    j1 =1;
    jend = jmax;
    jfin = jmax;
elseif floodplain_mode==2
    j1 =2;
    jend = jmax+1;
    jfin = jmax+2;
elseif floodplain_mode==3
    j1 =n_add+1;
    jend = jmax+n_add;
    jfin = jmax+2*n_add;
else
    disp('Error flooddplain_mode')
end

end