# Trabalho Prático 1

## Fib.hs

1. ### fibRec:
    Uma definição recursiva de fibonacci que tem como casos base 0 e 1 e vai sumando a partir dai. Exemplos:
    - fibRec 0 = 0
    - fibRec 19 = 4181
    - fibRec 30 = 832040, demora 8 segundos a retornar o resultado
    - fibRec 35 = 9227465, demora ~80 segundos, esta definição é pouco eficiente.

2. ### fibLista:
    Uma definição dinâmica de fibonacci que utiliza uma lista para guardar o resultado de fibonaccis de ordem inferior. Exemplos:
    - fibLista 4 = 3
    - fibLista 30 é praticamente instantâneo
    - fibLiata 100 = 354224848179261915075, também é instantâneo o que torna esta definição muito mais eficiente que o fibRec
    - fibLista 100000 demora uns segundos a retorna o valor

3. ### fibListaInfinita:
    Esta difinição de fibonacci cria uma lista infinita de fibonacci e vai buscar o elemento n dessa lista. Exemplos:
    - fibListaInfinita 10 = 55
    - fibListaInfinita 30 tempo semelhante ao fibLista
    - fibListaInfinita 100 também
    - fibListaInfinita 100000 é mais rápido que fibLista sendo este a função mais eficiente

4. ### fibRecBN, fibListaBN, fibListaInfinitaBN:
    Estas funções são adaptações de fibRec, fibLista e fibListaInfinita que utilizam BigNumber. Exemplos:
    - fibRecBN 10 = ('+', [5, 5])
    - fibRecBN 30 = ('+', [8, 3, 2, 0, 4, 0]), demora mais tempo que fibRec
    - fibListaBN 7 = ('+', [1, 3])
    - fiListaBN demora mais tempo que fibLista para indices altos
    - fibListaInfinitaBN 12 = ('+', [1, 4, 4])
    - fibListaInfinitaBN demora mais tempo que fibListaInfinita para indices altos
    - Concluindo, apesar de BN teóricamente aceitar números arbitrariamente grandes, na prática torna mais lento o processamento de fibonacci de ordem n

5. ### Resposta pergunta 4:
    Como BigNumber é uma lista de Int, o tamanho individual de um algarismo corresponde ao de um Int. Por isso, quando comparado ao tipo Int, BigNumber permite às funções calcular elementos de fibonacci de ordem mais elevada, restringido apenas pelo tempo de processamento, enquanto que as mesmas funções do tipo Int só podem no máximo processar até cerca do indice 92 antes de passarem a sofrer de Overflow. O tipo Integer por ser um tipo de precisão arbitrária em Haskeel não sofre do mesmo problema que o Int.



## BigNumber.hs


1. ### scanner:
    Transforma uma _string_ num BigNumber. Faz isto transformando cada _char_ individual num _int_. Caso a _string_ começa por um '-' o sinal do BigNumber será negativo, caso contrário é positivo. Nesta representação "0" é considerado positivo. Exemplos:
    - scanner "100" = ('+', [1, 0, 0])
    - scanner "-100" = ('-', [1, 0, 0])

2. ### output:
    Transforma um BigNumber numa _string_. Caso o número seja negativo adiciona um '-' antes do número, caso contrário, torna cada _int_ num _char_ e cria uma lista com eles. Exemplos:
    - output ('+', [1, 0, 0]) = "100"
    - output ('-', [1, 0, 0]) = "-100"

3. ### somaBN:
    Calcula a soma de 2 BigNumbers.  O sinal do resultado depende dos sinais dos operandos. Se ambos os operandos tiverem o mesmo sinal, esse é o sinal do resultado, caso contrário, o sinal é igual ao do número de maior módulo. No primeiro caso calcula-se a soma dos módulos e no outro a subtração dos mesmos, sendo o 1º operando maior que o 2º. Em ambos os casos utiliza-se a estratégia de fazer a operação dígito a dígito, somaLista e subLista. A seguir, acerta-se cada elemento da lista do resultado para que estaja entre 0 e 9, somaCheck e subCheck. Exemplos:
    - somaBN ('+', [4, 4]) ('+', [1, 6, 9]) = ('+', [2, 1, 3])
    - somaBN ('+', [4, 4]) ('-', [1, 6, 9]) = ('-', [1, 2, 5])
    - somaBN ('-', [7, 3]) ('-', [9, 6, 3]) = ('-', [1, 0, 3, 6])
    - somaBN ('-', [7, 3]) ('+', [9, 6, 3]) = ('+', [8, 9, 0])

4. ### subBN:
    Calcula a subtração entre 2 BigNumbers. Estratégia similar ao somaBN. A única diferença tem haver com os sinais. Sinais diferentes significa que o resultado terá sinal igual ao do 1º operando, e o resultado é igual a soma dos módulos. Noutros casos é preciso ver qual dos 2 tem maior módulo. Isto é feito através das funções auxiliares maior e maiorsame, a 1ª compara listaa de tamanhos diferente e a 2ª listas com o mesmo tamanho. O número com maior módulo terá o sinal do resultado e é o 1º operando na subtração dos módulos. Exemplos: 
    - subBN ('+', [4, 4]) ('+', [1, 6, 9]) = ('-', [1, 2, 5])
    - subBN ('+', [4, 4]) ('-', [1, 6, 9]) = ('+', [2, 1, 3])
    - subBN ('-', [7, 3]) ('-', [9, 6, 3]) = ('+', [8, 9, 0])
    - subBN ('-', [7, 3]) ('+', [9, 6, 3]) = ('-', [1, 0, 3, 6])

5. ### mulBN:
    Calcula o produto de 2 BigNumbers. Se os sinais dos operandos forem iguais então o sinal do resultado é positivo, caso contrário, é negativo. O módulo do resultado obtem-se seguindo o seguinte algoritmo: multiplica-se cada elemento da lista do 1º operando pelo primeiro elemento da lista do 2º e guarda-se numa lista de listas. Depois faz-se o mesmo para cada elemento da lista 2. Isto corresponde a mulLista. Em seguida soma-se todos os elementos da lista de listas, adicionado zeros aos números conforme a posição deles na lista, mulAdd e addZeros, respetivamente. O resultado será igual ao módulo que queremos. Exemplos:
    - mulBN ('+', [3, 4, 5]) ('+', [3, 2, 3]) = ('+', [1, 1, 1, 4, 3, 5])
    - mulBN ('+', [3, 4, 5]) ('-', [3, 2]) = ('-', [1, 1, 0, 4, 0])
    - mulBN ('+', [3, 4, 5]) ('+', [0]) = ('+', [0, 0, 0])

6. ### divBN:
    Calcula o quociente e o resto entre 2 BigNumbers. O sinal do resultado é sempre positivo. O quociente calcula-se usando a função auxiliar divSub2 que calcula a divisão através de subtrações sucessivas. Através do calculo da diferença na ordem de grandeza entre os operandos é capaz de diminuir o número de ciclos necessários para chegar à resposta.  Exemplos:
    - divBN ('+', [2, 3, 4]) ('+', [3, 4]) = ( ('+', [6]), ('+', [3, 0]) )
    - divBN ('+', [2, 3, 4, 4, 7]) ('+', [3, 4]) = ( ('+', [6, 8, 9]), ('+', [2, 1]) )
    - divBN ('+', [2, 3, 4]) ('+', [3, 4, 6]) = ( ('+', [0]), ('+', [2, 3, 4]) )
    - divBN ('+', [2, 3, 5, 4, 6, 8, 5, 4, 2]) ('+', [3, 4, 2, 5, 4, 6]) = ( ('+',[6, 8, 7]), ('+',[1, 3, 9, 4, 4, 0]) )

7. ### safeDivBN:
    Uma adaptação do divBN que utiliza o monad Maybe para garantir que não aconteça nenhum erro caso o 2º operando seja zero. Se o segundo operando é "0" então retorna _Nothing_, caso contrário, retorna _Just_ divBN. Exemplos:
    - safeDivBN ('+', [1, 1, 1]) ('+', [0]) = Nothing
    - safeDivBN ('+', [1, 1, 1]) ('+', [9]) = ( ('+', [1, 2]), ('+', [3]) )