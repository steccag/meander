function [x_matr_vec, y_matr_vec, z_matr_vec, z_bars_vec] = convert_to_vec(x_matr, y_matr, z_matr, z_bars)

imax = size(x_matr,1);
jfin = size(x_matr,2);



kmax = imax*jfin;
x_matr_vec= zeros(kmax,1);
y_matr_vec= zeros(kmax,1);
z_matr_vec= zeros(kmax,1);
x_bars_vec= zeros(kmax,1);

k=1;

for i =1:imax
    for j= 1:jfin
        
        x_matr_vec(k,1) =x_matr(i,j);
        y_matr_vec(k,1) =y_matr(i,j);
        z_matr_vec(k,1) =z_matr(i,j);
        z_bars_vec(k,1) =z_bars(i,j);

        k=k+1;
    end
end



end