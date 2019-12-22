;main procedure
to go
  fr1
  fr2
  fr3
  fr4
  fr5
end

;utility functions
to line [x1 y1 x2 y2]
  cro 1
  [
    set hidden? true
    setxy x1 y1
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

to text [x y str]
  ask patch x y
  [
    set plabel str
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
        wait .007
      ]
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
  wait 1
end

to fr2
  ca
  text -19 7 "A triangular number is one that is obtained by the summation of the natural numbers; 1, 2, 3, 4, 5, etc."
  wait 5
  text -19 5 "The nth triangular number is obtained by summing the first n natural numbers."
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
  wait 1.5
end

to fr4
  ca
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
  wait .75
  text -19 11 "now add another row."
  wait 1.1
  ask turtles
  [
    setxy xcor - 2 * sqrt 2 ycor
  ]
  wait .3
  spawn 4 * sqrt 2 6 "circle" red 2
  ask turtle 25 [rowDown 5]
  wait .2
  text 3 -11 "+ n"
  wait 2
end

to fr5
  text -19 12 ""
  text -19 11 ""
  line -9 -7.5 6 7.7
  let cy ([ycor] of turtle 0 + [ycor] of turtle 29) / 2
  let cx ([xcor] of turtle 0 + [xcor] of turtle 29) / 2
end








@#$#@#$#@
GRAPHICS-WINDOW
171
35
929
794
-1
-1
22.73
1
16
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
1266
243
1329
276
NIL
fr1\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1025
252
1088
285
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

BUTTON
1264
289
1327
322
NIL
fr2\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1266
337
1329
370
NIL
fr3\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1270
385
1333
418
NIL
fr4\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1271
430
1334
463
NIL
fr5
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
A visual proof of the formula for the sum of the 1st n numbers. Click go to play. Enjoy!
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
