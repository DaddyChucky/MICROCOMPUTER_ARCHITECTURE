.data
        note_memoire_min: .float 10.0

.text

.globl	_ZN18EtudiantEnMaitrise8admisasmEv

_ZN18EtudiantEnMaitrise8admisasmEv:
        pushl   %ebp                            # prologue
        movl    %esp, %ebp

        pushl   8(%ebp)                         # this, pour préparer le call
        call    _ZN8Etudiant8admisasmEv         # nous appelons la fonction qui retourne si l'étudiant est admis ou non selon la moyenne de ses notes 
        
        cmpl    $0, %eax                        # on regarde si l'étudiant est admis selon ses notes
        jz      retour                          # s'il ne l'est pas, le programme se termine, nous retournons 0
        
        movl    $0, %eax                        # remise à zéro du registre %eax
        movl    8(%ebp), %ecx                   # nous nous apprêtons à charger la moyenne de sa mémoire (voir ci-bas)
        flds    144(%ecx)                       # vtable(4) + 10 * float(4) + 100 * char(1) = 144, note de mémoire ajoutée à la pile
        flds    note_memoire_min                # nous ajoutons la note minimale à la pile
        fcompp                                  # on compare st[0] avec st[1], les flags sont stockés dans les codes de conditions
        fstsw   %ax                             # nous plaçons les codes de conditions de comparaison dans %ax (source: http://www.website.masmforum.com/tutorials/fptute/fpuchap7.htm#fcompp)
        fwait                                   # nous attendons que le résultat de la comparaison soit complété
        sahf                                    # nous transférons les codes de conditions dans le registre de drapeaux du CPU
        
        ja      non_admis                       # si la note mémoire minimale est supérieure à la note de la mémoire de l'étudiant, celui-ci n'est pas admis et nous sautons à non_admis
        
        movl    $1, %eax                        # sinon, nous retournons 1 (étudiant admis)
        jmp     retour                          # fin du programme sans passer par non_admis
        
non_admis:
        movl    $0, %eax                        # nous retournons 0 (étudiant non admis)

retour:
        leave                                   # épilogue
        ret       
