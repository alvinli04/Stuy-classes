;1. f(x) is 2 when x <= 3, and is x^2 - 3x + 8 when x > 3
(define (f x)
  (if (<= x 3)
      2
      (+ (expt x 2) (* -3 x) 8)
     )
  )
;(f -2)=2, (f 3)=2, (f 4)=12, (f 5)=18

;2. Create a function called Div23 which is given an integer (non-negative) and returns #t if it's evenly divisible by either 2 or 3 or both, and #f if neither.
(define (Div23 x)
  (if (or (= (modulo x 2) 0) (= (modulo x 3) 0))
      #t
      #f
     )
  )
;(Div23 3)=#t,(Div23 6)=#t,(Div23 2)=#t,(Div23 7)=#f,(Div23 9)=#t,(Div23 137)=#f

;3. create fred
(define (fred me)
  (cond
    ((< me 0) 0)
    ((or (>= 0 me) (= (modulo me 5) 0)) 5)
    (else 23)
   )
  )
;(fred -1)=0, (fred 5)=5, (fred 7)=23

;4 & 6. navy time without conditionals
(define (toNavyTime hour ampm)
  (+ (modulo hour 12) (* ampm 12))
  )
;(toNavyTime 11 0)=11, (toNavyTime 1 1)=13, (toNavyTime 12 0)=0, (toNavyTime 12 1)=12

;5 return largest root of ax^2+bx+c
(define (biggie a b c)
  (max (/ (+ (* b -1) (sqrt (- (expt b 2) (* 4 a c)))) (* 2 a)) (/ (- (* b -1) (sqrt (- (expt b 2) (* 4 a c)))) (* 2 a)))
  )
;(biggie -2 3 9) = 3

;--challenge --

;6 done in 4

;7 Smallest divisor of N (N<100)
;helper function that acts as a loop to go through numbers
(define (divisible? n d)
  (if (= 0 (modulo n d))
         d
         (divisible? n (+ d 1))
       )
  )
;main function
(define (smallestDivisor n)
  (divisible? n 2)
  )
; (smallestDivisor 97)=97, (smallestDivisor 21)=3, (smallestDivisor 14)=2