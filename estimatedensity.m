function density_vec = estimatedensity(data, dim1, dim2, cellsize, k)

%set min max quantile/percentile in density distribution to consider
%following is an example working parameters for many different datasets
min_quantile = 0.5;
max_quantile = 0.95;

cellsize = cellsize*2;

%preprocess cellsizes and dimensions
rdim1 = ceil(dim1/cellsize);
rdim2 = ceil(dim2/cellsize);

rcellsize = [dim1/rdim1, dim2/rdim2];

count = zeros(rdim1, rdim2);

for i = 1:size(data, 1)
    
    gridloc = ceil(data(i,:)./rcellsize);
    gridloc = max(gridloc, 1);
    count(gridloc(1), gridloc(2)) = count(gridloc(1), gridloc(2)) + 1;
    
end

density = count(:,:)/(rcellsize(1)*rcellsize(2));
density = imgaussfilt(density);
density = sort(density(:));

vec_len = rdim1*rdim2;

quantile_step = (max_quantile - min_quantile)/k;

density_vec = zeros(k,1);

for i = 1:k
    
    q = min_quantile + quantile_step*i;
    id = round(q*vec_len);
    density_vec(i) = density(id);
    
end
