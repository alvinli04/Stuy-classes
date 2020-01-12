;; dim: 68 * 40
;; lane center coords: 12, 6, -1, -8, -15
extensions [py]
globals [sunNum difficulty ticker]

breed [lawnmowers lawnmower]
breed [suns sun]
breed [zombies zombie]
breed [plants plant]
breed [bullets bullet]

suns-own [state ylim]
lawnmowers-own [state]
plants-own [health state cost mytick] ;;otherwise differentiated by shape
zombies-own [health state speed damage] ;;shape differentiation

to setup
  ca
  set ticker 0
  set difficulty 1
  py:setup "python3"
  (py:run
    "lane = {1:12, 2:6, 3:-1, 4:-8, 5:-15}"
    "plants = ['peashooter', 'sunflower', 'wallnut', 'cherry', 'snowpea']"
    "zombies = ['normal', 'cone', 'sports', 'garg']"
    "health = {'zombie':200, 'cone': 560, 'sports':500, 'garg':1600}"
    "speed = {}"
  )
  startAnimation
  makeMap
  create-ordered-lawnmowers 5
  [
    set shape "lawnmower"
    set size 7
    set color gray
    ask lawnmower 0 [setxy -19.7 12]
    ask lawnmower 1 [setxy -19.7 6]
    ask lawnmower 2 [setxy -19.7 -1]
    ask lawnmower 3 [setxy -19.7 -8]
    ask lawnmower 4 [setxy -19.7 -15]
  ]
end
;;main functions and animations
to go
  ;game functions
  ask lawnMowers [lawnmowerActions]
  ask plants [plantActions]
  ask bullets [bulletActions]
  ask zombies [zombieActions]
  if ticker mod 280 = 0
  [
    makeSun
  ]
  ask suns
  [
    sunActions
  ]

  set ticker (ticker + 1)
  wait .05 ;;20 fps
  ;show ticker
end

to startAnimation

end

to makeMap
  import-pcolors-rgb "map.PNG"
  ;;import-drawing "map.PNG"
end

;;lawnmowers
to lawnmowerActions
  if count zombies-here > 0 [set state "on"]
  set heading 90
  if state = "on"
  [
    ask zombies-here
    [
      set health -1
    ]
    fd .5
  ]
  if xcor > 33 [die]
end

;;sun
to makeSun
  create-ordered-suns 1
  [
    set size 7
    set ylim random 37 - 20
    set state "sky"
    set shape "sun"
    setxy random-xcor 16.4
  ]
end

to sunActions
  if state = "sky" and ycor > ylim
  [
    set ycor ycor - .5
  ]
  if distancexy mouse-xcor mouse-ycor < 2 and mouse-down?
  [
    set sunNum sunNum + 25
    die
  ]
end

;;plants
to plantActions
  set mytick mytick + 1
  let myy ycor
  ifelse count (zombies with [ycor = myy]) > 0
  [
    set state "shooting"
  ]
  [
    set state "stop"
    set mytick 0
  ]

  if state = "shooting" and (mytick mod 50 = 1)
  [
    shoot
  ]
end

to placePlant
  create-plants 1
  [
    set shape "peashooter"
    set size 7
    setxy -15 py:runresult "lane[1]"
  ]
end

to shoot
  let myshape shape
  hatch-bullets 1
  [
    set size 12
    (ifelse
      myshape = "peashooter"
      [
        set shape "pea"
      ]
      myshape = "default"
      [
        set shape "airplane"
      ]
    )
  ]
end

;;bullets
to bulletActions
  if count zombies-here > 0
  [
    ask zombies-here
    [
      set health health - 20
    ]
    die
  ]
  if xcor + .4 >= 34 [die]
  set xcor xcor + .4
end

;;zombies
to makeZombie
  create-zombies 1
  [
    set size 8
    set shape one-of ["zombie"]
    py:set "shape" shape
    set health py:runresult "health[shape]"
    let lane (random 4) + 1
    py:set "mylane" lane
    let laneycor py:runresult "lane[mylane]"
    setxy 34 laneycor
  ]
end

to zombieActions
  if health <= 0 [die]
  set xcor xcor - .07 * speed
end
@#$#@#$#@
GRAPHICS-WINDOW
200
104
895
521
-1
-1
10.0
1
10
1
1
1
0
0
0
1
-34
34
-20
20
0
0
1
ticks
30.0

BUTTON
87
232
150
265
NIL
go\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
88
189
151
222
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
85
108
171
153
Sun
sunNum
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

lawnmower
false
0
Circle -16777216 true false 70 184 45
Circle -16777216 true false 185 185 44
Polygon -2674135 true false 113 209 186 211 186 195 197 187 208 188 211 164 195 155 186 144 148 139 135 156 102 155 94 184 108 189 113 193 116 206
Polygon -7500403 true true 121 155 137 161 146 161 160 155 169 153 171 166 170 178 158 180 136 182 117 178 112 172 112 160 120 155
Polygon -16777216 true false 107 155 113 146 122 146 128 150 130 154 123 154 112 153
Polygon -16777216 true false 105 154 59 71 27 104 94 180 98 173 41 106 60 84 101 157

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pea
true
0
Circle -13840069 true false 135 135 30

peashooter
false
0
Rectangle -10899396 true false 144 177 157 249
Polygon -10899396 true false 134 240 123 219 108 223 98 234 96 240 108 246 130 245
Circle -13840069 true false 99 93 94
Polygon -13840069 true false 185 125 191 124 200 120 209 115 217 115 223 129 226 139 226 153 223 163 220 175 213 182 209 186 200 184 195 180 182 183 173 183 166 183 169 174 177 146
Polygon -16777216 true false 213 122 218 130 221 145 217 158 216 172 210 177 207 178 202 162 205 145 209 132
Circle -16777216 true false 150 127 12
Circle -16777216 true false 171 115 8
Polygon -13840069 true false 148 252 159 245 178 236 198 236 212 245 222 258 216 259 199 260 192 267 184 274 173 277 164 275 152 263 148 256 143 246 151 246 157 246
Polygon -13840069 true false 150 247 154 258 152 273 140 282 122 283 110 273 96 266 83 267 77 271 76 261 84 249 102 242 116 237 134 236 142 242
Polygon -10899396 true false 98 134 83 129 77 142 81 151 89 142

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

sun
true
0
Circle -1184463 true false 88 88 124
Polygon -1184463 true false 105 105 105 105 105 75 105 75 135 90 165 60 180 105 210 90 210 135 240 150 210 165 210 210 195 195 180 225 165 210 135 240 120 195 90 210 90 165 60 150 90 135 75 90 105 105
Circle -16777216 false false 90 90 120

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

zombie
false
7
Polygon -7500403 true false 105 173 89 167 88 171 94 175 98 178 93 176 85 179 87 185 94 186 111 183
Polygon -7500403 true false 117 198 109 200 103 206 103 212 107 210 112 205 110 209 110 217 116 218 120 217 120 211 127 207 129 198 123 195
Polygon -7500403 true false 182 213 184 228 205 245 212 246 191 227 189 211
Polygon -13345367 true false 185 188 195 215 177 219 167 188 181 182
Polygon -13345367 true false 156 202 163 218 141 250 112 249 137 217 132 205 152 176
Polygon -6459832 true false 129 144 112 160 104 170 110 185 132 165
Rectangle -1 true false 120 91 124 97
Rectangle -1 true false 135 87 140 93
Polygon -7500403 true false 110 59 128 50 141 47 155 50 165 57 173 63 175 72 174 89 166 101 151 109 142 118 126 119 116 112 116 106 124 103 130 106 138 103 138 97 131 94 123 96 116 97 111 92 108 84 104 76 103 68 111 60
Circle -1 true false 146 61 21
Circle -1 true false 105 64 18
Circle -16777216 true false 127 74 6
Circle -16777216 true false 138 76 3
Rectangle -1 true false 131 92 135 96
Rectangle -1 true false 122 100 125 105
Circle -16777216 true false 152 68 6
Circle -16777216 true false 111 71 4
Polygon -6459832 true false 169 97 172 108 176 120 181 142 185 156 187 174 187 187 174 193 166 199 150 204 147 206 145 198 145 178 143 163 144 146 144 133 144 124 144 116 151 109 154 101 164 100
Polygon -1 true false 143 117 128 117 125 125 130 144 128 166 128 184 132 185 139 177 146 175
Polygon -6459832 true false 159 121 156 148 150 176 149 169 129 183 116 198 129 212 139 198 148 192 162 183 161 162 167 141
Line -16777216 false 145 172 158 126
Line -16777216 false 172 134 159 181
Line -16777216 false 159 182 143 194
Polygon -6459832 true false 117 250 117 263 125 267 141 268 147 263 151 255 142 249 138 249
Polygon -6459832 true false 208 246 192 247 185 257 186 261 203 261 217 256 214 248 208 243 205 244
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
