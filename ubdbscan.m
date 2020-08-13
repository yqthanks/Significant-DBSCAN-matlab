function maxcomponent = ubdbscan(qgrid, minpts, neighborhood, maxthrd)

%maxthrd is the maximum number of points of a detected cluster, if exceeds, directly
%break

[dim1, dim2] = size(qgrid);
r = floor(neighborhood/2);

%first scan, find core grid cells
coremap = zeros(dim1, dim2);

%use integral image
intimg = generateii(qgrid);

for i = 1:dim1
    for j = 1:dim2
        
        if qgrid(i,j) > 0
            
            i0 = max(1, i-r);
            i1 = min(dim1, i+r);
            j0 = max(1, j-r);
            j1 = min(dim2, j+r);
            %use integral image
            quad_ub = computeii(intimg, i0, j0, i1, j1);
%             quad_ub = sum(sum(qgrid(i-r:i+r,j-r:j+r)));

            if quad_ub>minpts
                coremap(i,j) = 1;
            end
        end
        
    end
end

maxcomponent = 0;

visited = zeros(dim1,dim2);

for i = 1:dim1
    for j = 1:dim2
        
        if coremap(i,j)==1 && visited(i,j)==0
        
%             localbmap = zeros(dim1,dim2);
            
            npts = [i j];
            k = 1;
            
            %expand to all ub_cores
            while true
                
                ci = npts(k,1);
                cj = npts(k,2);
                
                if visited(ci,cj)==0
                    visited(ci,cj)=1;
                    
                    i0 = max(1, ci-r);
                    i1 = min(dim1, ci+r);
                    j0 = max(1, cj-r);
                    j1 = min(dim2, cj+r);
                    
                    [row,col] = find(coremap(i0:i1, j0:j1));
%                     [row,col] = find(coremap(ci-r:ci+r,cj-r:cj+r));

                    row = row + i0-1;
                    col = col + j0-1;
%                     row = row + ci-r-1;
%                     col = col + cj-r-1;
                    npts = [npts; [row col]];
                end
                
                k = k+1;
                if k>size(npts,1)
                    break;
                end
                
            end
            
            %count number of ub_points
            %get unique elements
            npts_linear = (npts(:,1)-1).*dim2 + npts(:,2);
            npts_linear_unique = unique(npts_linear);
            npts_unique = [ceil(npts_linear_unique/dim2), mod(npts_linear_unique,dim2)];
            
            %enumerate through array
            countvisit = zeros(dim1,dim2);
            
            localcount = 0;
            for id = 1:size(npts_unique,1)
                
                i0 = max(1, npts_unique(id,1)-r);
                i1 = min(dim1, npts_unique(id,1)+r);
                j0 = max(1, npts_unique(id,2)-r);
                j1 = min(dim2, npts_unique(id,2)+r);
                for ii = i0 : i1
                    for jj = j0 : j1
%                 for ii = npts_unique(id,1)-r : npts_unique(id,1)+r
%                     for jj = npts_unique(id,2)-r : npts_unique(id,2)+r
                        if countvisit(ii,jj)==0
                            countvisit(ii,jj)=1;
                            localcount = localcount + qgrid(ii,jj);
                        end
                    end
                end
                
            end
            
            maxcomponent = max(maxcomponent, localcount);
            
            if maxcomponent > maxthrd
                break;
            end
            
        end
        
    end
end