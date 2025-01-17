--opyright 2016 The Cartographer Authors
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

include "map_builder.lua"
include "trajectory_builder.lua"
options = {
  map_builder = MAP_BUILDER,
  trajectory_builder = TRAJECTORY_BUILDER,
  map_frame = "map",
  tracking_frame = "imu_link", 
  published_frame = "base_link",
  odom_frame = "odom",
  provide_odom_frame = true,
  publish_frame_projected_to_2d = false,
  use_odometry = true,
  use_nav_sat = false,
  use_landmarks = false,
  num_laser_scans = 0,
  num_multi_echo_laser_scans = 0,
  num_subdivisions_per_laser_scan = 1,
  num_point_clouds = 1,
  lookup_transform_timeout_sec = 0.2,
  submap_publish_period_sec = 0.3,
  pose_publish_period_sec = 5e-3,
  trajectory_publish_period_sec = 30e-3,
  rangefinder_sampling_ratio = 0.5,
  odometry_sampling_ratio = 1.0,
  fixed_frame_pose_sampling_ratio = 1.,
  imu_sampling_ratio = 1.,
  landmarks_sampling_ratio = 0.5, --dxs 1
}

MAP_BUILDER.use_trajectory_builder_2d = true
TRAJECTORY_BUILDER.pure_localization = true

--每个子地图（submap）包含的激光雷达数据的数量
TRAJECTORY_BUILDER_2D.submaps.num_range_data = 60 
TRAJECTORY_BUILDER_2D.min_range = 0.5
TRAJECTORY_BUILDER_2D.max_range = 50
TRAJECTORY_BUILDER_2D.min_z = 0.3 
TRAJECTORY_BUILDER_2D.max_z = 1.5 
TRAJECTORY_BUILDER_2D.missing_data_ray_length = 1.5 
TRAJECTORY_BUILDER_2D.use_imu_data = false
TRAJECTORY_BUILDER_2D.use_online_correlative_scan_matching = true

TRAJECTORY_BUILDER_2D.voxel_filter_size = 0.1 
TRAJECTORY_BUILDER_2D.submaps.range_data_inserter.probability_grid_range_data_inserter.hit_probability = 0.6 --0.55

-- TRAJECTORY_BUILDER_2D.submaps.grid_options_2d.resolution = 0.05

--点云匹配权重、平移旋转权重
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.occupied_space_weight = 100 
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.translation_weight = 1 
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.rotation_weight = 1 
POSE_GRAPH.optimization_problem.odometry_translation_weight = 1
POSE_GRAPH.optimization_problem.odometry_rotation_weight = 1 

POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher.linear_search_window = 1

POSE_GRAPH.optimize_every_n_nodes = 5 --|>太大，初始化很慢 5

POSE_GRAPH.constraint_builder.sampling_ratio = 0.3--0.3 --|> 三分之一采样 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!增大
-- 回环检测阈值，如果不稳定有错误匹配，可以提高这两个值，场景重复可以降低或者关闭回环
POSE_GRAPH.constraint_builder.min_score = 0.55 --<| 0.6 
POSE_GRAPH.constraint_builder.global_localization_min_score = 0.6 

POSE_GRAPH.max_num_final_iterations = 200 --建图结束后最终优化迭代次数
POSE_GRAPH.global_sampling_ratio = 0.3--0.003 --|> 0.1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!增大
POSE_GRAPH.log_residual_histograms = false --true 
POSE_GRAPH.global_constraint_search_after_n_seconds = 100000 --全局匹配间隔时长 100000000
--
--TRAJECTORY_BUILDER_2D.motion_filter.max_angle_radians = math.rad(5) --<| 0.2
--TRAJECTORY_BUILDER_2D.motion_filter.max_distance_meters = 1 --<| 0.2

return options
