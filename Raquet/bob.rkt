;fib function with only basic operations
(define phi1 (/ (+ 1 (sqrt 5)) 2))
(define phi2 (/ (- 1 (sqrt 5)) 2))
(define (getFib x) (* (/ 1 (sqrt 5)) (- (expt phi1 x) (expt phi2 x))))

;harry voldy thing
(define (harry voldy) (- (expt voldy 3) 3))
(define (joe me) (expt (+ (expt me 2) 2) 2))

;harry again
(define (harry q) (expt (f q) 2))
(define (f x) (+ (* x x) 2))
;(harry 2)
(define (g y) (- (f y) 2))
