include( ExternalProject )

# create interface targets that depend on these custom download targets. Link them up
# to the artifacts created from externalproject_add. Make them dependent on the download
# targets. Then you can use them for cross linking later.
# delete this later, not useful having them all in a list unless the whole list will be passed
# to target_link_libraries
set( dependencies "" )

# The CUDA Toolkit's built-in thrust library appears to have been found
find_package(Thrust)
if( NOT THRUST_FOUND )

if( NOT USE_CUDA )
set( prefix "${CMAKE_CURRENT_SOURCE_DIR}/external" )

message( "Downloading thrust..." )
ExternalProject_Add( thrust_download
                     PREFIX "${prefix}/thrust" 
                     GIT_REPOSITORY "https://github.com/NVIDIA/thrust.git"
                     CONFIGURE_COMMAND ""
                     BUILD_COMMAND ""
                     INSTALL_COMMAND "" )

set( THRUST_INCLUDE_DIR "${prefix}/thrust/src/thrust_download" )
else()
set( THRUST_INCLUDE_DIR "${CUDAToolkit_INCLUDE_DIRS}" )
endif()
find_package(Thrust REQUIRED)

add_library( thrust INTERFACE )
add_dependencies( thrust thrust_download )
target_include_directories( thrust INTERFACE ${THRUST_INCLUDE_DIR} )
list( APPEND dependencies thrust )
include_directories( ${THRUST_INCLUDE_DIR} )
endif()

find_package(LibConfig)
if( NOT LIBCONFIG_FOUND )

message( "Downloading libconfig..." )
ExternalProject_Add( libconfig_download
                     PREFIX "${prefix}/libconfig"
                     GIT_REPOSITORY "https://github.com/hyperrealm/libconfig.git" 
                     INSTALL_COMMAND "" )
set( LIBCONFIG_INCLUDE_DIR "${prefix}/libconfig/src/libconfig_download/lib" )
include_directories( ${LIBCONFIG_INCLUDE_DIR} )
set( LIBCONFIG_LIBRARY "${prefix}/libconfig/src/libconfig_download-build/out/libconfig.so" )
set( LIBCONFIGPP_INCLUDE_DIR "${prefix}/libconfig/src/libconfig_download/lib" )
include_directories( ${LIBCONFIGPP_INCLUDE_DIR} )
set( LIBCONFIGPP_LIBRARY "${prefix}/libconfig/src/libconfig_download-build/out/libconfig++.so" )
find_package(LibConfig REQUIRED)
add_library( libconfig INTERFACE )
add_dependencies( libconfig libconfig_download )
target_include_directories( libconfig INTERFACE 
                            ${LIBCONFIG_INCLUDE_DIR}
                            ${LIBCONFIGPP_INCLUDE_DIR} )

target_link_libraries( libconfig INTERFACE
                       ${LIBCONFIG_LIBRARY}
                       ${LIBCONFIGPP_LIBRARY} )
list( APPEND dependencies libconfig )
endif()

find_package(NetCDF COMPONENTS CXX)
if( NOT NETCDF_FOUND )
message( "Downloading netcdf-c and netcdf-cxx4..." )
ExternalProject_Add( netcdf-c_download
                     PREFIX "${prefix}/netcdf-c"
                     GIT_REPOSITORY "https://github.com/Unidata/netcdf-c.git"
                     CMAKE_ARGS "-DENABLE_DAP=OFF" )

ExternalProject_Add( netcdf-cxx4_download
                     PREFIX "${prefix}/netcdf-cxx4"
                     GIT_REPOSITORY "https://github.com/Unidata/netcdf-cxx4.git" )

add_dependencies( netcdf-cxx4_download netcdf-c_download )
set( NETCDF_LIBRARY "/usr/local/lib/libnetcdf.so" )
set( NETCDF_CXX_INCLUDE_DIR "${prefix}/netcdf-cxx4/src/netcdf-cxx4_download/cxx4" )
include_directories( ${NETCDF_CXX_INCLUDE_DIR} )
set( NETCDF_CXX_LIBRARY "/usr/local/lib/libnetcdf-cxx4.so" )
set( NETCDF_INCLUDE_DIR "${prefix}/netcdf-c/src/netcdf-c_download/include" )
include_directories( ${NETCDF_INCLUDE_DIR} )
find_package(NetCDF COMPONENTS CXX REQUIRED)
add_library( netcdf INTERFACE )
add_dependencies( netcdf netcdf_c_download netcdf-cxx4_download )
target_include_directories( netcdf INTERFACE ${NETCDF_INCLUDE_DIR} ${NETCDF_CXX_INCLUDE_DIR} )
target_link_libraries( netcdf INTERFACE ${NETCDF_LIBRARY} ${NETCDF_CXX_LIBRARY} )
list( APPEND dependencies netcdf )
endif()

if( GITR_USE_MPI )
include( FindMPI )
if(MPI_FOUND)
add_library( mpi INTERFACE )
target_include_directories( mpi INTERFACE ${MPI_CXX_INCLUDE_DIRS} ${MPI_C_INCLUDE_DIRS})
target_link_libraries( mpi INTERFACE ${MPI_CXX_LIBRARIES} ${MPI_C_LIBRARIES} )
else()
message( FATAL_ERROR "MPI was not found" )
endif()
endif()

# ensure that all targets in ${dependencies} are built first
if( dependencies )

  foreach( component IN LISTS source_components test_components )
  # does this really have to be dereferenced?
  add_dependencies( ${component} ${dependencies} )
  endforeach()

endif()

# ensure that all targets in ${source_components} are built before any test targets
foreach( component IN LISTS test_components )
  add_dependencies( ${component} ${source_components})
endforeach()

# ensure that all source targets are built before GITR
add_dependencies( GITR ${source_components} )
