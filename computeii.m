function bene = computeii(xbim, x0,y0,i,j)

if y0==1 || x0==1
    bene = xbim(i,j);
    if x0>1
        bene = bene - xbim(x0-1,j);
    else
        if y0>1
            bene = bene - xbim(i,y0-1);
        end
    end
else
    bene = xbim(i,j)-xbim(i,y0-1)-xbim(x0-1,j)+xbim(x0-1,y0-1);
end