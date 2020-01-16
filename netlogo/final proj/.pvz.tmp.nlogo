;; dim: 68 * 40
;; lane center coords: 12, 6, -1, -8, -15
;; column centers: -15 -10 -5 0 5 10 15 20 25
extensions [py]
globals [sunNum difficulty ticker occupied shovel? levelpicked gameEnd won? noMore t1 t2 t3 t4 t5]

breed [bullets bullet]
breed [plants plant]
breed [zombies zombie]
breed [lawnmowers lawnmower]
breed [suns sun]

suns-own [state ylim mytick]
lawnmowers-own [state]
plants-own [health state cost mytick suntick] ;;otherwise differentiated by shape
zombies-own [health state speed mytick damage] ;;shape differentiation

to setup
  cp
  ct
  set ticker 0
  set sunNum 25
  set occupied false
  set shovel? false
  set gameEnd false
  set won? false
  set noMore false
  py:setup py:python
  (py:run
    "lane = {1:12, 2:6, 3:-1, 4:-8, 5:-15}"
    "lanes = [12, 6, -1, -8, -15]"
    "columns = [-15, -10, -4, 1, 7, 13, 18, 23, 29]"
    "plants = ['peashooter', 'sunflower', 'wallnut', 'cherry', 'snowpea', 'mine']"
    "plantHealth = {'peashooter':300, 'sunflower':300, 'wallnut':4000, 'snowpea':300, 'mine':1000}"
    "zombies = ['normal', 'cone', 'sports', 'garg']"
    "health = {'zombie':200, 'cone': 560, 'sports':300, 'garg':3000}"
    "damage = {'zombie':100, 'cone': 100, 'sports':150, 'garg':500}"
    "speed = {'zombie':1, 'cone': 1, 'sports':1.75, 'garg':.4}"
  )
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
  waves
  ask lawnMowers [lawnmowerActions]
  ask plants [plantActions]
  ask bullets [bulletActions]
  ask zombies [zombieActions]
  if ticker mod 140 = 0
  [
    makeSun
  ]
  ask suns
  [
    sunActions
  ]

  set ticker (ticker + 1)
  wait .05 ;;20 fps
  if count (zombies with [xcor < -23]) > 0
  [
    loseAnimation
    set gameEnd true
    set won? false
  ]
  if noMore and count zombies = 0
  [
    winAnimation
    set gameEnd true
    set won? true
  ]

end

to load
  ca
  set levelpicked false
  set gameEnd false
  set levelpicked false
  set t1 -1000
  set t2 -1000
  set t3 -1000
  set t4 -1000
  set t5 -1000
  ask patch 8 0
  [
    set plabel-color black
    set plabel "Plants vs. Zombies 3"
    repeat 99
    [
      set plabel-color plabel-color + .1
      wait .01
    ]
  ]
  create-plants 1
  [
    setxy -21 5
    set shape "peashooter"
    set size 20
  ]
  create-zombies 1
  [
    setxy 21 5
    set shape "zombie"
    set size 15
  ]
  wait 1
  ask patch 8 -6
  [
    set plabel "select difficulty (click):"
  ]
  ask patch -8 -13
  [
    set plabel "easy"
  ]
  ask patch 8 -13
  [
    set plabel "hard"
  ]
  while [not levelpicked]
  [
    ;print "running"
    ask patch -9 -13
    [
      ;print distancexy mouse-xcor mouse-ycor
      if distancexy mouse-xcor mouse-ycor <= 1.5 ;and mouse-down?
      [
        ;print "hi"
        set difficulty "easy"
        set levelpicked true
      ]
    ]

    ask patch 6 -13
    [
      if distancexy mouse-xcor mouse-ycor <= 1.5 and mouse-down?
      [
        set difficulty "hard"
        set levelpicked true
      ]
    ]
  ]
  setup
end

to-report cooldown [tx time]
  ifelse (tx + time * 20 - ticker) / 20 < 0
  [report 0]
  [report (tx + time * 20 - ticker) / 20]
end

;;win and lose screens
to loseAnimation
  ca
  cro 1
  [
    set size 17
    set shape "dead"
    setxy 10 -10
  ]
  ask patch 11 4
  [
    set plabel "THE ZOMBIES ATE YOUR BRAINS!!!!"
    set plabel-color red
  ]
  wait 5
  load
end

to winAnimation
  ca
  ask patch 11 4
  [
    set plabel "You survived, for now..."
  ]
  wait 5
  load
end

to makeMap
  import-drawing "map.PNG"
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
    setxy (random 51 - 17) 16.4
  ]
end

to sunActions
  if state = "sky" and ycor > ylim
  [
    set ycor ycor - .2
  ]
  if distancexy mouse-xcor mouse-ycor < 2 and mouse-down?
  [
    set sunNum sunNum + 25
    die
  ]
  if mytick >= 260 [die]
  set mytick mytick + 1
end

;;plants
to plantActions
  set mytick mytick + 1
  let myy ycor
  let myx xcor
  if health <= -1 [die]
  (ifelse
    count (zombies with [ycor = myy and xcor > myx]) > 0 and state != "persuit"
    [
      set state "shooting"
    ]
    state != "persuit"
    [
      set state "idle"
      set mytick 0
    ]
  )
  if state = "shooting" and (mytick mod 35 = 1)
  [
    shoot
  ]
  sunFlower
  if shape = "mine"
  [
    if count zombies-here > 0
    [
      ask zombies with [shape != "garg"]
      [
        die
      ]
      ask zombies with [shape = "garg"]
      [
        set health health - 1500
      ]
      die
    ]
  ]
  ;;drag and drop function
  if state = "persuit"
  [
    setxy mouse-xcor mouse-ycor
    if mouse-down?
    [
      py:set "proxX" xcor
      py:set "proxY" ycor
      (py:run
        "placeY = None"
        "placeX = None"
        "lim = 100"
        "for i in lanes:"
        "    if abs(proxY - i) < lim:"
        "        lim = abs(proxY - i)"
        "        placeY = i"
        "lim = 100"
        "for i in columns:"
        "    if abs(proxX - i) < lim:"
        "        lim = abs(proxX - i)"
        "        placeX = i"
        )
      if count [turtles-at py:runresult "placeX" py:runresult "placeY"] of patch 0 0 = 0 and not shovel?
      [
        setxy py:runresult "placeX" py:runresult "placeY"
        set state "idle"
        set occupied false
      ]

      if shovel?
      [
        setxy py:runresult "placeX" py:runresult "placeY"
        set occupied false
        set shovel? false
        ask plants-here [die]
      ]
    ]
  ]
end

to placePlant [myPlant]
  if not occupied and not shovel?
  [
    set occupied true
    create-plants 1
    [
      py:set "myPlant" myPlant
      set health (py:runresult "plantHealth[myPlant]")
      set shape myPlant
      set size 7
      set state "persuit"
    ]
  ]

  if not occupied and shovel?
  [
    set occupied true
    create-plants 1
    [
      set shape "shovel"
      set size 7
      set state "persuit"
    ]
  ]
end

to shoot
  if shape = "peashooter" or shape = "snowpea"
  [
    let myshape shape
    hatch-bullets 1
    [
      set size 12
      (ifelse
        myshape = "peashooter"
        [
          set shape "pea"
        ]
        myshape = "snowpea"
        [
          set shape "snowbullet"
        ]
      )
    ]
  ]
end

to sunFlower
  set suntick suntick + 1
  let myX xcor
  let myY ycor
  if shape = "sunflower" and suntick mod 350 = 140
  [
    hatch-suns 1
    [
      set size 7
      set shape "sun"
    ]
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
    if shape = "snowbullet"
    [
      ask zombies-here with [state != "attacking"]
      [
        set state "frozen"
        set health health - 10
      ]
    ]
    die
  ]
  if xcor + .4 >= 34 [die]
  set xcor xcor + .7
end

;;zombies
to makeZombie [lane myshape time]
  if ticker = time * 20
  [
    create-zombies 1
    [
      set shape myshape
      set state "mobile"
      ifelse shape != "garg"
      [
        set size 9
      ]
      [
        set size 13
      ]
      py:set "shape" myshape
      set health py:runresult "health[shape]"
      set damage py:runresult "damage[shape]"
      set speed py:runresult "speed[shape]"
      py:set "mylane" lane
      let laneycor py:runresult "lane[mylane]"
      setxy 34 laneycor
    ]
  ]
end

to zombieActions
  if health <= 0 [die]
  if state = "mobile"
  [
    set xcor xcor - .04 * speed
  ]
  if state = "frozen"
  [
    set xcor xcor - 0.02 * speed
    set mytick 0
  ]
  if mytick = 60
  [
    set state "mobile"
  ]
  if mytick mod 20 = 0
  [
    set state "attacking"
    attack
  ]
  set mytick mytick + 1
end

to attack
  let mydamage damage
  if count [plants-at -2 0] of patch round xcor round ycor = 0
  [
    ;print round xcor - 2
    set state "mobile"
  ]
  if state = "attacking"
  [
    ask [plants-at -2 0] of patch round xcor round ycor
    [
      set health health - mydamage
    ]
  ]
end

;;writing the waves of zombies
to waves
  ;makeZombie lane shape time
  ;20 fps
  if difficulty = "easy"
  [
    makeZombie 2 "zombie" 25
    makeZombie 1 "zombie" 55
    makeZombie 3 "zombie" 75
    makeZombie 3 "cone" 90
    makeZombie 5 "cone" 75
    makeZombie 2 "sports" 120
    makeZombie 1 "zombie" 120
    makeZombie 3 "sports" 150
    makeZombie 5 "cone" 160
    makeZombie 2 "zombie" 160
    makeZombie 3 "zombie" 160
    bigWaveMessage 170
    makeZombie 1 "zombie" 185
    makeZombie 1 "cone" 185
    makeZombie 1 "zombie" 187
    makeZombie 2 "zombie" 185
    makeZombie 2 "sports" 187
    makeZombie 3 "garg" 186
    makeZombie 4 "zombie" 185
    makeZombie 4 "sports" 187
    makeZombie 5 "sports" 185
    makeZombie 5 "cone" 187
    makeZombie 5 "zombie" 187
    if ticker > 210 * 20 [set noMore true]
  ]
  if difficulty = "hard"
  [
    bigWaveMessage 10
    makezombie 2 "zombie" 20
    if ticker > 20 * 20 [set noMore true]
  ]
end

to bigWaveMessage [time]
  if ticker = time * 20
  [
    cro 1
    [
      setxy 16 0
      set size .0001
      set label-color red
      set label "A BIG WAVE OF ZOMBIES IS APPROACHING!!"
    ]
  ]
  if ticker = time * 20 + 60
  [
    ask turtles with [size = .0001]
    [
      die
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
189
34
887
453
-1
-1
10.0
1
20
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

MONITOR
91
35
177
80
Sun
sunNum
17
1
11

BUTTON
489
459
636
492
snow pea: 175 sun
if sunNum < 175 [stop]\nif ticker < t3 + 100 [stop]\nset t3 ticker\nplacePlant \"snowpea\"\nset sunNum sunNum - 175
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
22
517
156
550
get 10000 sun
set sunNum 10000\n
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
335
460
482
493
peashooter: 100 sun
if sunNum < 100 [stop]\nif ticker < t2 + 100 [stop]\nset t2 ticker\nplacePlant \"peashooter\"\nset sunNum sunNum - 100
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
646
459
766
492
wall-nut: 50 sun
if sunNum < 50 [stop]\nif ticker < t4 + 400 [stop]\nset t4 ticker\nplacePlant \"wallnut\"\nset sunNum sunNum - 50
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
189
460
320
493
sunflower: 50 sun
if sunNum < 50 [stop]\nif ticker < t2 + 100 [stop]\nset t2 ticker\nplacePlant \"sunflower\"\nset sunNum sunNum - 50
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
107
94
174
127
shovel
if levelpicked [\n    set shovel? true\n    placePlant \"shovel\"\n]
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
87
229
175
262
load game
load
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
86
273
179
306
play/pause
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

TEXTBOX
52
324
202
366
Click load game, pick the difficulty, and press play to run.
11
0.0
1

TEXTBOX
56
138
206
156
Gets rid of plants for free!\n
11
0.0
1

TEXTBOX
320
567
590
647
Plants and their respective sun costs. To place a plant, click a button and drag it to where you want it to be placed. Click again to place.\n
13
0.0
1

BUTTON
774
459
916
492
potato mine: 25 sun
if sunNum < 25 [stop]\nif ticker < t5 + 340 [stop]\nset t5 ticker\nplacePlant \"mine\"\nset sunNum sunNum - 25\n
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
778
500
840
545
cooldown
cooldown t5 17
0
1
11

MONITOR
189
501
254
546
cooldown
cooldown t1 5
0
1
11

MONITOR
336
501
401
546
cooldown
cooldown t2 5
0
1
11

MONITOR
490
501
555
546
cooldown
cooldown t3 5
0
1
11

MONITOR
645
499
710
544
cooldown
cooldown t4 20
0
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

cone
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
Polygon -955883 true false 137 43 117 51 138 59 172 56 155 43 152 13 139 13
Rectangle -1 true false 137 35 155 44
Line -16777216 false 146 205 187 185
Line -16777216 false 186 186 186 161
Line -16777216 false 185 160 169 94
Line -16777216 false 146 171 144 114
Line -16777216 false 128 145 103 167
Line -16777216 false 126 168 109 185

dead
false
0
Circle -10899396 true false 63 63 175
Line -16777216 false 112 120 137 145
Line -16777216 false 137 116 110 149
Line -16777216 false 174 118 206 143
Line -16777216 false 202 111 177 149
Line -16777216 false 98 189 113 179
Line -16777216 false 113 180 143 176
Line -16777216 false 144 176 180 182
Line -16777216 false 181 183 192 191

garg
false
7
Polygon -7500403 true false 85 101 83 118 86 133 93 142 96 152 94 162 99 166 112 167 122 125
Polygon -6459832 true false 110 202 100 211 109 222 149 219 142 196
Polygon -13345367 true false 107 158 110 205 141 200 139 157
Polygon -13345367 true false 190 138 193 193 141 201 140 159 174 133
Polygon -7500403 true false 108 141 107 159 131 162 146 159 161 148 158 127
Polygon -6459832 true false 110 47 127 41 151 44 173 51 193 58 179 76 156 92 156 99 160 121 160 127 131 140 111 146 106 140 104 122 99 114 89 103 82 98
Polygon -7500403 true false 88 39 80 42 71 53 69 64 67 70 70 77 74 89 75 101 90 103 99 100 107 95 117 82 116 67 114 54 106 43
Polygon -7500403 true false 192 60 177 65 169 81 156 92 156 97 157 115 158 128 160 148 161 161 156 167 159 178 160 186 176 185 192 173 196 159 188 156 188 142 198 126 198 113 199 97 199 82 199 72
Polygon -16777216 false false 191 62 182 62 175 72 166 82 158 90 156 97 160 162 156 167 160 185 177 185 188 175 195 161 188 156 188 143 197 125 200 81 197 69
Line -16777216 false 139 159 142 203
Polygon -6459832 true false 142 201 128 205 131 221 147 226 173 221 203 217 193 193
Polygon -16777216 false false 141 200 128 203 130 218 146 227 199 219 192 197 137 200
Line -16777216 false 156 101 98 115
Line -16777216 false 159 119 107 130
Circle -1 true false 93 61 20
Circle -16777216 true false 104 73 3
Line -16777216 false 101 52 92 62
Circle -1 true false 68 67 12
Circle -16777216 true false 71 73 4
Line -16777216 false 71 64 79 67
Circle -16777216 true false 79 80 2
Circle -16777216 true false 87 79 2
Polygon -16777216 true false 79 88 90 87 98 89 99 95 87 96 76 94
Rectangle -1 true false 91 87 94 92
Rectangle -1 true false 91 87 94 92
Rectangle -1 true false 81 88 84 93
Rectangle -1 true false 86 91 89 96
Line -16777216 false 109 144 110 160

lawnmower
false
0
Circle -16777216 true false 70 184 45
Circle -16777216 true false 185 185 44
Polygon -2674135 true false 113 209 186 211 186 195 197 187 208 188 211 164 195 155 186 144 148 139 135 156 102 155 94 184 108 189 113 193 116 206
Polygon -7500403 true true 121 155 137 161 146 161 160 155 169 153 171 166 170 178 158 180 136 182 117 178 112 172 112 160 120 155
Polygon -16777216 true false 107 155 113 146 122 146 128 150 130 154 123 154 112 153
Polygon -16777216 true false 105 154 59 71 27 104 94 180 98 173 41 106 60 84 101 157

mine
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

pea
true
0
Circle -13840069 true false 135 135 30

peashooter
false
0
Rectangle -10899396 true false 144 177 157 249
Polygon -10899396 true false 134 240 123 219 108 223 98 234 96 240 108 246 130 245
Circle -10899396 true false 99 93 94
Polygon -10899396 true false 185 125 191 124 200 120 209 115 217 115 223 129 226 139 226 153 223 163 220 175 213 182 209 186 200 184 195 180 182 183 173 183 166 183 169 174 177 146
Polygon -16777216 true false 213 122 218 130 221 145 217 158 216 172 210 177 207 178 202 162 205 145 209 132
Circle -16777216 true false 150 127 12
Circle -16777216 true false 171 115 8
Polygon -13840069 true false 148 252 159 245 178 236 198 236 212 245 222 258 216 259 199 260 192 267 184 274 173 277 164 275 152 263 148 256 143 246 151 246 157 246
Polygon -13840069 true false 150 247 154 258 152 273 140 282 122 283 110 273 96 266 83 267 77 271 76 261 84 249 102 242 116 237 134 236 142 242
Polygon -13840069 true false 98 134 83 129 77 142 81 151 89 142
Polygon -16777216 false false 214 115 207 117 192 123 182 109 175 99 163 94 146 94 134 95 119 101 108 112 102 122 101 137 86 130 77 139 81 149 92 137 101 143 103 158 107 167 113 174 121 182 134 185 145 187 145 198 145 215 144 226 144 236 144 246 136 237 130 233 124 219 121 216 111 220 104 228 100 235 95 241 100 241 85 252 79 262 75 271 91 264 98 264 106 270 112 275 118 282 128 282 143 281 148 277 152 272 154 262 157 271 162 276 172 277 180 275 187 269 193 263 199 261 208 260 223 257 218 251 209 244 202 237 195 234 185 234 177 238 160 244 154 245 157 234 157 221 155 203 156 191 158 182 170 181 180 180 187 180 195 179 206 183 212 183 218 176 223 169 224 160 226 150 226 143 225 135 222 129 221 121 217 115

shovel
false
7
Polygon -2674135 true false 187 83 226 117 217 130 201 118 178 141 164 128 181 112 164 96 180 81
Polygon -6459832 true false 167 130 125 175 132 188 175 135
Polygon -7500403 true false 127 171 139 178 135 187 169 209 163 228 148 239 122 246 96 247 86 241 80 223 75 197 78 176 88 169 107 179 114 182 122 172
Line -16777216 false 124 197 106 231

snowbullet
true
0
Circle -11221820 true false 135 135 30
Polygon -1 true false 147 136 145 145 138 150 134 145 134 138 141 134 147 134
Polygon -1 true false 157 146 160 154 166 150 165 143 159 140

snowpea
false
0
Polygon -13791810 true false 101 151 84 155 71 145 81 130 102 133 67 124 69 97 93 96 111 115 104 103 116 93 122 103
Polygon -13791810 true false 127 176 115 187 122 170 110 185 98 184 98 170 115 159 94 168 92 161 94 153 106 151 112 150 102 154
Rectangle -10899396 true false 144 177 157 249
Polygon -10899396 true false 134 240 123 219 108 223 98 234 96 240 108 246 130 245
Circle -11221820 true false 99 93 94
Polygon -11221820 true false 185 125 191 124 200 120 209 115 217 115 223 129 226 139 226 153 223 163 220 175 213 182 209 186 200 184 195 180 182 183 173 183 166 183 169 174 177 146
Polygon -16777216 true false 213 122 218 130 221 145 217 158 216 172 210 177 207 178 202 162 205 145 209 132
Circle -16777216 true false 150 127 12
Circle -16777216 true false 171 115 8
Polygon -13840069 true false 148 252 159 245 178 236 198 236 212 245 222 258 216 259 199 260 192 267 184 274 173 277 164 275 152 263 148 256 143 246 151 246 157 246
Polygon -13840069 true false 150 247 154 258 152 273 140 282 122 283 110 273 96 266 83 267 77 271 76 261 84 249 102 242 116 237 134 236 142 242

sports
false
7
Polygon -14835848 true true 150 201 156 220 137 223 131 191 149 191
Polygon -7500403 true false 105 173 89 167 88 171 94 175 98 178 93 176 85 179 87 185 94 186 111 183
Polygon -7500403 true false 117 198 109 200 103 206 103 212 107 210 112 205 110 209 110 217 116 218 120 217 120 211 127 207 129 198 123 195
Polygon -7500403 true false 182 213 184 228 205 245 212 246 191 227 189 211
Polygon -14835848 true true 185 188 195 215 177 219 167 188 181 182
Polygon -2674135 true false 129 144 112 160 104 170 110 185 132 165
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
Polygon -2674135 true false 169 97 172 108 176 120 181 142 185 156 187 174 187 187 174 193 166 199 150 204 147 206 145 198 145 178 143 163 144 146 144 133 144 124 144 116 151 109 154 101 164 100
Polygon -1 true false 143 117 128 117 125 125 130 144 128 166 128 184 132 185 139 177 146 175
Polygon -2674135 true false 159 121 156 148 150 176 149 169 129 183 116 198 129 212 139 198 148 192 162 183 161 162 167 141
Line -16777216 false 145 172 158 126
Line -16777216 false 172 134 159 181
Line -16777216 false 159 182 143 194
Polygon -2674135 true false 209 247 193 248 186 258 187 262 204 262 218 257 215 249 209 244 206 245
Line -16777216 false 165 105 165 105
Line -16777216 false 169 98 189 183
Line -16777216 false 186 186 150 204
Line -16777216 false 146 170 143 117
Line -16777216 false 129 142 103 168
Line -16777216 false 128 169 111 183
Line -16777216 false 103 168 110 182
Polygon -13345367 true false 154 56 143 56 136 57 125 57 113 58 120 44 136 40 150 41 159 49 161 56 147 54 113 59
Polygon -13791810 true false 118 50 85 51 85 56 118 55
Rectangle -1 true false 152 145 167 153
Polygon -7500403 true false 140 221 145 232 124 250 132 257 136 249 155 233 149 219
Polygon -2674135 true false 120 250 120 263 128 267 144 268 150 263 154 255 145 249 141 249

sun
true
0
Circle -1184463 true false 88 88 124
Polygon -1184463 true false 105 105 105 105 105 75 105 75 135 90 165 60 180 105 210 90 210 135 240 150 210 165 210 210 195 195 180 225 165 210 135 240 120 195 90 210 90 165 60 150 90 135 75 90 105 105
Circle -16777216 false false 90 90 120

sunflower
false
0
Polygon -13840069 true false 158 249 182 249 189 264 182 268 172 267 159 249
Rectangle -10899396 true false 145 190 155 250
Polygon -1184463 true false 145 96 142 88 145 77 153 71 159 72 163 80 163 85
Polygon -1184463 true false 142 93 139 88 137 75 131 71 125 70 115 73 113 78 118 87 123 93 129 96
Polygon -1184463 true false 117 96 115 87 112 81 104 77 96 77 94 86 96 95 106 101 114 101
Polygon -1184463 true false 101 108 99 99 96 93 88 89 80 89 78 98 80 107 90 113 98 113
Polygon -1184463 true false 91 116 80 109 73 111 66 118 61 124 67 128 77 128 88 127 91 121
Polygon -1184463 true false 84 133 73 129 61 130 53 139 66 143 80 144
Polygon -1184463 true false 83 151 74 145 64 146 59 156 53 164 65 163 79 161
Polygon -1184463 true false 83 163 73 166 66 177 68 186 79 187 85 176
Polygon -1184463 true false 163 98 162 87 167 80 176 77 183 81 183 90 176 101
Polygon -1184463 true false 183 104 185 94 196 86 203 87 205 98 201 106 185 111 180 106
Polygon -1184463 true false 199 114 205 104 213 99 220 99 227 103 223 112 212 116
Polygon -1184463 true false 209 120 217 117 231 117 233 123 221 131 213 131
Polygon -1184463 true false 219 136 229 130 236 129 244 139 246 146 246 151 236 153 219 147
Polygon -1184463 true false 223 154 231 152 241 161 246 169 240 173 224 172 218 166
Polygon -1184463 true false 83 196 83 182 92 175 98 180 100 193 93 199 88 200
Polygon -1184463 true false 219 172 226 177 231 192 227 197 217 193 210 182 211 174
Polygon -1184463 true false 200 178 205 180 208 190 203 202 194 198 193 188
Polygon -1184463 true false 103 206 102 195 103 183 109 183 115 189 115 199 111 204
Polygon -1184463 true false 117 202 117 190 126 186 132 189 133 197 130 203 122 202
Polygon -1184463 true false 136 204 136 192 145 188 151 191 152 199 149 205 141 204
Polygon -1184463 true false 153 202 153 190 162 186 168 189 169 197 166 203 158 202
Polygon -1184463 true false 172 202 172 190 181 186 187 189 188 197 185 203 177 202
Polygon -6459832 true false 135 92 124 95 113 96 100 105 93 112 84 123 80 134 79 148 77 160 79 169 83 179 98 189 112 192 135 193 157 193 178 190 196 188 209 184 221 173 224 161 225 148 222 134 216 121 206 112 192 107 176 99 169 95 156 93
Polygon -10899396 true false 146 222 138 215 129 213 119 213 117 221 125 226 135 227
Polygon -10899396 true false 154 224 162 220 173 220 174 232 166 233
Polygon -10899396 true false 146 249 153 248 167 253 174 267 174 273 162 273 145 274 132 268 126 263 131 253 142 250
Polygon -10899396 true false 145 249 128 246 117 255 109 262 111 269 121 269 132 268
Polygon -16777216 false false 144 249 131 258 132 267 140 272 171 274 173 265 167 257 158 251 160 248
Polygon -16777216 true false 127 120 122 130 123 141 128 150 134 147 136 138 133 124
Polygon -16777216 true false 178 119 173 129 174 140 179 149 185 146 187 137 184 123
Circle -1 true false 177 129 4
Circle -1 true false 124 130 4
Circle -1 true false 124 130 4
Polygon -16777216 true false 113 162 130 165 146 165 160 165 174 165 189 161 196 155 186 164 155 167 132 166
Polygon -16777216 false false 142 250 130 245 111 261 114 269 130 267 135 266 132 256
Polygon -16777216 false false 178 261
Polygon -16777216 false false 176 256
Polygon -16777216 false false 160 251 179 247 190 261 175 264
Polygon -16777216 false false 145 204 146 221 137 213 125 211 116 220 130 227 145 224 146 250 154 248 155 223 166 233 175 231 173 221 162 220 155 222 155 202

wallnut
false
0
Polygon -6459832 true false 146 75 132 75 128 83 120 88 115 93 112 103 108 115 103 123 101 135 99 137 98 142 96 146 93 158 88 175 89 184 93 198 99 215 107 227 115 230 137 233 159 235 179 233 194 227 205 212 211 200 211 187 211 175 210 159 210 145 209 130 204 115 196 105 189 94 182 84 176 77 166 73 153 73
Polygon -16777216 false false 136 73 132 86 126 94 128 105 124 119 126 133 118 146 120 158 115 169 116 181 113 195 118 204 121 215 128 222 128 233 124 232 120 222 115 214 109 201 107 190 109 178 110 171 112 157 111 144 111 134 116 127 120 118 118 105 118 94 121 86
Circle -1 true false 137 121 31
Circle -1 true false 181 125 24
Circle -16777216 true false 149 133 4
Circle -16777216 true false 189 133 4
Line -16777216 false 166 157 182 155
Line -16777216 false 170 163 173 163

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
Line -16777216 false 165 105 165 105
Line -16777216 false 169 98 189 183
Line -16777216 false 186 186 150 204
Line -16777216 false 146 170 143 117
Line -16777216 false 129 142 103 168
Line -16777216 false 128 169 111 183
Line -16777216 false 103 168 110 182
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
