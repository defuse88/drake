function fcn = Linear(frame,n_intermediate,n_knots)
  % fcn = drakeFunction.interpolation.Linear(frame, n_intermediate, n_knots)
  %   returns a DrakeFunction.Linear object which maps n_knots values of x to
  %   (n_knots-1)*n_intermediate values of x, where the output contains
  %   n_intermediate points between each pair of adjacent knots.
  nx = frame.dim;
  A = kron(spdiags(ones(n_knots,1),1,n_knots-1,n_knots),kron(linspace(0,1,n_intermediate)',eye(nx))) + ...
    kron(spdiags(ones(n_knots,1),0,n_knots-1,n_knots),kron(fliplr(linspace(0,1,n_intermediate))',eye(nx))); 
  input_frame  = MultiCoordinateFrame(repmat({frame},1,n_knots));
  output_frame = MultiCoordinateFrame(repmat({frame},1,(n_knots-1)*n_intermediate));
  fcn = drakeFunction.Linear(input_frame,output_frame,A);
end
