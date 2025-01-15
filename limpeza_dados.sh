#!/bin/bash

# Diretório contendo os arquivos FASTQ
FASTQ_DIR="caminho/para/diretorio_fastq"
# Diretório para salvar os resultados da limpeza
OUTPUT_DIR="caminho/para/diretorio_output"

# Cria o diretório de saída, se não existir
mkdir -p $OUTPUT_DIR

# Loop sobre cada arquivo FASTQ no diretório
for file in $FASTQ_DIR/*.fastq; do
    # Obtem o nome base do arquivo (sem extensão) para nomear os arquivos de saída
    base_name=$(basename "$file" .fastq)
    
    echo "Processando $base_name..."

    # Avaliação de qualidade das leituras com FastQC
    fastqc $file -o $OUTPUT_DIR

    # Limpeza e corte de sequências de baixa qualidade com Trim Galore
    trim_galore --fastqc -q 25 --trim-n --max_n 0 -j 1 --length 18 --dont_gzip --output_dir $OUTPUT_DIR $file

    # Convertendo FASTQ para FASTA com seqtk
    seqtk seq -a $file > $OUTPUT_DIR/"$base_name".fasta

    echo "Processamento de $base_name concluído."
done

echo "Limpeza de dados concluída para todos os arquivos."
