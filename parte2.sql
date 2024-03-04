USE company;

-- empregados por departamento e localidade

CREATE OR REPLACE VIEW employee_dept_local AS
SELECT 
	DL.Dlocation AS Localidade,
    D.Dname AS Departamento,
    COUNT(Ssn) AS Quantidade
FROM
	employee E
LEFT JOIN
	departament D ON D.Dnumber = E.Dno
LEFT JOIN
	dept_locations DL ON D.Dnumber = DL.Dnumber
GROUP BY
	Localidade, Departamento
ORDER BY Localidade;
    
SELECT * FROM  employee_dept_local;

-
-- departamentos e seus gerentes

CREATE OR REPLACE VIEW dept_manager AS
SELECT
	D.Dname AS Departamento,
    CONCAT(E.Fname, " ", COALESCE(E.Minit, ""), " ", E.Lname) AS Gerente
FROM
	departament D
LEFT JOIN
	employee E ON E.Ssn = D.Mgr_ssn
ORDER BY 
	Departamento;
    
SELECT * FROM dept_manager;

-- Projetos com maior número de empregados (ex: por ordenação desc) 

CREATE OR REPLACE VIEW proj_group_employee AS
SELECT
	P.Pname AS Projeto,
    COUNT(W.Essn) AS Empregados
FROM
	project P
LEFT JOIN 
	works_on W ON W.Pno = P.Pnumber
GROUP BY
	Projeto
ORDER BY 
	Empregados DESC;
    
SELECT * FROM proj_group_employee;

-- Lista de projetos, departamentos e gerentes

CREATE OR REPLACE VIEW proj_dept_manager AS
SELECT
	P.Pname AS Projeto,
    D.Dname AS Departamento,
    CONCAT(E.Fname, " ", COALESCE(E.Minit, ""), " ", E.Lname) AS Gerente
FROM
	project P
LEFT JOIN
	departament D ON P.Dnum = D.Dnumber
LEFT JOIN
	employee E ON D.Mgr_ssn = E.Ssn
GROUP BY 
	Projeto, Departamento
ORDER BY 
	Gerente desc;
    
SELECT * FROM proj_dept_manager;

-- Quais empregados possuem dependentes e se são gerentes?

CREATE OR REPLACE VIEW employee_dep_manag AS
SELECT 
	CONCAT(E.Fname, " ", COALESCE(E.Minit,"") , " ", E.Lname) as Empregado,
    CASE
		WHEN DP.Essn IS NULL THEN 'Não'
		ELSE 'Sim'
	END AS 'Tem dependente?',
	CASE 
		WHEN D.Mgr_ssn IS NULL THEN 'Não'
		ELSE 'Sim'
	END AS 'É Gerente?'
FROM 
	employee E
LEFT JOIN 
	departament D ON D.Mgr_ssn = E.Ssn
LEFT JOIN
	dependent DP ON DP.Essn = E.Ssn
ORDER BY Empregado;
    
SELECT * FROM employee_dep_manag;

-- acessos 
create user 'gerente'@localhost identified by '123486';
grant all privileges on company.departament to 'gerente'@localhost;
grant all privileges on company.employee to 'gerente'@localhost;