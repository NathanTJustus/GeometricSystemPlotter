function [] = 	sysf_config_gui_helpmenus(section)
%SYSF_CONFIG_GUI_HELPMENUS This function will tell the user about the
%purpose of each of the different options within the configuration gui as
%well as some information about the accepted inputs to the entry box.

switch section
    case 'geometry_type'
        h = sysf_config_gui_helpbox('string',sprintf(['This attribute controls the type of geometry of the system ' ...
            'and has the following options:\n'...
            'N-Link Chain: This geometry uses n rigid links connected together end to end of '...
            'the system.\n'...
            'General Curvature/Curvature Bases/Curvature Basis: These are all similar non-rigid '...
            'function based backbones for the system.']),'title','Geometry Type --- Help');
        
    case 'geometry_baseframe'
        h = sysf_config_gui_helpbox('string',sprintf(['baseframe: Specification of which link on the body should be '...
            'treated as the base frame. Default behavior is to put the base '...
            'frame at the center of the chain, either at the midpoint of the '...
            'middle link, or at the joint between the two middle links and at '...
            'the mean of their orientation. Options for this field are:\n'...
            'centered :    Default behavior base frame at s = 0\n'...
            'tail :        Base frame at s = -0.5\n'...
            'head :        Base frame at s =  0.5\n'...
            'numeric :       Specify a position on the range [-0.5 0.5] --- Enter numeric value in box to the right of drop down menu'])...
            ,'title','Geometry Baseframe --- Help');
        
    case 'geometry_linklengths'
        h = sysf_config_gui_helpbox('string',sprintf(['This is a vector where the each element corresponds to the relative '...
            'length of the different leg in an n-link chain. The number of elements corresponds to how many links will be in the chain. '...
            'This option should likely only be used in conjunction with the n-link chain geometry type.']),'title','Link Lengths --- Help');
        
    case 'geometry_length'
        h = sysf_config_gui_helpbox('string',sprintf(['length (optional): Total length of the backbone. If specified, the elements of '...
            'will be scaled such that their sum is equal to L. If this field '...
            'is not provided or is entered as an empty matrix, then the '...
            'backbone will not be scaled.']),'title','Total Lengths --- Help');
        
    case 'geometry_constraint_list'
        h = sysf_config_gui_helpbox('string',sprintf(['The link number array represents the links upon which the wheels are placed. Likewise '...
            'the data table below represents the relative direction of each of these wheels with each row being a different direction for a specific wheel. '...
            'Enter a -1 in the top left entry of the data table before saving to act as the None option for th table.']),'title','Constraint List --- Help');
        
    case 'physics_drag_ratio'
        h = sysf_config_gui_helpbox('string',sprintf(['This is the ratio of lateral to longitudanal drag in the system.']),'title','Drag Ratio --- Help');
        
    case 'physics_drag_coefficient'
        h = sysf_config_gui_helpbox('string',sprintf(['The Drag Coefficient is the drag per unit length in the longitudinal direction.']),'title','Drag Coefficient --- Help');
        
    case 'grid_range'
        h = sysf_config_gui_helpbox('string',sprintf(['Range over which to evaluate connection.']),'title','Grid Range --- Help');
        
    case 'tic_locs_xx'
        h = sysf_config_gui_helpbox('string',sprintf(['X Component of shape space tic location.']),'title','Tic Locs x --- Help');
        
    case 'tic_locs_y'
        h = sysf_config_gui_helpbox('string',sprintf(['Y Component of shape space tic location.']),'title','Tic Locs y --- Help');
        
    case 'visual_grid'
        h = sysf_config_gui_helpbox('string',sprintf(['This array corresponds to the different positions in the shape space of the system that will '...
            'be represented in when plotted.']),'title','Visual Grid Help --- Help');
        
    case 'singularity'
        h = sysf_config_gui_helpbox('string',sprintf(['This should be set to 1 if there is a singularity in the system or None if not.']),'title','Singularity Help --- Help');
        
    case 'density_vector'
        h = sysf_config_gui_helpbox('string',sprintf(['Density of the system for vector evaluation.']),'title','Density Vector --- Help');
        
    case 'density_scalar'
        h = sysf_config_gui_helpbox('string',sprintf(['Density of the system for scalar evaluation.']),'title','Density Scalar --- Help');
        
    case 'density_eval'
        h = sysf_config_gui_helpbox('string',sprintf(['Density of the system for function evaluation.']),'title','Density Eval --- Help');
        
    case 'density_metric_eval'
        h = sysf_config_gui_helpbox('string',sprintf(['Density of the system for metric evaluation.']),'title','Metric Eval --- Help');
        
    case 'density_finite_element'
        h = sysf_config_gui_helpbox('string',sprintf(['Density of finite elements for analysis.']),'title','Finite Element --- Help');
        
    case 'overall_help'
        h = sysf_config_gui_helpbox('string',sprintf(['Welcome to the system configuration GUI for sysplpotter.\n'...
            '\nThis GUI is designed to allow easy high level configuration of the different systems. In general, any of the below fields can '...
            'be changed using the dialog boxes. Take care to use proper MATLAB syntax as is shown in the default values.\n\n After any changes '...
            'have been made, they can be saved using the save button. \n\nTo reset to the default values, click the reset to defaults button. '...
            'However, beware that doing so will overwrite any previously saved files for that system. \n\n If you would like to edit the default '...
            'configuration or any of the more advanced options, please click the edit defaults button which will bring you to the matlab source for the '...
            'system.']),'title','System Config GUI');
        
        
end
end

