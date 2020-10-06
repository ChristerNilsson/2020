Originalkod hittas här: https://github.com/TimBeyer/node-dlx

* dlx.coffee,utils.coffe,interfaces.coffee innehåller Dancing Links (översatt från typescript)

# Queens

node js/queens.js 8 | node js/dlx.js

queens.coffee skapar styrfil till dlx.

# Sudoku

node js/sudoku-dlx 000000007004020600800000310000002900040090030009506000010000008006050200700000060 | node js/dlx

all.bat kör de tio första problemen från hardest_1106. Detta tar 4.3 sek. 4.3s/10000 = 0.43 ms = 430 us per problem

tdoku kör 375 problem på 35ms. Detta ger 0.093ms = 93 us per problem.

Om man skriver om dlx.coffee i C++ borde man kunna uppnå ungefär samma hastighet som tdoku.
Detta utan komplicerad användning av simd och dpll.
