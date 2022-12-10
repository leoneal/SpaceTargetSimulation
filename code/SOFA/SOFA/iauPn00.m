%  - - - - - - - -
%   i a u P n 0 0
%  - - - - - - - -
%
%  Precession-nutation, IAU 2000 model:  a multi-purpose function,
%  supporting classical (equinox-based) use directly and CIO-based
%  use indirectly.
%
%  This function is part of the International Astronomical Union's
%  SOFA (Standards Of Fundamental Astronomy) software collection.
%
%  Status:  support function.
%
%  Given:
%     date1,date2            TT as a 2-part Julian Date (Note 1)
%     dpsi,deps              nutation (Note 2)
%
%  Returned:
%     epsa                   mean obliquity (Note 3)
%     rb                     frame bias matrix (Note 4)
%     rp                     precession matrix (Note 5)
%     rbp                    bias-precession matrix (Note 6)
%     rn                     nutation matrix (Note 7)
%     rbpn                   GCRS-to-true matrix (Note 8)
%
%  Notes:
%  1) The TT date date1+date2 is a Julian Date, apportioned in any
%     convenient way between the two arguments.  For example,
%     JD(TT)=2450123.7 could be expressed in any of these ways,
%     among others:
%
%            date1          date2
%
%         2450123.7           0.0       (JD method)
%         2451545.0       -1421.3       (J2000 method)
%         2400000.5       50123.2       (MJD method)
%         2450123.5           0.2       (date & time method)
%
%     The JD method is the most natural and convenient to use in
%     cases where the loss of several decimal digits of resolution
%     is acceptable.  The J2000 method is best matched to the way
%     the argument is handled internally and will deliver the
%     optimum resolution.  The MJD method and the date & time methods
%     are both good compromises between resolution and convenience.
%
%  2) The caller is responsible for providing the nutation components;
%     they are in longitude and obliquity, in radians and are with
%     respect to the equinox and ecliptic of date.  For high-accuracy
%     applications, free core nutation should be included as well as
%     any other relevant corrections to the position of the CIP.
%
%  3) The returned mean obliquity is consistent with the IAU 2000
%     precession-nutation models.
%
%  4) The matrix rb transforms vectors from GCRS to J2000.0 mean
%     equator and equinox by applying frame bias.
%
%  5) The matrix rp transforms vectors from J2000.0 mean equator and
%     equinox to mean equator and equinox of date by applying
%     precession.
%
%  6) The matrix rbp transforms vectors from GCRS to mean equator and
%     equinox of date by applying frame bias then precession.  It is
%     the product rp x rb.
%
%  7) The matrix rn transforms vectors from mean equator and equinox of
%     date to true equator and equinox of date by applying the nutation
%     (luni-solar + planetary).
%
%  8) The matrix rbpn transforms vectors from GCRS to true equator and
%     equinox of date.  It is the product rn x rbp, applying frame
%     bias, precession and nutation in that order.
%
%  9) It is permissible to re-use the same array in the returned
%     arguments.  The arrays are filled in the order given.
%
%  Called:
%     iauPr00      IAU 2000 precession adjustments
%     iauObl80     mean obliquity, IAU 1980
%     iauBp00      frame bias and precession matrices, IAU 2000
%     iauCr        copy r-matrix
%     iauNumat     form nutation matrix
%     iauRxr       product of two r-matrices
%
%  Reference:
%     Capitaine, N., Chapront, J., Lambert, S. and Wallace, P.,
%     "Expressions for the Celestial Intermediate Pole and Celestial
%     Ephemeris Origin consistent with the IAU 2000A precession-
%     nutation model", Astron.Astrophys. 400, 1145-1154 (2003)
%     n.b. The celestial ephemeris origin (CEO) was renamed "celestial
%          intermediate origin" (CIO) by IAU 2006 Resolution 2.
%
%  This revision:  2010 January 18
%
%  SOFA release 2012-03-01
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [epsa, rb, rp, rbp, rn, rbpn] = iauPn00(date1, date2, dpsi, deps)

% IAU 2000 precession-rate adjustments.
[dpsipr, depspr] = iauPr00(date1, date2);

% Mean obliquity, consistent with IAU 2000 precession-nutation.
epsa = iauObl80(date1, date2) + depspr;

% Frame bias and precession matrices and their product.
[rb, rp, rbp] = iauBp00(date1, date2);iauBp00(date1, date2);

% Nutation matrix.
rn = iauNumat(epsa, dpsi, deps);

% Bias-precession-nutation matrix (classical).
rbpn = rn*rbp;

