# Teste Prático 
## _Relatório de vendas

## Introdução

 Esse arquivo tem como objetivo repassar as orientações e premissas básicas utilizadas na construção do teste prático de relatório de vendas.

## Tecnologias Utilizadas

Foram utilizadas as seguintes tecnologias no desenvolvimento

- [Delphi] - Versão 12.1 do Delphi Embarcadeiro Rad Studio
- [SQL Server] - SQL Server Management Studio 20 - SQL Server 22

É premissa ter configurado no Delphi a conexão ao database indicado no anexo do exercício.
Em arquivo anexo será enviado os scripts de criação do database e tabelas.

## Instalação

Primeiro é necessário ter configurado o sql server

- Criar um database local ou no servidor. Optei por criar um na minha máquina (localhost), apenas com WIndows Autentication.
- Criado o database, que chamei de database_vendas, criar as tabelas TAB_vendas e Tab_vendedores,e popular de acordo com o csv criado em anexo.
- A tabela vendedores possui nome e codigo do vendedor, conforme planilha. Ele tem chave estrangeira com a tabela vendas, que contém codigo do vendedor.
- Na hora de popular as tabelas, sustitui o nome do vendedor pelo código, para deixar o banco na forma normal.

Após isso, é necessário abrir o datamodule UDMRelatorioVendas e configurar o AdoConnection para refletir a conexão do database criado.
Clicar com o botão direito, em 'Edit ConnectionString', ir em 'Build' e colocar os parâmetros conforme foi criado no database do sql server.
Em anexo estão também as imagens das configurações desses pontos.

## Rodando

Após configuradas as bases, abrir o projeto RelatorioVendas.dproj, e compilar normalmente no Delphi. Para gerar o relatório, preencher os filtros e clicar em 'Gerar csv'. O programa gerará um arquivo chamado Relatorio.csv, no mesmo local onde está o executável.

## Observações

- COnforme comentado no código, não criei pdf, pois fiz esse teste no meu computador pessoal, onde tenho o Delphi 12 Trial instalado somente.Como nessa versão do Delphi não há componentes de relatório nativos, e não consegui baixar versões compatíveis do QuickReport, FastReport e etc, Estou desenvolvendo o relatório em CSV. Longe do ideal sim, e também não era o que foi solicitado, mas tomei essa decisao devido as limitações. Procurei seguir todos os outras solicitações, de agrupamento por vendedor e critério de pesquisa. Espero que não seja de todo perdido. Peço desculpas por não ter cumprido essa parte do teste, mas procurei entregar algo dentro das limitações.

- Em relação aos critérios de comissão, optei pelo simplificado, de 10%, pois considero mais tranquilo de ser implentado, considerando as restrições. Se necessário, posso enviar uma outra versão com os critérios conforme o vendedor que vendeu mais em um determinado período.
