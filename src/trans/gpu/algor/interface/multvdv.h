INTERFACE
SUBROUTINE MULTVDV(PVEC,PDIA,PROD)
USE PARKIND1, ONLY: JPIM, JPRB
REAL(KIND=JPRB), INTENT(IN) :: PVEC(:,:)
REAL(KIND=JPRB), INTENT(IN) :: PDIA(:)
REAL(KIND=JPRB), INTENT(OUT) :: PROD(:,:)
END SUBROUTINE MULTVDV
END INTERFACE