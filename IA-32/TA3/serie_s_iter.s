.text
.globl serie_s_iter
serie_s_iter:
   pushl  %ebp          # Prologue
   movl   %esp, %ebp
   pushl  %ebx

   movl  8(%ebp), %ecx  # Récupérer le premier paramètre (n) de la fonction serie_s_iter et le placer dans %ecx
   cmpl  $0, %ecx       # Comparer %ecx (n) avec 0
   je    N0             # Si n = 0, nous retournons 1
   cmpl  $1, %ecx       # Comparer %ecx (n) avec 1
   je    N1             # Si n = 1, nous retournons 2
   movl  $2, %ebx       # Initialiser %ebx (i) à 2
   movl  $1, %edx       # Initialiser %edx (p) à 1
   movl  $2, %eax       # Initialiser %eax (c) à 2
   jmp   Boucle         # Sautons à la boucle
   
N0:
   movl  $1, %eax       # Nous retournons 1
   jmp   Retour     
   
N1:
   movl  $2, %eax       # Nous retournons 2
   jmp   Retour   


Boucle:
   cmpl  %ecx, %ebx     # Nous comparons %ecx (n) avec %ebx (i)
   ja    Retour         # Fin du programme si n > i, nous retournons %eax (c)
   movl  %eax, %esi     # Nous changeons la valeur de %esi (t) à 2, soit %eax (c)
   addl  %edx, %eax     # Nous additionnons %edx (p) à %eax (c)
   inc   %eax           # Nous incrémentons %eax (c)
   movl  %esi, %edx     # Nous changeons la valeur de %edx (p) à %esi (t)
   inc   %ebx           # Nous incrémentons %ebx (i) (condition du for)
   inc   %ecx           # Nous incrémentons %ecx (i), afin de contrer l'effet du loop (%ecx - 1)
   loop  Boucle         # Nous bouclons
   
Retour:   
   popl  %ebx           # Épilogue
   leave
   ret
