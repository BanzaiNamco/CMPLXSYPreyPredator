patches-own[
  grass-amount
]
turtles-own[
  energy
  max-energy
  age
]

breed [rabbits rabbit]
breed [foxes fox]

to setup
  clear-all
  reset-ticks

  ask n-of grass patches [set grass-amount random 5]
  ask patches [recolor-patch]

  spawn-rabbits
  spawn-foxes
end

to spawn-rabbits
  create-rabbits num-rabbits [
    set shape "rabbit"
    set color 114
    set energy random 30 + 70 ;set energy to random number from 70-100
    set size 2
    set age 0
    move-to one-of patches
  ]
end

to spawn-foxes
  create-foxes num-foxes [
    set shape "wolf 2"
    set color 15
    set energy random 40 + 50 ;set energy to random number from 50-90
    set size 3
    set age 0
    move-to one-of patches with [not any? turtles-here]
  ]
end

to recolor-patch ;patch procedure
  ifelse grass-amount > 0 [
    set pcolor 68 - grass-amount
  ][
    set pcolor 36
  ]
end

to go
  if (not any? rabbits or not any? foxes) [stop]

  grow-grass
  move-rabbits
  ifelse control-predation = false [move-foxes] [move-foxes-2]

  ask patches [recolor-patch]
  tick
end

to grow-grass
    ask up-to-n-of grass-growth patches with [grass-amount = 0] [
      set grass-amount grass-amount + 1
    ]
end

to move-rabbits
  ask rabbits [
    set age age + 1
    ifelse energy < rabbit-hunger-threshold
    [rabbit-find-and-eat]
    [
      ifelse coin-flip? [right random max-turn-rabbit][left random max-turn-rabbit]
      fd 1
      set energy (energy - rabbit-move-cost)
      if (energy > rabbit-reproduce-cost) [reproduce-rabbits]
    ]

    death
    age-death-rabbit
    set label energy
  ]
end

to move-foxes
  ask foxes [
    set age age + 1
    ifelse (energy < fox-hunger-threshold)
    [fox-find-and-eat]
    [
      fox-movement
      if (energy > fox-reproduce-cost) [reproduce-foxes]
    ]

    death
    age-death-fox
    set label energy
  ]
end

to move-foxes-2
  ask foxes [
    set age age + 1
    ifelse (energy < fox-hunger-threshold) and (count rabbits > count foxes * 1.5)
    [fox-find-and-eat]
    [
      fox-movement
      if energy > fox-reproduce-cost [reproduce-foxes]
    ]

    death
    age-death-fox
    set label energy
  ]
end

to fox-movement
  ifelse coin-flip? [right random max-turn-fox][left random max-turn-fox]
  fd 1
  set energy (energy - fox-move-cost)
end

to rabbit-find-and-eat
  let grass-patch min-one-of (patches in-cone 5 330 with [grass-amount > 0]) [distance myself]
  ;;https://web.as.miami.edu/hare/vision.html
  (ifelse (grass-patch != nobody) and (grass-patch != patch-here)
  [
    set heading(towards grass-patch)
    let distance-to-grass round distance grass-patch

    let movement min list distance-to-grass 2
    fd movement
    eat-grass
    set energy (energy - rabbit-move-cost * movement)
  ]
  grass-patch = patch-here [eat-grass]
  [fd 1 set energy (energy - rabbit-move-cost)])

end

to eat-grass
  if grass-amount > 0 [
    set grass-amount grass-amount - 1
    set energy (energy + rabbit-gain-from-food)
  ]
end

to fox-find-and-eat
  ifelse any? rabbits in-cone 7 260
  [
    let target-rabbit min-one-of (rabbits in-cone 5 260) [distance myself]
    ;; https://www.wildlifeonline.me.uk/animals/article/red-fox-senses
    if target-rabbit != nobody [
      ifelse not member? target-rabbit rabbits-here [
        set heading(towards target-rabbit)
        let distance-to-rabbit round distance target-rabbit

        ifelse distance-to-rabbit > 2 [fd 3] [fd distance-to-rabbit + 1]
        set energy (energy - (fox-move-cost * (min list distance-to-rabbit 3)))
      ]
      [eat-rabbit]
    ]
  ] [fox-movement]
end

to eat-rabbit
  let target one-of rabbits-here
  if target != nobody[
    ask target [ die ]
    set energy (energy + fox-gain-from-food)
  ]
end

to reproduce-rabbits
  if (random 100 < rabbit-reproduce-%) and (age > (rabbit-max-age / 5))[
    set energy (energy - rabbit-reproduce-cost)
    hatch random 7 [
      set age 0
      set energy 50
      rt random-float 360 fd 1
    ]
  ]
end

to reproduce-foxes
  if (random 100 < fox-reproduce-%) and (age > (fox-max-age / 4)) [
    set energy (energy - fox-reproduce-cost)
    hatch random 5 [
      set age 0
      set energy 50
      rt random-float 360 fd 1
    ]
  ]
end

to death
  if energy < 0 [ die ]
end

to age-death-fox
  if age > fox-max-age [die]
end

to age-death-rabbit
  if age > rabbit-max-age [die]
end

to-report coin-flip?
  report random 2 = 0
end
@#$#@#$#@
GRAPHICS-WINDOW
541
10
1082
552
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-20
20
-20
20
1
1
1
ticks
30.0

SLIDER
17
191
189
224
grass
grass
1
1000
1000.0
1
1
NIL
HORIZONTAL

BUTTON
20
19
83
52
setup
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
16
62
188
95
num-rabbits
num-rabbits
1
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
16
105
188
138
num-foxes
num-foxes
1
100
50.0
1
1
NIL
HORIZONTAL

BUTTON
95
20
158
53
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
199
61
371
94
max-turn-rabbit
max-turn-rabbit
1
360
145.0
1
1
NIL
HORIZONTAL

SLIDER
16
146
188
179
grass-growth
grass-growth
0
1000
210.0
1
1
NIL
HORIZONTAL

PLOT
11
258
525
519
population
time
pop
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"rabbit" 1.0 0 -8630108 true "" "plot count rabbits"
"fox" 1.0 0 -2674135 true "" "plot count foxes * 2"
"grass" 1.0 0 -7500403 true "" "plot sum [grass-amount] of patches / 5"

MONITOR
25
523
82
568
foxes
count foxes
17
1
11

MONITOR
95
523
152
568
rabbits
count rabbits
17
1
11

SLIDER
11
574
183
607
fox-gain-from-food
fox-gain-from-food
0
100
40.0
1
1
NIL
HORIZONTAL

SLIDER
193
573
365
606
rabbit-gain-from-food
rabbit-gain-from-food
0
20
7.0
1
1
NIL
HORIZONTAL

SLIDER
10
648
182
681
fox-move-cost
fox-move-cost
0
20
2.0
0.5
1
NIL
HORIZONTAL

SLIDER
192
648
364
681
rabbit-move-cost
rabbit-move-cost
0
20
1.5
0.5
1
NIL
HORIZONTAL

SLIDER
10
690
182
723
fox-reproduce-cost
fox-reproduce-cost
0
100
30.0
1
1
NIL
HORIZONTAL

SLIDER
191
690
363
723
rabbit-reproduce-cost
rabbit-reproduce-cost
0
100
35.0
1
1
NIL
HORIZONTAL

SLIDER
10
730
182
763
fox-reproduce-%
fox-reproduce-%
0
100
3.0
1
1
%
HORIZONTAL

SLIDER
191
729
368
762
rabbit-reproduce-%
rabbit-reproduce-%
0
100
4.0
1
1
%
HORIZONTAL

SLIDER
10
611
182
644
fox-hunger-threshold
fox-hunger-threshold
0
100
42.0
1
1
NIL
HORIZONTAL

SLIDER
191
611
373
644
rabbit-hunger-threshold
rabbit-hunger-threshold
0
100
45.0
1
1
NIL
HORIZONTAL

MONITOR
169
524
226
569
grass
sum [grass-amount] of patches
17
1
11

SWITCH
193
17
344
50
control-predation
control-predation
1
1
-1000

SLIDER
200
104
372
137
max-turn-fox
max-turn-fox
1
360
140.0
1
1
NIL
HORIZONTAL

SLIDER
427
597
599
630
fox-max-age
fox-max-age
5
100
30.0
1
1
NIL
HORIZONTAL

SLIDER
427
643
599
676
rabbit-max-age
rabbit-max-age
5
100
30.0
1
1
NIL
HORIZONTAL

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

rabbit
false
0
Polygon -7500403 true true 61 150 76 180 91 195 103 214 91 240 76 255 61 270 76 270 106 255 132 209 151 210 181 210 211 240 196 255 181 255 166 247 151 255 166 270 211 270 241 255 240 210 270 225 285 165 256 135 226 105 166 90 91 105
Polygon -7500403 true true 75 164 94 104 70 82 45 89 19 104 4 149 19 164 37 162 59 153
Polygon -7500403 true true 64 98 96 87 138 26 130 15 97 36 54 86
Polygon -7500403 true true 49 89 57 47 78 4 89 20 70 88
Circle -16777216 true false 37 103 16
Line -16777216 false 44 150 104 150
Line -16777216 false 39 158 84 175
Line -16777216 false 29 159 57 195
Polygon -5825686 true false 0 150 15 165 15 150
Polygon -5825686 true false 76 90 97 47 130 32
Line -16777216 false 180 210 165 180
Line -16777216 false 165 180 180 165
Line -16777216 false 180 165 225 165
Line -16777216 false 180 210 210 240

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

wolf 2
false
0
Rectangle -7500403 true true 195 106 285 150
Rectangle -7500403 true true 195 90 255 105
Polygon -7500403 true true 240 90 217 44 196 90
Polygon -16777216 true false 234 89 218 59 203 89
Rectangle -1 true false 240 93 252 105
Rectangle -16777216 true false 242 96 249 104
Rectangle -16777216 true false 241 125 285 139
Polygon -1 true false 285 125 277 138 269 125
Polygon -1 true false 269 140 262 125 256 140
Rectangle -7500403 true true 45 120 195 195
Rectangle -7500403 true true 45 114 185 120
Rectangle -7500403 true true 165 195 180 270
Rectangle -7500403 true true 60 195 75 270
Polygon -7500403 true true 45 105 15 30 15 75 45 150 60 120

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
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
