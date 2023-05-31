#CRIANDO O BANCO DE DADOS

CREATE DATABASE projetoteste;

USE projetoteste;

#CRIANDO AS TABELAS

#HOSPITAL
CREATE TABLE HOSPITAL(
	id_hospital int unsigned not null auto_increment,
	razao_social varchar(45) not null,
	telefone char(11) not null,
	endereco varchar(250) not null,
	primary key(id_hospital));

#RAMO GARAGEM
CREATE TABLE GARAGEM(
	id_garagem int unsigned not null auto_increment,
	capacidade smallint unsigned not null,
	hospital_id int unsigned not null,
	primary key(id_garagem),
	constraint fk_garagem_hospital foreign key(hospital_id) references HOSPITAL(id_hospital));

CREATE TABLE AMBULANCIAS(
	id_ambulancia int unsigned not null auto_increment,
	disponibilidade bit(1) not null,
	garagem_id int unsigned not null ,
	primary key(id_ambulancia),
	constraint fk_ambulancia_garagem foreign key(garagem_id) references GARAGEM(id_garagem));
	

#RAMO FUNCIONARIOS
CREATE TABLE FUNCIONARIOS(
	id_funcionario int unsigned not null  auto_increment,
	nome varchar(80) not null,
	salario double unsigned not null,
	telefone char(11) not null,
	data_nascimento date not null,
	cpf char(11) not null,
	sexo enum('F', 'M') not null,
	hospital_id int unsigned not null,
	primary key(id_funcionario),
	constraint fk_funcionario_hospital foreign key(hospital_id) references HOSPITAL(id_hospital));

#ADICIONANDO CPF COMO CHAVE CANDIDATA (UNIQUE KEY)
alter table FUNCIONARIOS add constraint ak_cpf_funcionario unique(cpf);

CREATE TABLE MEDICOS(
	id_medico int unsigned not null auto_increment,
	crm char(8) not null,
	funcionario_id int unsigned not null ,
	primary key(id_medico),
	constraint fk_medico_funcionario foreign key(funcionario_id) references FUNCIONARIOS(id_funcionario));

#ADICIONANDO CRM COMO CHAVE CANDIDATA (UNIQUE KEY)
alter table MEDICOS add constraint ak_crm unique(crm);

CREATE TABLE SEGURANCAS(
	id_seguranca int unsigned not null  auto_increment,
	abseg char(8) not null,
	funcionario_id int unsigned not null,
	primary key(id_seguranca),
	constraint fk_seguranca_funcionario foreign key(funcionario_id) references FUNCIONARIOS(id_funcionario));

#ADICIONANDO ABSEG COMO CHAVE CANDIDATA (UNIQUE KEY)
alter table SEGURANCAS add constraint ak_abseg unique(abseg);

CREATE TABLE SERVICOS_GERAIS(
	id_servicos int unsigned not null  auto_increment,
	funcao varchar(15) not null,
	funcionario_id int unsigned not null ,
	primary key(id_servicos),
	constraint fk_servicos_funcionario foreign key(funcionario_id) references FUNCIONARIOS(id_funcionario));

CREATE TABLE MOTORISTAS(
	id_motorista int unsigned not null  auto_increment,
	cnh char(9) not null,
	data_exp_cnh date not null,
	funcionario_id int unsigned not null ,
	primary key(id_motorista),
	constraint fk_motorista_funcionario foreign key(funcionario_id) references FUNCIONARIOS(id_funcionario));

#ADICIONANDO CNH COMO CHAVE CANDIDATA (UNIQUE KEY)
alter table MOTORISTAS add constraint ak_cnh unique (cnh);
	
CREATE TABLE ENFERMEIROS(
	id_enfermeiro int unsigned not null  auto_increment,
	coren char(8) not null,
	especializacao varchar(15) not null,
	chefiado int unsigned not null,
	funcionario_id int unsigned not null ,
	primary key(id_enfermeiro),
	constraint fk_enfermeiro_funcionario foreign key(funcionario_id) references FUNCIONARIOS(id_funcionario));

#ADICIONANDO COREN COMO CHAVE CANDIDATA (UNIQUE KEY)
alter table ENFERMEIROS add constraint ak_coren unique(coren);
	

#RAMO SALAS
CREATE TABLE SALAS(
	id_sala int unsigned not null  auto_increment,
	capacidade tinyint unsigned not null ,
	tipo_sala varchar(20) not null,
	numero_sala smallint unsigned not null ,
	hospital_id int unsigned not null ,
	primary key(id_sala),
	constraint fk_sala_hospital foreign key(hospital_id) references HOSPITAL(id_hospital));

CREATE TABLE ENFERMARIA(
	id_enfermaria int unsigned not null auto_increment,
	tipo_enfermaria enum('coletiva', 'apartamento') not null,
	sala_id int unsigned not null,
	primary key(id_enfermaria),
	constraint fk_enfermaria_sala foreign key(sala_id) references SALAS(id_sala));

CREATE TABLE UTI(
	id_uti int unsigned not null auto_increment,
	ala_uti enum('verde', 'amarela', 'vermelha') not null,
	sala_id int unsigned not null ,
	primary key(id_uti),
	constraint fk_uti_sala foreign key(sala_id) references SALAS(id_sala));

CREATE TABLE DIAGNOSTICO(
	id_diagnostico int unsigned not null  auto_increment,
	especialidade varchar(30),
	sala_id int unsigned not null ,
	primary key(id_diagnostico),
	constraint fk_diagnostico_sala foreign key(sala_id) references SALAS(id_sala));
	

#RAMO PACIENTES
CREATE TABLE PACIENTES(
	id_paciente int unsigned not null auto_increment,
	nome varchar(80) not null,
	cpf char(11) not null,
	endereco varchar(150) not null,
	plano_saude bit(1) not null,
	sexo enum('F', 'M') not null,
	data_nascimento date not null,
	primary key(id_paciente));

#COLOCANDO CPF DO PACIENTE COMO CHAVE CANDIDATA (UNIQUE KEY)
alter table PACIENTES add constraint ak_cpf_paciente unique(cpf);

CREATE TABLE TELEFONE_PACIENTE(
	id_telefone int unsigned not null auto_increment,
	telefone char(11) not null,
	paciente_id int unsigned not null,
	primary key(id_telefone),
	constraint fk_telefone_paciente foreign key(paciente_id) references PACIENTES(id_paciente));

CREATE TABLE ACOMPANHANTES(
	id_acompanhante int unsigned not null auto_increment,
	nome varchar(80) not null,
	telefone char(11) not null,
	cpf char(11) not null,
	data_nascimento date not null,
	paciente_id int unsigned not null,
	primary key(id_acompanhante),
	constraint fk_acompanhante_paciente foreign key(paciente_id) references PACIENTES(id_paciente));

#COLOCANDO CPF DO ACOMPANHANTE COMO CHAVE CANDIDATA (UNIQUE KEY)
alter table ACOMPANHANTES add constraint ak_cpf_acompanhante unique(cpf);
	
	
#EVENTOS
CREATE TABLE ATENDIMENTO(
	id_atendimento int unsigned not null  auto_increment,
	data_hora datetime not null default CURRENT_TIMESTAMP,
	sala_id int unsigned not null ,
	paciente_id int unsigned not null ,
	medico_id int unsigned not null ,
	primary key(id_atendimento),
	constraint fk_atendimento_sala foreign key(sala_id) references SALAS(id_sala),
	constraint fk_atendimento_paciente foreign key(paciente_id) references PACIENTES(id_paciente),
	constraint fk_atendimento_medico foreign key(medico_id) references MEDICOS(id_medico));
	
CREATE TABLE RECEITUARIO(
	id_receituario int unsigned not null  auto_increment,
	atendimento_id int unsigned not null ,
	primary key(id_receituario),
	constraint fk_receituario_atendimento foreign key(atendimento_id) references ATENDIMENTO(id_atendimento));

CREATE TABLE MEDICAMENTOS(
   id_medicamento int unsigned not null auto_increment,
   nome varchar(45) not null,
   gramatura double unsigned not null,
   primary key(id_medicamento));

CREATE TABLE ENCAMINHAMENTOS(
   id_encaminhamento int unsigned not null  auto_increment,
   nome varchar(45) not null,
   primary key(id_encaminhamento));

CREATE TABLE LISTA_MEDICA_MEDICAMENTOS(
   id_lista_medica_medicamento int unsigned not null  auto_increment,
   receituario_id int unsigned not null ,
   medicamento_id int unsigned not null ,
   primary key(id_lista_medica_medicamento),
   constraint fk_lista_medica_medicamentos_receituario foreign key(receituario_id) references RECEITUARIO(id_receituario),
   constraint fk_lista_medica_medicamentos_medicamento foreign key(medicamento_id) references MEDICAMENTOS(id_medicamento));

CREATE TABLE LISTA_MEDICA_ENCAMINHAMENTOS(
   id_lista_medica_encaminhamento int unsigned not null  auto_increment,
   receituario_id int unsigned not null ,
   encaminhamento_id int unsigned not null ,
   primary key(id_lista_medica_encaminhamento),
   constraint fk_lista_medica_encaminhamentos_receituario foreign key(receituario_id) references RECEITUARIO(id_receituario),
   constraint fk_lista_medica_encaminhamentos_encaminhamento foreign key(encaminhamento_id) references ENCAMINHAMENTOS(id_encaminhamento));

CREATE TABLE OCORRENCIA(
	id_ocorrencia int unsigned not null  auto_increment,
	data_hora datetime not null default CURRENT_TIMESTAMP,
	endereco_ocorrencia varchar(250) not null,
	telefone_ocorrencia char(11) not null,
	motorista_id int unsigned not null ,
	enfermeiro_id int unsigned not null ,
	ambulancia_id int unsigned not null ,
	primary key(id_ocorrencia),
	constraint fk_ocorrencia_motorista foreign key(motorista_id) references MOTORISTAS(id_motorista),
	constraint fk_ocorrencia_enfermeiro foreign key(enfermeiro_id) references ENFERMEIROS(id_enfermeiro),
	constraint fk_ocorrencia_ambulancia foreign key(ambulancia_id) references AMBULANCIAS(id_ambulancia));

CREATE TABLE CAMAS_ENFERMARIAS(
	id_cama int unsigned not null auto_increment,
	disponibilidade bit(1) not null,
	paciente_id int unsigned not null ,
	enfermaria_id int unsigned not null ,
	primary key(id_cama),
	constraint fk_cama_enfermaria_paciente foreign key(paciente_id) references PACIENTES(id_paciente),
	constraint fk_cama_enfermaria_enfermaria foreign key(enfermaria_id) references ENFERMARIA(id_enfermaria));