create database GestionePizzeria

create table Pizza (
nome varchar(50) not null,
prezzo decimal (10,2) not null,
IdPizza int identity(1,1),
constraint pk_pizza primary key (IdPizza),
constraint chk_pizza check (prezzo>0),
constraint u_pizza  unique (nome)
)


create table Ingrediente (
nome varchar(50) not null,
costo decimal(10,2) not null,
scorteMagazzino int not null,
IdIngrediente int identity(1,1),
constraint pk_ingrediente primary key (IdIngrediente),
constraint chk1_ingrediente check (costo>0),
constraint chk2_ingrediente check (scorteMagazzino>=0),
constraint u_ingrediente unique (nome)
)

create table PizzaIngrediente (
IdPizza int,
IdIngrediente int,
constraint pk_PizzaIngrediente primary key (IdPizza,IdIngrediente),
constraint fk1_PizzaIngrediente foreign key (IdPizza) references Pizza(IdPizza),
constraint fk2_PizzaIngrediente foreign key (IdIngrediente) references Ingrediente(IdIngrediente)
)

insert into Pizza values('Margherita',5);
insert into Pizza values('Bufala',7);
insert into Pizza values('Diavola',6);
insert into Pizza values('Quattro Stagioni',6.5);
insert into Pizza values('porcini',7);
insert into Pizza values('Dioniso',8);
insert into Pizza values('Ortolana',8);
insert into Pizza values('Patate e Salsiccia',6);
insert into Pizza values('Pomodorini',6);
insert into Pizza values('Quattro Fromaggi',7.5);
insert into Pizza values('Caprese',7.5);
insert into Pizza values('Zeus',7.5);


insert into Ingrediente values('pomodoro',1,100);
insert into Ingrediente values('mozzarella',1,100);
insert into Ingrediente values('mozzarella di bufala',1,100);
insert into Ingrediente values('spianata piccante',1,100);
insert into Ingrediente values('funghi',1,100);
insert into Ingrediente values('carciofi',1,100);
insert into Ingrediente values('cotto',1,100);
insert into Ingrediente values('olive',1,100);
insert into Ingrediente values('funghi porcini',1,100);
insert into Ingrediente values('stracchino',1,100);
insert into Ingrediente values('speck',1,100);
insert into Ingrediente values('rucola',1,100);
insert into Ingrediente values('grana',1,100);
insert into Ingrediente values('verdure di stagione',1,100);
insert into Ingrediente values('patate',1,100);
insert into Ingrediente values('salsiccia',1,100);
insert into Ingrediente values('ricotta',1,100);
insert into Ingrediente values('provola',1,100);
insert into Ingrediente values('gorgonzola',1,100);
insert into Ingrediente values('pomodoro fresco',1,100);
insert into Ingrediente values('basilico',1,100);
insert into Ingrediente values('bresaola',1,100);
insert into Ingrediente values('pomodorini',1,100);

select * from Pizza;
select * from Ingrediente;


insert into PizzaIngrediente values(1,1);
insert into PizzaIngrediente values(1,2);
insert into PizzaIngrediente values(2,1);
insert into PizzaIngrediente values(2,3);
insert into PizzaIngrediente values(3,1);
insert into PizzaIngrediente values(3,2);
insert into PizzaIngrediente values(3,4);
insert into PizzaIngrediente values(4,1);
insert into PizzaIngrediente values(4,2);
insert into PizzaIngrediente values(4,5);
insert into PizzaIngrediente values(4,6);
insert into PizzaIngrediente values(4,7);
insert into PizzaIngrediente values(4,8);
insert into PizzaIngrediente values(5,1);
insert into PizzaIngrediente values(5,2);
insert into PizzaIngrediente values(5,9);
insert into PizzaIngrediente values(6,1);
insert into PizzaIngrediente values(6,2);
insert into PizzaIngrediente values(6,10);
insert into PizzaIngrediente values(6,11);
insert into PizzaIngrediente values(6,12);
insert into PizzaIngrediente values(6,13);
insert into PizzaIngrediente values(7,1);
insert into PizzaIngrediente values(7,2);
insert into PizzaIngrediente values(7,14);
insert into PizzaIngrediente values(8,2);
insert into PizzaIngrediente values(8,15);
insert into PizzaIngrediente values(8,16);
insert into PizzaIngrediente values(9,2);
insert into PizzaIngrediente values(9,23);
insert into PizzaIngrediente values(9,17);
insert into PizzaIngrediente values(10,2);
insert into PizzaIngrediente values(10,18);
insert into PizzaIngrediente values(10,19);
insert into PizzaIngrediente values(10,13);
insert into PizzaIngrediente values(11,2);
insert into PizzaIngrediente values(11,20);
insert into PizzaIngrediente values(11,21);
insert into PizzaIngrediente values(12,2);
insert into PizzaIngrediente values(12,2);
insert into PizzaIngrediente values(12,2);
insert into PizzaIngrediente values(12,22);
insert into PizzaIngrediente values(12,12);



-- QUERY --

--1 estrarre pizze con costo>6€

select p.nome,p.prezzo
from Pizza p
where p.prezzo>6


--2 estrarre le pizze piú costose

select p.nome,p.prezzo
from Pizza p
where p.prezzo = (select MAX(p.prezzo)
					from Pizza p)

--3 estrarre pizze bianche

select p.nome
		from Pizza p where nome not in(select p.nome as nome
										from Pizza p join PizzaIngrediente pin on p.IdPizza=pin.IdPizza
										join Ingrediente I on i.IdIngrediente=pin.IdIngrediente
										where i.nome='pomodoro')
		



--4 estrarre pizze che contengono funghi


select p.nome
		from Pizza p join PizzaIngrediente pin on p.IdPizza=pin.IdPizza
					 join Ingrediente I on i.IdIngrediente=pin.IdIngrediente
					where i.nome like '%funghi%'



        --STORED PROCEDURE--

--1 inserire una nuova pizza(nome,prezzo)

create procedure InserisciPizza
@nomePizza varchar(50),
@prezzoPizza decimal(10,2)
as
insert into Pizza values (@nomePizza,@prezzoPizza)
go

exec dbo.InserisciPizza 'regina',7;
select * from Pizza;




--2 assegnazione di un ingrediente ad una pizza(nomePizza,nomeIngrediente)


create procedure InserisciIngredienteInPizza
@nomePizza varchar(50),
@nomeIngrediente varchar(50)
as
	begin
		begin try
	
			declare  @idPizza int
			select @idPizza=Pizza.IdPizza from Pizza where @nomePizza=Pizza.nome

			declare @idIngrediente int
			select @idIngrediente=Ingrediente.IdIngrediente 
			from Ingrediente 
			where @nomeIngrediente=Ingrediente.nome

			insert into PizzaIngrediente values (@idPizza,@idIngrediente)
		end try
		begin catch
			select ERROR_LINE(),ERROR_MESSAGE()
		end catch
	end
go

exec dbo.InserisciIngredienteInPizza 'regina','pomodoro';
select * from PizzaIngrediente;




--3 aggiornamento del prezzo di una pizza (nomePizza, nuovoPrezzo)


create procedure aggiornaPrezzo
@nomePizza varchar(50),
@nuovoPrezzo decimal(10,2)
as
update Pizza set prezzo=@nuovoPrezzo where nome=@nomePizza
go


exec dbo.aggiornaPrezzo 'Margherita',5.5;
select * from Pizza;


--4 eliminazione di un ingrediente da una pizza (nomePizza,nomeIngredinte)

create procedure eliminaIngrediente
@nomePizza varchar (50),
@nomeIngrediente varchar(50)
as
	begin
		begin try
			
			declare  @idPizza int
			select @idPizza=Pizza.IdPizza from Pizza where @nomePizza=Pizza.nome

			declare @idIngrediente int
			select @idIngrediente=Ingrediente.IdIngrediente 
			from Ingrediente 
			where @nomeIngrediente=Ingrediente.nome

			delete from PizzaIngrediente 
			where PizzaIngrediente.IdPizza=@idPizza
				and
				  PizzaIngrediente.IdIngrediente=@idIngrediente
		end try
		begin catch
			select ERROR_LINE(),ERROR_MESSAGE()
		end catch
	end
go


exec dbo.eliminaIngrediente'regina','pomodoro';
select * from PizzaIngrediente;


--5 incremento del 10% del prezzo delle pizze contenenti un ingrdiente(nome ingrediente)


create procedure incrementoPrezzo
@nomeIngrediente varchar (50)
as
	begin
		begin try
			
			declare @idIngrediente int
			select @idIngrediente=Ingrediente.IdIngrediente 
			from Ingrediente 
			where @nomeIngrediente=Ingrediente.nome;

			with pizzeConIngrediente as(
			select p.nome,p.prezzo
			from Pizza p join PizzaIngrediente pin 
			on p.IdPizza=Pin.IdPizza
			where pin.IdIngrediente=@idIngrediente)

			update pizzeConIngrediente set prezzo=prezzo*1.1;

		end try
		begin catch
			select ERROR_LINE(),ERROR_MESSAGE()
		end catch
	end
go


exec incrementoPrezzo 'pomodorini';
select * from Pizza;


       --  FUNZIONI --

--1 tabella menú pizze (nome,prezzo) no input

create function Menu()
returns table
as
return
select p.nome, p.prezzo
from Pizza p

select * from Menu();

--2 tabella menú pizze contenenti un ingrediente (nome,prezzo) input nomeIngrediente

create function MenuPizzeConIngrediente(@nomeIngrediente varchar(50))
returns table
as 

return				
		select p.nome,p.prezzo
		from Pizza p join PizzaIngrediente pin on p.IdPizza=pin.IdPizza
					 join Ingrediente I on i.IdIngrediente=pin.IdIngrediente
					where @nomeIngrediente=i.nome
		

select * from MenuPizzeConIngrediente('grana');		


--3 tabella menú pizze che non contengono un ingrediente
	

create function MenuPizzeSenzaIngrediente(@nomeIngrediente varchar(50))
returns table
as 

		
return				
		
		

		select p.nome,p.prezzo
		from Pizza p where nome not in(select p.nome as nome
										from Pizza p join PizzaIngrediente pin on p.IdPizza=pin.IdPizza
										join Ingrediente I on i.IdIngrediente=pin.IdIngrediente
										where @nomeIngrediente=i.nome)
		

select * from MenuPizzeSenzaIngrediente('grana');		
		
--	4 calcolo	numero pizze contenenti un ingrediente input(nomeIngrediente)


create function ContaPizzeConIngrediente(@nomeIngrediente varchar(50))
returns int
as
begin
	declare @numeroPizze int
	select @numeroPizze=Count(*)
	from Pizza p join PizzaIngrediente pin on p.IdPizza=pin.IdPizza
					 join Ingrediente I on i.IdIngrediente=pin.IdIngrediente
					where @nomeIngrediente=i.nome

	return @numeroPizze
end

select dbo.ContaPizzeConIngrediente('grana') as [numero pizze];


--5 calcolo numero pizze senza ingrediente input(nomeIngrediente)

create function ContaPizzeSenzaIngrediente(@nomeIngrediente varchar(50))
returns int
as
begin
	declare @numeroPizze int
	select @numeroPizze=Count(*)
	from Pizza p where nome not in(select p.nome as nome
										from Pizza p join PizzaIngrediente pin on p.IdPizza=pin.IdPizza
										join Ingrediente I on i.IdIngrediente=pin.IdIngrediente
										where @nomeIngrediente=i.nome)
	return @numeroPizze
end


select dbo.ContaPizzeSenzaIngrediente('grana') as [numero pizze]


--6 calcolo numero ingredienti contenuti in una pizza input nomePizza

create function  ContaIngredienti(@nomePizza varchar(50))
returns int
as
begin
	declare @numeroIngredienti int
	select @numeroIngredienti=count(*)
	from PizzaIngrediente pin join Pizza p on p.IdPizza = pin.IdPizza
	where @nomePizza=p.nome
return @numeroIngredienti
end

select dbo.ContaIngredienti('Ortolana');


    --VIEW--

--creare una vista Menú con tutte le pizze

create view MenuPizze as (
select p.nome,p.prezzo
from Pizza p)

select * from MenuPizze

--creare una vista con gli ingredienti



--non funziona--
create view MenuPizzeIngredienti as(

select  p.nome, CONCAT_WS(',',i.nome,null ) as Menupizze
from Pizza p join PizzaIngrediente pin on p.IdPizza=pin.IdPizza
			 join Ingrediente i on i.IdIngrediente=pin.IdIngrediente
			 

)

select * from MenuPizzeIngredienti;