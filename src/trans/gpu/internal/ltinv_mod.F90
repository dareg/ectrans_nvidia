#define ALIGN(I, A) (((I)+(A)-1)/(A)*(A))
! (C) Copyright 2000- ECMWF.
! (C) Copyright 2000- Meteo-France.
! (C) Copyright 2022- NVIDIA.
! 
! This software is licensed under the terms of the Apache Licence Version 2.0
! which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
! In applying this licence, ECMWF does not waive the privileges and immunities
! granted to it by virtue of its status as an intergovernmental organisation
! nor does it submit to any jurisdiction.
!

MODULE LTINV_MOD
  USE BUFFERED_ALLOCATOR_MOD

  IMPLICIT NONE

  PRIVATE
  PUBLIC :: LTINV

CONTAINS

  SUBROUTINE LTINV()

    USE PRFI1B_MOD      ,ONLY : PRFI1B

    IMPLICIT NONE



    write(*,*)"START",__FILE__,__LINE__

    CALL PRFI1B()


    write(*,*)"END",__FILE__,__LINE__
    !     ------------------------------------------------------------------
  END SUBROUTINE LTINV
END MODULE LTINV_MOD

