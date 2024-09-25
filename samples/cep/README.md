## Buscador de CEP e Endereço de Localidades do Brasil

Este exemplo tem por objetivo principal criar um componente Delphi 12.1 CE (Firemonkey/FMX) para realizar integração com a API pública ViaCEP e realizar buscas por CEP ou por endereço para obter os dados de um endereço completo de localidade do Brasil.

![image](https://github.com/user-attachments/assets/fd799d2c-749f-48b7-bfc8-bc53ca3d9a1e)


[![PayPal donate button](https://user-images.githubusercontent.com/26885358/62580349-60bd8780-b87c-11e9-901e-425cf2a83671.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=AW8TZ2QTDA7K8)

## Contatos:

E-mail: [**marcelojaloto@gmail.com**](mailto:marcelojaloto@gmail.com) 
Linkedin: [**https://www.linkedin.com/in/marcelojaloto**](https://www.linkedin.com/in/marcelojaloto/) 

## Requisitos técnicos:

1. Possibilitar armazenar os resultados das consultas em uma tabela no banco de dados Postgre SQL;
2. Possibilitar que as consultas possam ser feitas tanto por CEP quanto por Endereço Completo;
3. Permitir navegar através dos registros já inseridos, e caso seja feita a consulta de um CEP ou Endereço que já exista cadastrado, deverá perguntar ao usuário se deseja atualizar os dados encontrados;
4. O layout foi desenvolvido com Delphi (FMX) com tema escuro;
5. Utilização de Clean Code;
6. Utilização de SOLID;
7. Utilização de Programação Orientada a Objetos;
8. Serialização e desserialização de objetos JSON e XML;
9. Utilização de Interfaces;
10. Aplicação de Patterns MVC, padrões de projeto (GoF);
11. Criação de Componentes Delphi FMX;
12. Plataforma 64bits.

## API ViaCEP

Acesse: [**viacep.com.br**](https://viacep.com.br/) 

## Instalação

a) Criação do banco de dados PostgreSQL :

- Baixe o PostgreSQL no endereço abaixo para a versão 16.2 Windows 64 bits:
  
https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

Or directly at the address below:

https://sbp.enterprisedb.com/getfile.jsp?fileid=1258893

- Configure PostgreSQL:
```
- Server - localhost
- Port = 5432
- Username = postgres
- Password = postgres
```

- Crie um banco de dados com o nome "cep"
```
CREATE DATABASE cep
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
```

- Em seguida, execute o script abaixo no banco de dados "cep":
```
CREATE TABLE public.enderecos
(
    codigo uuid NOT NULL,
    cep character varying(8) NOT NULL,
    logradouro character varying(100) NOT NULL,
    complemento character varying(100),
    bairro character varying(100),
    localidade character varying(100) NOT NULL,
    uf character varying(2) NOT NULL,
    PRIMARY KEY (codigo),
    CONSTRAINT idx_unique_cep UNIQUE (cep)
);

ALTER TABLE IF EXISTS public.enderecos
    OWNER to postgres;
```

b) Confira se está na pasta de deploy as DLLs necessárias para acesso ao banco de dados Postgre SQL

- \Output\Deploy\Win64\postgresql\lib

![image](https://github.com/user-attachments/assets/b5c8cec8-c383-4735-8892-dd43cf1c45b3)

	
c) Confira se está na pasta de deploy as DLLs necessárias para uso do protocolo SSL	

- .\Output\Deploy\Win64\

```
libeay32.dll
ssleay32.dll
```
	
d) Instalação do componente TCEP

- Abra o Delphi e carregue o grupo de projeto CEP_GrupoProjeto.groupproj;
- Execute um build no pacote runtime Jaloto_CEP_ComponenteRT;
- Execute um build no pacote desingtime Jaloto_CEP_ComponenteDT e depois instale o componente;
- Execute um build no projeto JalotoBuscadorCEP.
