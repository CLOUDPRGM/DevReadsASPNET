-- Criação do banco de dados 'db_DevReads'
create database db_DevReads;

-- Seleciona o banco de dados 'db_DevReads' para uso
use db_DevReads;

-- Tabela para armazenar informações dos clientes
create table tbCliente(
    id int primary key auto_increment, -- Identificador único do cliente (auto incremento)
    NomeCli varchar(200) not null, -- Nome do cliente
    EmailCli varchar(60) not null, -- E-mail do cliente
    SenhaCli varchar(40) not null, -- Senha do cliente
    NivelAcesso bool not null -- Nível de acesso (true ou false, para indicar admin ou cliente)
);

-- Tabela para armazenar categorias de livros
create table tbCategoria(
    IdCategoria int primary key auto_increment, -- Identificador único da categoria (auto incremento)
    NomeCategoria varchar(255) not null -- Nome da categoria de livros
);

-- Tabela para armazenar informações sobre editoras
create table tbEditora(
    idEdi int primary key auto_increment, -- Identificador único da editora (auto incremento)
    NomeEdi varchar(100) not null -- Nome da editora
);

-- Tabela redundante para editar informações sobre editoras com mais detalhes (não está em uso)
create table tbEditora2(
    idEdi int primary key auto_increment, -- Identificador único da editora (auto incremento)
    CNPJ decimal (14,0) unique not null, -- Cadastro Nacional da Pessoa Jurídica (único)
    NomeEdi varchar(100) not null, -- Nome da editora
    TelEdi int not null -- Número de telefone da editora
);

-- Tabela para armazenar informações sobre notas fiscais
create table tbNotaFiscal(
    NF int primary key, -- Número da nota fiscal (chave primária)
    TotalNota decimal(8,2) not null, -- Total da nota fiscal
    DataEmissao date not null -- Data de emissão da nota fiscal
);

-- Tabela para armazenar informações sobre os livros
create table tbLivro(
    IdLiv int primary key auto_increment, -- Identificador único do livro (auto incremento)
    ISBN decimal(13,0) not null, -- Código ISBN do livro
    NomeLiv varchar(150) not null, -- Nome do livro
    PrecoLiv decimal(6,2) not null, -- Preço do livro
    DescLiv varchar(250) not null, -- Descrição do livro
    ImgLiv varchar(255) not null, -- Caminho para a imagem da capa do livro
    IdCategoria int not null, -- Chave estrangeira para a tabela tbCategoria
    IdEdi int not null, -- Chave estrangeira para a tabela tbEditora
    Autor varchar(100) not null, -- Nome do autor do livro
    DataPubli date not null, -- Data de publicação do livro
    EspecialLiv enum('P','S','O','D','N') not null, -- Tipo especial do livro (promoção, estoque, etc.)
    NoCarrinho bool not null, -- Booleano indicando se o livro está no carrinho
    constraint FK_Id_Edi foreign key(idEdi) references tbEditora(idEdi) -- Chave estrangeira para a editora
);

-- Criação da visão (view) para juntar informações dos livros, categorias e editoras
create view vw_Livro 
as 
select 
    tbLivro.IdLiv, -- ID do livro
    tbLivro.ISBN, -- ISBN do livro
    tbLivro.NomeLiv, -- Nome do livro
    tbLivro.PrecoLiv, -- Preço do livro
    tbLivro.DescLiv, -- Descrição do livro
    tbLivro.ImgLiv, -- Imagem da capa do livro
    tbLivro.IdCategoria, -- ID da categoria
    tbCategoria.NomeCategoria, -- Nome da categoria
    tbLivro.IdEdi, -- ID da editora
    tbEditora.NomeEdi, -- Nome da editora
    tbLivro.Autor, -- Autor do livro
    tbLivro.DataPubli, -- Data de publicação do livro
    tbLivro.EspecialLiv, -- Tipo especial do livro
    tbLivro.NoCarrinho -- Indicador se o livro está no carrinho
from tbLivro 
inner join tbEditora
    on tbLivro.IdEdi = tbEditora.IdEdi
inner join tbCategoria
    on tbLivro.IdCategoria = tbCategoria.IdCategoria;

-- Tabela para armazenar os itens do carrinho de compras
create table tbCarrinho(
    idCarrinho int primary key auto_increment, -- Identificador único do carrinho (auto incremento)
    id int not null, -- Chave estrangeira para o cliente (usuário)
    IdLiv int not null, -- Chave estrangeira para o livro
    constraint fk_Carrinho_Cliente foreign key (id) references tbCliente(id), -- Relacionamento com a tabela tbCliente
    constraint fk_Carrinho_Livro foreign key (IdLiv) references tbLivro(IdLiv) -- Relacionamento com a tabela tbLivro
);

-- Tabela para armazenar informações sobre as compras realizadas pelos clientes
create table tbCompra( 
    NumeroCompra int primary key, -- Número da compra (chave primária, também serve como chave estrangeira para nota fiscal)
    DataCompra date not null, -- Data da compra
    TotalCompra decimal(8,2) not null, -- Total da compra
    FormPag varchar(100) not null, -- Forma de pagamento (cartão, boleto, etc.)
    id_Cli int not null, -- Chave estrangeira para o cliente que realizou a compra
    NF int not null, -- Chave estrangeira para a nota fiscal associada à compra
    constraint FK_Id_Compra foreign key(Id_cli) references tbCliente(id), -- Relacionamento com a tabela tbCliente
    constraint fk_NF foreign key(NF) references tbNotaFiscal(NF) -- Relacionamento com a tabela tbNotaFiscal
);

-- Tabela para armazenar os itens comprados em cada compra
create table tbItemCompra(
    NumeroCompra int not null, -- Chave estrangeira para a tabela tbCompra
    IdLiv int not null, -- Chave estrangeira para a tabela tbLivro
    ValorItem decimal (8,2) not null, -- Valor do item
    Qtd int not null, -- Quantidade do item
    constraint primary key(NumeroCompra, IdLiv), -- Chave primária composta por NumeroCompra e IdLiv
    constraint FK_NumeroCompra foreign key(NumeroCompra) references tbCompra(NumeroCompra), -- Relacionamento com a tabela tbCompra
    constraint FK_ISBN_C foreign key(IdLiv) references tbLivro(IdLiv) -- Relacionamento com a tabela tbLivro
);

-- Tabela para armazenar informações sobre as vendas
create table tbVenda(
    NumeroVenda int primary key, -- Número da venda (chave primária)
    DataVenda date not null, -- Data da venda
    ValorTotal decimal(8,2) not null, -- Valor total da venda
    QtdTotal int not null, -- Quantidade total de itens vendidos
    idEdi int not null, -- Chave estrangeira para a tabela tbEditora
    constraint fk_idEdi foreign key(idEdi) references tbEditora(idEdi) -- Relacionamento com a tabela tbEditora
);

-- Tabela para armazenar os itens vendidos em cada venda
create table tbItemVenda(
    NumeroVenda int not null, -- Chave estrangeira para a tabela tbVenda
    IdLiv int not null, -- Chave estrangeira para a tabela tbLivro
    ValorItem decimal(8,2) not null, -- Valor do item vendido
    Qtd int not null, -- Quantidade do item vendido
    constraint PK_NV_ISBN primary key(NumeroVenda, IdLiv), -- Chave primária composta por NumeroVenda e IdLiv
    constraint FK_NumeroVenda foreign key(NumeroVenda) references tbVenda(NumeroVenda), -- Relacionamento com a tabela tbVenda
    constraint FK_ISBN foreign key(IdLiv) references tbLivro(IdLiv) -- Relacionamento com a tabela tbLivro
);

-- OBS: OS INSERT NO BANCO SÃO POUCOS POIS NO SISTEMA PODE SER FEITA A INSERÇÃO DOS MESMOS --

-- PROCEDURES ----------------------------------------------------------------------------------


                 
-- Procedure para inserir clientes
delimiter $$ 
create procedure spInsertCliente(
    vNomeCli varchar(200), -- Nome do cliente
    vEmailCli varchar(50), -- E-mail do cliente
    vSenhaCli varchar(50), -- Senha do cliente
    vNivelAcesso bool -- Nível de acesso (true para admin, false para usuário)
)
begin
    -- Verifica se o cliente já existe antes de inserir
    if not exists (select Id from tbCliente where NomeCli = vNomeCli) then
        insert into tbCliente(NomeCli, EmailCli, SenhaCli, NivelAcesso)
        values(vNomeCli, vEmailCli, vSenhaCli, vNivelAcesso);
    else
        select "Já tem"; -- Retorna mensagem caso o cliente já exista
    end if;
end $$

-- Inserções manuais de exemplo na tabela tbCliente
insert into tbCliente(NomeCli, EmailCli, SenhaCli, NivelAcesso)
values('Niko', 'nikoolhate@gmail.com', 123456, true);

insert into tbCliente(NomeCli, EmailCli, SenhaCli, NivelAcesso)
values('Lucy', 'Luci@gmail.com', 123777, true);

-- Atualização do nível de acesso do cliente com id 2
update tbCliente set NivelAcesso = false where id = 2;

-- Chamadas da procedure para inserir novos clientes
call spInsertCliente('Luciano', 'Luciano@gmail.com', 132457, false);
call spInsertCliente('Edu bolanhos', 'Edu@gmail.com', 345678, false);

-- CATEGORIAS ----------------------------------------------------------------------------------

-- Procedure para inserir categorias de livros
delimiter $$ 
create procedure spInsertCategoria(vNomeCategoria varchar(255))
begin
    -- Verifica se a categoria já existe antes de inserir
    if not exists (select IdCategoria from tbCategoria where NomeCategoria = vNomeCategoria) then
        insert into tbCategoria(NomeCategoria)
        values(vNomeCategoria);
    else
        select "Já tem"; -- Retorna mensagem caso a categoria já exista
    end if;
end $$

-- Chamadas da procedure para inserir categorias
call spInsertCategoria('Inteligência Artificial e Machine Learning');
call spInsertCategoria('FrontEnd');

-- EDITORA -------------------------------------------------------------------------------------

-- Procedure para inserir editoras na tabela tbEditora2
delimiter $$ 
create procedure spInsertEditora2(
    vCNPJ decimal(14,0), -- CNPJ da editora
    vNomeEdi varchar(50), -- Nome da editora
    vTelEdi varchar(100) -- Telefone da editora
)
begin
    -- Verifica se a editora já existe antes de inserir
    if not exists (select CNPJ from tbEditora2 where CNPJ = vCNPJ) then
        insert into tbEditora2(CNPJ, NomeEdi, TelEdi)
        values(vCNPJ, vNomeEdi, vTelEdi);
    else
        select "Já tem"; -- Retorna mensagem caso a editora já exista
    end if;
end $$

-- Chamadas da procedure para inserir editoras
call spInsertEditora2 (04713695000452, 'Alta Books', 987654321);
call spInsertEditora2 (23308850000157, 'Érica', 888997767);
call spInsertEditora2 (08693550000145, 'Visual Books', 991733583);
call spInsertEditora2 (03032435000106, 'Matrix Editora', 38682863);

-- LIVROS - ATUALIZAÇÃO -----------------------------------------------------------------------

-- Procedure para atualizar informações de um livro
delimiter $$ 
create procedure spUpdateLivro(
    vISBN decimal(13,0), -- ISBN do livro
    vNomeLiv varchar(100), -- Nome do livro
    vPrecoLiv decimal(6,2), -- Preço do livro
    vDescLiv varchar(250), -- Descrição do livro
    vImgLiv varchar(200), -- Caminho da imagem do livro
    vNomeCategoria varchar(255), -- Nome da categoria do livro
    vNomeEdi varchar(100), -- Nome da editora do livro
    vAutor varchar(50), -- Nome do autor do livro
    vDataPubli char(20), -- Data de publicação
    vNoCarrinho bool, -- Indica se o livro está no carrinho
    vEspecialLiv enum('P','S','O','D','N') -- Classificação especial do livro
)
begin
    -- Verifica se o livro existe antes de atualizar
    if exists (select IdLiv from tbLivro where ISBN = vISBN) then
        update tbLivro
        set ISBN = vISBN, NomeLiv = vNomeLiv, PrecoLiv = vPrecoLiv, DescLiv = vDescLiv, ImgLiv = vImgLiv,
            IdCategoria = (select IdCategoria from tbCategoria where NomeCategoria = vNomeCategoria),
            IdEdi = (select IdEdi from tbEditora where NomeEdi = vNomeEdi),
            Autor = vAutor, DataPubli = str_to_date(vDataPubli, '%d/%m/%Y'), 
            NoCarrinho = vNoCarrinho, EspecialLiv = vEspecialLiv
        where ISBN = vISBN;
    else
        select "Update não realizado" as Aviso; -- Mensagem caso o livro não exista
    end if;
end $$

-- LIVROS - INSERÇÃO -----------------------------------------------------------------------

-- Procedure para inserir informações de um livro
delimiter $$                  
create procedure spInsertLivro(
    vISBN decimal(13,0), -- ISBN do livro (chave única para identificação)
    vNomeLiv varchar(100), -- Nome do livro
    vPrecoLiv decimal(6,2), -- Preço do livro
    vDescLiv varchar(250), -- Descrição do livro
    vImgLiv varchar(200), -- Caminho para a imagem do livro
    vNomeCategoria Varchar(255), -- Nome da categoria do livro
    vNomeEdi varchar(100), -- Nome da editora do livro
    vAutor varchar(50), -- Nome do autor do livro
    vDataPubli char(20), -- Data de publicação no formato texto
    vEspecialLiv enum('P','S','O','D','N'), -- Classificação especial do livro
    vNoCarrinho bool -- Indica se o livro está no carrinho (true ou false)
)
begin
    -- Verifica se a editora existe, caso contrário, insere uma nova
    if not exists (select IdEdi from tbEditora where NomeEdi = vNomeEdi) then
        insert into tbEditora(NomeEdi) values (vNomeEdi);
    end if;               

    -- Verifica se a categoria existe, caso contrário, insere uma nova
    if not exists (select IdCategoria from tbCategoria where NomeCategoria = vNomeCategoria) then
        insert into tbCategoria(NomeCategoria) values(vNomeCategoria);
    end if;

    -- Verifica se o livro existe, caso contrário, insere o novo livro
    if not exists (select ISBN from tbLivro where ISBN = vISBN) then
        insert into tbLivro(
            ISBN, NomeLiv, PrecoLiv, DescLiv, ImgLiv, IdCategoria, idEdi, Autor, DataPubli, EspecialLiv, NoCarrinho
        )
        values(
            vISBN, vNomeLiv, vPrecoLiv, vDescLiv, vImgLiv, 
            (select IdCategoria from tbCategoria where NomeCategoria = vNomeCategoria), 
            (select idEdi from tbEditora where NomeEdi = vNomeEdi), vAutor, 
            str_to_date(vDataPubli, '%d/%m/%Y'), vEspecialLiv, vNoCarrinho
        );
    else
        -- Retorna mensagem indicando que o livro já existe
        select "O livro já existe!" as Aviso;
    end if;
end $$

-- PEGAR AS IMAGENS PARA PASTA IMG COM A EXTENSÃO DE PNG/COMENTAR O RESTO DO CÓDIGO -> Ver amanhã (12/12/24)

-- 1 -----
call spInsertLivro(9788535262128, 'Como Criar Uma Mente', 32.00,
 'Conhecimento da tecnologia para com a mente humana','comocriar.png',
 'Inteligência Artificial e Machine Learning', 'Companhia das Letras', 'Ray Kurzweil', '13/11/2013', 'N', false);
-- 2 -----
call spInsertLivro(9788576082675, 'Código Limpo: Habilidades Práticas do Agile Software', 42.00,
'Habilidades da codificação de software','codigolimpo.png', 
'FrontEnd', 'Alta Books', 'Robert Cecil Martin', '01/08/2008', 'N', false);
-- 3 -----
call spInsertLivro(9788535248740, 'Projetos e Implementação de Redes: Fundamentos, Soluções, Arquiteturas e Planejamento', 65.00,
'Esta publicação apresenta conceitos iniciais e avançados sobre redes de computador, com exemplos práticos e estudo de soluções', 'projetoseimplementacao.png', 
'Redes e Infraestrutura ', 'Érica', 'Edmundo Antonio Pucci', '30/07/2010', 'N', false);
-- 4 -----
call spInsertLivro(9788574526102, 'Manual de Produção de Jogos Digitais', 90.00, 
'São apresentados tópicos gerais como: pré-produção, testes e liberação do código, bem como tópicos específicos como: gravações de voiceover e motioncapture, tradução e localização e fornecedores externos.', 'manualdeproducao.png', 'Programação e Desenvolvimento de Software', 
'Visual Books', 'Adriano Hazenauer', '01/01/2012', 'N', false);
-- 5 -----
call spInsertLivro(9788550802320, 'Inteligência Artificial na Sala de Aula: Como a Tecnologia Está Revolucionando a Educação', 40.00, 
'Qual é o impacto da Inteligência Artificial na educação? Ao embarcar neste livro, que responde a essas perguntas, lembre-se de que a integração da Inteligência Artificial na educação é uma jornada, não um destino.', 'inteligenciaartificial.png', 
'Inteligência Artificial e Machine Learning','Matrix Editora', 'Leo Fraiman', '25/06/2024', 'N', false);
-- 6 -----
call spInsertLivro(9788545207481, 'A Guerra das Inteligências na Era do ChatGPT', 75.00, 
'O ChatGPT está na origem de uma virada fundamental de nossa História. Seu fundador, Sam Altman, quer criar uma Superinteligência Artificial para competir com nossos cérebros, mesmo que isso signifique uma perigosa corrida mundial.', 'guerradasinteligencias.png', 
'Inteligência Artificial e Machine Learning ', 'Editora Gente', 'Renato de Castro', '17/05/2024', 'N', false);  
-- 7 -----
call spInsertLivro(9788597004087, 'O Verdadeiro Valor do TI ', 90.00 , 
'Como Transformar TI de um Centro de Custos em um Centro de Valor e Competitividade Se esta parece ser a situação na sua empresa, considere este livro como um chamado para despertar para a vida.', 'overdadeirovalor.png', 
'Gestão de TI', 'Alta Books', 'Mark Schwartz', '01/01/2019', 'N', false);
-- 8 -----
call spInsertLivro(9788599593196, 'Redes, Guia Prático, de Carlos Morimoto', 70.00, 
'O livro Redes e Servidores Linux, Guia Prático o primeiro best-seller do Carlos Morimoto, vendendo um total de 8.000 exemplares em suas duas edições.', 'redes.png', 
'Redes e Infraestrutura', 'Sulina', 'Carlos E. Morimoto', '01/01/2011', 'P', false);
 -- 9 -----
call spInsertLivro(9788577805310, 'Design de Navegação Web: Otimizando a Experiência do Usuário', 75.00,
'Este livro trata das principais ferramentas de design de navegação', 'designdenavegacao.png',
'visual Books', 'Bookman',  'James kalbach', '01/01/2009', 'N', false);
 -- 10 -----
call spInsertLivro(9788502082045,'Um bate-papo sobre T.I.: Tudo que você gostaria de saber sobre ERP e tecnologia da informação', 25.00, 
'Um bate-papo sobre T.I. mostrará ao leitor, de maneira leve e bem humorada, a evolução rápida e constante da Tecnologia da Informação e o quanto ela pode ajudar pessoas, e principalmente empresas, a serem mais eficientes e eficazes', 'umbatepapo.png', 
'Gestão de TI', 'Saraiva Uni', 'Ernesto Mario Haberkorn', '29/11/2012', 'P', false);
 -- 11 ----- 
call spInsertLivro(9788543108704, 'O poder dos quietos: Como os tímidos e introvertidos podem mudar um mundo que não para de falar', 40.00, 
'O poder dos quietos já vendeu mais de 3 milhões  de exemplares no mundo todo, foi traduzido para 41 idiomas e passou quatro anos na lista de mais vendidos do The New York Times .', 'opoderdosquietos.png', 
'Gestão de TI', 'Editora Sextante', 'Susan Cain', '02/10/2019', 'P', false);
 -- 12 ----- 
call spInsertlivro(9788576084730, 'Use a Cabeça!: Programação', 85.00, 
'Alguma vez você desejou aprender a programar com um livro? Se você não tem nenhuma experiência em programação, pode estar imaginando por onde começar.', 'useacabeçaprogramacao.png', 
'Gestão de TI', 'Alta Books', 'Paul Barry', '18/08/2009', 'P', false);
 -- 13 ----- 
 call spInsertlivro(9788550819884, 'Use a Cabeça Java – 3ª Edição: Guia do Aprendiz Para Programação no Mundo Real', 95.00, 
 'O “Use a Cabeça Java” é uma experiência completa de aprendizado em Java e programação orientada a objetos.', 'useacabeçajava.png', 
 'Gestão de TI', 'Alta Books', 'Kathy Sierra', '30/09/2024', 'S', false);
 -- 14 -----
call spInsertlivro(9788576089483, 'Começando a Programar em Python Para Leigos', 70.00, 
'Potente e dinâmico, o Python é uma linguagem de programação usada em várias aplicações e projetada para ter uma independência real de plataforma. Isso o torna uma ótima ferramenta para programadores.', 'começandoaprogramar.png', 
'Gestão de TI', 'Alta Books', 'John Paul Mueller', '05/11/2020', 'O', false);
 -- 15 ----- 
 call spInsertlivro(9788572839785, 'A Quarta Revolução Industrial', 50.00,
 'Novas tecnologias estão fundindo os mundos físico, digital e biológico de forma a criar grandes promessas e possíveis perigos.', 'aquartarevolução.png',
 'Inteligência Artificial', 'Edipro', 'Klaus Schwab', '01/02/2018', 'O', false);
 -- 16 ----- 
 call spInsertlivro(9788580555332, 'Engenharia de Software: Uma Abordagem Profissional', 80.00, 
 'Engenharia de Software chega à sua 8ª edição como o mais abrangente guia sobre essa importante área.', 'engenhariadesoftware.png',
 'Habilidades da codificação de software', 'AMGH', 'Bruce R. Maxim', '15/01/2016', 'O', false);
 -- 17 ----- 
 call spInsertlivro(9788589384780, 'Governança de ti - Tecnologia da Informação', 25.00, 
 'Como administrar os direitos decisórios de TI na busca por resultados superiores como as empresas com melhor desempenho administram os direitos decisórios de TI.', 'governançadeti.png', 
 'Gestão de TI', 'MBooks', 'Peter Weil', '01/01/2005', 'D', false);
 -- 18 ----- 
 call spInsertlivro(9788575222348, 'Desenvolvendo Websites com PHP – 2ª Edição', 18.00, 
 'Desenvolvendo Websites com PHP apresenta técnicas de programação fundamentais para o desenvolvimento de sites dinâmicos e interativos.', 'desenvolvendowebsites.png',
 'Habilidades de codificação de software', ' Novatec', 'Juliano Niederauer', '10/03/2011', 'N', false);
 -- 19 ----- 
 call spInsertlivro(9788575224038, 'HTML5: a Linguagem de Marcação que Revolucionou a Web', 42.00, 
 'HTML, alterando de maneira significativa como você desenvolve para a web.','html5.png',
 'Gestão de TI', 'Novatec', 'Maurício Samy Silva', '12/11/2014', 'D', false);
 -- 20 -----
 call spInsertlivro(9788575221778, 'Linux Guia do Administrador do Sistema', 25.00, 
 'Este livro é uma referência completa do Linux, abrangendo desde as atividades básicas de administração até a criação e manutenção de redes Linux.', 'linux.png', 
 'Programação e Desenvolvimento de Software', 'Novatec', 'Rubem E. Ferreira', '07/11/2008', 'D', false);
 -- 21 -----
 call spInsertlivro(9788577807000, 'O Programador Pragmático: De Aprendiz a Mestre', 82.00, 
 'O Programador Pragmático ilustra as melhores práticas e as principais armadilhas do desenvolvimento de software.', 'oprogramador.png', 
 'Programação e Desenvolvimento de Software', 'Bookman', 'Andrew Hunt', '01/01/2010', 'N', false);
 -- 22 -----
 call spInsertlivro(9788552001447, 'O cérebro no mundo digital: Os desafios da leitura na nossa era', 52.00,
 'Nunca se leu tanto como hoje. Com alguns toques no smartphone, temos na palma da mão um universo de informações.', 'ocerebro.png',
 'Inteligência Artificial e Machine Learning', 'Editora Contexto', 'Maryanne Wolf', '01/05/2019', 'N', false);
 -- 23 -----
 call spInsertlivro(9788576085591,'Use a Cabeça!: C#', 91.00, 
 'O Use a Cabeça! C# – 2ª Edição é uma experiência completa de aprendizagem para a programação com C#.', 'useacabecacsharp.png',
 'Programação de Software', 'Alta Books','Andrew Stellman', '11/02/2013', 'N', false);
 -- 24 -----
 call spInsertlivro(9786555878349,'A próxima onda: Inteligência artificial', 36.00,
 'A próxima onda , de Mustafa Suleyman e Michael Bhaskar, é um alerta urgente sobre os riscos que a inteligência artificial e outras tecnologias em rápido desenvolvimento representam para o mundo','aproximaonda.png',
 'Inteligência Artificial', 'Record', 'Mustafa Suleyman', '16/09/2023', 'N', false);
 -- 25 -----
 call spInsertlivro(9788552946106,'Segurança de Ti',28.00, 
 'O tema central deste livro é a segurança da informação, um assunto bastante divulgado e discutido por diversas empresas, trata-se de uma área complexa e de difícil implementação', 'sagurançadeti.png',
 'Gestão de TI', 'Clube de Autores', 'Gomes', '03/10/2018', 'N', false);
 -- 26 -----
 call spInsertlivro(9788576089520,'Implementando Domain-Driven Design',51.00,
 'Implementando Domain-Driven Design apresenta uma abordagem completa para o entendimento de domaindriven design (DDD), a fim de conectar fluentemente padrões estratégicos às ferramentas táticas fundamentais de programação.','implementandodomain.png',
 'Programação de Software', 'Alta Books','Vaughn Vernon','28/03/2016', 'N', false);
 -- 27 -----
 call spInsertlivro(9788550811765,'Data Science do Zero - 2º Edição',61.00,
 'Para aprender data science de verdade, além de dominar as ferramentas ― bibliotecas, frameworks, módulos e kits ―, você também deve compreender as ideias e os princípios da área.','datascience.png',
 'Gestão de TI', 'Alta Books', 'Joel Grus','30/03/2021','N', false);
 -- 28 -----
 call spInsertlivro(9788575228418,'Python Para Análise de Dados',65.00,
 'Adquira o manual definitivo para manipulação, processamento, limpeza e extração de informações de conjuntos de dados em Python.','pythonparaanalise.png',
 'Gestão de TI', ' Novatec Editora', 'Wes McKinney', '16/03/2023', 'N', false);
 -- 29 -----
 call spInsertlivro(9788565837194,'JavaScript: O Guia Definitivo',95.00,
 'Referência completa para programadores, JavaScript: O guia definitivo fornece uma ampla descrição da linguagem JavaScript básica e das APIs JavaScript do lado do cliente definidas pelos navegadores Web.','javascript.png',
 'Gestão de TI','Bookman','David Flanagan','01/01/2012', 'N', false);
 -- 30 -----
 call spInsertlivro(9788550815480,'Mãos à Obra: Aprendizado de Máquina com Scikit-Learn',37.00,
 'Por meio de uma série de avanços tecnológicos, o aprendizado de máquina tem estimulado todos os campos de atuação em que se insere.','maosaobra.png',
 'inteligencia Artificial','Alta Books','Aurélien Géron','06/09/2021', 'N', false);
 
-- Procedure compra
delimiter $$
Create procedure spInsertCompra
(vNumeroCompra int, vISBN decimal(13, 0), vQtd int, vNomeCli varchar(200), vValorItem decimal(8, 2), vFormPag varchar(40))
begin
    declare vIdCli int;
    select Id into vIDCli from tbCliente where NomeCli = vNomeCli;
        if exists (select NomeCli from tbCliente where NomeCli = vNomeCli) and
         exists (select ISBN from tbLivro where ISBN = vISBN) then
           
           insert into tbCompra (NumeroCompra, DataCompra, TotalCompra, FormPag, ID_Cli)
				values (vNumeroCompra, current_date(), (vValorItem * vQtd), vFormPag, vIdCli);
            
            insert into tbItemCompra (NumeroCompra, ISBN, ValorItem, Qtd)
				values (vNumeroCompra, vISBN, vValorItem, vQtd);
        end if;
       
end $$

call spInsertCompra(3, 1234567891023, 3, 'Edu bolanhos', 85.00, 'Dinheiro');
call spInsertCompra(2, 1234567891023, 2, 'Luciano', 85.00, 'Pix');
call spInsertCompra(1, 1234567891023, 1, 'Niko', 85.00, 'Crédito');
call spInsertCompra(4, 1234567891023, 4, 'Lucy', 85.00, 'Débito');

-- Venda ------------------------------------------------------------------------------------
delimiter $$
Create procedure spInsertVenda(vNumeroVenda int, vNomeEdi varchar(100), vDataVenda char(10), vIdLiv int, vValorItem decimal (8,2), vQtd int, vQtdTotal int, vValorTotal decimal (8,2))
BEGIN 
	If not exists (select NumeroVenda from tbVenda where NumeroVenda = vNumeroVenda) then
		If exists (select idEdi from tbEditora where NomeEdi = vNomeEdi) and exists (select IdLiv from tbLivro where IdLiv = vIdLiv) then
			insert into tbVenda (NumeroVenda, DataVenda, ValorTotal, QtdTotal, idEdi) 
				values (vNumeroVenda, str_to_date(vDataVenda, '%d/%m/%Y'), vValorTotal, vQtdTotal, (select idEdi from tbEditora where NomeEdi = vNomeEdi));
		End if;
	End if; 
	
    If not exists (select * from tbItemVenda where (IdLiv = vIdLiv) and (NumeroVenda = vNumeroVenda)) then
		insert into tbItemVenda (NumeroVenda, IdLiv, ValorItem, Qtd)
			values (vNumeroVenda, vIdLiv, vValorItem, vQtd);
	End if;
END $$

call spInsertVenda(1, 'Alta Books', '01/05/2018', 1, 22.22, 200, 700, 21944.00);

-- NotaFiscal ----------------------
delimiter $$
create procedure spInsertNF(vNF int, vNomeCli varchar(200))
begin
    declare vTotalNota decimal(8,2);
    if exists(select 1 from tbCliente where NomeCli = vNomeCli) then
        if not exists (select 1 from tbNotaFiscal where NF = vNF) then
			select sum(TotalCompra) into vTotalNota from tbCompra where id_Cli = (select id from tbCliente where NomeCli = vNomeCli);
            
            if vTotalNota is null then
                set vTotalNota = 0;
            end if;

            insert into tbNotaFiscal(NF, TotalNota, DataEmissao) values(vNF, vTotalNota, current_date());
        end if;
    end if;
end $$

call spInsertNF (359, 'Niko'); 
call spInsertNF (360, 'Luciano'); 
call spInsertNF (361, 'Edu bolanhos'); 

-- Triggers! -------------------------------------------------------------------------------
create table tbClienteHistorico like tbCliente;

alter table tbClienteHistorico add Ocorrencia varchar(20) NULL AFTER SenhaCli;
alter table tbClienteHistorico add Atualizacao datetime null after Ocorrencia;

DELIMITER $$
create trigger trgClienteNovo AFTER INSERT ON tbCliente
for each row
begin
    insert into tbClienteHistorico (id, NomeCli, EmailCli, SenhaCli, Ocorrencia, Atualizacao, NivelAcesso)
    values (NEW.id, NEW.NomeCli, NEW.EmailCli, NEW.SenhaCli, 'Novo', NOW(), NEW.NivelAcesso);
end $$

call spInsertCliente('Eunuco', 'eunucoemailbrabo@gmail.com', 654321, false);

-- Livro ////////////////////////////////////////////////////////
create table tbLivroHistorico like tbLivro;

alter table tbLivroHistorico add Ocorrencia varchar(20) NULL AFTER DataPubli;
alter table tbLivroHistorico add Atualizacao datetime null after Ocorrencia;

DELIMITER $$
create trigger trgLivroNovo AFTER INSERT ON tbLivro
for each row
begin
    insert into tbLivroHistorico (IdLiv, ISBN, NomeLiv, PrecoLiv, DescLiv, ImgLiv, IdCategoria, idEdi, Autor, DataPubli, Ocorrencia, Atualizacao, NoCarrinho)
    values (NEW.IdLiv, NEW.ISBN, NEW.NomeLiv, NEW.PrecoLiv, NEW.DescLiv, NEW.ImgLiv, NEW.IdCategoria, NEW.idEdi, NEW.Autor, NEW.Datapubli, 'Novo', NOW(), NEW.NoCarrinho);
end $$

-- Compra /////////////////////////////////////////////////////////
create table tbCompraHistorico like tbCompra;

alter table tbCompraHistorico add Ocorrencia varchar(20) NULL AFTER id_Cli;
alter table tbCompraHistorico add Atualizacao datetime null after Ocorrencia;

DELIMITER $$
create trigger trgCompraNova AFTER INSERT ON tbCompra
for each row
begin
    insert into tbCompraHistorico (NumeroCompra, DataCompra, TotalCompra, FormPag, id_Cli, NF, Ocorrencia, Atualizacao)
    values (NEW.NumeroCompra, NEW.DataCompra, NEW.TotalCompra, NEW.FormPag, NEW.id_Cli, NEW.NF, 'Novo', NOW());
end $$

-- Venda ///////////////////////////////////////////////////////////
create table tbVendaHistorico like tbVenda;

alter table tbVendaHistorico add Ocorrencia varchar(20) NULL AFTER idEdi;
alter table tbVendaHistorico add Atualizacao datetime null after Ocorrencia;

DELIMITER $$
create trigger trgVendaNova AFTER INSERT ON tbVenda
for each row
begin
    insert into tbVendaHistorico (NumeroVenda, DataVenda, ValorTotal, QtdTotal, idEdi, Ocorrencia, Atualizacao)
    values (NEW.NumeroVenda, NEW.DataVenda, NEW.ValorTotal, NEW.QtdTotal, New.idEdi, 'Novo', NOW());
end $$

-- Editora - Pra tabela editora 1 ///////////////////////////////////////////////////////
create table tbEditoraHistorico like tbEditora;

alter table tbEditoraHistorico add Ocorrencia varchar(20) NULL AFTER TelEdi;
alter table tbEditoraHistorico add Atualizacao datetime null after Ocorrencia;

DELIMITER $$
create trigger trgEditoraNova AFTER INSERT ON tbEditora
for each row
begin
    insert into tbVendaHistorico (idEdi, NomeEdi, Ocorrencia, Atualizacao)
    values (NEW.idEdi, NEW.NomeEdi, 'Novo', NOW());
end $$

-- NotaFiscal //////////////////////////////////////////////////////////////////
create table tbNotaFiscalHistorico like tbNotaFiscal;

alter table tbNotaFiscalHistorico add Ocorrencia varchar(20) NULL AFTER DataEmissao;
alter table tbNotaFiscalHistorico add Atualizacao datetime null after Ocorrencia;

DELIMITER $$
create trigger trgNotaFiscalNova AFTER INSERT ON tbNotaFiscal
for each row
begin
    insert into tbNotaFiscalHistorico (NF, TotalNota, DataEmissao, Ocorrencia, Atualizacao)
    values (NEW.NF, NEW.TotalNota, NEW.DataEmissao, 'Novo', NOW());
end $$