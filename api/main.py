from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd
import numpy as np
import json

app = FastAPI()

# Configurar CORS para permitir requisiçoes de outro dominio 
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Limpar cedulas vazias
def clean_dataframe(df):
    return df.replace({np.nan: None})  # Ou substitua por '' se preferir strings vazias

# Carregar o CSV com tratamento adequado
try:
    df = pd.read_csv(
        'Relatorio_cadop.csv',
        delimiter=';',
        dtype={'CEP': str, 'DDD': str, 'Telefone': str},
        encoding='utf-8',
        on_bad_lines='skip'
    )
    # Limpar os dados
    df = clean_dataframe(df)
except Exception as e:
    print(f"Erro ao carregar CSV: {str(e)}")
    df = pd.DataFrame()  # DataFrame vazio em caso de erro

@app.get("/buscar")
async def buscar(termo: str):
    try:
        termo = termo.strip().lower()
        
        if not termo or len(termo) < 2:
            return {"error": "O termo deve ter pelo menos 2 caracteres"}
        
        # Filtrar e limpar resultados
        resultado = df[
            df['Nome_Fantasia'].str.lower().str.contains(termo, case=False, na=False)
        ].head(50)
        
        # Converter NaN para None antes da serialização JSON
        resultado_clean = resultado.where(pd.notnull(resultado), None)
        
        return json.loads(resultado_clean.to_json(orient='records'))
        
    except Exception as e:
        return {"error": f"Erro na busca: {str(e)}"}