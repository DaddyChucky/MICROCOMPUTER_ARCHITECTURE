.data
        critere: .float 10.0

.text

.globl	_ZN8Etudiant8admisasmEv

_ZN8Etudiant8admisasmEv:
        pushl   %ebp                            # prologue
        movl    %esp, %ebp

        pushl   8(%ebp)                         # this, pour préparer le call
        call    _ZN8Etudiant10moyenneasmEv      # calcul de la moyenne

        movl    $0, %eax                        # réinitialisation de %eax après le call
        flds    critere                         # on push 10 dans la FPU (le critère)
        fcompp                                  # on compare st[0] avec st[1], les flags sont stockés dans les codes de conditions
        fstsw   %ax                             # nous plaçons les codes de conditions de comparaison dans %ax (source: http://www.website.masmforum.com/tutorials/fptute/fpuchap7.htm#fcompp)
        fwait                                   # nous attendons que le résultat de la comparaison soit complété (voir source ci-haut)
        sahf                                    # nous transférons les codes de conditions dans le registre de drapeaux du CPU (voir source ci-haut)

        ja      non_admis                       # si le critère est supérieur à la moyenne, l'étudiant n'est pas admis et nous sautons à non_admis
        
        movl    $1, %eax                        # nous retournons 1
        jmp     retour                          # nous sautons à retour sans passer par non admis

non_admis:
        movl    $0, %eax                        # nous retournons 0

retour:
        leave                                   # épilogue
        ret
