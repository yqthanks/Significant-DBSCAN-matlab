function sig_vec = sigdb_mcs(ncluster_vec, eps, minpts, n, dim1, dim2, m, siglvl, ras, cellsize, mode, eps_div)
%may add a raster input later to constrain space for random point
%distribution

%can be easily parallelized with "parfor" (some variables need update to avoid dependency)
%contact xiexx347@umn.edu if parallel version is needed

%mode is for acceleration
%0 - no acceleration
%1 - upper bound only
%2 - early termination only
%3 - both
%4 - add lower bound --> not as effective as upper bound

if exist('mode','var')
   mode = round(mode);
   if mode<0 || mode>10
       fprintf('Invalid mode input! %d, using mode = 3\n', mode);
       mode = 3;
   end
else
    mode = 3;
end

if ~exist('eps_div','var')
    eps_div = 0.25;
end

nlist = zeros(m,1);
vec_len = max(size(ncluster_vec));

%early termination vector
geq_vec = zeros(vec_len,1);

%significance result vector
sig_vec = zeros(vec_len,1);

%get another vec to store quad-eps-cell bounds (another one is geq_vec)
% quad_vec = zeros(vec_len,1);

%evaluate how effective is the filter
ub_works = 0;

for t = 1:m
    
    %raster is used to constrain 2D space of point distribution for case
    %studies; can be ignored for synthetic data
    if max(size(ras))==0
        rdis = ran2d(dim1, dim2, n);
    else
        rdis = rdis_raster(dim1, dim2, n, ras, cellsize);
    end
    
    local_ub_id = 0;%zeros(vec_len,1);
    
    %activate upper bound
    if mode == 1 || mode == 3 || mode == 4
    
        max_ub = getub(rdis, eps, minpts, dim1, dim2, eps_div, ncluster_vec(1));

%         %test effectiveness of upper bound
%         if mod(t,20)==0
%             fprintf('ub_works rate: %2.2f%%\n', ub_works/t*100);
%         end

        ub_bounded = ncluster_vec > max_ub;
        local_ub_id = sum(double(ub_bounded));
        nonsig_count = sum(double(geq_vec >= siglvl*m));
        if sum(double(ub_bounded)) >= vec_len - nonsig_count
            ub_works = ub_works + 1;
            continue;%no need for further checking
        end
        
    end
    
    %activate lower bound (not recommended unless small grid cells are
    %used)
    if mode == 4
        
        %exclude the ub-bounded ones and only check the rest
        left_max_id = local_ub_id + 1;
        max_lb = getlb(rdis, eps, minpts, dim1, dim2, eps_div, ncluster_vec(left_max_id));
        
        %if even the lower bound is greater than this max, then there is no
        %need for exact run
        if max_lb >= ncluster_vec(left_max_id)
            
            geq_vec(left_max_id:end) = geq_vec(left_max_id:end) + 1;
            
            if geq_vec(1) >= siglvl*m
                fprintf('terminated at t=%d\n', [t]);
                break;
            end
            
            continue;
            
        end
    end
    
    %exact DBSCAN
    idx=DBSCAN(rdis, eps, minpts, cellsize, dim1, dim2);
    
    maxid = max(idx);
    
    
    for j = 1:maxid
        check = (idx==j);
        nlist(t) = max(nlist(t), sum(double(check)));
    end
    
    for j = 1:vec_len
        if nlist(t) >= ncluster_vec(j)
            geq_vec(j) = geq_vec(j) + 1;
        end
        
    end
    
    if mode == 2 || mode == 3 || mode == 4

        if geq_vec(1) >= siglvl*m
            fprintf('terminated at t=%d\n', [t]);
            break;
        end
        
    end
    
    if n >= 1000
        if mod(t,20)==0
            fprintf('mcs_data_size: %d, msc_trial_id: %d\n', [n,t]);%disp(t);
        end
    end
end

sig_vec = double(geq_vec < siglvl*m);

end