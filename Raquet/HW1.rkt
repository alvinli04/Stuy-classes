#lang r5rs
;#1
(+ 3.0 (/ 1 (+ 7 (/ 1 16))))
;answer: 3.14159, this is an approximation of pi

;#2a
(modulo (expt 2 12) 13) ;1
;#2b
(modulo (expt 5 22) 23) ;1
;#2c
(modulo (expt 55 6) 7) ;1
;#2d
(modulo (expt 18 42) 43) ;1

;#3a
(define au 93e+6)
(define c 186e+3)
(/ (/ au c) 60)
;answer: 8.33 min

;#3b
(define cFt (* c 5280))
(/ cFt 1000000000)
;answer: 0.98

;#3c
(define Fred (* cFt 365.242196 60 60 24))
(define George (+ Fred 1))
(- George Fred)
;answer: 0.0

(#%provide Fred)
(#%provide George)