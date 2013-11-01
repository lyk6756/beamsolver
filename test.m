a = -1;

switch iscell(supports) | iscell(supports(1)) |  iscell(supports(2))
    case 1
        a = 1;
    case 0
        a = 0;
end