# (C) Copyright 2020- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

## Apply workarounds for some known compilers

if(CMAKE_Fortran_COMPILER_ID MATCHES "NVHPC")

	## Compile setup_trans with pinned memory to improve data movement performance. 
  #ectrans_add_compile_options(
  #    SOURCES external/setup_trans.F90
  #    FLAGS   "-gpu=pinned,deepcopy,fastmath,nordc")
  ## TODO: check if it is sufficient to only set "-gpu=pinned" which appends rather than overwrites

endif()

## Assemble sources

list( APPEND trans_src
	sharedmem/sharedmem.c
	#sharedmem/sharedmem_mod.F90
	#algor/external/fourier/fft_wrapper.cpp
	algor/external/growing_allocator.h
	#algor/external/gemm/gemm_wrapper.cpp
	#algor/module/seefmm_mix.F90
	#algor/module/wts500_mod.F90
	algor/module/dilatation_mod.F90
	algor/module/interpol_decomp_mod.F90
	#algor/module/butterfly_alg_mod.F90
	#algor/module/IPC_Alltoall.cu
	#internal/updsp_mod.F90
	#internal/sump_trans_preleg_mod.F90
	#internal/sumplatbeq_mod.F90
	#internal/ftdir_mod.F90
	#internal/tpm_fft.F90
	#internal/updspb_mod.F90
	#internal/sump_trans0_mod.F90
	#internal/ftinv_mod.F90
	#internal/abort_trans_mod.F90
	#internal/pre_suleg_mod.F90
	#internal/field_split_mod.F90
	#internal/uvtvd_mod.F90
	#internal/sutrle_mod.F90
	#internal/shuffle_mod.F90
	internal/tpm_dim.F90
	#internal/tpm_ctl.F90
	#internal/trmtol_mod.F90
	#internal/read_legpol_mod.F90
	#internal/gstats_label_ifs.F90
	#internal/trmtol_pack_unpack.F90
	#internal/tpm_flt.F90
	#internal/inigptr_mod.F90
	#internal/tpm_fields.F90
	#internal/inv_trans_ctl_mod.F90
	#internal/buffered_allocator_mod.F90
	#internal/set2pe_mod.F90
	#internal/sustaonl_mod.F90
	#internal/fsc_mod.F90
	#internal/sumplatf_mod.F90
	#internal/vdtuv_mod.F90
	#internal/trltom_mod.F90
	#internal/sufft_mod.F90
	internal/ext_acc.F90
	internal/growing_allocator_mod.F90
	#internal/mysendset_mod.F90
	#internal/dist_spec_control_mod.F90
	#internal/tpm_gen.F90
	#internal/supolf_mod.F90
	#internal/sugaw_mod.F90
	#internal/spnorm_ctl_mod.F90
	#internal/pe2set_mod.F90
	#internal/supol_mod.F90
	#internal/sumplat_mod.F90
	#internal/ltinv_mod.F90
	#internal/spnormd_mod.F90
	#internal/dealloc_resol_mod.F90
	#internal/tpm_trans.F90
	#internal/dist_grid_32_ctl_mod.F90
	#internal/leinv_mod.F90
	#internal/ledir_mod.F90
	#internal/gawl_mod.F90
	#internal/gath_grid_ctl_mod.F90
	internal/prfi1b_mod.F90
	#internal/tpm_fftc.F90
	#internal/tpm_distr.F90
	#internal/tpm_pol.F90
	#internal/cuda_gemm_batched_mod.F90
	internal/parkind_ectrans.F90
	#internal/sump_trans_mod.F90
	#internal/trltom_pack_unpack.F90
	#internal/cdmap_mod.F90
	#internal/trltog_mod.F90
	#internal/sumplatb_mod.F90
	#internal/gath_spec_control_mod.F90
	#internal/setup_geom_mod.F90
	#internal/setup_dims_mod.F90
	#internal/prepsnm_mod.F90
	#internal/myrecvset_mod.F90
	#internal/gath_grid_32_ctl_mod.F90
	#internal/spnsde_mod.F90
	#internal/write_legpol_mod.F90
	#internal/trgtol_mod.F90
	#internal/tpm_constants.F90
	#internal/spnormc_mod.F90
	#internal/tpm_geometry.F90
	#internal/dir_trans_ctl_mod.F90
	#internal/prfi1_mod.F90
	#internal/eq_regions_mod.F90
	#internal/dist_grid_ctl_mod.F90
	#internal/ltdir_mod.F90
	#internal/set_resol_mod.F90
	internal/cpledn_mod.F90
	internal/suwavedi_mod.F90
	#internal/tpm_stats.F90
                        )

## for reduced memory option, replace source files
#if( HAVE_GPU_REDUCED_MEMORY )
	#ecbuild_list_add_pattern( LIST reducedmem_files
  #                          GLOB internal_reducedmem/* QUIET )
  #foreach( src_file ${reducedmem_files} )
  #  get_filename_component( base_name ${src_file} NAME )
  #  list(REMOVE_ITEM trans_src "internal/${base_name}" )
  #  list(APPEND      trans_src ${src_file} )
  #endforeach()
	#endif()

ecbuild_list_exclude_pattern( LIST trans_src            REGEX dilatation_mod.F90 )
ecbuild_find_package( NAME NvidiaCutlass REQUIRED)

foreach( prec dp )
  if( HAVE_${prec} )

    # We build an object library first. And then use these objects to create a shared and static library.

    ectrans_add_library(
      TARGET           trans_gpu_object_${prec}
      TYPE             OBJECT
      SOURCES          ${trans_src}
      PUBLIC_INCLUDES  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../include>
                       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../include/ectrans>
                       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/algor/interface>
                       $<INSTALL_INTERFACE:include/ectrans>
                       $<INSTALL_INTERFACE:include>
      PUBLIC_LIBS      parkind_${prec}
                       fiat
      PRIVATE_LIBS     OpenACC::OpenACC_Fortran
                       CUDA::cufft
                       CUDA::cublas
                       MPI::MPI_Fortran
                       MPI::MPI_C
                       nvhpcwrapnvtx
                       nvidia::cutlass::cutlass
                       ${LAPACK_LIBRARIES}
    )
    # Propagate "-acc" as link flag for NVHPC Fortran linker
    target_link_options( trans_gpu_object_${prec} INTERFACE $<$<LINK_LANG_AND_ID:Fortran,NVHPC>:-acc -cuda> )

    #We don't build module for the gpu files because they only implemente some part of the functionality, so we will just use the cpu module to compile and then link with the gpu version of the library and then the cpu library to fill the gaps
    #ectrans_target_fortran_module_directory(
    #  TARGET            trans_gpu_object_${prec}
    #  MODULE_DIRECTORY  ${PROJECT_BINARY_DIR}/module/trans_gpu_${prec}
    #  INSTALL_DIRECTORY module/trans_gpu_${prec}
    #)

		#if( HAVE_OMP )
    #  target_link_libraries( trans_gpu_object_${prec} PRIVATE OpenMP::OpenMP_Fortran )
    #endif()

    #if( prec STREQUAL sp )
    #  target_compile_definitions( trans_gpu_object_${prec} PRIVATE TRANS_SINGLE PARKINDTRANS_SINGLE )
    #endif()

    #if( HAVE_GPU_REDUCED_MEMORY )
    #  target_compile_definitions( trans_gpu_object_${prec} PRIVATE REDUCED_MEM )
    #endif()

    #if( HAVE_GPU_AWARE_MPI )
    #  target_compile_definitions( trans_gpu_object_${prec} PRIVATE USE_CUDA_AWARE_MPI_FT )
    #endif()

		#ectrans_add_library(
    #  TARGET           trans_gpu_shared_${prec}
    #  OUTPUT_NAME      trans_gpu_${prec}
    #  TYPE             SHARED
    #  LINKER_LANGUAGE  Fortran
    #  PUBLIC_LIBS      trans_gpu_object_${prec}
    #)

    ectrans_add_library(
      TARGET           trans_gpu_${prec}
      TYPE             STATIC
      LINKER_LANGUAGE  Fortran
      PUBLIC_LIBS      trans_gpu_object_${prec}
    )
  endif()
endforeach()

