patches-own [re im]
;main procedure
to go
  world
  fr1
  fr2
  fr3
  fr4
  fr5
  fr6
  fin
end

to world
  resize-world -16 16 -16 16
  set-patch-size 23.242424242424246
end

;utility functions
to line [x1 y1 x2 y2]
  cro 1
  [
    set hidden? true
    setxy x1 y1
    set size 2
    pd
    glide x2 y2
    die
  ]
end

to glide [x y]
  facexy x y
  while [abs (x - xcor) > .1 or abs (y - ycor) > .1]
  [
    fd .1
    wait .02
  ]
end

to glideAll [L]
  repeat 20
  [
    foreach L
    [
      [turt] -> ask turt
      [
        setxy xcor - (.1 * sqrt 2) ycor
      ]
    ]
    tick
    wait .04
  ]
end

to text [x y str]
  ask patch x y
  [
    set plabel-color black
    set plabel str
    fadeIn x y
  ]
end

to fadeOut [x y]
  ask patch x y
  [
    repeat 98
    [
      set plabel-color plabel-color - .1
      wait .01
    ]
  ]
end

to fadeIn [x y]
  ask patch x y
  [
    repeat 99
    [
      set plabel-color plabel-color + .1
      wait .01
    ]
  ]
end

to spawn [x y mshape mcolor msize]
  cro 1
  [
    set shape mshape
    set color mcolor
    set size msize
    setxy x y
  ]
end
;optimal lattice: 2 up 2 side from prev
;circles: blue red, size 2

to triangleDown [x y num]
  if num != 0
  [
    spawn x y "circle" red 2
    triangleDown (x - 2) (y - 2) (num - 1)
    triangleDown (x + 2) (y - 2) (num - 1)
  ]
end

to square [x]
  if x != 1
  [
    ask turtles with [who > 24 - 5 * x]
    [
     hatch 1
      [
        set heading 180
      ]
    ]
    repeat 20
    [
      ask turtles with [who > 24 - 5 * (x - 1)]
      [
        fd .1 * sqrt 2
      ]
      tick
      wait .035
    ]
    square x - 1
  ]
end

to rowDown [x]
  if x != 1
  [
    hatch 1
    [
      glide xcor ycor - 2 * sqrt 2
      rowDown x - 1
    ]
  ]
end

to dRotate [x y L]
  foreach L
  [
    [turt] -> ask turt [
      let dist distancexy x y
      let theta atan (ycor - y) (xcor - x)
      setxy (x + dist * cos (theta + 1)) (y + dist * sin (theta + 1))
    ]
  ]
  wait .025
  tick
end

to endSc

end

;frames
to fr1
  ca
  text 5 0 "A Visual Proof of Triangular Numbers"
  wait 1
  triangleDown 7 11 1
  wait .5
  triangleDown 7 11 2
  wait .5
  triangleDown -8 -7 1
  wait .5
  triangleDown -8 -7 2
   wait .5
  triangleDown -8 -7 3
  wait 1
  text 3 -2 "an animation by Alvin Li"
  wait 2.5
end

to fr2
  ca
  text -19 7 "A triangular number is one that is obtained by the "
  text -19 5 "summation of the natural numbers; 1, 2, 3, 4, 5, etc."
  wait 5
  text -19 3 "The nth triangular number is obtained by summing the first n natural numbers."
  wait 3.3
  triangleDown 0 0 4
  wait 1
  text -19 -10 "This is 10, the 4th triangular number. (See why they're called triangular?)"
  wait 3
end

to fr3
  ca
  text -19 7 "The sum of the first n natural numbers can be calculated easily with this formula."
  wait 2.5
  spawn -11 -2 "sum" blue 10
  wait .5
  spawn -11 -6.5 "k=1" blue 5
  wait .5
  spawn -11 2.5 "n" blue 5
  wait .5
  spawn -5 -2 "=" blue 7
  wait .5
  spawn -.5 1 "n" blue 7
  spawn 3 1 "(" blue 7
  spawn 5 1 "n" blue 7
  spawn 8 1 "plus" blue 3
  spawn 10 1 "1" blue 7
  spawn 12 1 ")" blue 7
  spawn 5 -2 "-" blue 14
  spawn 5 -5 "2" blue 7
  wait 1
  ask turtles [set color 15]
  wait 1
  ask turtles [set color 25]
  wait 1
  ask turtles [set color 45]
  wait 1
  ask turtles [set color 65]
  wait 1
  ask turtles [set color 95]
  wait .5
  text 12 -11 "But why is that?"
  wait 2.2
end

to fr4
  ca
  reset-ticks
  text -19 12 "Lets take any number and square it."
  wait 1
  spawn -4 * sqrt 2 6 "circle" red 2
  spawn -2 * sqrt 2 6 "circle" red 2
  spawn 0 6 "circle" red 2
  spawn 2 * sqrt 2 6 "circle" red 2
  spawn 4 * sqrt 2 6 "circle" red 2
  text 0 -11 "n"
  wait .73
  square 5
  wait .5
  text 1 -10 "2"
  wait 1
  text -19 11 "now add another column."
  wait 1.1
  glideAll (list turtles)
  wait .3
  spawn 4 * sqrt 2 6 "circle" red 2
  ask turtle 25 [rowDown 5]
  wait .2
  text 3 -11 "+ n"
  wait 2
end

to fr5
  reset-ticks
  fadeOut -19 12
  ask patch -19 12 [set plabel-color black]
  fadeOut -19 11
  ask patch -19 11 [set plabel-color black]
  ;text -19 12 ""
  ;text -19 11 ""
  line -9 -7.5 6 7.7
  wait 1
  let cy ([ycor] of turtle 0 + [ycor] of turtle 29) / 2
  let cx ([xcor] of turtle 0 + [xcor] of turtle 29) / 2
  ask turtles with [ycor < xcor + 1.6] [set color blue]
  let L (list turtles with [color = blue])
  repeat 180 [dRotate cx cy L]
  ;rotate
  ask turtles [set color blue]
  wait .45
  cro 1
  [
    setxy 4 -12
    set size .000001
    set label "____________"
  ]
  text 2 -13 "2"
  wait 1.5
  text -8 8 "n"
  text -5 8 "n - 1"
  text -1 8 ". . ."
  text 3 8 "1"
  wait 2.5
  text -2 -12 "Therefore, 1 + 2 + ... + (n - 1) + n = "
  wait 3
end

to fr6
  ca
  text 7 7 "This proves what was stated earlier."
  wait 1.5
  spawn -11 -2 "sum" blue 10
  wait .5
  spawn -11 -6.5 "k=1" blue 5
  wait .5
  spawn -11 2.5 "n" blue 5
  wait .5
  spawn -5 -2 "=" blue 7
  wait .5
  spawn -.5 1 "n" blue 7
  spawn 3 1 "(" blue 7
  spawn 5 1 "n" blue 7
  spawn 8 1 "plus" blue 3
  spawn 10 1 "1" blue 7
  spawn 12 1 ")" blue 7
  spawn 5 -2 "-" blue 14
  spawn 5 -5 "2" blue 7
  wait 1
  ask turtles [set color 15]
  wait 1
  ask turtles [set color 25]
  wait 1
  ask turtles [set color 45]
  wait 1
  ask turtles [set color 65]
  wait 1
  ask turtles [set color 95]
  wait 2.5
end

to fin
  ca
  wait 0.2
  end-animation
end

;end animation
to end-animation
  set-patch-size 1
  resize-world -383 383 -383 383
  text 3 0 "Thanks for watching!"
  let b 1 / 383
  let L (list patches)
  foreach L
  [
    p -> ask p
    [
      set re pxcor * b
      set im pycor * b
      let c (list re im)
      ifelse inM c = -1
      [
       set pcolor black
      ]
      [
        set pcolor approximate-hsb (255 * inM c / 100) 255 255
      ]
    ]
  ]
end

to-report sq [c]
  let a item 0 c
  let b item 1 c
  let newRe a * a - b * b
  let newIm 2 * a * b
  report (list newRe newIm)
end

to-report mag [c]
  let a item 0 c
  let b item 1 c
  report sqrt (a * a + b * b)
end

to-report add [z w]
  let a item 0 z
  let b item 1 z
  let c item 0 w
  let d item 1 w
  report (list (a + c) (b + d))
end

to-report inM [c]
  let w [0 0]
  let i 0
  while [i < 100]
  [
    set w add (sq w) c
    if mag w > 2
    [
      report i + 1 - ln (log (mag w) 2)
    ]
    set i i + 1
  ]
  report -1
end
@#$#@#$#@
GRAPHICS-WINDOW
110
30
885
806
-1
-1
1.0
1
16
1
1
1
0
1
1
1
-383
383
-383
383
0
0
1
ticks
30.0

BUTTON
966
416
1029
449
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## Netlogo Animation Project
A visual proof of the formula for triangular numbers. Click go to play. Enjoy!

## Credits
Creator : Alvin Li

Inspired by Flammable Maths
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

(
true
0
Polygon -7500403 true true 195 75 180 60 165 75 150 90 135 105 120 135 120 165 135 195 180 240 195 225 150 180 135 165 135 135 195 75

)
true
0
Polygon -7500403 true true 105 75 120 60 135 75 150 90 165 105 180 135 180 165 165 195 120 240 105 225 150 180 165 165 165 135 105 75

-
true
0
Rectangle -7500403 true true 0 135 300 150

1
true
0
Rectangle -7500403 true true 150 75 165 210
Polygon -7500403 true true 150 75 135 90 150 90

2
true
0
Polygon -7500403 true true 105 105 105 90 135 60 180 60 210 90 210 135 150 195 210 195 210 225 105 225 105 180 165 120 165 105 150 105 150 120 105 120 105 105

=
true
0
Rectangle -7500403 true true 120 120 180 135
Rectangle -7500403 true true 120 150 180 165

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

circle
false
0
Circle -7500403 true true 0 0 300

k=1
true
0
Polygon -7500403 true true 45 105 45 195 60 195 60 165 90 195 105 195 60 150 105 105 90 105 60 135 60 105 45 105
Rectangle -7500403 true true 120 120 165 135
Rectangle -7500403 true true 120 150 165 165
Rectangle -7500403 true true 210 105 225 195
Polygon -7500403 true true 210 105 195 120 210 120

n
true
0
Polygon -7500403 true true 105 210 105 90 120 90 120 105 135 90 150 90 180 90 180 90 195 105 210 120 210 210 195 210 195 150 195 135 180 120 165 105 165 105 135 105 120 120 120 120 120 210 105 210

plus
true
0
Rectangle -7500403 true true 135 75 165 225
Rectangle -7500403 true true 90 135 90 150
Rectangle -7500403 true true 75 135 225 165

square
false
0
Rectangle -7500403 true true 30 30 270 270

sum
true
0
Polygon -7500403 true true 225 60 225 75 105 75 180 150 105 225 225 225 225 240 75 240 60 240 150 150 60 60 225 60 225 60
Polygon -7500403 true true 225 225 240 210 225 240
Polygon -7500403 true true 225 60 240 90 225 75

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
