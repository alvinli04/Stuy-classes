(define (myAbs a)
    (if (< 0 a) a (* -1 a)))

(define (f x)
  (if (> x 3)
      (expt x 2)
      (+ x 1)
     )
  )

(define (rev s)
  (if (= s 1)
      5
      (if (= s 2)
          3
          (if (= s 3)
              1)
          )
      )
  )
