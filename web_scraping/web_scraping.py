#pip install requests beautifulsoup4 

import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

# URL
url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"

# requisição HTTP
headers = {"User-Agent": "Mozilla/5.0"}
response = requests.get(url, headers=headers)

if response.status_code == 200:
    soup = BeautifulSoup(response.text, "html.parser")

    # buscando a referencia do link
    pdf_link = soup.find("a", href=lambda href: href and "Anexo_I" in href)

    if pdf_link:
        pdf_url = urljoin(url, pdf_link["href"])  

        # executa o download
        pdf_response = requests.get(pdf_url, headers=headers)

        if pdf_response.status_code == 200:
            with open("Anexo_I.pdf", "wb") as f:
                f.write(pdf_response.content)
            print("PDF baixado com sucesso:", pdf_url)
        else:
            print("Erro ao baixar o PDF")
    else:
        print("Link do PDF não encontrado!")
else:
    print("Erro ao acessar a página")