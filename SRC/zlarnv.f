*> \brief \b ZLARNV returns a vector of random numbers from a uniform or normal distribution.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download ZLARNV + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/zlarnv.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/zlarnv.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/zlarnv.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE ZLARNV( IDIST, ISEED, N, X )
*
*       .. Scalar Arguments ..
*       INTEGER            IDIST, N
*       ..
*       .. Array Arguments ..
*       INTEGER            ISEED( 4 )
*       COMPLEX*16         X( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> ZLARNV returns a vector of n random complex numbers from a uniform or
*> normal distribution.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] IDIST
*> \verbatim
*>          IDIST is INTEGER
*>          Specifies the distribution of the random numbers:
*>          = 1:  real and imaginary parts each uniform (0,1)
*>          = 2:  real and imaginary parts each uniform (-1,1)
*>          = 3:  real and imaginary parts each normal (0,1)
*>          = 4:  uniformly distributed on the disc abs(z) < 1
*>          = 5:  uniformly distributed on the circle abs(z) = 1
*> \endverbatim
*>
*> \param[in,out] ISEED
*> \verbatim
*>          ISEED is INTEGER array, dimension (4)
*>          On entry, the seed of the random number generator; the array
*>          elements must be between 0 and 4095, and ISEED(4) must be
*>          odd.
*>          On exit, the seed is updated.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of random numbers to be generated.
*> \endverbatim
*>
*> \param[out] X
*> \verbatim
*>          X is COMPLEX*16 array, dimension (N)
*>          The generated random numbers.
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date September 2012
*
*> \ingroup complex16OTHERauxiliary
*
*> \par Further Details:
*  =====================
*>
*> \verbatim
*>
*>  This routine calls the auxiliary routine DLARUV to generate random
*>  real numbers from a uniform (0,1) distribution, in batches of up to
*>  128 using vectorisable code. The Box-Muller method is used to
*>  transform numbers from a uniform to a normal distribution.
*> \endverbatim
*>
*  =====================================================================
      SUBROUTINE ZLARNV( IDIST, ISEED, N, X )
*
*  -- LAPACK auxiliary routine (version 3.4.2) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     September 2012
*
*     .. Scalar Arguments ..
      INTEGER            IDIST, N
*     ..
*     .. Array Arguments ..
      INTEGER            ISEED( 4 )
      COMPLEX*16         X( * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      DOUBLE PRECISION   ZERO, ONE, TWO
      PARAMETER          ( ZERO = 0.0D+0, ONE = 1.0D+0, TWO = 2.0D+0 )
      INTEGER            LV
      PARAMETER          ( LV = 128 )
      DOUBLE PRECISION   TWOPI
      PARAMETER          ( TWOPI = 6.2831853071795864769252867663D+0 )
*     ..
*     .. Local Scalars ..
      INTEGER            I, IL, IV
*     ..
*     .. Local Arrays ..
      DOUBLE PRECISION   U( LV )
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          DCMPLX, EXP, LOG, MIN, SQRT
*     ..
*     .. External Subroutines ..
      EXTERNAL           DLARUV
*     ..
*     .. Executable Statements ..
*
      DO 60 IV = 1, N, LV / 2
         IL = MIN( LV / 2, N-IV+1 )
*
*        Call DLARUV to generate 2*IL real numbers from a uniform (0,1)
*        distribution (2*IL <= LV)
*
         CALL DLARUV( ISEED, 2*IL, U )
*
         IF( IDIST.EQ.1 ) THEN
*
*           Copy generated numbers
*
            DO 10 I = 1, IL
               X( IV+I-1 ) = DCMPLX( U( 2*I-1 ), U( 2*I ) )
   10       CONTINUE
         ELSE IF( IDIST.EQ.2 ) THEN
*
*           Convert generated numbers to uniform (-1,1) distribution
*
            DO 20 I = 1, IL
               X( IV+I-1 ) = DCMPLX( TWO*U( 2*I-1 )-ONE,
     $                       TWO*U( 2*I )-ONE )
   20       CONTINUE
         ELSE IF( IDIST.EQ.3 ) THEN
*
*           Convert generated numbers to normal (0,1) distribution
*
            DO 30 I = 1, IL
               X( IV+I-1 ) = SQRT( -TWO*LOG( U( 2*I-1 ) ) )*
     $                       EXP( DCMPLX( ZERO, TWOPI*U( 2*I ) ) )
   30       CONTINUE
         ELSE IF( IDIST.EQ.4 ) THEN
*
*           Convert generated numbers to complex numbers uniformly
*           distributed on the unit disk
*
            DO 40 I = 1, IL
               X( IV+I-1 ) = SQRT( U( 2*I-1 ) )*
     $                       EXP( DCMPLX( ZERO, TWOPI*U( 2*I ) ) )
   40       CONTINUE
         ELSE IF( IDIST.EQ.5 ) THEN
*
*           Convert generated numbers to complex numbers uniformly
*           distributed on the unit circle
*
            DO 50 I = 1, IL
               X( IV+I-1 ) = EXP( DCMPLX( ZERO, TWOPI*U( 2*I ) ) )
   50       CONTINUE
         END IF
   60 CONTINUE
      RETURN
*
*     End of ZLARNV
*
      END
