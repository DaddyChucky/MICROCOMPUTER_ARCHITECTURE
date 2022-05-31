.text
.globl calcul_2

calcul_2 :
    movl $64, %ecx          # Nous initialisons %ecx, soit les 64 cases de mémoires, chacune sur 32 bits
    movl $0, %edx           # Nous initialisons %edx à 0, soit l'index de la case mémoire pointée
    clc                     # Nous initialisons le Carry Flag (CF) à 0

boucle:
    movl adr_x(%edx), %eax  # Nous déplaçons le contenu d'une case mémoire de adr_x dans une variable temporaire (%eax)
    adcl adr_y(%edx), %eax  # Nous additionnons le contenue d'une case mémoire de adr_y dans la variable temporaire (%eax)
    movl %eax, adr_z(%edx)  # Nous déplaçons la variable temporaire (%eax) - le résultat de l'addition - dans une case mémoire de adr_z (la réponse)  
    inc %edx                # Incrémentation de %edx (4 fois), sans affecter le carry
    inc %edx                # (voir ci-haut)
    inc %edx                # (voir ci-haut)
    inc %edx                # (voir ci-haut)
    loop boucle             # Nous répétons la boucle 64 fois, soit jusqu'à ce que %eax égal 0
    ret                     # Fin du programme
