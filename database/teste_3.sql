CREATE DATABASE IF NOT EXISTS base_dados;

USE base_dados;

CREATE TABLE IF NOT EXISTS operadoras (
    registro_ans INT PRIMARY KEY,
    cnpj VARCHAR(14),
    razao_social VARCHAR(255),
    nome_fantasia VARCHAR(255),
    modalidade VARCHAR(50),
    logradouro VARCHAR(255),
    numero VARCHAR(50),
    complemento VARCHAR(255),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2),
    cep VARCHAR(10),
    ddd_telefone CHAR(2),
    telefone VARCHAR(20),
    fax VARCHAR(15),
    endereco_eletronico VARCHAR(255),
    representante VARCHAR(255),
    cargo_representante VARCHAR(255),
    regiao_comercializacao VARCHAR(255),
    data_registro_ans DATE
);

CREATE TABLE IF NOT EXISTS dados_contabeis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    registro_ans INT NOT NULL,
    cod_conta_contabil INT NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    vl_saldo_inicial DECIMAL(15,2) NOT NULL,
    vl_saldo_final DECIMAL(15,2) NOT NULL,
    data DATE NOT NULL,
    FOREIGN KEY (registro_ans) REFERENCES operadoras(registro_ans)
);

-- Importando dados da tabela operadoras
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Relatorio_cadop.csv'
INTO TABLE operadoras
FIELDS TERMINATED BY ';'  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS
(registro_ans, cnpj, razao_social, nome_fantasia, modalidade, logradouro, numero, complemento, 
bairro, cidade, uf, cep, ddd_telefone, telefone, fax, endereco_eletronico, representante, cargo_representante, regiao_comercializacao, data_registro_ans);

/*
-- Exibindo dados da tabela operadoras
DESC operadoras;
SELECT * FROM operadoras;
*/

SET FOREIGN_KEY_CHECKS = 0; #ha empresas nao registradas

-- Importando dados para dados_contabeis
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/1T2023.csv'
INTO TABLE dados_contabeis
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(data, registro_ans, cod_conta_contabil, descricao, @vl_saldo_inicial, @vl_saldo_final)
SET
  vl_saldo_inicial = CAST(REPLACE(@vl_saldo_inicial, ',', '.') AS DECIMAL(15, 2)),
  vl_saldo_final = CAST(REPLACE(@vl_saldo_final, ',', '.') AS DECIMAL(15, 2));

-- Importando dados para dados_contabeis do segundo arquivo
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2t2023.csv' 
INTO TABLE dados_contabeis 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(data, registro_ans, cod_conta_contabil, descricao, @vl_saldo_inicial, @vl_saldo_final) 
SET 
  vl_saldo_inicial = CAST(REPLACE(@vl_saldo_inicial, ',', '.') AS DECIMAL(15, 2)),
  vl_saldo_final = CAST(REPLACE(@vl_saldo_final, ',', '.') AS DECIMAL(15, 2));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/3T2023.csv' 
INTO TABLE dados_contabeis 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(data, registro_ans, cod_conta_contabil, descricao, @vl_saldo_inicial, @vl_saldo_final) 
SET 
  vl_saldo_inicial = CAST(REPLACE(@vl_saldo_inicial, ',', '.') AS DECIMAL(15, 2)),
  vl_saldo_final = CAST(REPLACE(@vl_saldo_final, ',', '.') AS DECIMAL(15, 2));
  
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/4T2023.csv' 
INTO TABLE dados_contabeis
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@data_str, registro_ans, cod_conta_contabil, descricao, @vl_saldo_inicial, @vl_saldo_final)
SET
  data = STR_TO_DATE(@data_str, '%d/%m/%Y'),
  vl_saldo_inicial = CAST(REPLACE(@vl_saldo_inicial, ',', '.') AS DECIMAL(15,2)),
  vl_saldo_final = CAST(REPLACE(@vl_saldo_final, ',', '.') AS DECIMAL(15,2));

/*
É necessário desativar update safemode para apagar empresas sem registro 
-- apagar registros orfaos(sem foreign key) 
DELETE FROM dados_contabeis
WHERE registro_ans IS NOT NULL
AND registro_ans NOT IN (SELECT registro_ans FROM operadoras);
*/

/*
-- Exibindo os dados da tabela operadoras - OPCIONAL
SELECT * FROM operadoras;
SELECT COUNT(*) AS Total_op FROM operadoras;
-- Exibindo os dados da tabela dados_contabeis
SELECT * FROM dados_contabeis;
SELECT COUNT(*) AS total_registros FROM dados_contabeis;
SELECT * FROM dados_contabeis WHERE descricao LIKE '%EVENTOS/%SINISTROS CONHECIDOS%ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%';
*/

#ultimos 3 meses
SELECT 
    o.razao_social AS operadora,
    o.registro_ans,
    SUM(d.VL_SALDO_FINAL) AS total_despesas,
    COUNT(d.COD_CONTA_CONTABIL) AS quantidade_registros
FROM 
    dados_contabeis d
JOIN 
    operadoras o ON d.REGISTRO_ANS = o.registro_ans
WHERE 
    d.DESCRICAO = '%EVENTOS/%SINISTROS CONHECIDOS%ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%'
    AND d.DATA >= DATE_SUB(
        (SELECT MAX(DATA) FROM dados_contabeis), 
        INTERVAL 3 MONTH
    )
GROUP BY 
    o.razao_social, o.registro_ans
ORDER BY 
    total_despesas DESC
LIMIT 10;

-- Verifica se existem dados no período filtrado (Todos os Anos)
SELECT 
    o.razao_social,
    SUM(d.VL_SALDO_FINAL) AS total_despesas
FROM 
    dados_contabeis d
JOIN 
    operadoras o ON d.REGISTRO_ANS = o.registro_ans
WHERE 
    d.DESCRICAO LIKE '%SINISTROS CONHECIDOS%ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%'
GROUP BY 
    o.razao_social
ORDER BY 
    total_despesas DESC
LIMIT 10;

