library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.simple_risc_def.all;

package simple_risc_programs is

   constant program_0 : inst_mem_type := (
      x"A000001", -- r0    <- +1           - addr x00
      x"A010002", -- r1    <- +2           - addr x01
      x"0040200", -- r4    <- r2 + r0      - addr x02
      x"0040400", -- r4    <- r4 + r0      - addr x03
      x"0040400", -- r4    <- r4 + r0      - addr x04
      x"1050301", -- r5    <- r3 - r1      - addr x05
      x"A060009", -- r6    <- +9           - addr x06
      x"9000106", -- M[r1] <- r6           - addr x07
      x"8070100", -- r7    <- M[r1]        - addr x08
      x"0010100", -- r1    <- r1 + r0      - addr x09
      x"0060600", -- r6    <- r6 + r0      - addr x0A
      x"1040400", -- r4    <- r4 - r0      - addr x0B
      x"C020007", -- jnz 0x07              - addr x0C
      others => (others => '1')
   );

   constant program_1 : inst_mem_type := (
      x"A010004", -- r1    <- +4             - addr x00 - À changer pour le nombre d'itérations voulues suite pour compléter la suite de { 1, 2, ... }
      x"A020001", -- r2    <- +1             - addr x01 - Constante à 1
      x"A030001", -- r3    <- +1             - addr x02 - Correspond à notre variable temporaire 1 pour les calculs qui suivent
      x"A040002", -- r4    <- +2             - addr x03 - Correspond à notre variable temporaire 2 pour les calculs qui suivent
      x"9000003", -- M[r0] <- r3             - addr x04 - Stocker dans la mémoire le premier résultat de la suite, soit S0 (1)
      x"9000204", -- M[r2] <- r4             - addr x05 - Stocker dans la mémoire le second résultat de la suite, soit S1 (2)
      x"A050001", -- r5    <- +1             - addr x06 - Mettre à 1 le registre correspondant à l'index de la mémoire pour laquelle nous voulons insérer les résultats de la suite
      x"0030203", -- r3    <- r3 + r2        - addr x07 - Nous additionnons la constante (1) à la variable temporaire 1; la réponse est stockée dans la variable temporaire 1
      x"0030403", -- r3    <- r4 + r3        - addr x08 - Nous additionnons les deux variables temporaires ensemble; la réponse est stockée dans la variable temporaire 1
      x"0050502", -- r5    <- r5 + r2        - addr x09 - Nous incrémentons de 1 le registre correspondant à l'index de la mémoire
      x"9000503", -- M[r5] <- r3             - addr x0A - Stocker dans la mémoire les résultats de la suite où le nombre d'itérations est impair
      x"1010102", -- r1    <- r1 - r2        - addr x0B - Nous décrémentons le nombre d'itérations de 1
      x"C010013", -- jz 0x13                 - addr x0C - Le programme se termine si le nombre d'itérations est nul
      x"0040403", -- r4    <- r4 + r3        - addr x0D - Nous additionnons les deux variables temporaires ensemble; la réponse est stockée dans la variable temporaire 2
      x"0040402", -- r4    <- r4 + r2        - addr x0E - Nous additionnons la constante (1) à la variable temporaire 2; la réponse est stockée dans la variable temporaire 2
      x"0050502", -- r5    <- r5 + r2        - addr x0F - Nous incrémentons de 1 le registre correspondant à l'index de la mémoire
      x"9000504", -- M[r5] <- r4             - addr x10 - Stocker dans la mémoire les résultats de la suite où le nombre d'itérations est pair
      x"1010102", -- r1    <- r1 - r2        - addr x11 - Nous décrémentons le nombre d'itérations de 1
      x"C020007", -- jnz 0x07                - addr x12 - Nous bouclons si le nombre d'itérations n'est pas nul pour compléter la suite
      others => (others => '1')
   );
   
end simple_risc_programs;

package body simple_risc_programs is  
end simple_risc_programs;