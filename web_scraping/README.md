# Scraper de PDF da ANS

Este script Python faz o download do arquivo PDF "Anexo I" disponível na página da Agência Nacional de Saúde Suplementar (ANS) sobre a atualização do rol de procedimentos.

Acessa a página da ANS utilizando requests.
Utiliza BeautifulSoup para analisar o HTML e encontrar o link do PDF.
Faz o download do arquivo e o salva localmente como Anexo_I.pdf.

bash #pip install requests beautifulsoup4
bash - python script.py
