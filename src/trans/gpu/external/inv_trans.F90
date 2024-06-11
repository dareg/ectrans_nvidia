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

SUBROUTINE INV_TRANS()

USE INV_TRANS_CTL_MOD ,ONLY : INV_TRANS_CTL
write(*,*)"START",__FILE__,__LINE__

CALL INV_TRANS_CTL()
 
write(*,*)"END",__FILE__,__LINE__


END SUBROUTINE INV_TRANS

