#-----------------Configurações do Display-----------------#
# 1) Unit Width in Pixels: 8
# 2) Unit Height in Pixels: 8
# 3) Display Width in Pixels: 512
# 4) Display Height in Pixels: 512
# 5) Base address for display: static data
#----------------------------------------------------------#
.data
display: .space 16384

printDif:  .asciiz "Escolha a dificuldade (1 - Facil, 2 - Medio, 3 - Dificil, 4 - Extremo): "
printInv:  .asciiz "\nOpcao invalida, tente novamente.\n"
printDnv:  .asciiz "\nDeseja jogar novamente? (1 - Sim, 2 - Nao): "

facil:    .word 60
medio:    .word 40
dificil:  .word 25
extremo:  .word 15

cinza:	  .word 0x828282
vermelho: .word 0xff0000
vermelho2:.word 0xff0001
laranja:  .word 0xff9300
amarelo:  .word 0xefff00
verde:    .word 0x00ff00
verde2:   .word 0x00ff01
salmao:   .word 0xd18d86
rosa:     .word 0xff80ed
azul:	  .word 0x0000ff
dourado:  .word 0xffd700
bordo:    .word 0x7a0000
preto:    .word 0x000000
branco:   .word 0xffffff
.text

#-----------------Dificuldade-----------------#
escolherDificuldade:
	li $s1, 0xffff0004
	sw $t0, 0($s1)
	li $t0, 0
	li $t1, 0
	lw $t2, dourado
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0x10010000
	li $s1, 0
	li $s2, 0
 	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	
    li $v0, 4
    la $a0, printDif
    syscall

    li $v0, 5
    syscall
    move $t0, $v0
    
    li  $t1, 1
    beq $t0, $t1, modoFacil

    li  $t1, 2
    beq $t0, $t1, modoMedio

    li  $t1, 3
    beq $t0, $t1, modoDificil

    li  $t1, 4
    beq $t0, $t1, modoExtremo
    
    li $v0, 4
    la $a0, printInv
    syscall
    
    j escolherDificuldade

modoFacil:
    lw $s7, facil
    
    j iniciarJogo

modoMedio:
    lw $s7, medio
    
    j iniciarJogo

modoDificil:
    lw $s7, dificil
    
    j iniciarJogo

modoExtremo:
    lw $s7, extremo
    
    j iniciarJogo

#-----------------Inicia o jogo-----------------#
iniciarJogo:
	lw   $t0, preto
	sw   $t0, 0($s0)
	addi $s0, $s0, 4
	
	addi $t9, $t9, 1
	beq  $t9, 4095, inicio
	
	j iniciarJogo
	
#-----------------Borda Cinza-----------------#	
#s0 = posição para pintar as bordas cinzas
#s1 = posição para pintar a borda inferior
#t0 = cor cinza/branca
#t9 = contador pra pintar todos os pixels
inicio:
	li   $s0, 0x10010000
	li   $s1, 0x10013F08
	li   $t9, 0

bordaSuperior:
	lw   $t0, cinza
	sw   $t0, 0($s0)
	addi $s0, $s0, 4
	
	addi $t9, $t9, 1
	beq  $t9, 128, bordasLaterais
	
	j bordaSuperior
	
bordasLaterais:
	lw   $t0, cinza
	sw   $t0, 0($s0)
	
	addi $s0, $s0, 4
	sw   $t0, 0($s0)
	
	addi $s0, $s0, 244
	sw   $t0, 0($s0)
	
	addi $s0, $s0, 4
	sw   $t0, 0($s0)
	addi $s0, $s0 4
	
	addi $t9, $t9, 1
	beq  $t9, 188,bordaInferior
	
	j bordasLaterais

bordaInferior:
	lw  $t0, cinza
	sw  $t0, 0($s0)
	
	addi $s0, $s0, 4
	addi $t9, $t9, 1
	beq $t9, 316, blocos
	
	j bordaInferior
	
#-----------------Blocos-----------------#
#s0 = posição do primeiro bloco até o útlimo
#t0 = cor atual
#t9 = contador de blocos (30 em cada linha = 240)

blocos:	
    li   $s0, 0x10010208
	lw   $t0, vermelho
	li   $t9, 0
blocoVermelhoL1:	
	sw   $t0, 0($s0)
	addi $s0, $s0,  4
	
	addi $t9, $t9, 1
	bne  $t9, 60, blocoVermelhoL1
	
	addi $s0, $s0, 16
	addi $s0, $s0, 256
	lw $t0, laranja
	j blocoLaranjaL1
blocoVermelhoL2:
	sw   $t0, 0($s0)
	addi $s0, $s0, 4
	
	addi $t9, $t9, 1
	bne  $t9, 120  blocoVermelhoL2

	lw   $t0, laranja
	addi $s0, $s0, 16
	
blocoLaranjaL1:
	sw   $t0, 0($s0)
	addi $s0, $s0, 4
	
	addi $t9, $t9, 1
	#bne  $t9, 180 blocoLaranjaL1
	bne   $t9, 120, blocoLaranjaL1
	addi $s0, $s0, 16

	addi $s0, $s0, 256
		lw $t0, amarelo
	j blocoAmareloL1
blocoLaranjaL2:
	sw   $t0, 0($s0)
	addi $s0, $s0, 4
	
	addi $t9, $t9, 1
	bne  $t9, 240, blocoLaranjaL2

	lw   $t0, amarelo
	addi $s0, $s0, 16
	
blocoAmareloL1:
	sw   $t0, 0($s0)
	addi $s0, $s0, 4
	
	addi $t9, $t9, 1
	#bne  $t9, 300, blocoAmareloL1
	bne  $t9, 180, blocoAmareloL1
	addi $s0, $s0, 16

	addi $s0, $s0, 256
			lw $t0, verde
	j blocoVerdeL1
blocoAmareloL2:
	sw   $t0, 0($s0)
	addi $s0, $s0, 4
	
	addi $t9, $t9, 1
	bne  $t9, 360 blocoAmareloL2
	
	lw   $t0, verde
	addi $s0, $s0, 16
	
blocoVerdeL1:
	sw   $t0, 0($s0)
	addi $s0, $s0, 4
	
	addi $t9, $t9, 1
	#bne  $t9, 420, blocoVerdeL1
	bne  $t9, 240, blocoVerdeL1
	addi $s0, $s0, 16
	j a
blocoVerdeL2:
	sw   $t0, 0($s0)
	addi $s0, $s0, 4
	
	addi $t9, $t9, 1
	bne  $t9, 480, blocoVerdeL2
	
#-----------------Raquete-----------------#	
#s1 = posição primária da raquete (muda depois que se mover)
#t0 = cor salmão/vermelho/verde
a:
	li   $s1, 0x1001346C#0x1001346C
	lw   $t0, salmao
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	
	lw   $t0, vermelho2
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)

	lw   $t0, verde2
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	
#-----------------Bolinha-----------------#	
#s3 = posição primária da bolinha (muda depois que se mover)
#t0 = cor dourada

	li $s3, 0x1001337C
	lw $t0, dourado
	sw $t0, 0($s3)
	
#-----------------Movimentação da Raquete-----------------#	
#t3 = código da tecla
#t4 = tecla anterior do a
#t5 = tecla posterior do d
#t6 = comparativo 

	li  $t9, 0
key:
	jal loop
	li  $t4, 96
	li  $t5, 101
	
	beq $t3, 0, key
	beq $t3, 97, moverEsq	#a == vai pra esquerda
	beq $t3, 98, key		#b == não mexe
	beq $t3, 99, key		#c == não mexe
	beq	$t3, 100, moverDir  #d == vai pra direita
	
	slt $t6, $t3, $t5		#se a tecla atual for maior que 'd' não mexe
	beq $t6, 0, key
	slt $t6, $t4, $t3		#se a tecla atual for menor que 'a' não mexe
	beq $t6, 0, key
	
#-----------------Esquerda-----------------#
#s1 = posição da raquete ao movimentar
#s2 = posição anterir da raquete pra pintar de preto
#t0 = cor salmão/vermelha/verde/preta
#t9 = contador da raquete

moverEsq:
	beq  $t9, -25, key		   #limite do mapa
	
	addi $s1, $s1, -36
	lw   $t0, salmao 
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	
	addi $s1, $s1, 4
	lw   $t0, vermelho2
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
		
	addi $s1, $s1, 4
	lw   $t0, verde2
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	
	addi $s1, $s1, 4
	lw   $t0, preto
	sw   $t0, 0($s1)
	
	addi $s1, $s1, -4
	addi $t9, $t9, -1
	j key
	
#-----------------Direita-----------------#	
#s1 = posição da raquete ao movimentar
#s2 = posição anterir da raquete pra pintar de preto
#t0 = cor salmão
#t0 = cor preta
#t9 = contador da raquete

moverDir:
	beq  $t9, 26, key			#limite do mapa
	
	lw   $t0, preto
	addi $s1, $s1, -32
	sw   $t0, 0($s1)
	
	lw   $t0, salmao
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	
	lw   $t0, vermelho2
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)	
			
	lw   $t0, verde2
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
	addi $s1, $s1, 4
	sw   $t0, 0($s1)
		
	addi $t9, $t9, 1
	j key
	
#-----------------Loop da Bolinha e da raquete-----------------#
#s3 = posição da bolinha
#s5 = posição em volta da bolinha
#t0/t1 = cores
#t3 = posição na memória que guarda a tecla
loop:
	sgt  $t2, $s3, $s1
	beq  $t2, 1, derrota
	
	lw   $t3, 0xffff0004
	li   $v0, 32
	move $a0, $s7
	syscall
	
	move $s5, $s3
	addi $s5, $s5, 256
	
	lw   $t0, 0($s5)
	lw   $t1, salmao			#t1 = cor da esquerda da raquete
	beq  $t0, $t1, diagonalEsq
	
	lw   $t1, vermelho2			#t1 = cor do meio da raquete
	beq  $t0, $t1, cima
	
	lw   $t1, verde2				#t1 = cor da direita da raquete
	beq  $t0, $t1, diagonalDir
	
	beq  $t8, 1, cima
	beq  $t8, 2, baixo
	beq  $t8, 3, diagonalEsq
	beq  $t8, 4, diagonalDir
	beq  $t8, 5, diagonalEsqBaixo
	beq  $t8, 6, diagonalDirBaixo
	beq  $t8, 7, diagonalEsqBaixoTopo
	beq  $t8, 8, diagonalDirBaixoTopo
	jr   $ra

cima:	
	li   $t8, 1
	
	move $s5, $s3
	addi $s5, $s5, -256
	lw   $t0, 0($s5)
	lw   $t1, verde
	beq  $t0, $t1, baixo
	lw   $t1, amarelo
	beq  $t0, $t1, baixo
	lw   $t1, laranja
	beq  $t0, $t1, baixo
	lw   $t1, vermelho
	beq  $t0, $t1, baixo
	lw   $t1, cinza
	beq  $t0, $t1, baixo_Topo
	
	addi $s3, $s3, -256
	li   $a1, 4
	li   $v0, 42
	syscall
	move $t7, $a0
	add  $sp, $sp, -4
	sw   $ra, 0($sp)
	jal  cor
	sw   $t2, 0($s3)

	lw   $t0, preto
	addi $s5, $s5, 256
	sw   $t0, 0($s5)
	lw   $ra, 0($sp)
	add  $sp, $sp, 4
	
	jr   $ra
	
baixo:
	li   $t8, 2
	
	move $s5, $s3
	addi $s5, $s5, 256
	lw   $t0, 0($s5)
	lw   $t1, verde
	beq  $t0, $t1, cima
	lw   $t1, amarelo
	beq  $t0, $t1, cima
	lw   $t1, laranja
	beq  $t0, $t1, cima
	lw   $t1, vermelho
	beq  $t0, $t1, cima

	addi $s3, $s3, 256
	li   $a1, 4
	li   $v0, 42
	syscall
	move $t7, $a0
	add  $sp, $sp, -4
	sw   $ra, 0($sp)
	jal  cor
	sw   $t2, 0($s3)

	move $s5, $s3
	addi $s5, $s5, -256
	lw   $t0, preto
	sw   $t0, 0($s5)
	
	addi $s5, $s5, -256
	sw   $t0, 0($s5)
	
	lw   $ra, 0($sp)
	add  $sp, $sp, 4
	jr   $ra
	
baixo_Topo: 
	li   $t8, 2
	
	addi $s3, $s3, 256
	li   $a1, 4
	li   $v0, 42
	syscall
	move $t7, $a0
	add  $sp, $sp, -4
	sw   $ra, 0($sp)
	jal  cor
	sw   $t2, 0($s3)
	
	lw   $t0, preto
	addi $s5, $s5, 256
	sw   $t0, 0($s5)
	
	lw   $ra, 0($sp)
	add  $sp, $sp, 4
	jr   $ra

diagonalEsq:
	li   $t8, 3
	
	move $s5, $s3
	addi $s5, $s5 -4
	lw   $t0, 0($s5) 
	lw   $t1, cinza
	beq  $t0, $t1, diagonalDir
	
	move $s5, $s3
	addi $s5, $s5 -256
	lw   $t0, 0($s5) 
	lw   $t1, cinza
	beq  $t0, $t1, diagonalEsqBaixoTopo
		
	move $s5, $s3
	addi $s5, $s5, -260
	lw   $t0, 0($s5)
	lw   $t1, verde
	beq  $t0, $t1, diagonalEsqBaixo	
	lw   $t1, amarelo
	beq  $t0, $t1, diagonalEsqBaixo
	lw   $t1, laranja
	beq  $t0, $t1, diagonalEsqBaixo
	lw   $t1, vermelho
	beq  $t0, $t1, diagonalEsqBaixo
	
	move $s5, $s3
	addi $s3, $s3, -260
	li   $a1, 4
	li   $v0, 42
	syscall
	move $t7, $a0
	add  $sp, $sp, -4
	sw   $ra, 0($sp)
	jal  cor
	sw   $t2, 0($s3)
	lw   $t0, preto
	sw   $t0, 0($s5)
	
	lw   $ra, 0($sp)
	add  $sp, $sp, 4
	jr   $ra
	
diagonalDir:
	li   $t8, 4
	
	move $s5, $s3
	addi $s5, $s5 4
	lw   $t0, 0($s5) 
	lw   $t1, cinza
	beq  $t0, $t1, diagonalEsq
	
	move $s5, $s3
	addi $s5, $s5, -256
	lw   $t0, 0($s5) 
	lw   $t1, cinza
	beq  $t0, $t1, diagonalDirBaixoTopo
	
	move $s5, $s3
	addi $s5, $s5, -252
	lw   $t0, 0($s5) 
	beq  $t0, $t1, diagonalEsqBaixo
	
	move $s5, $s3
	addi $s5, $s5, -252
	lw   $t0, 0($s5)
	lw   $t1, verde
	beq  $t0, $t1, diagonalDirBaixo
	lw   $t1, amarelo
	beq  $t0, $t1, diagonalDirBaixo
	lw   $t1, laranja
	beq  $t0, $t1, diagonalDirBaixo
	lw   $t1, vermelho
	beq  $t0, $t1, diagonalDirBaixo
	
	move $s5, $s3
	addi $s3, $s3, -252
	li   $a1, 4
	li   $v0, 42
	syscall
	move $t7, $a0
	add  $sp, $sp, -4
	sw   $ra, 0($sp)
	jal  cor
	sw   $t2, 0($s3)
	
	lw   $t1, preto
	sw   $t1, 0($s5)
	
	lw   $ra, 0($sp)
	add  $sp, $sp, 4
	jr   $ra

diagonalEsqBaixo:
	li   $t8, 5
	
	lw   $t1, cinza
	move $s5, $s3	
	addi $s5, $s5, -4
	lw   $t0, 0($s5)
	beq  $t0, $t1, diagonalDirBaixo
	
	move $s5, $s3
	addi $s5, $s5, -260
	lw   $t0, preto
	sw   $t0, 0($s5)
	
	move $s5, $s3
	lw   $t0, preto
	sw   $t0, 0($s5)
	addi $s3, $s3, 252
	li   $a1, 4
	li   $v0, 42
	syscall
	move $t7, $a0
	add  $sp, $sp, -4
	sw   $ra, 0($sp)
	jal  cor
	sw   $t2, 0($s3)

	lw   $ra, 0($sp)
	add  $sp, $sp, 4
	jr   $ra
diagonalEsqBaixoTopo:
	li   $t8, 7
	
	lw   $t1, cinza
	move $s5, $s3	
	addi $s5, $s5, -4
	lw   $t0, 0($s5)
	beq  $t0, $t1, diagonalDirBaixo
	
	#move $s5, $s3
	#addi $s5, $s5, -260
	#lw   $t0, preto
	#sw   $t0, 0($s5)
	
	move $s5, $s3
	lw   $t0, preto
	sw   $t0, 0($s5)
	addi $s3, $s3, 252
	li   $a1, 4
	li   $v0, 42
	syscall
	move $t7, $a0
	add  $sp, $sp, -4
	sw   $ra, 0($sp)
	jal  cor
	sw   $t2, 0($s3)

	lw   $ra, 0($sp)
	add  $sp, $sp, 4
	jr   $ra

diagonalDirBaixo:
	li   $t8, 6
	
	lw   $t1, cinza
	move $s5, $s3	
	addi $s5, $s5, 4
	lw   $t0, 0($s5)
	beq  $t0, $t1, diagonalEsqBaixo
	
	move $s5, $s3
	addi $s5, $s5, -252
	lw   $t1, preto
	sw   $t1, 0($s5)
	move $s5, $s3
	addi $s5, $s5, 260
	lw   $t0, 0($s5)
	lw   $t1, verde
	beq  $t0, $t1, diagonalEsq
	lw   $t1, amarelo
	beq  $t0, $t1, diagonalEsq
	lw   $t1, laranja
	beq  $t0, $t1, diagonalEsq
	lw   $t1, vermelho
	beq  $t0, $t1, diagonalEsq	

	move $s5, $s3
	addi $s5, $s5, -252
	lw   $t0, preto
	sw   $t0, 0($s5)
	
	move $s5, $s3
	lw   $t0, preto
	sw   $t0, 0($s5)
	addi $s3, $s3, 260
	li   $a1, 4
	li   $v0, 42
	syscall
	move $t7, $a0
	add  $sp, $sp, -4
	sw   $ra, 0($sp)
	jal  cor
	sw   $t2, 0($s3)

	lw   $ra, 0($sp)
	add  $sp, $sp, 4
	jr   $ra
diagonalDirBaixoTopo:
	li   $t8, 8
	
	lw   $t1, cinza
	move $s5, $s3	
	addi $s5, $s5, 4
	lw   $t0, 0($s5)
	beq  $t0, $t1, diagonalEsqBaixo
	
	#move $s5, $s3
	#addi $s5, $s5, -260
	#lw   $t0, preto
	#sw   $t0, 0($s5)
	
	move $s5, $s3
	lw   $t0, preto
	sw   $t0, 0($s5)
	addi $s3, $s3, 260
	li   $a1, 4
	li   $v0, 42
	syscall
	move $t7, $a0
	add  $sp, $sp, -4
	sw   $ra, 0($sp)
	jal  cor
	sw   $t2, 0($s3)

	lw   $ra, 0($sp)
	add  $sp, $sp, 4
	jr   $ra

cor:
	beq  $t7, 0, bola_Rosa
	beq  $t7, 1, bola_Azul
	beq  $t7, 2, bola_Dourada
	beq  $t7, 3, bola_Bordo
sair:
	jr $ra
bola_Rosa:
	lw  $t2, rosa
	j sair
bola_Azul:
	lw  $t2, azul
	j sair
bola_Dourada:
	lw  $t2, dourado
	j sair
bola_Bordo:
	lw  $t2, bordo
	j sair
#-----------------Faz um desenho e pergunta "Play Again"-----------------#
derrota:
	li   $s0, 0x10010000
	addi $s0, $s0, 7284
	lw   $t0, vermelho
	sw   $t0, 0($s0)
	addi $s0, $s0, 4
	sw   $t0, 0($s0)
	addi $s0, $s0, 4
	sw   $t0, 0($s0)
	addi $s0, $s0, 4 
	sw   $t0, 0($s0)
	addi $s0, $s0, 4
	sw   $t0, 0($s0)
	addi $s0, $s0, 768
	sw   $t0, 0($s0)
	addi $s0, $s0, -4
	sw   $t0, 0($s0)
	addi $s0, $s0, -4
	sw   $t0, 0($s0)
	addi $s0, $s0, -4
	sw   $t0, 0($s0)
	addi $s0, $s0, -4
	sw   $t0, 0($s0)
	addi $s0, $s0, -256
	sw   $t0, 0($s0)
	addi $s0, $s0, -256
	sw   $t0, 0($s0)
	addi $s0, $s0, 768
	sw   $t0, 0($s0)
	addi $s0, $s0, 256
	sw   $t0, 0($s0)
	addi $s0, $s0, 256
	sw   $t0, 0($s0)
	addi $s0, $s0, 256
	sw   $t0, 0($s0)
	
	li $v0, 4
    la $a0, printDnv
    syscall
    
    li   $v0, 5
    syscall
    move $t9, $v0
    
    li  $t0, 1
    beq $t9, $t0, escolherDificuldade
	
	li  $t0, 2
	beq $t9, $t0, exit
	
#-----------------Saida-----------------#	
exit:
	li $v0 10
	syscall
