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

MODULE PRFI1B_MOD
  CONTAINS
  SUBROUTINE PRFI1B()
  
  IMPLICIT NONE
  INTEGER :: I,J,K
  
  !$ACC PARALLEL LOOP
  DO I=1,100
    DO J=0,100
      DO K=1,1
      ENDDO
    ENDDO
  ENDDO
  
  END SUBROUTINE PRFI1B
  END MODULE PRFI1B_MOD
