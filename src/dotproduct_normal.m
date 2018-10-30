function result = dotproduct_normal(v,w)
% This function computes the dot product of a vector v by the normal
% vector to another vector w
%the result is positive if w is rotated in the countercloackwise direction
%compared to the direction given by v
% all vectors are 2D


% compute the normal to v, that indicates a 90 degree counter clockwise
% rotation with respect to v

%v
%pause

modv= sqrt( v(1,1)^2 + v(1,2)^2);
%modv
%pause

v = v/ modv;
%v
%pause

%pause

nv = [-v(1,2) , v(1,1)] ;


modw = sqrt(w(1,1)^2+w(1,2)^2);

w(1,:) = w(1,:)/modw;


% compute the dot product
result = nv(1,1)*w(1,1)+nv(1,2)*w(1,2);


end