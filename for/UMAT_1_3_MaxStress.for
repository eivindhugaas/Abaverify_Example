      SUBROUTINE UMAT(STRESS,STATEV,DDSDDE,SSE,SPD,SCD, &
      RPL,DDSDDT,DRPLDE,DRPLDT, &
      STRAN,DSTRAN,TIME,DTIME,TEMP,DTEMP,PREDEF,DPRED,CMNAME, &
      NDI,NSHR,NTENS,NSTATV,PROPS,NPROPS,COORDS,DROT,PNEWDT, &
      CELENT,DFGRD0,DFGRD1,NOEL,NPT,LAYER,KSPT,JSTEP,KINC)

      INCLUDE 'ABA_PARAM.INC'

      CHARACTER*80 CMNAME
      DIMENSION STRESS(NTENS),STATEV(NSTATV), &
      DDSDDE(NTENS,NTENS),DDSDDT(NTENS),DRPLDE(NTENS), &
      STRAN(NTENS),DSTRAN(NTENS),TIME(2),PREDEF(1),DPRED(1), &
      PROPS(NPROPS),COORDS(3),DROT(3,3),DFGRD0(3,3),DFGRD1(3,3), &
      JSTEP(4)

!-----------------------------------------------------------------------
!     Define parameters, Set Sredfac to the reduction factor of the stiffness
!     zero does not work as it creates singular stiffness.
!-----------------------------------------------------------------------
           DIMENSION PLSN(NTENS), ELSN(NTENS), MAXSEL(NTENS), ELMAT(NTENS)
           DIMENSION LMAT(NTENS), FMAT(NTENS), FSTRESS(NTENS,2)
           DIMENSION STRESSTRIAL(NTENS), SM2(NTENS,NTENS), SM(NTENS,NTENS) 
           DIMENSION OLDSTRESS(NTENS), DELTASTRAIN(NTENS)
			

           PARAMETER (ZERO = 0.0, ONE=1.0, TWO=2.0, SREDFAC=0.5)
		 E1Trial=PROPS(1)
		 E2Trial=PROPS(2)
	     E3Trial=PROPS(3)
		 NU12=PROPS(4)
		 NU13=PROPS(5)
		 NU23=PROPS(6)
		 G12Trial=PROPS(7)
		 G13Trial=PROPS(8)
		 G23Trial=PROPS(9)
		 BETA=PROPS(10)
		 NOTUSED=PROPS(11)
		 NOTUSED=PROPS(12)
		 NOTUSED=PROPS(13)
		 NOTUSED=PROPS(14)
		 NOTUSED=PROPS(15)
		 NOTUSED=PROPS(16)
		 XT=PROPS(17)
		 XC=PROPS(18)
		 YT=PROPS(19)
		 YC=PROPS(20)
		 ZT=PROPS(21)
		 ZC=PROPS(22)
		 NOTUSED=PROPS(23)
		 NOTUSED=PROPS(24)
		 S12=PROPS(25)
		 S13=PROPS(26)
		 S23=PROPS(27)
		 DELTATrial=(ONE-(NU12*NU12)-(NU23*NU23)-(NU13*NU13)-(TWO*NU12*NU13*NU23))/(E1Trial*E2Trial*E3Trial)
!-----------------------------------------------------------------------
!     Compute Failstress matrix
!-----------------------------------------------------------------------
		 FSTRESS(1,1)=XT
		 FSTRESS(2,1)=YT
		 FSTRESS(3,1)=ZT
		 FSTRESS(4,1)=S12
		 FSTRESS(5,1)=S13
		 FSTRESS(6,1)=S23
		 FSTRESS(1,2)=XC
		 FSTRESS(2,2)=YC
		 FSTRESS(3,2)=ZC
		 FSTRESS(4,2)=-S12
		 FSTRESS(5,2)=-S13
		 FSTRESS(6,2)=-S23
!-----------------------------------------------------------------------
!     Compute vector of elastic properties to degrade.
!-----------------------------------------------------------------------
		 ELMAT(1)=E1Trial
		 ELMAT(2)=E2Trial
		 ELMAT(3)=E3Trial
		 ELMAT(4)=G12Trial
		 ELMAT(5)=G13Trial
		 ELMAT(6)=G23Trial
!-----------------------------------------------------------------------
!     Compute trial elasticity matrix
!-----------------------------------------------------------------------
           SM(1,1)=(ONE-(NU23*NU23))/(E2Trial*E3Trial*DELTATrial)
		 SM(2,2)=(ONE-(NU13*NU13))/(E3Trial*E1Trial*DELTATrial)
		 SM(3,3)=(ONE-(NU12*NU12))/(E1Trial*E2Trial*DELTATrial)
		 SM(4,4)=TWO*G12Trial
		 SM(5,5)=TWO*G13Trial
		 SM(6,6)=TWO*G23Trial
		 SM(1,2)=(NU12+(NU13*NU23))/(E2Trial*E3Trial*DELTATrial)
		 SM(1,3)=(NU13+(NU12*NU23))/(E2Trial*E3Trial*DELTATrial)
		 SM(2,3)=(NU23+(NU13*NU12))/(E1Trial*E3Trial*DELTATrial)
		 SM(2,1)=(NU12+(NU13*NU23))/(E2Trial*E3Trial*DELTATrial)
		 SM(3,1)=(NU13+(NU12*NU23))/(E2Trial*E3Trial*DELTATrial)
		 SM(3,2)=(NU23+(NU13*NU12))/(E1Trial*E3Trial*DELTATrial)
!-----------------------------------------------------------------------
!     Create Old stress vector and deltastrain vector from input.
!-----------------------------------------------------------------------
           DO I=1,NTENS
			OLDSTRESS(I)=STRESS(I)
			DELTASTRAIN(I)=DSTRAN(I)
	     ENDDO
!-----------------------------------------------------------------------
!     Compute trial stress
!-----------------------------------------------------------------------
		 STRESSTRIAL(1)=OLDSTRESS(1)+(SM(1,1)*DELTASTRAIN(1)+SM(1,2)*DELTASTRAIN(2)+SM(1,3)*DELTASTRAIN(3)+SM(1,4)*DELTASTRAIN(4)+SM(1,5)*DELTASTRAIN(5)+SM(1,6)*DELTASTRAIN(6))
		 STRESSTRIAL(2)=OLDSTRESS(2)+(SM(2,1)*DELTASTRAIN(1)+SM(2,2)*DELTASTRAIN(2)+SM(2,3)*DELTASTRAIN(3)+SM(2,4)*DELTASTRAIN(4)+SM(2,5)*DELTASTRAIN(5)+SM(2,6)*DELTASTRAIN(6))
		 STRESSTRIAL(3)=OLDSTRESS(3)+(SM(3,1)*DELTASTRAIN(1)+SM(3,2)*DELTASTRAIN(2)+SM(3,3)*DELTASTRAIN(3)+SM(3,4)*DELTASTRAIN(4)+SM(3,5)*DELTASTRAIN(5)+SM(3,6)*DELTASTRAIN(6))
		 STRESSTRIAL(4)=OLDSTRESS(4)+(SM(4,1)*DELTASTRAIN(1)+SM(4,2)*DELTASTRAIN(2)+SM(4,3)*DELTASTRAIN(3)+SM(4,4)*DELTASTRAIN(4)+SM(4,5)*DELTASTRAIN(5)+SM(4,6)*DELTASTRAIN(6))
		 STRESSTRIAL(5)=OLDSTRESS(5)+(SM(5,1)*DELTASTRAIN(1)+SM(5,2)*DELTASTRAIN(2)+SM(5,3)*DELTASTRAIN(3)+SM(5,4)*DELTASTRAIN(4)+SM(5,5)*DELTASTRAIN(5)+SM(5,6)*DELTASTRAIN(6))
		 STRESSTRIAL(6)=OLDSTRESS(6)+(SM(6,1)*DELTASTRAIN(1)+SM(6,2)*DELTASTRAIN(2)+SM(6,3)*DELTASTRAIN(3)+SM(6,4)*DELTASTRAIN(4)+SM(6,5)*DELTASTRAIN(5)+SM(6,6)*DELTASTRAIN(6))
		 
!-----------------------------------------------------------------------
!     Check if Trialstress or Old stress exceeds any failure criteria and record it and set the elastic and plastic strain
!-----------------------------------------------------------------------
		 DO I=1,NTENS
		    IF (STRESSTRIAL(I).GE.ZERO) THEN
			   IF (STRESSTRIAL(I).GT.FSTRESS(I,1)) THEN
			      IF ((STRESSTRIAL(I)-OLDSTRESS(I)).GE.ZERO) THEN
			         FMAT(I)=SREDFAC
			         IF (OLDSTRESS(I).GT.FSTRESS(I,1)) THEN
					    PLSN(I)=DELTASTRAIN(I)
					    ELSN(I)=ZERO
			         ELSE
					    PLSN(I)=DELTASTRAIN(I)*(STRESSTRIAL(I)-FSTRESS(I,1))/(STRESSTRIAL(I)-OLDSTRESS(I))
					    ELSN(I)=DELTASTRAIN(I)-PLSN(I)
				     END IF
				  ELSE
			         FMAT(I)=ONE
			         PLSN(I)=ZERO
			         ELSN(I)=DELTASTRAIN(I)   
			      END IF
			   ELSE
			      FMAT(I)=ONE
			      PLSN(I)=ZERO
			      ELSN(I)=DELTASTRAIN(I)
			   END IF
			END IF
		    IF (STRESSTRIAL(I).LT.ZERO) THEN
			   IF (STRESSTRIAL(I).LT.FSTRESS(I,2)) THEN
			      IF ((STRESSTRIAL(I)-OLDSTRESS(I)).LE.ZERO) THEN
				     FMAT(I)=SREDFAC
			         IF (OLDSTRESS(I).LT.FSTRESS(I,2)) THEN
					    PLSN(I)=DELTASTRAIN(I)
					    ELSN(I)=ZERO
			         ELSE
					    PLSN(I)=DELTASTRAIN(I)*(STRESSTRIAL(I)-FSTRESS(I,2))/(STRESSTRIAL(I)-OLDSTRESS(I))
					    ELSN(I)=DELTASTRAIN(I)-PLSN(I)
					 ENDIF
				  ELSE
			         FMAT(I)=ONE
			         PLSN(I)=ZERO
			         ELSN(I)=DELTASTRAIN(I) 
				  END IF
			   ELSE
			      FMAT(I)=ONE
			      PLSN(I)=ZERO
			      ELSN(I)=DELTASTRAIN(I)
			   END IF
			END IF
		 ENDDO

!-----------------------------------------------------------------------
!     Compute Stiffness, elastic for first increment at time equal zero.
!-----------------------------------------------------------------------	
		 
		 DO K=1,NTENS
		    MAXSEL(K)=ELMAT(K)*FMAT(K)
		 ENDDO

		 E1=MAXSEL(1)
		 E2=MAXSEL(2)
		 E3=MAXSEL(3)
		 G12=MAXSEL(4)
		 G13=MAXSEL(5)
		 G23=MAXSEL(6)
		 DELTA=(ONE-(NU12*NU12)-(NU23*NU23)-(NU13*NU13)-(TWO*NU12*NU13*NU23))/(E1*E2*E3)

		 IF (TIME(1).EQ.ZERO) THEN
              DDSDDE(1,1)=(ONE-(NU23*NU23))/(E2Trial*E3Trial*DELTATrial)
		    DDSDDE(2,2)=(ONE-(NU13*NU13))/(E3Trial*E1Trial*DELTATrial)
		    DDSDDE(3,3)=(ONE-(NU12*NU12))/(E1Trial*E2Trial*DELTATrial)
		    DDSDDE(4,4)=TWO*G12Trial
		    DDSDDE(5,5)=TWO*G13Trial
		    DDSDDE(6,6)=TWO*G23Trial
		    DDSDDE(1,2)=(NU12+(NU13*NU23))/(E2Trial*E3Trial*DELTATrial)
		    DDSDDE(1,3)=(NU13+(NU12*NU23))/(E2Trial*E3Trial*DELTATrial)
		    DDSDDE(2,3)=(NU23+(NU13*NU12))/(E1Trial*E3Trial*DELTATrial)
		    DDSDDE(2,1)=(NU12+(NU13*NU23))/(E2Trial*E3Trial*DELTATrial)
		    DDSDDE(3,1)=(NU13+(NU12*NU23))/(E2Trial*E3Trial*DELTATrial)
		    DDSDDE(3,2)=(NU23+(NU13*NU12))/(E1Trial*E3Trial*DELTATrial)

		 ELSE

		    SM2(1,1)=(ONE-(NU23*NU23))/(E2*E3*DELTA)
		    SM2(2,2)=(ONE-(NU13*NU13))/(E3*E1*DELTA)
		    SM2(3,3)=(ONE-(NU12*NU12))/(E1*E2*DELTA)
		    SM2(4,4)=TWO*G12
		    SM2(5,5)=TWO*G13
		    SM2(6,6)=TWO*G23
		    SM2(1,2)=(NU12+(NU13*NU23))/(E2*E3*DELTA)
		    SM2(1,3)=(NU13+(NU12*NU23))/(E2*E3*DELTA)
		    SM2(2,3)=(NU23+(NU13*NU12))/(E1*E3*DELTA)
		    SM2(2,1)=(NU12+(NU13*NU23))/(E2*E3*DELTA)
		    SM2(3,1)=(NU13+(NU12*NU23))/(E2*E3*DELTA)
		    SM2(3,2)=(NU23+(NU13*NU12))/(E1*E3*DELTA)

		    DO I=1,NTENS
	           DO J=1,NTENS
			      DDSDDE(I,J)=(SM2(I,J)*(PLSN(J)/DELTASTRAIN(J)))+(SM(I,J)*(ELSN(J)/DELTASTRAIN(J)))
			   ENDDO
		    ENDDO
		 ENDIF
		 DO I=1,NTENS
	        DO J=1,NTENS
		       STRESS(I)=STRESS(I)+DDSDDE(I,J)*DSTRAN(J)
			ENDDO
		 ENDDO

	  RETURN
	  END