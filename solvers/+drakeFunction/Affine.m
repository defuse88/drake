classdef Affine < drakeFunction.DrakeFunction
  % DrakeFunction representing an affine map:
  % \f[
  % f(x) = Ax + b
  % \f]
  properties (SetAccess = immutable)
    A
    b
  end
  methods
    function obj = Affine(input_frame,output_frame,A,b)
      % obj = drakeFunction.Affine(input_frame,output_frame,A,b) returns
      %   an affine function from input_frame to output_frame
      % @param input_frame    -- CoordinateFrame representing the domain
      % @param output_frame   -- CoordinateFrame representing the range
      % @param A              -- [n x m] matrix where m and n are the
      %                          dimension of input_frame and
      %                          output_frame respectively
      % @param b              -- n-element column vector
      %
      % @retval obj           -- drakeFunction.Affine object
      sizecheck(A,[output_frame.dim,input_frame.dim]);
      sizecheck(b,[output_frame.dim,1]);
      obj = obj@drakeFunction.DrakeFunction(input_frame,output_frame);
      obj.A = A;
      obj.b = b;
      obj = obj.setSparsityPattern();
    end

    function [f,df] = eval(obj,x)
      f = obj.A*x + obj.b;
      df = obj.A;
    end

    function obj = setSparsityPattern(obj)
      [obj.iCfun, obj.jCvar] = find(obj.A);
    end

    function fcn = concatenate(obj, varargin)
      if islogical(varargin{end})
        same_input = varargin{end};
        fcns = [obj, varargin(1:end-1)];
      else
        same_input = false;
        fcns = [{obj}, varargin];
      end
      typecheck(fcns,'cell');
      if all(cellfun(@(arg)isa(arg,'drakeFunction.Affine'), fcns));
        input_frame = drakeFunction.Concatenated.constructInputFrame(fcns, same_input);
        output_frame = drakeFunction.Concatenated.constructOutputFrame(fcns);
        if same_input
          A_cat = cell2mat(reshape(cellfun(@(fcn) fcn.A, fcns, 'UniformOutput',false),[],1));
        else
          A_cell = reshape(cellfun(@(fcn) sparse(fcn.A), fcns, 'UniformOutput',false),1,[]);
          A_cat = blkdiag(A_cell{:});
        end
        b_cat = cell2mat(reshape(cellfun(@(fcn) fcn.b, fcns, 'UniformOutput',false),[],1));
        fcn = drakeFunction.Affine(input_frame,output_frame,A_cat,b_cat);
      else
        % punt to DrakeFunction
        fcn = concatenate@drakeFunction.DrakeFunction(obj, varargin{:});
      end
    end
  end
end
