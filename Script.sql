create database db_DevReads;
use db_DevReads;

create table tbCliente(
id int primary key auto_increment,
NomeCli varchar(200) not null,
EmailCli varchar(50) not null,
SenhaCli varchar(50),
NivelAcesso bool not null
);

create table tbCategoria(
IdCategoria int primary key auto_increment,
NomeCategoria varchar(255) not null
);

-- Caso o grupo quiser a inserção direta----
create table tbEditora(
idEdi int primary key auto_increment,
NomeEdi varchar(100) not null
);

-- Caso voltar ao modo tradicional -----
create table tbEditora(
idEdi int primary key auto_increment,
CNPJ decimal (14,0) unique not null,
NomeEdi varchar(100) not null,
TelEdi int 
);

create table tbNotaFiscal(
NF int primary key, -- Chave Principal NotaFiscal/Chave estrangeira tbCompra
TotalNota decimal(8,2) not null,
DataEmissao date not null
);

create table tbLivro(
IdLiv int primary key auto_increment, -- Coloquei pra ver se vai
ISBN decimal(13,0) not null,
NomeLiv varchar(100) not null,
PrecoLiv decimal(6,2) not null,
DescLiv varchar(250)not null,
ImgLiv varchar(255) not null,
IdCategoria int not null,
IdEdi int not null,
Autor varchar(100) not null,
DataPubli date not null,
EspecialLiv enum('P','S','O','D','N') not null,
NoCarrinho bool,
constraint FK_Id_Edi foreign key(idEdi) references tbEditora(idEdi)
);

create view vw_Livro 
as select 
	tbLivro.IdLiv,
    tbLivro.ISBN,
	tbLivro.NomeLiv,
    tbLivro.PrecoLiv,
    tbLivro.DescLiv,
    tbLivro.ImgLiv,
    tbLivro.IdCategoria,
    tbCategoria.NomeCategoria,
    tbLivro.IdEdi,
    tbEditora.NomeEdi,
    tbLivro.Autor,
    tbLivro.DataPubli,
    tbLivro.EspecialLiv,
    tbLivro.NoCarrinho
from tbLivro inner join tbEditora
	on tbLivro.IdEdi = tbEditora.IdEdi
    inner join tbCategoria
    on tbLivro.IdCategoria = tbCategoria.IdCategoria;

create table tbCarrinho(
	idCarrinho int primary key auto_increment,
    id int, -- FK no id do usuario
    IdLiv int, -- FK do id do livro
    constraint fk_Carrinho_Cliente foreign key (id) references tbCliente(id),
    constraint fk_Carrinho_Livro foreign key (IdLiv) references tbLivro(IdLiv)
);

create table tbCompra( 
NumeroCompra int primary key, -- Notafiscal
DataCompra date not null,
TotalCompra decimal(8,2) not null,
FormPag varchar(100) not null,
id_Cli int, -- Chave Estrangeira da Tabela tbCliente
NF int, -- Chave Estranheira nota fiscal
constraint FK_Id_Compra foreign key(Id_cli) references tbCliente(id),
constraint fk_NF foreign key(NF) references tbNotaFiscal(NF)
);

create table tbItemCompra(
NumeroCompra int,-- Chave Estrangeira CodCompra/NotaFiscal
ISBN decimal(13,0), -- Chave Estrangeira da tabela tbLivro
ValorItem decimal (8,2) not null,
Qtd int not null,
constraint primary key(NumeroCompra, ISBN),
constraint FK_NumeroCompra foreign key(NumeroCompra) references tbCompra(NumeroCompra),
constraint FK_ISBN_C foreign key(ISBN) references tbLivro(ISBN)
);

create table tbVenda(
NumeroVenda int primary key,
DataVenda date not null,
ValorTotal decimal(8,2) not null,
QtdTotal int not null,
idEdi int, -- TbEditora
constraint fk_idEdi foreign key(idEdi) references tbEditora(idEdi)
);

create table tbItemVenda(
NumeroVenda int, -- Chave estrangeira para a tabela tbVenda
ISBN decimal(13, 0) not null, -- Chave Estrangeira da tabela tbLivro
ValorItem decimal(8,2) not null,
Qtd int not null,
constraint PK_NV_ISBN primary key(NumeroVenda, ISBN),
constraint FK_NumeroVenda foreign key(NumeroVenda) references tbVenda(NumeroVenda),
constraint FK_ISBN foreign key(ISBN) references tbLivro(ISBN)
);

-- Procedures! ----------------------------------------------------------------------------------
delimiter $$                  
create procedure spInsertCliente(vNomeCli varchar(200), vEmailCli varchar(50), vSenhaCli varchar(50), vNivelAcesso bool)
begin
if not exists (select Id from tbCliente where NomeCli = vNomeCli)then
	insert into tbCliente(NomeCli, EmailCli, SenhaCli, NivelAcesso)
			values(vNomeCli, vEmailCli, vSenhaCli, vNivelAcesso);
else
select "Já tem";

end if;
end $$

insert into tbCliente(NomeCli, EmailCli, SenhaCli, NivelAcesso)
values('Niko','nikoolhate@gmail.com', 123456, true);

insert into tbCliente(NomeCli, EmailCli, SenhaCli, NivelAcesso)
values('Lucy','Luci@gmail.com', 123777, true);

update tbCliente
set NivelAcesso = false
where id = 2;

call spInsertCliente('Luciano', 'Luciano@gmail.com', 132457, false);
call spInsertCliente('Edu bolanhos', 'Edu@gmail.com', 345678, false);

-- Categoria --------------------------------------------------------------
delimiter $$                  
create procedure spInsertCategoria(vNomeCategoria varchar(255))
begin
if not exists (select IdCategoria from tbCategoria where NomeCategoria = vNomeCategoria)then
	insert into tbCategoria(NomeCategoria)
			values(vNomeCategoria);
else
select "Já tem";

end if;
end $$

call spInsertCategoria('Inteligência Artificial e Machine Learning');
call spInsertCategoria('FrontEnd');

-- Editora ----------------------------------------------------------------
delimiter $$                  
create procedure spInsertEditora(vCNPJ decimal(14,0), vNomeEdi varchar(50), vTelEdi varchar(100))
begin
if not exists (select CNPJ from tbEditora where CNPJ = vCNPJ)then
	insert into tbEditora(CNPJ, NomeEdi, TelEdi)
			values(vCNPJ, vNomeEdi, vTelEdi);
else
select "Já tem";

end if;
end $$
select * from tbLivro;

/*
call spInsertEditora (04713695000452, 'Alta Books', 987654321);
call spInsertEditora (23308850000157, 'Érica', 888997767);
call spInsertEditora (08693550000145, 'Visual Books', 991733583);
call spInsertEditora (03032435000106, 'Matrix Editora', 38682863);
call spInsertEditora (74514316000138, 'Editora Gente',  36752505);
call spInsertEditora (55789390000112, 'Companhia das Letras', 37073500);
call spInsertEditora (02507334000181, '‎ Sulina', 1932581970);
call spInsertEditora (01043230000109,'Bookman', 130277000);
call spInsertEditora (50268838000309, 'Saraiva Uni', 1947141771);
call spInsertEditora (02310771000100,'Susan Cain', 2125384100);
call spInsertEditora (11154322000101, 'AMGH', 130733914);
call spInsertEditora (04908981000120,'MBooks',1136415314);
call spInsertEditora (585511850001,'Novatec',1129596529);
call spInsertEditora (57105736000141, 'Editora Contexto',1138325838);
*/

-- Procedure tbLivro ----------------------------------------------------------
-- Procedure de Atualização/Update: Está corrigida o problema da clausula WHERE ---------------------------
delimiter $$
create procedure spUpdateLivro(vISBN decimal(13,0), vNomeLiv varchar(100), vPrecoLiv decimal(6,2), 
vDescLiv varchar(250), vImgLiv varchar(200), vNomeCategoria Varchar(255), vNomeEdi varchar(100), 
vAutor varchar(50), vDataPubli char(20), vNoCarrinho bool, vEspecialLiv enum('P','S','O','D','N'))
begin
	if exists(select IdLiv from tbLivro where ISBN = vISBN) then
		update tbLivro
		set ISBN = vISBN, NomeLiv = vNomeliv, PrecoLiv = vPrecoLiv, DescLiv = vDescLiv, ImgLiv = vImgLiv, 
			IdCategoria = (select IdCategoria from tbCategoria where NomeCategoria = vNomeCategoria), 
			IdEdi = (select IdEdi from tbEditora where NomeEdi = vNomeEdi), Autor = vAutor, DataPubli = str_to_date(vDataPubli, '%d/%m/%Y'), NoCarrinho = vNoCarrinho, EspecialLiv = vEspecialLiv
		where ISBN = vISBN;
    
	else
		select "Update não realizado" as Aviso;
	end if;
end;

-- Esta Procedure irá inserir a Categoria, a Editora e o Livro de uma vez, poupando tempo. É mais uma opção. -------------
delimiter $$                  
create procedure spInsertLivro(vISBN decimal(13,0), vNomeLiv varchar(100), vPrecoLiv decimal(6,2), 
vDescLiv varchar(250), vImgLiv varchar(200), vNomeCategoria Varchar(255), vNomeEdi varchar(100), 
vAutor varchar(50), vDataPubli char(20), vEspecialLiv enum('P','S','O','D','N'), vNoCarrinho bool)
begin
	if not exists (select IdEdi from tbEditora where NomeEdi = vNomeEdi) then
		insert into tbEditora(NomeEdi) values (vNomeEdi);
         end if;               
            if not exists (select IdCategoria from tbCategoria where NomeCategoria = vNomeCategoria) then
            insert into tbCategoria(NomeCategoria) values(vNomeCategoria);
            end if;
			
if not exists (select ISBN from tbLivro where ISBN = vISBN)then
	insert into tbLivro(ISBN, NomeLiv, PrecoLiv, DescLiv, ImgLiv, IdCategoria, idEdi, Autor, DataPubli, EspecialLiv,  NoCarrinho)
			values(vISBN, vNomeLiv, vPrecoLiv, vDescLiv, vImgLiv, 
            (select IdCategoria from tbCategoria where NomeCategoria = vNomeCategoria), 
            (select idEdi from tbEditora where NomeEdi = vNomeEdi), vAutor, str_to_date(vDataPubli, '%d/%m/%Y'), vEspecialLiv, vNoCarrinho);
else
select "O livro já existe!" as Aviso;

end if;
end $$

select * from tbLivro;

-- PEGAR AS IMAGENS PARA PASTA IMG COM A EXTENSÃO DE PNG
-- 1 -----
call spInsertLivro(9788535262128, 'Como Criar Uma Mente', 32.50,
 'Conhecimento da tecnologia para com a mente humana','comocriar.png',
 'Inteligência Artificial e Machine Learning', 'Companhia das Letras', 'Ray Kurzweil', '13/11/2013', 'N', false);
-- 2 -----
call spInsertLivro(9788576082675, 'Código Limpo: Habilidades Práticas do Agile Software', 
42.50, 'Habilidades da codificação de software','codigolimpo.png', 
'FrontEnd', 'Alta Books', 'Robert Cecil Martin', '01/08/2008', 'N', false);
-- 3 -----
call spInsertLivro(9788535248740, 'Projetos e Implementação de Redes: Fundamentos, Soluções, Arquiteturas e Planejamento', 213.00,
'Esta publicação apresenta conceitos iniciais e avançados sobre redes de computador, com exemplos práticos e estudo de soluções', 'projetoseimplementacao.png', 
'Redes e Infraestrutura ', 'Érica', 'Edmundo Antonio Pucci', '30/07/2010', 'N', false);
-- 4 -----
call spInsertLivro(9788574526102, 'Manual de Produção de Jogos Digitais', 340.00, 
'São apresentados tópicos gerais como: pré-produção, testes e liberação do código, bem como tópicos específicos como: gravações de voiceover e motioncapture, tradução e localização e fornecedores externos.', 'manualdeproducao.png', 'Programação e Desenvolvimento de Software', 
'Visual Books', 'Adriano Hazenauer', '01/01/2012', 'N', false);
-- 5 -----
call spInsertLivro(9788550802320, 'Inteligência Artificial na Sala de Aula: Como a Tecnologia Está Revolucionando a Educação', 40.00, 
'Qual é o impacto da Inteligência Artificial na educação? Ao embarcar neste livro, que responde a essas perguntas, lembre-se de que a integração da Inteligência Artificial na educação é uma jornada, não um destino.', 'inteligenciaartificial.png', 
'Inteligência Artificial e Machine Learning','Matrix Editora', 'Leo Fraiman', '25/06/2024', 'N', false);
-- 6 -----
call spInsertLivro(9788545207481, 'A Guerra das Inteligências na Era do ChatGPT', 98.00, 
'O ChatGPT está na origem de uma virada fundamental de nossa História. Seu fundador, Sam Altman, quer criar uma Superinteligência Artificial para competir com nossos cérebros, mesmo que isso signifique uma perigosa corrida mundial.', 'guerradasinteligencias.png', 
'Inteligência Artificial e Machine Learning ', 'Editora Gente', 'Renato de Castro', '17/05/2024', 'N', false);  
-- 7 -----
call spInsertLivro(9788597004087, 'O Verdadeiro Valor do TI ', 99.00 , 
'Como Transformar TI de um Centro de Custos em um Centro de Valor e Competitividade Se esta parece ser a situação na sua empresa, considere este livro como um chamado para despertar para a vida.', 'Img7.png', 
'Gestão de TI', 'Alta Books', 'Mark Schwartz', '01/01/2019', 'N', false);
-- 8 -----
call spInsertLivro(9788599593196, 'Redes, Guia Prático, de Carlos Morimoto', 73.03, 
'O livro Redes e Servidores Linux, Guia Prático o primeiro best-seller do Carlos Morimoto, vendendo um total de 8.000 exemplares em suas duas edições.', 'redes.png', 
'Redes e Infraestrutura', 'Sulina', 'Carlos E. Morimoto', '01/01/2011', 'P', false);
 -- 9 -----
call spInsertLivro(9788577805310, 'Design de Navegação Web: Otimizando a Experiência do Usuário', 154.00,
'Este livro trata das principais ferramentas de design de navegação', 'Redes.png',
'visual Books', 'Bookman',  'James kalbach', '01/01/2009', 'N', false);
 -- 10 -----
call spInsertLivro(9788502082045,'Um bate-papo sobre T.I.: Tudo que você gostaria de saber sobre ERP e tecnologia da informação', 19.00, 
'Um bate-papo sobre T.I. mostrará ao leitor, de maneira leve e bem humorada, a evolução rápida e constante da Tecnologia da Informação e o quanto ela pode ajudar pessoas, e principalmente empresas, a serem mais eficientes e eficazes', 'batepaposobreti.png', 
'Gestão de TI', 'Saraiva Uni', 'Ernesto Mario Haberkorn', '29/11/2012', 'P', false);
 -- 11 ----- 
call spInsertLivro(9788543108704, 'O poder dos quietos: Como os tímidos e introvertidos podem mudar um mundo que não para de falar', 39.45, 
'O poder dos quietos já vendeu mais de 3 milhões  de exemplares no mundo todo, foi traduzido para 41 idiomas e passou quatro anos na lista de mais vendidos do The New York Times .', 'opoderdosquietos.png', 
'Gestão de TI', 'Editora Sextante', 'Susan Cain', '02/10/2019', 'P', false);
 -- 12 ----- 
call spInsertlivro(9788576084730, 'Use a Cabeça!: Programação', 114.00, 
'Alguma vez você desejou aprender a programar com um livro? Se você não tem nenhuma experiência em programação, pode estar imaginando por onde começar.', 'useacabeça.png', 
'Gestão de TI', 'Alta Books', 'Paul Barry', '18/08/2009', 'P', false);
 -- 13 ----- 
 call spInsertlivro(9788550819884, 'Use a Cabeça Java – 3ª Edição: Guia do Aprendiz Para Programação no Mundo Real', 119.00, 
 'O “Use a Cabeça Java” é uma experiência completa de aprendizado em Java e programação orientada a objetos.', 'useacabeçajava.png', 
 'Gestão de TI', 'Alta Books', 'Kathy Sierra', '30/09/2024', 'S', false);
 -- 14 -----
call spInsertlivro(9788576089483, 'Começando a Programar em Python Para Leigos', 69.67, 'Potente e dinâmico, o Python é uma linguagem de programação usada em várias
 aplicações e projetada para ter uma independência real de plataforma. Isso o torna uma ótima ferramenta para programadores.', 'começandoaprogramar.png', 'Gestão de TI', 'Alta Books', 'John Paul Mueller',
 '05/11/2020', 'O', false);
 -- 15 ----- 
 call spInsertlivro(9788572839785, 'A Quarta Revolução Industrial', 49.32,
 'Novas tecnologias estão fundindo os mundos físico, digital e biológico de forma a criar grandes promessas e possíveis perigos.', 'aquartarevolução.png',
 'Inteligência Artificial', 'Edipro', 'Klaus Schwab', '01/02/2018', 'O', false);
 -- 16 ----- 
 call spInsertlivro(9788580555332, 'Engenharia de Software: Uma Abordagem Profissional', 299.00, 
 'Engenharia de Software chega à sua 8ª edição como o mais abrangente guia sobre essa importante área.', 'engenhariadesoftware.png',
 'Habilidades da codificação de software', 'AMGH', 'Bruce R. Maxim', '15/01/2016', 'O', false);
 -- 17 ----- 
 call spInsertlivro(9788589384780, 'Governança de ti - Tecnologia da Informação', 25.00, 
 'Como administrar os direitos decisórios de TI na busca por resultados superiores como as empresas com melhor desempenho administram os direitos decisórios de TI.', 'governançadeti.png', 
 'Gestão de TI', 'MBooks', 'Peter Weil', '01/01/2005', 'D', false);
 -- 18 ----- 
 call spInsertlivro(9788575222348, 'Desenvolvendo Websites com PHP – 2ª Edição', 18.00, 'Desenvolvendo Websites com PHP apresenta técnicas de programação fundamentais para o desenvolvimento de sites dinâmicos e interativos.', 'redes.png', 'Habilidades de codificação de software', ' Novatec', 'Juliano Niederauer', '10/03/2011', 'N', false);
 -- 19 ----- 
 call spInsertlivro(9788575224038, 'HTML5: a Linguagem de Marcação que Revolucionou a Web', 85.00, 'HTML, alterando de maneira significativa como você desenvolve para a web.',
 'html5.png', 'Gestão de TI', 'Novatec', 'Maurício Samy Silva', '12/11/2014', 'D', false);
 -- 20 -----
 call spInsertlivro(9788575221778, 'Linux Guia do Administrador do Sistema', '50.00', 'Este livro é uma referência completa do Linux, abrangendo desde as atividades 
 básicas de administração até a criação e manutenção de redes Linux.', 'linux.png', 'Programação e Desenvolvimento de Software', 'Novatec', 'Rubem E. Ferreira', '07/11/2008', 'D', false);
 -- 21 -----
 call spInsertlivro(9788577807000, 'O Programador Pragmático: De Aprendiz a Mestre', '157.00', 'O Programador Pragmático ilustra as melhores práticas e as principais armadilhas
 do desenvolvimento de software.', 'redes.png', 'programação e Desenvolvimento de software', 'Bookman', 'Andrew Hunt', 01/01/2010, 'N', false);
 -- 22 -----
 call spInsertlivro(9788552001447, 'O cérebro no mundo digital: Os desafios da leitura na nossa era', '52.72', 'Nunca se leu tanto como hoje. Com alguns toques no smartphone, temos
 na palma da mão um universo de informações.', 'redes.png', 'Inteligência Artificial e Machine Learning', 'Editora Contexto', 'Maryanne Wolf', 01/05/2019, 'N', false);
 -- 23 -----
 call spInsertlivro(9788576085591,'Use a Cabeça!: C#', '173.25', 'O Use a Cabeça! C# – 2ª Edição é uma experiência completa de aprendizagem para a programação com C#.', 'redes.png',
 'programação de software', 'Alta Books','Andrew Stellman', 11/02/2013, 'N', false);
 -- 24 -----
 call spInsertlivro(9786555878349,'A próxima onda: Inteligência artificial', '71.28', 'A próxima onda , de Mustafa Suleyman e Michael Bhaskar, é um alerta urgente sobre os riscos que a
 inteligência artificial e outras tecnologias em rápido desenvolvimento representam para o mundo','redes.png','Inteligência Artificial', 'Record', 'Mustafa Suleyman', '16/09/2023', 'N', false);
 -- 25 -----
 call spInsertlivro(9788552946106,'Segurança de Ti','52.12', 'O tema central deste livro é a segurança da informação.um assunto bastante divulgado e discutido por diversas empresas, trata-se 
 de uma área complexa e de difícil implementação', 'redes.png', 'Gestão de TI', 'Clube de Autores', 'Gomes', '03/10/2018', 'N', false);
 -- 26 -----
 call spInsertlivro(9788576089520,'Implementando Domain-Driven Design','102.52', 'Implementando Domain-Driven Design apresenta uma abordagem completa para o entendimento de domaindriven design (DDD),
 a fim de conectar fluentemente padrões estratégicos às ferramentas táticas fundamentais de programação.','redes.png', 'programação e Software', 'Alta Books','Vaughn Vernon','28/03/2016', 'N', false);
 -- 27 -----
 call spInsertlivro(9788550811765,'Data Science do Zero - 2º Edição','118.00','Para aprender data science de verdade, além de dominar as ferramentas ― bibliotecas, frameworks, módulos e kits ―,
 você também deve compreender as ideias e os princípios da área.','redes.png','Gestão de TI', 'Alta Books', 'Joel Grus','30/03/2021','N', false);
 -- 28 -----
 call spInsertlivro(9788575228418,'Python Para Análise de Dados','130.00','Adquira o manual definitivo para manipulação, processamento, limpeza e extração de informações de conjuntos de dados em Python.','redes.png',
 'Gestão de TI', ' Novatec Editora', 'Wes McKinney', '16/03/2023', 'N', false);
 -- 29 -----
 call spInsertlivro(9788565837194,'JavaScript: O Guia Definitivo','189.75','Referência completa para programadores, JavaScript: O guia definitivo fornece uma ampla descrição da linguagem JavaScript básica e das APIs
 JavaScript do lado do cliente definidas pelos navegadores Web.','redes.png','Gestão de TI','Bookman','David Flanagan','01/01/2012', 'N', false);
 -- 30 -----
 call spInsertlivro(9788550815480,'Mãos à Obra: Aprendizado de Máquina com Scikit-Learn','72.00','Por meio de uma série de avanços tecnológicos, o aprendizado de máquina tem estimulado todos os campos
 de atuação em que se insere.','redes.png','inteligencia Artificial','Alta Books','Aurélien Géron','06/09/2021', 'N', false);
 
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
call spInsertCompra(1, 9788535262128, 1, 'Niko', 85.00, 'Cartão');
call spInsertCompra(4, 1234567891023, 4, 'Luciana Amelia Damasceno Ramos dos Santos', 85.00, 'débito');
select * from tbCompra;

-- Venda ------------------------------------------------------------------------------------
delimiter $$
Create procedure spInsertVenda(vNumeroVenda int, vNomeEdi varchar(100), vDataVenda char(10), vISBN decimal(13,0), vValorItem decimal (8,2), vQtd int, vQtdTotal int, vValorTotal decimal (8,2))
BEGIN 
	If not exists (select NumeroVenda from tbVenda where  NumeroVenda = vNumeroVenda) then
		If exists (select idEdi from tbEditora where NomeEdi = vNomeEdi) and exists (select ISBN from tbLivro where ISBN = vISBN) then
			insert into tbVenda (NumeroVenda, DataVenda, ValorTotal, QtdTotal, idEdi) 
				values (vNumeroVenda, str_to_date(vDataVenda, '%d/%m/%Y'), vValorTotal, vQtdTotal, (select idEdi from tbEditora where NomeEdi = vNomeEdi));
		End if;
	End if; 
	
    If not exists (select * from tbItemVenda where (ISBN = vISBN) and (NumeroVenda = vNumeroVenda)) then
		insert into tbItemVenda (NumeroVenda, ISBN, ValorItem, Qtd)
			values (vNumeroVenda, vISBN, vValorItem, vQtd);
	End if;
END $$

call spInsertVenda(1, 'Alta Books', '01/05/2018', 9788535262128, 22.22, 200, 700, 21944.00);

describe tbVenda;
describe tbItemvenda;
select * from tbitemVenda;
select * from tbVenda;

select * from 
-- NotaFiscal

delimiter $$
create procedure spInsertNF(vNF int, vNomeCli varchar(200))
begin
declare vTotalNota decimal(8,2);
if exists(select vNomeCli from tbCliente where NomeCli = vNomeCli)then
	if not exists (select NF from tbNotaFiscal where NF = vNF) then
    
    set vTotalNota = (select sum(TotalCompra) from tbCompra where id_Cli = (select id from tbCliente where Nomecli = vNomecli));
    
		insert into tbNotaFiscal(NF, TotalNota, DataEmissao)
			values(vNF, vTotalNota, current_date());

	end if;
end if;
end $$

call spInsertNF (359, 'Niko'); 
call spInsertNF (360, 'Luciano'); 
call spInsertNF (361, 'Edu bolanhos'); 

select * from tbNotaFiscal;

-- Triggers! -------------------------------------------------------------------------------
-- select * from tbClienteHistorico; 
-- Select * from tbCliente;
-- drop procedure spInsertCliente;
-- drop table tbClienteHistorico;
 describe tbCliente;

create table tbClienteHistorico like tbCliente; -- Teste de Histórico
alter table tbClienteHistorico add Ocorrencia varchar(20) NULL AFTER Tel;
alter table tbClienteHistorico add Atualizacao datetime null after Ocorrencia;

DELIMITER $$
create trigger trgClienteNovo AFTER INSERT ON tbCliente
for each row
begin
    insert into tbClienteHistorico (CPF, NomeCli, EmailCli, SenhaCli, Tel, Ocorrencia, Atualizacao)
    values (NEW.CPF, NEW.NomeCli, NEW.EmailCli, NEW.SenhaCli, NEW.Tel, 'Novo', NOW());
end$$

call spInsertCliente(46956936969,'Niko', 'nikoolhate@gmail.com' , 123456, 986754389);

-- show create trigger trgClienteNovo;
-- show create procedure spInsertCliente;
-- show create table tbCliente;

-- Livro ////////////////////////////////////////////////////////
create table tbLivroHistorico like tbLivro; -- Teste de Histórico
alter table tbLivroHistorico add Ocorrencia varchar(20) NULL AFTER DataPubli;
alter table tbLivroHistorico add Atualizacao datetime null after Ocorrencia;

describe tbLivro;

DELIMITER $$
create trigger trgLivroNovo AFTER INSERT ON tbLivro
for each row
begin
    insert into tbLivroHistorico (ISBN, NomeLiv, PrecoLiv, DescLiv, ImgLiv, Categoria, idEdi, Autor, DataPubli, Ocorrencia, Atualizacao)
    values (NEW.ISBN, NEW.NomeLiv, NEW.PrecoLiv, NEW.DescLiv, NEW.ImgLiv, NEW.Categoria, NEW.idEdi, NEW.Autor, NEW.Datapubli, 'Novo', NOW());
end$$
select * from tbcomprahistorico;

-- Compra /////////////////////////////////////////////////////////
create table tbCompraHistorico like tbCompra; -- Teste de Histórico
alter table tbCompraHistorico add Ocorrencia varchar(20) NULL AFTER id_Cli;
alter table tbCompraHistorico add Atualizacao datetime null after Ocorrencia;
describe tbCompra;

DELIMITER $$
create trigger trgCompraNova AFTER INSERT ON tbCompra
for each row
begin
    insert into tbCompraHistorico (NumeroCompra, DataCompra, TotalCompra, FormPag, id_Cli, NF, Ocorrencia, Atualizacao)
    values (NEW.NumeroCompra, NEW.DataCompra, NEW.TotalCompra, NEW.FormPag, NEW.id_Cli, NEW.NF, 'Novo', NOW());
end$$

-- Venda ///////////////////////////////////////////////////////////
create table tbVendaHistorico like tbVenda; -- Teste de Histórico
alter table tbVendaHistorico add Ocorrencia varchar(20) NULL AFTER idEdi;
alter table tbVendaHistorico add Atualizacao datetime null after Ocorrencia;

describe tbVenda;
DELIMITER $$
create trigger trgVendaNova AFTER INSERT ON tbVenda
for each row
begin
    insert into tbVendaHistorico (CodVenda, DataVenda, ValorTotal, QtdTotal, idEdi, Ocorrencia, Atualizacao)
    values (NEW.CodVenda, NEW.DataVenda, NEW.ValorTotal, NEW.QtdTotal, New.idEdi, 'Novo', NOW());
end$$

-- Editora ///////////////////////////////////////////////////////
create table tbEditoraHistorico like tbEditora; -- Teste de Histórico
alter table tbEditoraHistorico add Ocorrencia varchar(20) NULL AFTER TelEdi;
alter table tbEditoraHistorico add Atualizacao datetime null after Ocorrencia;

describe tbEditora;
DELIMITER $$
create trigger trgEditoraNova AFTER INSERT ON tbEditora
for each row
begin
    insert into tbVendaHistorico (idEdi, CNPJ, NomeEdi, TelEdi, Ocorrencia, Atualizacao)
    values (NEW.idEdi, NEW.CNPJ, NEW.NomeEdi, NEW.TelEdi, 'Novo', NOW());
end$$

-- NotaFiscal //////////////////////////////////////////////////////////////////
describe tbNotafiscal;

create table tbNotaFiscalHistorico like tbNotaFiscal; -- Teste de Histórico
alter table tbNotaFiscalHistorico add Ocorrencia varchar(20) NULL AFTER IdCli;
alter table tbNotaFiscalHistorico add Atualizacao datetime null after Ocorrencia;
select * from tbCompraHistorico;
DELIMITER $$
create trigger trgNotaFiscalNova AFTER INSERT ON tbNotaFiscal
for each row
begin
    insert into tbNotaFiscalHistorico (NF, TotalCompra, DataEmissao, idCli, Ocorrencia, Atualizacao)
    values (NEW.NF, NEW.TotalCompra, NEW.DataEmissao, NEW.idCli, 'Novo', NOW());
end$$