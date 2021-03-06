function walking_plan_data = planWalkingZMP(obj, x0, footstep_plan)
% Construct a dynamic walking plan based on the ZMP formulation.
% @param x0 the initial robot state vector
% @param footstep_plan a FootstepPlan or DynamicFootstepPlan

walking_plan_data = QPWalkingPlan.from_biped_footstep_plan(footstep_plan, obj, x0);
