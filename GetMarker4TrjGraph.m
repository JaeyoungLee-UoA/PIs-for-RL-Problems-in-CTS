function str = GetMarker4TrjGraph(i, iIndex, opt)
l = length(iIndex);

if strcmp(opt,  'Type_0')
    if i == iIndex(1)
        str = 'r';
    elseif i == iIndex(2)
        str = 'g';
    elseif i == iIndex(3)
        str = 'b';
    elseif i == iIndex(4)
        str = 'k';
    elseif i == iIndex(5)
        str = 'm';
    elseif i == iIndex(6)
        str = 'r';
    elseif i == iIndex(7)
        str = 'g';
    elseif i == iIndex(8)
        str = 'y';
    elseif i == iIndex(9)
        str = 'c';
    end
elseif strcmp(opt,  'Type_1')
    if i == iIndex(1)
        str = 'r--';
    elseif i == iIndex(2)
        str = 'b-.';
    elseif i == iIndex(3)
        str = 'g:';
    elseif i == iIndex(4)
        str = 'k';
    else
        str = 'y';
    end
elseif strcmp(opt,  'Type_2')
    if i == iIndex(1)
        str = 'r--';
    elseif i == iIndex(2)
        str = 'g-.';
    elseif i == iIndex(3)
        str = 'b:';
    else
        str = 'y';
    end
elseif strcmp(opt,  'Type_3')
    if i == iIndex(1)
        str = 'r--';
    elseif i == iIndex(2)
        str = 'b-.';
    elseif i == iIndex(3)
        str = 'g';
    elseif i == iIndex(4)
        str = 'k:';
    else
        str = 'y';
    end
else
    disp('opt must be Type_0, Type_1, Type_2, or Type_3.')
end % end if
end % end function
