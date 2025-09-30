# Función correcta
def suma(a, b):
    return a + b

# Error: operador no válido
if a =? b:
    print("operador invalido")

# Error: número con letras
x = 123abc

# Error: float mal formado
y = 12.34.56

# Error: notación científica incompleta
z = 3e+

# Error: long mal formado
w = 123LL

# Error: imaginario mal formado
c = 5jj

# Error: string sin cerrar
texto1 = 'hola
texto2 = "mundo

# Error: identificador inválido
$dinero = 100

# Error: operador desconocido
res = 10 ?? 20

# Caso válido
print("fin de prueba", suma(2,3))
