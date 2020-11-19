function [A, M_a,J_full, local_inertias,M_full] = Inertial_local_connection(geometry,physics,shapeparams)
% Calculate the local connection for an inertial system.
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
        physics_function = @Inertial_connection_continuous;
        
    case {'n-link chain'}
        
        physics_function = @Inertial_tensors_discrete;
        
end

% Call the physics function identified for the system
[A, M_a,J_full, local_inertias,M_full] = physics_function(geometry,physics,shapeparams);

end