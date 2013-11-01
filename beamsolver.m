function [x, V, M, vy]=beamsolver(L, EI, supports, loads, maxdx)
% beamsolver
% INPUTS:
% symbol    physical quantity                   MATLAB data type    Example
% L         the total length of the beam        real                10.0
% EI        flexural rigidity                   real                2e8
% supports  the two supports                    2-element cell      { {'p',1.0},{'r',8.0} }
% loads     the external loads                  cell                { {support type, location}, {support type, location} }
% maxdx     the maximum x-spacing dx            real                0.1
%
% units system: SI,      length: m,   moment: N.m,   force: N,   intensity q: N/m
% sign conventions for loads:   forces: downward as positive,   moments: counter-clockwise as positive
%
%
% SUPPORTS:
% { {support type, location}, {support type, location} }
% support type: 'p' 'pin',    'r' 'roller',   'f' 'fixed',    'v' 'void'
%
%
% LOADS:
% { {load type, specifier}, {load type, specifier}, ... }
% load type = 'f' (concentrated force), specifier = [location, value]
% load type = 'm' (concentrated moment), specifier = [location, value] (?-element vector in real)
% load type = 'd' (distributed force), a. specifier = [xs, xe, xc, k0, [k1, [k2, [k3...]]]] or b. specifier = [x;q] (a 2 ¡Á N array in real)
% Examples:
% {...
% {'f', [2.0, 9000]}, ...                       % a concentrated force of 9000N at x = 2.0m
% {'f', [7.0, 15000]}, ...                      % another concentrated force of 15000N at x = 7.0m
% {'m', [5.0, -4000]}, ...                      % another concentrated moment of -4000N at x = 5.0m
% {'d', [2.0,4.0, 2.0, 100]}, ...               % a distributed force on (2.0, 4.0) with q = 100
% {'d', [7.0,9.0, 3.0, 20, 100]}, ...           % a distributed force on (7.0, 9.0) with q = 20 + 100(x - 3)
% {'d', [(10.0:0.01:13.0); (0:0.01:3.0).^2]} ...% a distributed force on (10.0, 13.0)
% }
%
%
% OUTPUTS:
% symbol      physical quantity                       MATLAB data type    Example
% x           piecewise position for segments         1D row vector       [(?:?.?:?),(?:?.?:??)]
%             boundaries should be overlapped                             note 1 is overlapped
% V           shear force                             1D row vector
% M           bending moment                          1D row vector
% vy          deflection                              1D row vector
%
%
% author: Li Yukun @ HIT
% e-mail: lyk6756@sina.com
% 2013.10.5

%% inputs check
switch nargin
    case 5        
    otherwise
        error('inputs error');
end
% length check
switch isreal(L)
    case 1
    otherwise
        error('inputs error: data format (L)');
end
% EI check
switch isreal(EI)
    case 1
    otherwise
        error('inputs error: data format (EI)');
end
% supports check: is cell
switch iscell(supports) && iscell(supports(1)) &&  iscell(supports(2))
    case 1
    otherwise
        error('inputs error: data format (supports)');
end
% supports check: support type (statically determinate structure only)
switch ischar(supports{1}{1}) & ischar(supports{2}{1})
    case 1
         if (strcmp(supports{1}{1}, 'p') && strcmp(supports{2}{1}, 'r')) || (strcmp(supports{1}{1}, 'r') && strcmp(supports{2}{1}, 'p'))
             if  (strcmp(supports{1}{1}, 'v') && strcmp(supports{2}{1}, 'f')) || (strcmp(supports{1}{1}, 'f') && strcmp(supports{2}{1}, 'v'))
                
            else
                error('inputs error: support type (supports)');
            end
        else
            error('inputs error: support type (supports)');
        end
    otherwise
        error('inputs error: support type (supports)');
end
% supports check: location
switch isreal(supports{1}{2}) && isreal(supports{2}{2})
    case 1
        if supports{1}{2} >= 0 && supports{2}{2} >= 0 && supports{1}{2} <= L && supports{2}{2} <= L
            if supports{1}{2} < supports{2}{2} % first l second r
            elseif supports{1}{2} > supports{2}{2} % first r second l
            else
                error('inputs error: support location (supports)');
            end
        else
            error('inputs error: support location (supports)');
        end
    otherwise
        error('inputs error: data format (supports)');
end
% maxdx check
switch isreal(maxdx)
    case 1
        if maxdx > 0 && maxdx < L
        else
            error('inputs error: data format (maxdx)');
        end
    otherwise
        error('inputs error: data format (maxdx)');
end

