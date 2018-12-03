source /project/projectdirs/atom/atom-install-edison/GITR/env.edison.sh

cmake -DTHRUST_INCLUDE_DIR=/global/homes/t/tyounkin/code/thrust/ \
-DNETCDF_DIR=/opt/cray/pe/netcdf/4.4.1.1.3/GNU/5.1/ \
-DLIBCONFIGPP_INCLUDE_DIR=/global/homes/t/tyounkin/code/libconfigBuild/gnu/include \
-DLIBCONFIGPP_LIBRARY=/global/homes/t/tyounkin/code/libconfigBuild/gnu/lib/libconfig++.so \
-DCMAKE_C_COMPILER=gcc \
-DCMAKE_CXX_COMPILER=g++ \
-DMPI_C_LIBRARIES=/opt/cray/pe/mpt/7.6.2/gni/mpich-gnu/5.1/lib/libmpich.so \
-DMPI_C_INCLUDE_PATH=/opt/cray/pe/mpt/7.6.2/gni/mpich-gnu/5.1/include \
-DMPI_CXX_LIBRARIES=mpichcxx \
-DMPI_CXX_INCLUDE_PATH=/opt/cray/pe/mpt/7.6.2/gni/mpich-gnu/5.1/include \
-DMPI_C_COMPILER=mpich \
-DMPI_CXX_COMPILER=mpichcxx \
    -DUSE_CUDA=0 \
    -DUSEMPI=0 \
    -DUSE_MPI=1 \
    -DUSE_OPENMP=0 \
    -DUSE_BOOST=1 \
    -DUSEIONIZATION=1 \
    -DUSERECOMBINATION=1 \
    -DUSEPERPDIFFUSION=1 \
    -DUSECOULOMBCOLLISIONS=1 \
    -DUSETHERMALFORCE=0 \
    -DUSESURFACEMODEL=1 \
    -DUSESHEATHEFIELD=1 \
    -DBIASED_SURFACE=1 \
    -DUSEPRESHEATHEFIELD=1 \
    -DBFIELD_INTERP=0 \
    -DLC_INTERP=0 \
    -DGENERATE_LC=0 \
    -DEFIELD_INTERP=0 \
    -DPRESHEATH_INTERP=0 \
    -DDENSITY_INTERP=2 \
    -DTEMP_INTERP=2 \
    -DFLOWV_INTERP=0 \
    -DGRADT_INTERP=0 \
    -DODEINT=0 \
    -DFIXEDSEEDS=0 \
    -DPARTICLESEEDS=1 \
    -DGEOM_TRACE=0 \
    -DGEOM_HASH=3 \
    -DGEOM_HASH_SHEATH=3 \
    -DPARTICLE_TRACKS=0 \
    -DPARTICLE_SOURCE_SPACE=0 \
    -DPARTICLE_SOURCE_ENERGY=0 \
    -DPARTICLE_SOURCE_ANGLE=0 \
    -DPARTICLE_SOURCE_FILE=1 \
    -DSPECTROSCOPY=3 \
    -DUSE3DTETGEOM=1 \
    -DUSECYLSYMM=1 \
    -DFLUX_EA=1 \
    -DCHECK_COMPATIBILITY=1 \
..