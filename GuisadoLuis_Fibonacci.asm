.data                          # Secci�n de datos est�ticos
prompt_n:      .asciiz "Cuantos terminos de Fibonacci desea generar? "   # Pedir N
msg_series:    .asciiz "Serie: "                                         # Texto previo a la serie
coma_esp:      .asciiz ", "                                              # Separador coma-espacio
newline:       .asciiz "\n"                                              # Salto de l�nea
msg_suma:      .asciiz "Suma: "                                          # Texto previo a la suma
msg_err:       .asciiz "Ingrese un entero N >= 1.\n"                     # Error si N < 1

.text                          # Secci�n de c�digo
.globl main                    # Punto de entrada

main:                          # Inicio del programa
# Leer N y validar N >= 1
read_n:                        # Bucle de lectura de N
    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, prompt_n           # Direcci�n del mensaje
    syscall                    # Imprimir

    li $v0, 5                  # Syscall 5: leer entero
    syscall                    # Leer N
    move $t0, $v0              # $t0 = N

    blt $t0, 1, n_invalid      # Si N < 1, inv�lido
    j start_fib                # Si v�lido, continuar

n_invalid:                     # Manejo de N inv�lido
    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, msg_err            # Mensaje de error
    syscall                    # Imprimir
    j read_n                   # Reintentar

# Inicializar variables para Fibonacci
start_fib:                     # Preparar el c�lculo
    li $t1, 0                  # a = 0 (primer t�rmino)
    li $t2, 1                  # b = 1 (segundo t�rmino)
    move $t3, $zero            # i = 0 (contador)
    move $t4, $zero            # sum = 0 (acumulador)
    li $t5, 0                  # flag_first = 0 (para formato de impresi�n)

    # Imprimir encabezado "Serie: "
    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, msg_series         # Direcci�n del texto "Serie: "
    syscall                    # Imprimir

# Bucle para generar e imprimir N t�rminos
fib_loop:                      # Bucle principal de la serie
    beq $t3, $t0, end_series   # Si i == N, terminar

    # Imprimir separador si no es el primer termino
    beq $t5, $zero, print_term   # Si es el primero, no imprimir separador
    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, coma_esp           # Direcci�n de ", "
    syscall                    # Imprimir separador

print_term:                    # Imprimir t�rmino actual 'a'
    li $v0, 1                  # Syscall 1: imprimir entero
    move $a0, $t1              # a0 = a
    syscall                    # Imprimir a

    add $t4, $t4, $t1          # sum += a
    li $t5, 1                  # flag_first = 1 (ya imprimimos el primero)

    # Siguiente t�rmino: next = a + b; a = b; b = next
    addu $t6, $t1, $t2         # next = a + b (addu evita excepci�n por signo)
    move $t1, $t2              # a = b
    move $t2, $t6              # b = next

    addi $t3, $t3, 1           # i++
    j fib_loop                 # Repetir

# Imprimir salto de l�nea y la suma
end_series:                    # Fin de la serie
    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, newline            # Salto de l�nea
    syscall                    # Imprimir

    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, msg_suma           # Texto "Suma: "
    syscall                    # Imprimir

    li $v0, 1                  # Syscall 1: imprimir entero
    move $a0, $t4              # a0 = sum
    syscall                    # Imprimir suma

    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, newline            # Salto de l�nea final
    syscall                    # Imprimir

    li $v0, 10                 # Syscall 10: salir
    syscall                    # Finalizar
