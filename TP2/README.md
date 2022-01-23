# Projeto de Programação Lógica

# Trabalho Prático 2: JOSTLE

O nosso trabalho consistiu na implementação do jogo "Jostle", criado por Mark Steere, recorrendo para isso à linguagem Prolog com execução em terminal.

<br>

## Grupo T2_Jostle_3:
|Nome do Estudante| Número mecanográfico|Contribuição|
|----|----|----|
|Francisco Renato Barbosa Pires| up201908044|50%|
|Alberto José Ribeiro da Cunha| up201906325 |50%|

<br>

# Instalação e Execução

Esta implementação assume apenas a instalação base de SICStus Prolog.

Para iniciar o jogo deve mudar o "Working Directory" para a pasta /src, consultar o ficheiro main.pl e executar o predicado play().

# Descrição do jogo

As regras detalhadas do jogo podem ser consultadas na página oficial do seu criador em http://www.marksteeregames.com/Jostle_Go_rules.pdf

Trata-se de um jogo para duas pessoas jogado num tabuleiro 10 por 10 na qual cada jogador tem 16 peças semelhantes a damas. Em turnos os jogadores devem mover uma das suas peças para um espaço adjacente livre (apenas nas direções ortogonais: cima; baixo; esquerda e direita) que dê á sua peça um valor de **ligações adjacentes** mais elevado do que o que tinha anteriormente, se o valor for o mesmo ou inferior a jogada não é permitida.

O valor de **ligações adjacentes** define-se pelo numero de peças adjacentes (ortogonalmente) do mesmo jogador menos o número de peças adjacentes adversárias.

Ganha o último jogador a efetuar uma jogada, i.e. o primeiro jogador a não poder mover nenhuma peça perde.

# Lógica do Jogo

Na secção seguinte apresentaremos as partes relevantes da lógica de funcionamento do nosso jogo.

## Representação interna do estado do jogo

Neste jogo todas as peças encontram-se no tabuleiro desde inicio e não há captura de peças, tendo isto em conta o nosso estado de jogo consiste numa lista de 32 elementos contendo informação sobre a posição de cada peça, visto cada jogador ter 16 peças.

Para facilitar a consulta de peças pela sua posição e vice-versa, bem como facilitar a inserção de novos elementos com novos dados optámos por guardar cada elemento na lista com o formato Cor-Indice-Posição.

<br>
Cor - Representa a cor do jogador, vermelho ou azul, representado pelos átomos 'r' ou 'b'.

Indice - Para distinguir entre as 16 peças de um jogador usamos um indice de 0 a 15.

Posição - Um valor inteiro que representa a posição no tabuleiro, começando em 0, seguindo a convenção semelhante à de leitura de um texto, da esquerda para a direita e depois em linhas de cima pra baixo. Isto tem o efeito de no tabuleiro 10 por 10 o primeiro algarismo representar o indice das linhas e o segundo as colunas.

<br>

Isto permite um fácil ascesso aos dados do tabuleiro e não necessita manter a ordem dos argumentos.

