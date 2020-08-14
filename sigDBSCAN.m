function [cluster_idx] = sigDBSCAN(data, dim1, dim2, m, siglvl, mode, eps_div)

%mode is for acceleration
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

%%%%%%%%%%%%%%%%%%%%%%User inputs preferred%%%%%%%%%%%%%%%%%%%%%%%%

%number of densities to consider
n_density = 5;
%a range of eps and step-size to consider
eps_vec = [2:0.5:5]'/100*(dim1+dim2)/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%max number of candidates (e.g., in density or eps selection) to consider
max_candidate_thrd = 100;

%init ras, only used for eliminating invalid 2D areas in case studies (prevent points from being generated at those places)
init_ras = 0;

%display trends of cluster-size change during paramter selection? for testing only
display_trend = 0;
trends = zeros(n_density, size(eps_vec,1));

%proportion criteria
%minimum increase in average cluster size needed to change choice of
%parameters
min_imp_thrd = 0.1;

%get density criteria (for finding multiple clusters)
%density range defined in "estimatedensity" function, can be changed
density_vec = estimatedensity(data, dim1, dim2, mean(eps_vec), n_density);%mean(eps_vec)%max(eps_vec)
density_vec = sort(density_vec, 'desc');

fprintf('density_vec:\n');
disp(density_vec);

%convert density criteria to a list of (eps, minpts)
minpts_mat = getminpts(density_vec, eps_vec);

fprintf('minpts_mat:\n');
disp(minpts_mat);

%vector storing output cluster ids for each point
cluster_idx = [];%format: x,y,idx

%default not initiating ras; this can be ignored for synthetic data
ras = [];
cellsize = max(eps_vec);
%initiating ras
if init_ras == 1
    
    cellsize = mean(eps_vec);
    ras = rasterize_init(data, ones(size(data, 1), 1), dim1, dim2, cellsize, []);
    
end

i = 0;
while i<n_density
    
    i = i + 1;
    
    n = size(data,1);
    
    local_idx = zeros(size(data,1),1);
    local_count = [];

    best_combo = [];
    best_j = 0;
    best_i = 0;

    fprintf('searching for best combo...\n');
    for j = 1:max(size(eps_vec))
        
        [idx,~] = DBSCAN(data, eps_vec(j), minpts_mat(i,j), cellsize, dim1, dim2);
        
        if max(idx) > 0
            %time for this is secondary, can be easily improved if needed;
            [uidx,~,icidx] = unique(idx);
            u_count = [uidx, accumarray(icidx,1)];
            u_count = sortrows(u_count);
            if u_count(1,1) == 0
                u_count = u_count(2:end,:);
            end

            if j == 1
                local_idx = idx(:,:);
                local_count = u_count(:,:);

                %save data for trend visualization
                u_count_mean = mean(u_count(:,2));
                trends(i,j) = u_count_mean;

                continue;
            end
            
            %may add max size so that it won't be affected much by increased
            %number of clusters
            
            max_candidate = min([size(u_count,1), size(local_count,1), max_candidate_thrd]);
            
            %save data for trend visualization
            u_count_mean = mean(u_count(:,2));
            local_count_mean = mean(local_count(:,2));
            trends(i,j) = u_count_mean;

            if max(size(local_count)) == 0 || (u_count_mean - local_count_mean)/local_count_mean > min_imp_thrd
                local_idx = idx(:,:);
                local_count = u_count(:,:);
            else
                best_combo = [eps_vec(j-1); minpts_mat(i,j-1)];
                best_j = j-1;
                best_i = i;%not varying i
                fprintf('best_combo: \n');
                disp(best_combo);
                break;
            end
            
        else
            
            if max(local_idx)>0
                best_combo = [eps_vec(j-1); minpts_mat(i,j-1)];
                best_j = j-1;
                best_i = i;%not varying i
                fprintf('best_combo: \n');
                disp(best_combo);
                break;
            end

        end
        
        if j == max(size(eps_vec))
            best_combo = [eps_vec(j); minpts_mat(i,j)];
            best_j = j;
            best_i = i;%not varying i
            fprintf('best_combo: \n');
            disp(best_combo);
        end
        
    end
    
    if max(local_idx)>0
        
        while i<n_density
            i = i + 1;

            [idx_c,~] = DBSCAN(data, eps_vec(best_j), minpts_mat(i,best_j), cellsize, dim1, dim2);
            [uidx_c,~,icidx_c] = unique(idx_c);
            u_count_c = [uidx_c, accumarray(icidx_c,1)];
            u_count_c = sortrows(u_count_c);
            if u_count_c(1,1) == 0
                u_count_c = u_count_c(2:end,:);
            end
            
            %may use max size instead so that it won't be affected much by increased
            %number of clusters
            
            max_candidate = min([size(u_count_c,1), size(local_count,1), max_candidate_thrd]);
            u_count_c_mean = mean(u_count_c(:,2));
            local_count_mean = mean(local_count(:,2));

            if (u_count_c_mean - local_count_mean)/local_count_mean > min_imp_thrd
                local_count = u_count_c(:,:);
                local_idx = idx_c;
                best_i = i;
            else
                fprintf('density reaching: %d\n', i-1);
                break;
            end
            
        end
        
        local_count = sortrows(local_count,2,'desc');
        cluster_vec = local_count(:,2);

        %plot the trends for eps
        if display_trend == 1
            figure, plot(1:j, trends(i,1:j));%size(eps,1)
        end

%         fprintf('local_count...\n');
%         disp(local_count);

        fprintf('start significance testing for density = %f\n', density_vec(best_i));
        sigtest_vec = sigdb_sigtest(cluster_vec, eps_vec(best_j), minpts_mat(best_i,best_j), n, dim1, dim2, m, siglvl, ras, cellsize, mode);

        local_count = [local_count, sigtest_vec];

        fprintf('testing results for top 5 candidates...\n');
        disp(local_count(1:min(size(local_count,1), 5), :));

        %remove significant clusters
        fprintf('start removing clusters...\n');

        if sum(sigtest_vec)>0
            
            removelist = zeros(n,1);
            for cid = 1:size(local_count,1)

                if local_count(cid,3) == 1
                    remove_id = local_count(cid,1);
                    removelist(local_idx == remove_id) = 1;
                else
                    break;
                end

            end

            maxid = 0;
            if max(size(cluster_idx)) > 0
                maxid = max(cluster_idx(:,3));
            end
            local_idx = local_idx + maxid;
            cluster_idx = [cluster_idx; [data(removelist == 1,:), local_idx(removelist == 1)]];
            
            %update raster to exclude space covered by significant
            %clusters
            [ras, cellsize] = rasterize(data, removelist, dim1, dim2, cellsize, ras);%max(eps_vec)

            data(removelist == 1, :) = [];
            
        end
        
    end
    
    %if this is the last density, then add all rest points
    if i == n_density
        zero_idx = zeros(size(data,1),1);
        cluster_idx = [cluster_idx; [data, zero_idx]];
    end
    
end