# 🧩 Analisador Léxico — Linguagem Tonto

Este projeto implementa um **analisador léxico** para a linguagem **Tonto**, desenvolvido em **C++** com o auxílio do **Flex (Fast Lexical Analyzer Generator)**.  
O analisador é responsável por ler um arquivo fonte (`.tonto`) e gerar como saída os **tokens** identificados, indicando seus tipos e lexemas.


## 🚀 Tecnologias Utilizadas

- **C++17**
- **Flex** (para geração automática do analisador léxico)
- **GNU Make** (opcional, para automação da compilação)
- **Linux / WSL / macOS** (recomendado)

## ⚙️ Instalação e Configuração

No **Debian/Ubuntu**:

```bash
sudo apt update
sudo apt install flex g++ make
``` 
## 🏗️ Compilação

Após a instalação da dependências, rode o seguinte comando:

```bash
make
```

## ▶️ Como Executar

Para rodar o analisador sobre um arquivo .tonto, use:

```bash
./lexer exemplos/car.tonto
```

## 🧪 Testes

Para testar com outros arquivos `.tonto`, basta adicioná-los na pasta `exemplos/` e executar:

```bash
./lexer exemplos/nome_arquivo.tonto
```


