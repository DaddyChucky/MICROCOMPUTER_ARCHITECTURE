.data
.globl adr_temp,adr_res
adr_temp :
     .int 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,3,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64
adr_res:
     .int 1

.text
.globl calcul_3

calcul_3 :
     movl $256, %edi               # Nous initialisons %edi à 256, soit l'adresse de la case no. 1 de adr_res 
     movl $63, %ecx                # Nous initialisons %ecx à 63, soit le nombre d'itérations voulues pour initialiser adr_temp et adr_res (avec un 3 initial représenté sur 256 octets)
     movl $0, %esi                 # Nous initialisons %esi à 0, soit le nombre de puissances à laquelle nous sommes rendues
     movl $0, %edx                 # Nous initialisons %edx à 0, soit une case initiale de mémoire
     movl $3, adr_temp(%edx)       # Nous initialisons la première case mémoire de adr_temp à 3  
     movl $3, adr_res(%edx)        # Nous initialisons la première case mémoire de adr_res à 3 
     addl $4, %edx                 # Nous ajoutons 4 à %edx afin de pointer vers la prochaine case mémoire

initialisation:
     movl $0, adr_temp(%edx)       # Nous ajoutons des zéros pour combler les cases mémoires de adr_temp pour représenter le 3 sur 256 octets
     movl $0, adr_res(%edx)        # Nous ajoutons des zéros pour combler les cases mémoires de adr_res pour représenter le 3 sur 256 octets
     addl $4, %edx                 # Nous ajoutons 4 à %edx afin de pointer vers la prochaine case mémoire
     loop initialisation           # Nous bouclons pour couvrir toutes les cases mémoires (63 cases à boucler)
     movl $64, %ecx                # Nous réinitialisons %ecx à 64, soit le nombre d'itérations représentant les cases mémoires
     movl $0, %edx                 # Nous réinitialisons notre pointeur à 0

sommation:
     clc                           # Nous initialisons le Carry Flag (CF) à 0
     movl adr_temp(%edx), %eax     # Nous déplaçons le contenu d'une case mémoire de adr_temp dans une variable temporaire (%eax)
     adcl %eax, adr_temp(%edx)     # Nous additionnons la variable temporaire à une case mémoire de adr_temp (en tenant compte du carry)
     adcl %eax, adr_temp(%edx)     # (voir ci-haut)
     addl $4, %edx                 # Nous pointons vers la prochaine case mémoire
     loop sommation                # Nous bouclons pour additionner, entre elles, toutes les cases mémoires
     movl $64, %ecx                # Nous réinitialisons %ecx à 64, soit le nombre d'itérations représentant les cases mémoires
     movl $0, %edx                 # Nous réinitialisons notre pointeur à 0

ecrire_resultat:
     movl adr_temp(%edx), %eax     # Nous déplaçons le contenu de la case mémoire de adr_temp dans une variable temporaire (%eax)
     movl %eax, adr_res(%edi)      # Nous déplaçons le contenu de la variable temporaire dans adr_res
     addl $4, %edx                 # Nous pointons vers la prochaine case mémoire de adr_temp
     addl $4, %edi                 # Nous pointons vers la prochaine case mémoire de adr_res
     loop ecrire_resultat          # Nous bouclons pour écrire la réponse, soit les 256 octets dans adr_res
     inc %esi                      # Nous incrémentons (de 1) le nombre de puissance réalisée
     movl $64, %ecx                # Nous réinitialisons %ecx à 64, soit le nombre d'itérations représentant les cases mémoires
     movl $0, %edx                 # Nous réinitialisons notre pointeur
     cmp $10, %esi                 # Nous comparons le nombre de puissances (%esi) à 10; nous bouclons pour 10 puissances
     jb sommation                  # Nous sautons à sommation tant que le nombre de puissances est inférieur à 10
     ret                           # Fin du programme
