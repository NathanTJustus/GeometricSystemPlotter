function [A, h, J,Omega] = LowRE_local_connection(geometry,physics,shapeparams)
% Calculate the local connection for a set of curvature bases
%
% Inputs:
% geometry: structure defining system geometry
%      geometry.type: how the system geometry is defined 
%         (e.g., links, curvature basis, general curvature)
%      geometry.function: map from shape variables to local backbone
%         deformation (e.g., curvature or joint angles)
%      geometry.length: total length of swimmer
% physics: structure defining system physics
%      drag_ratio: ratio of lateral to longitudinal drag
%      drag_coefficient: drag per unit length
% cparams: value of shape variables




% Identify what kind of system is being calculated, and use this to specify how
% the local connection should be generated
switch geometry.type
    
    case {'curvature basis','curvature bases','general curvature'}
        physics_function = @LowRE_connection_continuous;
        
    case {'n-link chain','branched chain'}
        physics_function = @LowRE_connection_discrete;
        
end

% Call the physics function identified for the system
[A, h, J,Omega] = physics_function(geometry,physics,shapeparams);

end


% %Generate backbone geometry and Jacobian from its local definition
% [h,J] = backbone(geometry,shapeparams);
% 
% % Itegrate from one halflength before the midpoint to one halflength after it
% int_limit = geometry.length*[-0.5 0.5];
% 
% % Now integrate to get the pfaffian
% Omega_sol = ode45( @(s,Omega) LowRE_Pfaffian_infinitesimal(s,h(s),J(s),physics.drag_coefficient,physics.drag_ratio),int_limit,zeros(3,3+length(shapeparams)));
% 
% % Reshape the terms of the Pfaffian into a matrix of the correct dimension
% Omega = reshape(deval(Omega_sol,int_limit(end)),3,[]);
% 
% % Calculate the local connection by multiplying the inverse of the first
% % block in the Pfaffian by the second block
% A = Omega(:,1:3)\Omega(:,4:end);
% 
% 
% end
% 
% 
% function dOmega = LowRE_Pfaffian_infinitesimal(s,h,J,c,drag_ratio) %#ok<INUSL>
% % Calculate the derivative of the local connection as it's built up along
% % the backbone
% 
% 	% Convert velocity to local velocity
% 	gdot_to_gcirc_local = TgLginv(h);
% 		
% 	% Local drag, based on unit longitudinal drag, lateral according to the ratio, no local
% 	% torsional drag, multiplied by drag coefficient
% 	gcirc_local_to_F_local = ...
%         [-1     0       0;
%         0   -drag_ratio 0;
%         0       0       0]*c;
% 	
%     % Transfer force to midpoint-tangent frame by transpose of the
%     % adjoint-inverse action
%     F_local_to_F_midpoint = transpose(Adjinv(h));
% 	
% 	% shape component of pfaffian
%     % (map from shape velocities to midpoint-tangent forces)
% 	omega2 = F_local_to_F_midpoint ...
%         * gcirc_local_to_F_local ...
%         * gdot_to_gcirc_local ...
%         * J; % J is rdot to gdot mapping
% 	
% 	% system body velocity component of pfaffian
% 	omega1 = F_local_to_F_midpoint ...
% 		* gcirc_local_to_F_local ...
%         * gdot_to_gcirc_local ...
%         * TeRg(h); % Mapping from gdot of system to gdot of outboard point
% 	
%     % Combine contributions to Pfaffian from shape and position motion
% 	dOmega = [omega1 omega2];
%     
%     % Turn Pfaffian into column vector for ODE45
% 	dOmega = dOmega(:);
% 
% end