function neighbors = rangeQuery(data, eps, gridindex, gridcount, gridcellsize, pid)

    gridloc = ceil(data(pid,:)/gridcellsize);
    gridi = gridloc(1);
    gridj = gridloc(2);
    
    [rdim1, rdim2] = size(gridcount);
    
    range = ceil(eps/gridcellsize);
    
    mingi = max(1, gridi - range);
    maxgi = min(rdim1, gridi + range);
    
    mingj = max(1, gridj - range);
    maxgj = min(rdim2, gridj + range);
    
    p1 = data(pid,:);
    

    maxneighbor = sum(sum(gridcount(mingi:maxgi, mingj:maxgj)));
    neighbors = zeros(1,maxneighbor);
    
    count = 0;
    
    for i = mingi:maxgi
        for j = mingj:maxgj
            
            for k = 1:gridcount(i,j)
                
                id = gridindex(i,j,k);
                p2 = data(id,:);
                dis = norm(p1-p2,2);
                if dis<=eps
                    
                    count = count + 1;
                    neighbors(1,count) = id;
                    
                end
                
            end
            
        end
    end
    
    
    neighbors = neighbors(1,1:count);
    
end
