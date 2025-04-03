Conversão de PDF para CSV

Este script Python converte tabelas de um arquivo PDF em um arquivo CSV e compacta o resultado em um arquivo ZIP.

O script:
Lê um arquivo PDF (Anexo_I.pdf) e extrai tabelas das páginas 3 a 181 usando tabula.
Concatena todas as tabelas extraídas em um único DataFrame do pandas.
Renomeia as colunas da tabela extraída para um formato padronizado.
Salva os dados convertidos em um arquivo CSV (tabela_convertida.csv).
Compacta o arquivo CSV em um arquivo ZIP (Teste_Daniel_Kulique.zip)

bash - #pip install pandas tabula-py
bash - python script.py
