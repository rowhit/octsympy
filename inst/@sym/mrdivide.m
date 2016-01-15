%% Copyright (C) 2014, 2016 Colin B. Macdonald
%%
%% This file is part of OctSymPy.
%%
%% OctSymPy is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 3 of the License,
%% or (at your option) any later version.
%%
%% This software is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty
%% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%% the GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public
%% License along with this software; see the file COPYING.
%% If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*-
%% @documentencoding UTF-8
%% @deftypefn  {Function File}  {@var{z} =} mrdivide (@var{x}, @var{y})
%% Forward slash division of symbolic expressions (/).
%%
%% Example:
%% @example
%% @group
%% syms x
%% A = sym([1 pi; 3 4])
%%   @result{} A = (sym 2×2 matrix)
%%       ⎡1  π⎤
%%       ⎢    ⎥
%%       ⎣3  4⎦
%% A / 2
%%   @result{} ans = (sym 2×2 matrix)
%%       ⎡     π⎤
%%       ⎢1/2  ─⎥
%%       ⎢     2⎥
%%       ⎢      ⎥
%%       ⎣3/2  2⎦
%% @end group
%% @end example
%%
%% The forward slash notation can be used to solve systems
%% of the form A⋅B = C using @code{A = C / B}:
%% @example
%% @group
%% B = sym([1 0; 1 2]);
%% C = A*B
%%   @result{} C = (sym 2×2 matrix)
%%       ⎡1 + π  2⋅π⎤
%%       ⎢          ⎥
%%       ⎣  7     8 ⎦
%% C / B                         % doctest: +SKIP
%%   @result{} ans = (sym 2×2 matrix)
%%       ⎡1  π⎤
%%       ⎢    ⎥
%%       ⎣3  4⎦
%% C * inv(B)
%%   @result{} ans = (sym 2×2 matrix)
%%       ⎡1  π⎤
%%       ⎢    ⎥
%%       ⎣3  4⎦
%% @end group
%% @end example
%% (However, as of 2016-01 this feature requires a development
%% version of SymPy 0.7.7-dev.)
%%
%% @seealso{rdivide, mldivide}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function z = mrdivide(x, y)

  % Dear hacker from the distant future... maybe you can delete this?
  if (isa(x, 'symfun') || isa(y, 'symfun'))
    warning('OctSymPy:sym:arithmetic:workaround42735', ...
            'worked around octave bug #42735')
    z = mrdivide(x, y);
    return
  end

  z = python_cmd ('return _ins[0]/_ins[1],', sym(x), sym(y));

end


%!test
%! % scalar
%! syms x
%! assert (isa( x/x, 'sym'))
%! assert (isequal( x/x, sym(1)))
%! assert (isa( 2/x, 'sym'))
%! assert (isa( x/2, 'sym'))

%!test
%! % matrix / scalar
%! D = 2*[0 1; 2 3];
%! A = sym(D);
%! assert (isequal ( A/2 , D/2  ))
%! assert (isequal ( A/sym(2) , D/2  ))

%!test
%! % 1/A: either invert A or leave unevaluated: not bothered which
%! A = sym([1 2; 3 4]);
%! B = 1/A;
%! assert (isequal (B, inv(A))  ||  strncmpi(char(B), 'MatPow', 6))

%!xtest
%! % fails, on sympy <= 0.7.7-dev: probably upstream sympy bug
%! A = sym([1 2; 3 4]);
%! B = 2/A;
%! assert (isequal (B, 2*inv(A))  ||  strncmpi(char(B), 'MatPow', 6))

%!test
%! % A = C/B is C = A*B
%! if (str2num(strrep(python_cmd ('return sp.__version__,'),'.',''))<=761)
%!   disp('skipping a test b/c SymPy <= 0.7.6.x')
%! else
%! A = sym([1 2; 3 4]);
%! B = sym([1 3; 4 8]);
%! C = A*B;
%! A2 = C / B;
%! assert (isequal (A, A2))
%! end

%!test
%! if (str2num(strrep(python_cmd ('return sp.__version__,'),'.',''))<=761)
%!   disp('skipping a test b/c SymPy <= 0.7.6.x')
%! else
%! A = [1 2; 3 4];
%! B = A / A;
%! % assert (isequal (B, sym(eye(2))
%! assert (isequal (B(1,1), 1))
%! assert (isequal (B(2,2), 1))
%! assert (isequal (B(2,1), 0))
%! assert (isequal (B(1,2), 0))
%! end

%!test
%! if (str2num(strrep(python_cmd ('return sp.__version__,'),'.',''))<=761)
%!   disp('skipping a test b/c SymPy <= 0.7.6.x')
%! else
%! A = sym([5 6]);
%! B = sym([1 2; 3 4]);
%! C = A*B;
%! A2 = C / B;
%! assert (isequal (A, A2))
%! end
