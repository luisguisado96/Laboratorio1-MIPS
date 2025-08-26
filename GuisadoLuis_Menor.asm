.data                      # Secci�n de datos est�ticos
prompt_n:      .asciiz "Ingrese cuantos numeros desea comparar (3 a 5): "   # Mensaje para pedir la cantidad
prompt_val:    .asciiz "Ingrese un numero entero: "                          # Mensaje para pedir cada numero
msg_result:    .asciiz "El menor numero es: "                                # Mensaje para mostrar el resultado
msg_err:       .asciiz "Valor invalido. Debe ser entre 3 y 5.\n"             # Mensaje de error
newline:       .asciiz "\n"                                                  # Salto de linea

.text                      # Secci�n de c�digo
.globl main                # Punto de entrada

main:                      # Inicio del programa
    # Bucle para leer una cantidad v�lida (entre 3 y 5)
read_count:                # Etiqueta para reintentar si el usuario ingresa un valor inv�lido
    li $v0, 4              # Syscall 4: imprimir cadena
    la $a0, prompt_n       # Direcci�n del mensaje de cantidad
    syscall                # Llamar al sistema para imprimir

    li $v0, 5              # Syscall 5: leer entero
    syscall                # Leer entero del usuario
    move $t0, $v0          # Guardar cantidad en $t0 (n)

    blt $t0, 3, invalid    # Si n < 3, es inv�lido
    bgt $t0, 5, invalid    # Si n > 5, es inv�lido
    j read_values          # Si es v�lido, continuar a leer valores

invalid:                   # Manejo de cantidad inv�lida
    li $v0, 4              # Syscall 4: imprimir cadena
    la $a0, msg_err        # Direcci�n del mensaje de error
    syscall                # Imprimir error
    j read_count           # Reintentar

# Leer el primer valor y asumir que es el m�nimo inicial
read_values:               # Inicio de la lectura de valores
    li $v0, 4              # Syscall 4: imprimir cadena
    la $a0, prompt_val     # Direcci�n del mensaje para pedir un numero
    syscall                # Imprimir mensaje

    li $v0, 5              # Syscall 5: leer entero
    syscall                # Leer primer numero
    move $t1, $v0          # $t1 = min actual
    li $t2, 1              # Contador i = 1 (ya le�mos 1 numero)

# Bucle para leer los (n-1) restantes y actualizar el m�nimo
loop_read:                 # Bucle principal de lectura/comparaci�n
    beq $t2, $t0, show_result  # Si i == n, salir del bucle
    li $v0, 4              # Syscall 4: imprimir cadena
    la $a0, prompt_val     # Direcci�n del mensaje para pedir otro numero
    syscall                # Imprimir mensaje

    li $v0, 5              # Syscall 5: leer entero
    syscall                # Leer numero
    move $t3, $v0          # $t3 = numero le�do

    # Comparar $t3 con el min actual ($t1)
    bge $t3, $t1, no_update   # Si $t3 >= $t1, no actualizar
    move $t1, $t3          # Si $t3 < $t1, actualizar min = $t3
no_update:                 # No se actualiz� el m�nimo

    addi $t2, $t2, 1       # i++
    j loop_read            # Repetir

# Mostrar el resultado
show_result:               # Mostrar el m�nimo encontrado
    li $v0, 4              # Syscall 4: imprimir cadena
    la $a0, msg_result     # Mensaje "El menor numero es: "
    syscall                # Imprimir mensaje

    li $v0, 1              # Syscall 1: imprimir entero
    move $a0, $t1          # Pasar el m�nimo en $t1
    syscall                # Imprimir valor del m�nimo

    li $v0, 4              # Syscall 4: imprimir cadena
    la $a0, newline        # Imprimir salto de linea
    syscall                # Salto de linea

    li $v0, 10             # Syscall 10: salir del programa
    syscall                # Finalizar