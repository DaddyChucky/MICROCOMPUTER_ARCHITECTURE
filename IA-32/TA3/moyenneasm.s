.data
        factor: .float 10.0

.text

.globl	_ZN8Etudiant10moyenneasmEv

_ZN8Etudiant10moyenneasmEv:

    push    %ebp                # prologue
    mov     %esp, %ebp

    movl    8(%ebp), %eax       # nous plaçons la valeur de tabnotes[0] dans %eax
    mov     $10, %ecx           # nous allons boucler 10 fois
    mov     $1, %edx            # %edx servira à référencer l'index du tableau
    flds    (%eax)              # nous insérons l'adresse de la première valeur de tabnotes[0] dans le registre à virgule flottante

boucle:
    flds    (%eax, %edx, 4)     # nous insérons l'adresse de la prochaine valeur de tabnotes[%edx] dans le registre à virgule flottante
    faddp                       # nous additionnons st[%edx - 1] avec st[%edx] et nous remplaçons la valeur de st[%edx] par le résultat de cette sommation
    inc     %edx                # nous incrémentons l'index de tabnotes, soit %edx
    loop    boucle              # nous bouclons 10 fois pour parcourir l'entièreté du tableau tabnotes
    
    flds    factor              # nous plaçons la valeur de factor (10.0) dans le registre à virgule flottante, nous préparant à la division
    fdivrp                      # nous divisons la dernière valeur du tableau sommée par factor, tout en stockant le quotient à la 11e case du registre à virgule flottante

    leave                       # épilogue
    ret
 