OPTION BASE 1

DIM TIME(241), MASS(241), WIDTH(241), HEIGHT(241) AS DOUBLE
DIM m0, m1, g, C, R, Temp, den, V, X1, X2, Y, Y2 AS DOUBLE
DIM K1, K2, K3, K4, P2, t, t0, m, mp, alpha, x AS DOUBLE
DIM LL, WW, HH, stepSize AS DOUBLE
DIM j, i, ii AS INTEGER

g = 10.00
C = 0.64
R = 278
den = 1.20
LL = 3.05
WW = 3.05
HH = 3.05
Temp = 363
V = LL * WW * HH
P2 = 100000
t0 = 0.00
t = 0.00
stepSize = 0.5
m0 = den * V
m = m0
x = 0
alpha = ((g * C) / (R * Temp))

PRINT TAB(10); "MODELLING VENTILATION OF SMOKE-LOGGED ROOM"
PRINT TAB(10); "=========================================="
PRINT
PRINT "            S/No.        Time(s)        Mass(kg)"
PRINT "            =====        ======         ========="
tmp$ = "           #####        ###.##         ##.######"

j = 1
FOR i = 1 TO 241
    TIME(i) = 0.00
    MASS(i) = 0.00
    WIDTH(i) = 0.00
    HEIGHT(i) = 0.00
NEXT

PRINT USING tmp$; j; t; m
TIME(j) = t
MASS(j) = m

DO
    x = 2 * R * Temp * m ^ 2 - P2 * V * m
    IF (x < 0) THEN
        x = -x
        'EXIT DO
    END IF
    K1 = -(alpha * SQR(x))
    m = m0 + (K1 * stepSize) / 2
    t = t0 + stepSize / 2
    K2 = -(alpha * SQR(x))
    m = m0 + (K2 * stepSize) / 2
    t = t0 + stepSize / 2
    K3 = -(alpha * SQR(x))
    m = m0 + K3 * stepSize
    t = t0 + stepSize
    K4 = -(alpha * SQR(x))
    m = m0 + (1 / 6) * (K1 + 2 * (K2 + K3) + K4) * 0.5
    j = j + 1
    PRINT USING tmp$; j; t; m
    TIME(j) = t
    MASS(j) = m

    'DO: K$ = UCASE$(INKEY$)
    'LOOP UNTIL K$ = "Y" ' OR K$ = "N"

    m0 = m
    t0 = t
LOOP UNTIL (t = 120)

PRINT
PRINT

DO
    INPUT "       Is a printer ready(Y/N)?  Enter y or n and press enter.", ans$
LOOP UNTIL ((ans$ = "Y" OR ans$ = "y") OR (ans$ = "N" OR ans$ = "n"))

IF (ans$ = "Y" OR ans$ = "y") THEN
    LPRINT TAB(10); "MODELLING VENTILATION OF SMOKE-LOGGED ROOM"
    LPRINT TAB(10); "=========================================="
    LPRINT
    LPRINT "            S/No.        Time(s)        Mass(kg)"
    LPRINT "            =====        ======         ========="
    tmp$ = "            #####        ###.##         ##.######"
    FOR j = 1 TO 241
        LPRINT USING tmp$; j; TIME(j); MASS(j)
    NEXT
END IF

CLS
SCREEN 12

LOCATE 2, 20: PRINT "VENTILATION OF SMOKE-LOGGED ROOM";
LOCATE 3, 20: PRINT "GRAPH OF SMOKE MASS(KG) VS TIME(S)";

'SCREEN 640 x 480
X1 = 80
X2 = 620
Y = 48
Y2 = 420

m0 = den * V
m1 = 8.072195
ii = 0

'Mapping MASS and TIME to SCREEN pixel.
FOR ii = 1 TO 241
    HEIGHT(ii) = Y2 - ((MASS(ii) - m1) / (m0 - m1)) * (Y2 - Y)
    WIDTH(ii) = X1 + (TIME(ii) / 120) * (X2 - X1)
NEXT

'DRAW AXES
'Y - AXIS
LINE (X1, Y)-(X1, Y2), 7
LINE (72, Y)-(82, Y)
LINE (72, (Y + 96))-(82, (Y + 96))
LINE (72, (Y + 196))-(82, (Y + 196))
LINE (72, (Y + 288))-(82, (Y + 288))
LINE (72, 420)-(82, 420)

'X - AXIS
LINE (X1, Y2)-(X2, Y2), 7
LINE (X1, (Y2 - 3))-(X1, (Y2 + 3))
LINE ((X1 + 135), (Y2 - 3))-((X1 + 135), (Y2 + 3))
LINE ((X1 + 270), (Y2 - 3))-((X1 + 270), (Y2 + 3))
LINE ((X1 + 405), (Y2 - 3))-((X1 + 405), (Y2 + 3))
LINE ((X1 + 540), (Y2 - 3))-((X1 + 540), (Y2 + 3))

'Label Axes
'Y - Axis
LOCATE 13, 2: PRINT "Mass(Kg)";
LOCATE 4, 5: PRINT "34.05";
LOCATE 10, 5: PRINT "27.55";
LOCATE 16, 5: PRINT "21.06";
LOCATE 22, 5: PRINT "14.56";
LOCATE 27, 6: PRINT "8.07";

'X - Axis
LOCATE 29, 35: PRINT "Time(S)";
LOCATE 28, 11: PRINT "0";
LOCATE 28, 27: PRINT "30";
LOCATE 28, 44: PRINT "60";
LOCATE 28, 61: PRINT "90";
LOCATE 28, 77: PRINT "120";

'Draw Curve
ii = 1
DO
    LINE (WIDTH(ii), HEIGHT(ii))-(WIDTH(ii + 1), HEIGHT(ii + 1)), 7
    ii = ii + 1
LOOP UNTIL (ii = 240)


