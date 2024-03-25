CREATE SCHEMA IF NOT EXISTS "instance";

CREATE  TABLE "instance".cliente ( 
	cli_id               integer  NOT NULL  ,
	cli_nome             varchar(255)    ,
	cli_contato          varchar(50)    ,
	cli_email            varchar(100)    ,
	cli_endereço_cep     varchar(20)    ,
	cli_endereço_estado  varchar(50)    ,
	cli_endereço_cidade  varchar(100)    ,
	cli_endereço_rua     varchar(255)    ,
	CONSTRAINT pk_cliente PRIMARY KEY ( cli_id )
 );

CREATE  TABLE "instance".pedido ( 
	ped_id               integer  NOT NULL  ,
	ped_datavenda        date    ,
	ped_status           varchar(50)    ,
	ped_cli_id           integer  NOT NULL  ,
	ped_total            numeric(10,2)    ,
	CONSTRAINT pk_pedido PRIMARY KEY ( ped_id, ped_cli_id ),
	CONSTRAINT fk_pedido_cliente FOREIGN KEY ( ped_cli_id ) REFERENCES "instance".cliente( cli_id )   
 );

CREATE UNIQUE INDEX unq_pedidoid ON "instance".pedido ( ped_id );

CREATE  TABLE "instance".produto ( 
	prod_id              integer  NOT NULL  ,
	prod_nome            varchar(255)    ,
	prod_tipo            varchar(50)    ,
	prod_preço           numeric(10,2)    ,
	prod_estoque_quantidade integer    ,
	prod_estoque_reposicao integer    ,
	CONSTRAINT pk_produto PRIMARY KEY ( prod_id )
 );

CREATE  TABLE "instance".itemdopedido ( 
	item_ped_id          integer  NOT NULL  ,
	item_prod_id         integer  NOT NULL  ,
	item_quantidade      integer    ,
	item_preçounitário   numeric(10,2)    ,
	CONSTRAINT pk PRIMARY KEY ( item_prod_id, item_ped_id ),
	CONSTRAINT fk_itemdopedido_pedido FOREIGN KEY ( item_ped_id ) REFERENCES "instance".pedido( ped_id )   ,
	CONSTRAINT fk_itemdopedido_produto FOREIGN KEY ( item_prod_id ) REFERENCES "instance".produto( prod_id )   
 );

CREATE  TABLE "instance".pagamento ( 
	pag_id               integer    ,
	pag_ped_id           integer  NOT NULL  ,
	pag_valor            numeric(10,2)    ,
	pag_datapagamento    date    ,
	pag_método           varchar(50)    ,
	CONSTRAINT pk_pagamento PRIMARY KEY ( pag_ped_id ),
	CONSTRAINT fk_pagamento_pedido FOREIGN KEY ( pag_ped_id ) REFERENCES "instance".pedido( ped_id )   
 );

COMMENT ON COLUMN "instance".pedido.ped_status IS 'Exemplo de valores: ''Pendente'', ''Concluído'', ''Cancelado''';

COMMENT ON COLUMN "instance".pedido.ped_cli_id IS 'Chave Estrangeira de Cliente';

COMMENT ON COLUMN "instance".produto.prod_tipo IS 'Exemplo de valores: ''Semente'', ''Manejo Químico''';

COMMENT ON COLUMN "instance".pagamento.pag_método IS 'Exemplo de valores: ''Dinheiro'', ''Cartão de Crédito'', ''Boleto''';
