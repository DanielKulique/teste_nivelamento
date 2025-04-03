from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import pandas as pd
import numpy as np
import json

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# validar POST
class BuscaRequest(BaseModel):
    termo: str

def clean_dataframe(df):
    return df.replace({np.nan: None})

try:
    df = pd.read_csv(
        'Relatorio_cadop.csv',
        delimiter=';',
        dtype={'CEP': str, 'DDD': str, 'Telefone': str},
        encoding='utf-8',
        on_bad_lines='skip'
    )
    df = clean_dataframe(df)
except Exception as e:
    print(f"Erro ao carregar CSV: {str(e)}")
    df = pd.DataFrame()

# requisicao GET - Usado no front
@app.get("/buscar")
async def buscar(termo: str):
    return buscar_operadora(termo)

# requisicao POST - Apenas para teste
@app.post("/buscar")
async def buscar_post(request: BuscaRequest):
    return buscar_operadora(request.termo)

# funcao de busca para operadoras
def buscar_operadora(termo: str):
    try:
        termo = termo.strip().lower()

        if not termo or len(termo) < 2:
            raise HTTPException(status_code=400, detail="O termo deve ter pelo menos 2 caracteres")

        resultado = df[
            df['Nome_Fantasia'].str.lower().str.contains(termo, case=False, na=False)
        ].head(50)

        resultado_clean = resultado.where(pd.notnull(resultado), None)

        return json.loads(resultado_clean.to_json(orient='records'))

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro na busca: {str(e)}")
