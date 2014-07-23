@********************************************************
@ rutinas.s
@ Autor: Héctor A. Möller
@ Fecha: 22/07/2014
@ Curso: CC4010 Taller de Assembler
@ Contiene varias subrutinas:
@ str2num convierte string a número. 
@ perimetro encuentra el perímetro del triángulo.
@ tipoTriangulo determina el tipo de triángulo. 
@********************************************************

.global str2num
str2num:


@Lee una cadena de largo 3 y la convierte en un número. 
@Parametros:
@r0: dirección de memoria del String recibido. 
@Retorna:
@r1: valor numérico del string.
@El string del número se divide en tres caracteres:  
@Otros registros:
@r1: centenas
@r2: decenas
@r3: unidades


	push {lr}
	
@Primero se leen los tres caracteres. Recordar que vienen como valores ASCII. 
@La dirección de la cadena es enviada en R0. Se utiliza direccionamiento pre-indexado para no alterar r0.
		ldrb r1,[r0]
		ldrb r2,[r0,#1]
		ldrb r3,[r0,#2]
		
@Se convierten caracteres a valores numéricos. Se le resta 30 hexadecimal.  
		
		sub r1,r1,#0x30
		sub r2,r2,#0x30
		sub r3,r3,#0x30
		
@Ahora se tiene:
@r1: centenas
@r2: decenas
@r3: unidades
@r4: registro intermedio para manejo de datos. 
@Entonces se procede a convertirlo todo en un número. 

@Multiplicando la cifra de centenas por 100.

		mov r4,#100
		mul r1,r1,r4
		
@Las decenas por 10.
		
		mov r4,#10
		mul r2,r2,r4
		
@Las unidades se dejan tal y como están y se suma todo.
		add r1,r2
		add r1,r3
		
	pop {pc}

.global perimetro
perimetro:

@Calcula el perímetro del triángulo, sumando sus tres lados y devuelve resultado en R0
@Parámetros:
@r0: lado 1 
@r1: lado 2 
@r2: lado 3 
@Retorna:
@R0: perímetro 

	push {lr}
		add r0, r1
		add r0, r2
			
	pop {pc}
	
.global tipoTriangulo
tipoTriangulo:

@Encuentra qué tipo de triángulo es comparando sus tres lados. 
@Parámetros:
@r0: lado 1 
@r1: lado 2 
@r2: lado 3 

@Retorna:
@R0: entero que indica tipo de triángulo: 1 Equilátero (3 lados iguales), 2 Isósceles (2 lados iguales), 3 Escaleno (lados diferentes). 

@r3: registro intermedio de manejo de datos.

	push {lr}
	
@Compara lado 1 con lado 2. Si son iguales, puede ser equilátero. De no tener primeros dos lados iguales, puede ser iso1 o escaleno.
		cmp r0,r1
		beq equilatero
		b iso1
	
equilatero:

@Compara lado 1 con lado 3. Si son iguales, es equilátero. De no ser así, es iso2.
		cmp r0, r2
		moveq r3,#1
		beq salida
		b iso2

iso1:

@Compara lado 1 con lado 3. Si son iguales, es isóceles. De no serlo, los otros lados pueden ser iguales. Entonces salta a iso2.
		cmp r0,r2
		moveq r3,#2
		beq salida
		b iso2
		
@Compara lado 2 con lado 3. Si son iguales, entonces es isóceles. De no ser iguales, es escaleno.
iso2: 
		cmp r1,r2
		moveq r3, #2
		beq salida
		b escaleno

escaleno:

		mov r3,#3
		b salida
		
salida:

		mov r0, r3
			
	pop {pc}
	
