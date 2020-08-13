function [idx, noise] = DBSCAN(data, eps, minpts, gridcellsize, dim1, dim2)
%this version is for 2d data, space will be exponential in
%number of dimension, be careful with high dimensions
%using a grid index

    if ~exist('gridcellsize','var')
        gridcellsize = 2;%change for case study
    end
    
    if ~exist('dim1','var')
        dim1 = 100;
    end
    
    if ~exist('dim2','var')
        dim2 = 100;
    end

    n=size(data,1);
    idx=zeros(n,1);
    max_idx=0;
    
    visited=false(n,1);
    noise=false(n,1);

    [gridindex, gridcount] = creategridindex(data, dim1, dim2, gridcellsize);
    
    for i=1:n
        if ~visited(i)
            visited(i)=true;
                        
            neighbors=rangeQuery(data, eps, gridindex, gridcount, gridcellsize, i);
            if numel(neighbors)<minpts
                noise(i)=true;
            else
                max_idx=max_idx+1;
                expand(i,neighbors,max_idx);
            end
            
        end
    
    end
    
    function expand(i,neighbors,max_idx)
        idx(i)=max_idx;
        
        k = 1;
        while true
            j = neighbors(k);
            
            if ~visited(j)
                visited(j)=true;
                neighbors2=rangeQuery(data, eps, gridindex, gridcount, gridcellsize, j);
                if numel(neighbors2)>= minpts
                    
                    %add set difference to remove redundancy
%                     newneighbors = setdiff(neighbors2,neighbors)
%                     neighbors=[neighbors newneighbors];
                    %this has visited information
                    neighbors = [neighbors neighbors2];
                end
            end
            if idx(j)==0
                idx(j)=max_idx;
            end
            
            k = k + 1;
            if k > numel(neighbors)
                break;
            end
        end
    end

end



