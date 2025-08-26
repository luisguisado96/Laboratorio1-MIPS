.data                          # Sección de datos estáticos
prompt_n:      .asciiz "Cuantos terminos de Fibonacci desea generar? "   # Pedir N
msg_series:    .asciiz "Serie: "                                         # Texto previo a la serie
coma_esp:      .asciiz ", "                                              # Separador coma-espacio
newline:       .asciiz "\n"                                              # Salto de línea
msg_suma:      .asciiz "Suma: "                                          # Texto previo a la suma
msg_err:       .asciiz "Ingrese un entero N >= 1.\n"                     # Error si N < 1

.text                          # Sección de código
.globl main                    # Punto de entrada

main:                          # Inicio del programa
# Leer N y validar N >= 1
read_n:                        # Bucle de lectura de N
    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, prompt_n           # Dirección del mensaje
    syscall                    # Imprimir

    li $v0, 5                  # Syscall 5: leer entero
    syscall                    # Leer N
    move $t0, $v0              # $t0 = N

    blt $t0, 1, n_invalid      # Si N < 1, inválido
    j start_fib                # Si válido, continuar

n_invalid:                     # Manejo de N inválido
    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, msg_err            # Mensaje de error
    syscall                    # Imprimir
    j read_n                   # Reintentar

# Inicializar variables para Fibonacci
start_fib:                     # Preparar el cálculo
    li $t1, 0                  # a = 0 (primer término)
    li $t2, 1                  # b = 1 (segundo término)
    move $t3, $zero            # i = 0 (contador)
    move $t4, $zero            # sum = 0 (acumulador)
    li $t5, 0                  # flag_first = 0 (para formato de impresión)

    # Imprimir encabezado "Serie: "
    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, msg_series         # Dirección del texto "Serie: "
    syscall                    # Imprimir

# Bucle para generar e imprimir N términos
fib_loop:                      # Bucle principal de la serie
    beq $t3, $t0, end_series   # Si i == N, terminar

    # Imprimir separador si no es el primer termino
    beq $t5, $zero, print_term   # Si es el primero, no imprimir separador
    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, coma_esp           # Dirección de ", "
    syscall                    # Imprimir separador

print_term:                    # Imprimir término actual 'a'
    li $v0, 1                  # Syscall 1: imprimir entero
    move $a0, $t1              # a0 = a
    syscall                    # Imprimir a

    add $t4, $t4, $t1          # sum += a
    li $t5, 1                  # flag_first = 1 (ya imprimimos el primero)

    # Siguiente término: next = a + b; a = b; b = next
    addu $t6, $t1, $t2         # next = a + b (addu evita excepción por signo)
    move $t1, $t2              # a = b
    move $t2, $t6              # b = next

    addi $t3, $t3, 1           # i++
    j fib_loop                 # Repetir

# Imprimir salto de línea y la suma
end_series:                    # Fin de la serie
    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, newline            # Salto de línea
    syscall                    # Imprimir

    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, msg_suma           # Texto "Suma: "
    syscall                    # Imprimir

    li $v0, 1                  # Syscall 1: imprimir entero
    move $a0, $t4              # a0 = sum
    syscall                    # Imprimir suma

    li $v0, 4                  # Syscall 4: imprimir cadena
    la $a0, newline            # Salto de línea final
    syscall                    # Imprimir

    li $v0, 10                 # Syscall 10: salir
    syscall                    # Finalizar
