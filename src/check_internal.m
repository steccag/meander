function internal = check_internal(point, polygon_points)
%checks if a point is intenal to a convex polygon-
%polygon_points must be giben in counter_clockwise order
%both point and polygon_points are 2D on input and converted to 3D here
%as needed





npol = size(polygon_points,1);

%if (size(polygon_points,2))==2
%    polygon_points(:,3) = 0;
%end
%if (size(point,2))==2
%    point(:,3) = 0;
%end
polygon_points(npol+1,:)=polygon_points(1,:);

%plot(point(1,1), point(1,2), '*k')
%hold on
%plot(polygon_points(:,1), polygon_points(:,2), '-ob')
%hold off

for ipoint =1: npol
    % compute vectors
    vector(ipoint,:)=polygon_points(ipoint+1,:)-polygon_points(ipoint,:);
end
vector(ipoint+1,:) = vector(1,:);

internal = 1;
for ipoint =1: npol
    %check counter clockwise order
    %if dotproduct_normal(vector(ipoint,:), vector(ipoint+1,:))<0
    %    vector(ipoint,:)
    %    vector(ipoint+1,:)
    %    result = dotproduct_normal(vector(ipoint,:), vector(ipoint+1,:));
    %    result
    %    size(result)
    %   error('polygon_points must be given in counter-clockwise order')
    %end
    vector_test = point - polygon_points(ipoint,:);
    result = dotproduct_normal(vector(ipoint,:), vector_test);
   % result
    if result<0 
        %external
        internal = internal *0;
    end
    

end
%    if (internal>0)
%internal
 %       pause
%    end
%pause

end
