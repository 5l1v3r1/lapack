*> \brief \b CLATZM
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download CLATZM + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/clatzm.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/clatzm.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/clatzm.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE CLATZM( SIDE, M, N, V, INCV, TAU, C1, C2, LDC, WORK )
*
*       .. Scalar Arguments ..
*       CHARACTER          SIDE
*       INTEGER            INCV, LDC, M, N
*       COMPLEX            TAU
*       ..
*       .. Array Arguments ..
*       COMPLEX            C1( LDC, * ), C2( LDC, * ), V( * ), WORK( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> This routine is deprecated and has been replaced by routine CUNMRZ.
*>
*> CLATZM applies a Householder matrix generated by CTZRQF to a matrix.
*>
*> Let P = I - tau*u*u**H,   u = ( 1 ),
*>                               ( v )
*> where v is an (m-1) vector if SIDE = 'L', or a (n-1) vector if
*> SIDE = 'R'.
*>
*> If SIDE equals 'L', let
*>        C = [ C1 ] 1
*>            [ C2 ] m-1
*>              n
*> Then C is overwritten by P*C.
*>
*> If SIDE equals 'R', let
*>        C = [ C1, C2 ] m
*>               1  n-1
*> Then C is overwritten by C*P.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] SIDE
*> \verbatim
*>          SIDE is CHARACTER*1
*>          = 'L': form P * C
*>          = 'R': form C * P
*> \endverbatim
*>
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix C.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix C.
*> \endverbatim
*>
*> \param[in] V
*> \verbatim
*>          V is COMPLEX array, dimension
*>                  (1 + (M-1)*abs(INCV)) if SIDE = 'L'
*>                  (1 + (N-1)*abs(INCV)) if SIDE = 'R'
*>          The vector v in the representation of P. V is not used
*>          if TAU = 0.
*> \endverbatim
*>
*> \param[in] INCV
*> \verbatim
*>          INCV is INTEGER
*>          The increment between elements of v. INCV <> 0
*> \endverbatim
*>
*> \param[in] TAU
*> \verbatim
*>          TAU is COMPLEX
*>          The value tau in the representation of P.
*> \endverbatim
*>
*> \param[in,out] C1
*> \verbatim
*>          C1 is COMPLEX array, dimension
*>                         (LDC,N) if SIDE = 'L'
*>                         (M,1)   if SIDE = 'R'
*>          On entry, the n-vector C1 if SIDE = 'L', or the m-vector C1
*>          if SIDE = 'R'.
*>
*>          On exit, the first row of P*C if SIDE = 'L', or the first
*>          column of C*P if SIDE = 'R'.
*> \endverbatim
*>
*> \param[in,out] C2
*> \verbatim
*>          C2 is COMPLEX array, dimension
*>                         (LDC, N)   if SIDE = 'L'
*>                         (LDC, N-1) if SIDE = 'R'
*>          On entry, the (m - 1) x n matrix C2 if SIDE = 'L', or the
*>          m x (n - 1) matrix C2 if SIDE = 'R'.
*>
*>          On exit, rows 2:m of P*C if SIDE = 'L', or columns 2:m of C*P
*>          if SIDE = 'R'.
*> \endverbatim
*>
*> \param[in] LDC
*> \verbatim
*>          LDC is INTEGER
*>          The leading dimension of the arrays C1 and C2.
*>          LDC >= max(1,M).
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is COMPLEX array, dimension
*>                      (N) if SIDE = 'L'
*>                      (M) if SIDE = 'R'
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
*> \date November 2011
*
*> \ingroup complexOTHERcomputational
*
*  =====================================================================
      SUBROUTINE CLATZM( SIDE, M, N, V, INCV, TAU, C1, C2, LDC, WORK )
*
*  -- LAPACK computational routine (version 3.4.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     November 2011
*
*     .. Scalar Arguments ..
      CHARACTER          SIDE
      INTEGER            INCV, LDC, M, N
      COMPLEX            TAU
*     ..
*     .. Array Arguments ..
      COMPLEX            C1( LDC, * ), C2( LDC, * ), V( * ), WORK( * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      COMPLEX            ONE, ZERO
      PARAMETER          ( ONE = ( 1.0E+0, 0.0E+0 ),
     $                   ZERO = ( 0.0E+0, 0.0E+0 ) )
*     ..
*     .. External Subroutines ..
      EXTERNAL           CAXPY, CCOPY, CGEMV, CGERC, CGERU, CLACGV
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MIN
*     ..
*     .. Executable Statements ..
*
      IF( ( MIN( M, N ).EQ.0 ) .OR. ( TAU.EQ.ZERO ) )
     $   RETURN
*
      IF( LSAME( SIDE, 'L' ) ) THEN
*
*        w :=  ( C1 + v**H * C2 )**H
*
         CALL CCOPY( N, C1, LDC, WORK, 1 )
         CALL CLACGV( N, WORK, 1 )
         CALL CGEMV( 'Conjugate transpose', M-1, N, ONE, C2, LDC, V,
     $               INCV, ONE, WORK, 1 )
*
*        [ C1 ] := [ C1 ] - tau* [ 1 ] * w**H
*        [ C2 ]    [ C2 ]        [ v ]
*
         CALL CLACGV( N, WORK, 1 )
         CALL CAXPY( N, -TAU, WORK, 1, C1, LDC )
         CALL CGERU( M-1, N, -TAU, V, INCV, WORK, 1, C2, LDC )
*
      ELSE IF( LSAME( SIDE, 'R' ) ) THEN
*
*        w := C1 + C2 * v
*
         CALL CCOPY( M, C1, 1, WORK, 1 )
         CALL CGEMV( 'No transpose', M, N-1, ONE, C2, LDC, V, INCV, ONE,
     $               WORK, 1 )
*
*        [ C1, C2 ] := [ C1, C2 ] - tau* w * [ 1 , v**H]
*
         CALL CAXPY( M, -TAU, WORK, 1, C1, 1 )
         CALL CGERC( M, N-1, -TAU, WORK, 1, V, INCV, C2, LDC )
      END IF
*
      RETURN
*
*     End of CLATZM
*
      END
