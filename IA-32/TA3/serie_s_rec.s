.text
.globl serie_s_rec

   pushl %ebx
serie_s_rec:
   pushl %ebp           # Prologue
   movl  %esp, %ebp
   pushl %ebx

   cmpl  $0, 8(%ebp)    # Nous comparons n (8(%ebp)) avec 0
   je    N0             # Si n == 0, nous sautons à N0
   cmpl  $1, 8(%ebp)    # Nous comparons n avec 1
   je    N1             # Si n == 1, nous sautons à N1

   movl  8(%ebp), %eax  # Nous mettons n dans %eax
   decl  %eax           # Nous décrémentons %eax de 1
   pushl %eax           # Nous préparons le call de serie_s_rec avec, en paramètre, n - 1
   call  serie_s_rec    # Nous appelons serie_s_rec (récursivité)
   movl  %eax, %ebx     # Nous stockons la valeur de retour dans %ebx
   movl  8(%ebp), %eax  # Nous mettons n dans %eax
 
   subl  $2, %eax       # Nous décrémentons %eax de 2
   pushl %eax           # Nous préparons le call de serie_s_rec avec, en paramètre, n - 2
   call  serie_s_rec    # Nous appelons serie_s_rec (récursivité)
   addl  %ebx, %eax     # Nous additionnons la valeur sauvegardée de %ebx au premier call à %eax
   incl  %eax           # Nous incrémentons la valeur de retour de 1
   movl  -4(%ebp), %ebx # Pour la récursivité des valeurs 4 à 6, nous écrasons la valeur %ebx en mémoire pour l'additionner à %eax à la prochaine itération
   jmp   Retour         # Nous retournons la valeur

N0:
   movl  $1, %eax       # Nous retournons 1
   jmp   Retour     
   
N1:
   movl  $2, %eax       # Nous retournons 2 

Retour:
   leave                # Épilogue
   ret
   popl %ebx
   