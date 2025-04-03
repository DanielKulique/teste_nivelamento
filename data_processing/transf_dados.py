import csv
import pandas as pd
import tabula
import zipfile

# funcao para converter para dados para pdf
def pdf_convert(pdf_path):
    tables = tabula.read_pdf(pdf_path, pages="3-181", lattice=True)
    dataframe_combined = pd.DataFrame()

    for table in tables:
        df = table.copy()
        dataframe_combined = pd.concat([dataframe_combined, df], ignore_index=True)

    return dataframe_combined

path_pdf = 'Anexo_I.pdf'

dataframe = pdf_convert(path_pdf)

# alterando colunas
dataframe.columns = [
    "PROCEDIMENTO", "RN (alteração)", "VIGÊNCIA", "SEGURANÇA ODONTOLÓGICA", 
    "SEGURANÇA AMBULATORIAL", "HCO", "HSO", "REF", "PAC", "DUT", 
    "SUBGRUPO", "GRUPO", "CAPÍTULO"
]

# ajustar csv
csv_file = 'tabela_convertida.csv'
dataframe.to_csv(
    csv_file,
    index=False,
    sep=';',          
    encoding='utf-8-sig',  
    quotechar='"',     
    quoting=csv.QUOTE_NONNUMERIC 
)

# Compactando
with zipfile.ZipFile('Teste_Daniel_Kulique.zip', 'w', zipfile.ZIP_DEFLATED) as zipf:
    zipf.write(csv_file)