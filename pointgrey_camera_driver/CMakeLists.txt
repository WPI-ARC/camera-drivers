cmake_minimum_required(VERSION 2.8.3)
project(pointgrey_camera_driver)

find_package(catkin REQUIRED roscpp nodelet sensor_msgs wfov_camera_msgs image_exposure_msgs camera_info_manager dynamic_reconfigure image_transport driver_base diagnostic_updater message_generation)

# Find FlyCapture (HOW?!) - make a new CMake file
# Find the flycapture2 library from Point Grey
# include_directories("/usr/include/flycapture")
# find_library(FLYCAPTURE2 flycapture)

## Find FlyCapture2
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/")
find_package(FlyCapture2)

## Generate dynamic reconfigure files
generate_dynamic_reconfigure_options(cfg/PointGrey.cfg)



# Only build driver if we have the FlyCapture SDK
if("${FLYCAPTURE2_FOUND}" STREQUAL "")
  message(WARNING "FlyCapture2 SDK not found. PointGrey camera driver will not be built.")

  catkin_package(INCLUDE_DIRS include LIBRARIES PointGreyCamera PointGreyCameraNodelet PointGreyStereoCameraNodelet CATKIN_DEPENDS roscpp nodelet sensor_msgs wfov_camera_msgs image_exposure_msgs camera_info_manager dynamic_reconfigure image_transport driver_base diagnostic_updater message_runtime DEPENDS system_lib)
else()
  if(${FLYCAPTURE2_FOUND} GREATER 0)
    message(STATUS "FlyCapture2 SDK found. Building PointGrey camera driver.")

    catkin_package(INCLUDE_DIRS include LIBRARIES PointGreyCamera PointGreyCameraNodelet PointGreyStereoCameraNodelet CATKIN_DEPENDS roscpp nodelet sensor_msgs wfov_camera_msgs image_exposure_msgs camera_info_manager dynamic_reconfigure image_transport driver_base diagnostic_updater message_runtime DEPENDS system_lib FlyCapture2)

    include_directories(include ${catkin_INCLUDE_DIRS} ${FLYCAPTURE2_INCLUDE_DIRS})

    ## Build libraries
    add_library(PointGreyCamera src/PointGreyCamera.cpp)
    target_link_libraries(PointGreyCamera ${catkin_LIBRARIES} ${FLYCAPTURE2_LIBRARIES})
    add_dependencies(PointGreyCamera ${catkin_EXPORTED_TARGETS})

    add_library(PointGreyCameraNodelet src/nodelet.cpp)
    target_link_libraries(PointGreyCameraNodelet PointGreyCamera ${catkin_LIBRARIES})
    add_dependencies(PointGreyCameraNodelet ${catkin_EXPORTED_TARGETS})

    add_library(PointGreyStereoCameraNodelet src/stereo_nodelet.cpp)
    target_link_libraries(PointGreyStereoCameraNodelet PointGreyCamera ${catkin_LIBRARIES})
    add_dependencies(PointGreyStereoCameraNodelet ${catkin_EXPORTED_TARGETS})

    ## Build executables
    add_executable(pointgrey_camera_node src/node.cpp)
    target_link_libraries(pointgrey_camera_node ${catkin_LIBRARIES})
    add_dependencies(pointgrey_camera_node ${catkin_EXPORTED_TARGETS})

    add_executable(pointgrey_stereo_node src/stereo_node.cpp)
    target_link_libraries(pointgrey_stereo_node ${catkin_LIBRARIES})
    add_dependencies(pointgrey_stereo_node ${catkin_EXPORTED_TARGETS})

    add_library(list_cameras src/list_cameras.cpp)
    target_link_libraries(list_cameras PointGreyCamera ${catkin_LIBRARIES})
    add_dependencies(list_cameras ${catkin_EXPORTED_TARGETS})

    ## Mark library for installation
    install(TARGETS PointGreyCamera PointGreyCameraNodelet PointGreyStereoCameraNodelet
      ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
      LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
      RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
    )

    ## Mark cpp header files for installation
    install(DIRECTORY include/${PROJECT_NAME}/
      DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
      PATTERN ".svn" EXCLUDE
    )

    ## Add nodelet XML file
    install(FILES pointgreycamera_nodelet.xml DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})
  else()
    message(WARNING "FlyCapture2 SDK not found. PointGrey camera driver will not be built.")
    catkin_package(INCLUDE_DIRS include LIBRARIES PointGreyCamera PointGreyCameraNodelet PointGreyStereoCameraNodelet CATKIN_DEPENDS roscpp nodelet sensor_msgs wfov_camera_msgs image_exposure_msgs camera_info_manager dynamic_reconfigure image_transport driver_base diagnostic_updater message_runtime DEPENDS system_lib)
  endif()
endif()

