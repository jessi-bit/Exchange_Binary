  #while(num!=0){// num = 428
    #tmp = num%10; 
      #num = num/10; 
	#inv = inv*10+tmp;}
.data                                                                                    
strSpace : .asciiz " "
dati: .word -214
fine_dati:
.data
results:
.space 256
.globl __start
.text

__start:la $t0, dati
        la $t1, results
        lw $a1, 0($t0)
        
        bgt $a1, $zero start    

crct:   bne $a1, $zero, negat
sum:    li $v0, 5
	syscall
        add $a1, $a1, $v0      
        bgt $a1, $zero start

negat:  li $t3, -1              
        mul $a1, $a1, $t3       


start:  srl $s7, $a1, 1
        xor $s7, $a1, $s7          #grey'       
        sw $s7, 0($t1)
                 
        
        li $v0, 1
        move $a0, $s7
        syscall
        li $v0, 4
        la $a0, strSpace
        syscall

        addu $t2, $zero, $zero   #inizializzo t2 --> inv
        addu $t7, $zero, $zero   #inizializzo t7--> temp
        move $t5, $s7            #sposto il numero in grey in un registro pronto per un nuovo calcolo
        li $t3, 10

cicle1: divu $t5, $t5, $t3      #il numero diventa la parte intera della divisione x 10         
        mfhi $t7                #temp = RESTO                
        mul $t2, $t2, $t3       
        addu $t2, $t2, $t7
        bne $t5, $zero cicle1
        
        sw $t2,4($t1)
        li $v0, 1
        move $a0, $t2          #t2 numero grey invertito
        syscall
        li $v0, 4
        la $a0, strSpace
        syscall
        
        move $a2, $t2         #sposto in un altro registro per effettuare un nuovo ricalcolo
        li $t8, 2
        addiu $t1, $t1, 8     #indirizzo inizio sequenza binaria invertita
        move $s7, $t1

cicle2: div $a2, $a2, $t8
        mfhi $t6
        sb $t6, 0($t1)
        addiu $t1, $t1, 1     #t1 punta all'indirizzo di fine della sequenza binaria(invertita)
        bne $a2, $zero cicle2
        
        subu $a3, $t1, $s7       #lunghezza della sequenza binaria
        addiu $t1, $t1, -1
        move $s6, $t1 
        addu $s5, $zero, $zero   #inizializzo il registro dove mettero dentro tutta la sequenza binaria
        addu $t8, $zero, $zero
        
cicle3: lb $t9, 0($t1)    
        sb $t9, 0($s6)
        addiu $t8, $t8, 1  #contatore dei byte => mi serve per verificarlo alla fine del ciclo con a3 che contiene la lunghezza della seq bin. 
        li $v0, 1
        move $a0, $t9
        syscall
        sll $s5, $s5, 1
        addu $s5, $s5, $t9
        addiu $s6, $s6, 1
        addiu $t1, $t1, -1
        bge $t1, $s7 cicle3
                   
        li $t7, 4
        div $t3, $s6, $t7    #numero / 4
        mfhi $t3             #quanto manca al resto per essere multiplo di 4?
        subu $t3, $t7, $t3   #$t3 contiene offset
        addu $s6, $s6, $t3   #dovrei allineare cosi il puntatore alla memoria
     
        ori $s0, $zero, 0xffff    
        bleu $s5, $s0 halfw
        
        sw $s5, 0($s6)
        li $v0, 4
        la $a0, strSpace
        syscall
        li $v0, 1
        move $a0, $s5
        syscall
        
        li $v0, 4
        la $a0, strSpace
        syscall

        move $s4, $s5
        nor $s4, $s4, $zero 
        addiu $s4, $s4, 1
        sw $s4, 4($s6)
        addiu $s6, $s6, 6
        
        li $v0, 1
        move $a0, $s4
        syscall
j end

halfw:  sh $s5, 0($s6)
        li $v0, 4
        la $a0, strSpace
        syscall
        li $v0, 1
        move $a0, $s5
        syscall
        
        li $v0, 4
        la $a0, strSpace
        syscall

        move $s4, $s5
        nor $s4, $s4, $zero 
        addiu $s4, $s4, 1
        sh $s4, 2($s6)
        addiu $s6, $s6, 4             
        
        #addiu $s4, $s4, -1
        #nor $s4, $s4, $zero
        
        li $v0, 1
        move $a0, $s4
        syscall
        
        
end:    j end
 
#t0 e t1 puntatori alla memoria
#a1 numero letto dalla memoria
#s7 primo risulatato in Grey. Il numero in Grey verrà spostato in t5
#t2 secondo risultato del numero invertito
#s7 indirizzo di inizio della prima sequenza binaria invertita che scrivo come byte, mentre s6 avrà l'indirizzo di fine
#Numero invertito passa al registro a2 e l'indirizzo a cui punta t1 messo in s7
#t6 registro di appoggio per i resti che vengono scritti in memoria
#a3 lunghezza stringa binaria
#s5 registro che conterrà il numero di nuovo
#s4 numero in complemento a 2.





        

             
        
             