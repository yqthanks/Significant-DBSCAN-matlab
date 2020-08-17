function plotClusters(X, IDX)

    %the end of this code is hardcoded for visualizing synthetic data with
    %dims o [100,100]
    
    if ~exist('IDX','var') && size(X,2)==3
        IDX = X(:,3);
        X = X(:,1:2);
    end
    
    figure;
    
    %if only want to visualize point distribution, i.e., not clustering
    %results
    just_points = 0;
    if max(size(IDX)) == 0
        IDX = zeros(size(X,1),1);
        just_points = 1;
    end
    
    offset = 0;
    if min(IDX)==0
        offset = 1;
    end
    
    
    %process IDX to make it unique and continuous
    [uidx,~,icidx] = unique(IDX);
    IDX = icidx(:,:) - offset;%if everything is in a cluster then no
    
    k=max(IDX);
    
    markersize = 6;
    Colors = lines(k);

    for i=0:k
        Xi=X(IDX==i,:);
        if i~=0
            Style = '.';
            Color = Colors(i,:);
        else
            Style = '.';
            if just_points == 1
                Color = [0 0 0];
            else
                Color = [0.5 0.5 0.5];
            end
        end
        if ~isempty(Xi)
            plot(Xi(:,1),Xi(:,2),Style,'MarkerSize',markersize,'Color',Color);
        end
        hold on;
    end
    hold off;
    
    xlim([0,100]);
    ylim([0,100]);
    
    ax = gca;
    ax.Visible = 'off';
    
    pbaspect([1 1 1])

end