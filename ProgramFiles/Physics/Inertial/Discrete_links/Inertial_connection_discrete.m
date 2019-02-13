function [A, h, J, J_full, omega] = Inertial_connection_discrete(geometry,physics,jointangles)
% Calculate the local connection for for an inertial system (floating in space or
% ideal high-Re fluid)
%
% Inputs:
%
%   geometry: Structure containing information about geometry of chain.
%       Fields required for this function are:
%
%       linklengths: A vector of link lengths defining a kinematic chain
%
%       baseframe (optional): Specification of which link on the body should be
%           treated as the base frame. Default behavior is to put the base
%           frame at the center of the chain, either at the midpoint of the
%           middle link, or at the joint between the two middle links and at
%           the mean of their orientation. Options for this field are
%           specified in the documentation of N_link_chain.
%
%       length (optional): Total length of the chain. If specified, the elements of
%           will be scaled such that their sum is equal to L. If this field
%          is not provided or is entered as an empty matrix, then the links
%          will not be scaled.
%
%       link_shape: string naming what kind of object the link is
%
%       link_shape_parameters: structure containing parameters of link
%         shape
%
%   physics: Structure containing information about the system's physics.
%       Fields are:
%
%       fluid_density: density of fluid surrounding object, relative to
%         object
%
%   jointangles: Angles of the joints between the links, defining the
%       chain's current shape.
%
% Outputs:
%
%   A: The "local connection" matrix, or "Locomotion Jacobian". This matrix
%       maps joint angular velocities ("shape velocities") to body
%       velocities of the system's base frame as 
%
%            g_b = -A * alphadot
%
%       with g_b the body velocity and alphadot the joint angular velocity.
%
%       (Note the negative sign in this equation; sysplotter code uses the
%       classical formulation of the geometric mechanics equations, which
%       includes this negative sign.
%
%   [h,J,J_full]: location and Jacobians for the links on the chain. These
%       are passed through from N_link_chain; see the documentation on that
%       function for more details
%
%   omega: The "Pfaffian constraint matrix" from which the local connection
%       A is calculated. This matrix is a linear map from system body and
%       shape velocities to net external forces acting on the base frame,
%       which must be zero for all achievable motions of the system


    %%%%
    % First, get the positions of the links in the chain and their
    % Jacobians with respect to the system parameters
    [h, J, J_full] = N_link_chain(geometry,jointangles);

    %%%%%%%%
    % We are modeling low Reynolds number physics as being resistive
    % viscous force, with a quasistatic equilibrium condition that inertial
    % forces are negligable, so that the viscous drag on the whole system
    % is zero at any given time. (The drag is anisotropic, so the system
    % can actually be moving even though there is no net force acting on
    % it).
    %
    % Because viscous drag is linear, we can build a linear map from the
    % body velocity of a given link to the force and moment acting on the
    % link.
    % 
    % Further, because the velocity kinematics from the system's body and
    % shape velocities to the body velocity of each link are linearly
    % encoded by the Jacobians of the links, we can use these Jacobians to
    % pull the drag operators on the links back onto the space of system
    % body and shape velocities, giving us a linear map from the system's
    % body and shape velocity to the net forces acting on the system
    %    
    % To calculate this linear mapping, we first pre-allocate storage for
    % the metric contributions. Each contribution is 3 x m (rows for
    % x,y,theta motion, and one column per joint), and there is one
    % contribution per link. This structure is of the same dimensions as
    % J_full, so we use it as a template.
    link_force_maps = J_full;
    
    % Now iterate over each link, calculating the map from system body and
    % shape velocities to forces acting on the body
    for idx = 1:numel(link_force_maps)
        
        link_inertias{idx} = Inertia_link(h.pos(idx,:),...            % Position of this link relative to the base frame
                                                    J_full{idx},...             % Jacobian from body velocity of base link and shape velocity to body velocity of this link
                                                    h.lengths(idx),...          % Length of this link
                                                    geometry.link_shape{idx},...         % Shape type of this link
                                                    geometry.link_shape_parameters{idx},...  % Shape parametes for this link
                                                    physics.fluid_density);      % Fluid density relative to link
  
    end

    % Sum the force-maps for each link to find the total map from system
    % body and shape velocities to force actign on the body
    M_full = sum(cat(3,link_inertias{:}),3);

    
    % Pfaffian is first three rows of M_full
    omega = M_full(1:3,:);
    
    % Build the local connection
    A = omega(:,1:3)\omega(:,4:end);


end


function Inertia_link_system = Inertia_link(h,J_full,L,link_shape,link_shape_parameters,fluid_density)
% Calculate the matrix that maps from system body and shape velocities to
% forces acting on the base frame of the system

    % These are for an elliptical link. Can be generalized to other shapes

    % length and width of an elliptical link
    a = L/2;
    b = link_shape_parameters.aspect_ratio * a;
    
	mass_link = pi*a*b;
    
    rotational_inertia_link = mass_link*(a^2+b^2)/4;
    
    added_mass = fluid_density * diag([pi*b^2, pi*a^2, (a^2-b^2)^2]);
    
    Inertia_link_local = diag([mass_link,mass_link,rotational_inertia_link]) + added_mass;
    
    
    % Pullback of local inertia to body velocity/shape velocity coordinates
    
    Inertia_link_system = J_full' * Inertia_link_local * J_full;




end