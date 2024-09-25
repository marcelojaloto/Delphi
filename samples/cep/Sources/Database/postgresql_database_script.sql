CREATE DATABASE cep
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

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