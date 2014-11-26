function whosh(varargin)

if nargin < 1
    S = evalin('base', 'whos');
else
    argstr = sprintf('''%s'',', varargin{:});
    argstr = argstr(1:end-1);
    expression = ['whos(' argstr ')'];
    S = evalin('base', expression);
end

% Bytes string

gig = [S.bytes] > 1024^3;
meg = [S.bytes] > 1024^2 & ~gig;
kil = [S.bytes] > 1024 & ~meg & ~gig;

bytes = [S.bytes]';
bytes(gig) = [S(gig).bytes] ./ 1024^3;
bytes(meg) = [S(meg).bytes] ./ 1024^2;
bytes(kil) = [S(kil).bytes] ./ 1024;

suffix = cell(size(bytes));
[suffix{:}] = deal('B');
[suffix{gig}] = deal('G');
[suffix{meg}] = deal('M');
[suffix{kil}] = deal('K');

bytestr = cellfun(@(a,b) sprintf('%d%s', a, b), num2cell(floor(bytes)), suffix, 'uni', 0);



% Size string

sizestr = arrayfun(@(X) sprintf('%dx', X.size), S, 'uni', 0);
sizestr = cellfun(@(x) x(1:end-1), sizestr, 'uni', 0);

xloc = strfind(sizestr, 'x');
xloc = cellfun(@(x) x(1), xloc);
xlocmax = max(xloc);

npad = num2cell(xlocmax - xloc);
sizestr = cellfun(@(str,x) [repmat(' ', 1,x) str], sizestr, npad, 'uni', 0);

% Format strings

namecol = strvcat('Name', S.name);
sizecol = strvcat('Size', sizestr{:});
bytescol = strvcat('Bytes', bytestr{:});
bytescol(2:end,:) = strjust(bytescol(2:end,:), 'right');
classcol = strvcat('Class', S.class);

data = [cellstr2(namecol) cellstr2(sizecol) cellstr2(bytescol) cellstr2(classcol)];

fprintf('%s  %s  %s  %s\n\n', data{1,:});
temp = data(2:end,:)';
fprintf('%s  %s  %s  %s\n', temp{:});


