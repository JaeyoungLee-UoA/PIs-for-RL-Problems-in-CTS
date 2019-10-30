function ordinal = num2ordinal(num)
if num >= 4
    postfix = 'th';
elseif num == 1
    postfix = 'st';
elseif num == 2
    postfix = 'nd';
elseif num == 3
    postfix = 'rd';
else
    disp('num should be a positive interger.')
end % end if
ordinal = [num2str(num), postfix];
end % end function