! (C) Copyright 2001- ECMWF.
! (C) Copyright 2001- Meteo-France.
! (C) Copyright 2022- NVIDIA.
! 
! This software is licensed under the terms of the Apache Licence Version 2.0
! which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
! In applying this licence, ECMWF does not waive the privileges and immunities
! granted to it by virtue of its status as an intergovernmental organisation
! nor does it submit to any jurisdiction.
!

MODULE INV_TRANS_CTL_MOD
CONTAINS
  SUBROUTINE INV_TRANS_CTL()
    USE LTINV_MOD

    IMPLICIT NONE

    write(*,*)"START",__FILE__,__LINE__

      CALL LTINV()

    write(*,*)"END",__FILE__,__LINE__
  END SUBROUTINE INV_TRANS_CTL
END MODULE INV_TRANS_CTL_MOD
