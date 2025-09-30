# Python Subset Lexical Analyzer (Flex)  
This project is a **lexical analyzer written in Flex** for a simplified subset of Python. It recognizes keywords, identifiers, literals, operators, and symbols, while reporting malformed tokens as **lexical errors** with line and column information.  

## Requirements  
Ubuntu with `flex` and `gcc` installed:  
```bash
sudo apt update && sudo apt install flex gcc
```

## Build
```bash
flex analizador.l
gcc lex.yy.c -o analizador -lfl
```


## Run

```bash
./analizador [nombre de archivo].py
```



## Example

### Input
```python
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
```

### output
```txt
DEF ID1=suma PARABRE ID2=a COMA ID3=b PARCIERR DOSPUNTOS RETURN ID2=a OP_PLUS ID3=b IF ID2=a ASSIGN 
    ERROR (linea 11, col 7): ?
ID3=b DOSPUNTOS PRINT PARABRE STRING="operador invalido" PARCIERR ID4=x ASSIGN 
    ERROR (linea 19, col 5): 123abc
ID5=y ASSIGN 
    ERROR (linea 25, col 5): 12.34.56
ID6=z ASSIGN 
    ERROR (linea 31, col 5): 3e+
ID7=w ASSIGN 
    ERROR (linea 37, col 5): 123LL
ID8=c ASSIGN 
    ERROR (linea 43, col 5): 5jj
ID9=texto1 ASSIGN 
    ERROR (linea 49, col 10): string no cerrado
ID10=texto2 ASSIGN 
    ERROR (linea 51, col 10): string no cerrado

    ERROR (linea 57, col 1): $
ID11=dinero ASSIGN FLOAT=100 ID12=res ASSIGN FLOAT=10 
    ERROR (linea 63, col 10): operador desconocido ??
FLOAT=20 PRINT PARABRE STRING="fin de prueba" COMA ID1=suma PARABRE FLOAT=2 COMA FLOAT=3 PARCIERR PARCIERR 

--- Identificadores encontrados ---
Id1=suma
Id2=a
Id3=b
Id4=x
Id5=y
Id6=z
Id7=w
Id8=c
Id9=texto1
Id10=texto2
Id11=dinero
Id12=res

Total errores léxicos: 10
```
