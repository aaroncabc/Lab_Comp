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
