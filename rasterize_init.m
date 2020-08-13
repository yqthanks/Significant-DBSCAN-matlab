function [ras, cellsize] = rasterize_init(data, remove, dim1, dim2, eps, ras)

cellsize = eps;

rdim1 = ceil(dim1/cellsize);
rdim2 = ceil(dim2/cellsize);

ext = 1;

if max(size(ras)) == 0
    ras = zeros(rdim1, rdim2);
end

for i = 1:size(remove, 1)
    
    if remove(i) == 1
        
        gridloc = ceil(data(i,:)/cellsize);
        gridloc = max(gridloc, 1);
        
        mingridi = max(gridloc(1) - ext, 1);
        maxgridi = min(gridloc(1) + ext, rdim1);
        mingridj = max(gridloc(2) - ext, 1);
        maxgridj = min(gridloc(2) + ext, rdim2);
        
        ras(mingridi:maxgridi, mingridj:maxgridj) = 1;
    end
    
end

ras = abs(ras - 1);