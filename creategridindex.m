function [gridindex, gridcount] = creategridindex(data, dim1, dim2, gridcellsize)

rdim1 = ceil(dim1/gridcellsize);
rdim2 = ceil(dim2/gridcellsize);

%estimate max number of points per grid cell (memory inefficient, import linked list from java if needed)
[ras, ~] = rasterize_density(data, ones(size(data,1),1), dim1, dim2, gridcellsize, []);
maxpts = max(max(ras));


% gridindex = cell(rdim1, rdim2);
gridindex = zeros(rdim1, rdim2, maxpts);
gridcount = zeros(rdim1, rdim2);%keep current index

for i = 1:size(data,1)
    
    gridloc = ceil(data(i,:)/gridcellsize);
    gridloc = max(gridloc, 1);
    
    x = gridloc(1);
    y = gridloc(2);
    
    gridcount(x,y) = gridcount(x,y) + 1;
    gridindex(x,y, gridcount(x,y)) = i;
    
end

% for i = 1:size(data,1)
%     
%     gridloc = ceil(data(i,:)/gridcellsize);
%     gridloc = max(gridloc, 1);
%     
%     if isempty(gridindex{gridloc(1), gridloc(2)})
%         gridindex{gridloc(1), gridloc(2)} = 
%     end
%     
% end
