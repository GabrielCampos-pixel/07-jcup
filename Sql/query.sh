#!/bin/bash

# Define o nome do arquivo de entrada da consulta
INPUT_FILE="entradaquery.txt"

# Limpa arquivos gerados anteriormente
echo "Limpando arquivos gerados..."
rm -f *.class *.java sym.java QueryParser.java QueryLexer.java
rm -f jcup.jar jflex.jar

# Baixa as ferramentas JFlex e CUP
echo "Baixando JFlex e CUP JARs..."
# Usa -O para salvar com os nomes simplificados jflex.jar e jcup.jar
wget -q https://repo1.maven.org/maven2/de/jflex/jflex/1.8.2/jflex-1.8.2.jar -O jflex.jar
wget -q https://repo1.maven.org/maven2/com/github/vbmacher/java-cup/11b-20160615/java-cup-11b-20160615.jar -O jcup.jar

echo "Gerando QueryLexer.java com JFlex..."
# AQUI ESTÁ A CHAVE: Certifique-se de usar -cp e jflex.Main
java -cp "jflex.jar:jcup.jar" jflex.Main QueryLexer.flex

echo "Gerando QueryParser.java e sym.java com CUP..."
# E AQUI: Certifique-se de usar -cp e java_cup.Main
java -cp jcup.jar java_cup.Main -parser MeuParser QueryParser.cup

echo "Compilando arquivos Java gerados..."
# Certifique-se de que o classpath está correto para o javac
javac -cp ".:jflex.jar:jcup.jar" *.java

echo -e "\n--- Executando analisador de Consulta ---"
java -cp ".:jflex.jar:jcup.jar" MeuParser "$INPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Análise de consulta concluída com sucesso."
else
    echo "Análise de consulta falhou."
fi