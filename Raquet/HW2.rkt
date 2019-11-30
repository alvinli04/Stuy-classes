;1: celsius and fahrenheit conversions
(define (c2f cels) (+ 32 (* cels 9/5)))
(define (f2c fahr) (/ (- fahr 32) 9/5))

;2 dist from origin
(define (dist x y) (sqrt (+ (expt x 2) (expt y 2))))

; -- challenge --

;3 maximum without max() or conditionals
(define (maximum a b) (/ (+ (abs (- a b)) a b) 2))

;4 round num to ndecimals places
(define (prec num ndecimals) (/ (round (* num (expt 10 ndecimals))) (expt 10 ndecimals)))

;5 round num to nearest multiple of near
(define (nearest num near) (* near (round (/ num near))))
