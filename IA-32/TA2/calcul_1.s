.data
.globl adr
adr:
   .int 1,2,3,4,5,6,7,8,9,10,11,12,12,14,15,16,17,18    #Cases memoires debutant de l'adresse adr
   
.text
.globl calcul_1

calcul_1 :
   movl $18, %ecx          # Nous initialisons %ecx à 18, soit le nombre de puissances voulues
   movl $0, %edx           # Nous initialisons %edx à 0, soit l'index de la première case mémoire de adr
   movl $3, adr(%edx)      # Nous initialisons la première case mémoire de adr à 3
   jmp sommation           # Nous sautons à sommation, qui calcule les 18 puissances de 3

sommation :
   movl adr(%edx), %eax    # Pour calculer la n puissance, nous déplacons la valeur de adr(n - 1) vers %eax
   addl adr(%edx), %eax    # Nous additionnons la valeur de adr(n - 1) vers %eax
   addl adr(%edx), %eax    # Nous additionnons à nouveau la valeur de adr(n - 1) vers %eax
   addl $4, %edx           # Nous ajoutons 4 à %edx, pointant vers la prochaine case mémoire de adr (incrémente d'un index)
   movl %eax, adr(%edx)    # Nous déplaçons la n puissance dans adr(n)
   loopnz sommation        # Nous bouclons tant que %ecx n'est pas égal à zéro (la boucle décrémentant %ecx à chaque itération)
   ret                     # Fin du programme
