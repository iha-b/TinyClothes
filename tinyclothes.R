setwd("/Users/iha/Downloads/tinyclothes")
#save files in working directory
CUSTOMER<- read.csv("/Users/iha/Downloads/tinyclothes/CUSTOMER.txt")
DEPARTMENT<-read.csv("/Users/iha/Downloads/tinyclothes/DEPARTMENT.txt")
EMPLOYEE_PHONE<-read.csv("/Users/iha/Downloads/tinyclothes/EMPLOYEE_PHONE.txt")
EMPLOYEE<-read.csv("/Users/iha/Downloads/tinyclothes/EMPLOYEE.txt")
INVOICES<-read.csv("/Users/iha/Downloads/tinyclothes/INVOICES.txt")
PRODUCT<-read.csv("/Users/iha/Downloads/tinyclothes/PRODUCT.txt")
SALES_ORDER_LINE<-read.csv("/Users/iha/Downloads/tinyclothes/SALES_ORDER_LINE.txt")
SALES_ORDER<-read.csv("/Users/iha/Downloads/tinyclothes/SALES_ORDER.txt")
STOCK_TOTAL<-read.csv("/Users/iha/Downloads/tinyclothes/STOCK_TOTAL.txt")

#create RSQLite database
PSTAT10db <- dbConnect(RSQLite::SQLite(), "PSTAT10db.sqlite")
PSTAT10db

#copy R data frame into an SQLite database, replace existing table with same name
dbWriteTable(PSTAT10db, "DEPARTMENT", DEPARTMENT, overwrite=TRUE)
dbWriteTable(PSTAT10db, "CUSTOMER", CUSTOMER,overwrite=TRUE)
dbWriteTable(PSTAT10db, "EMPLOYEE", EMPLOYEE, overwrite=TRUE)
dbWriteTable(PSTAT10db, "EMPLOYEE_PHONE", EMPLOYEE_PHONE, overwrite=TRUE)
dbWriteTable(PSTAT10db, "INVOICES", INVOICES,overwrite=TRUE)
dbWriteTable(PSTAT10db, "PRODUCT", PRODUCT, overwrite=TRUE)
dbWriteTable(PSTAT10db, "SALES_ORDER_LINE", SALES_ORDER_LINE, overwrite=TRUE)
dbWriteTable(PSTAT10db, "SALES_ORDER", SALES_ORDER,overwrite=TRUE)
dbWriteTable(PSTAT10db, "STOCK_TOTAL", STOCK_TOTAL, overwrite=TRUE)

#list all tables
dbListTables(PSTAT10db)
#return all tuples in CUSTOMER
dbGetQuery(PSTAT10db, 'SELECT * FROM CUSTOMER')

dbGetQuery(PSTAT10db, 'SELECT DISTINCT(NAME) FROM EMPLOYEE')
dbGetQuery(PSTAT10db, 'SELECT NAME FROM DEPARTMENT WHERE NAME LIKE "S%r%"')
dbGetQuery(PSTAT10db, 'SELECT NAME FROM DEPARTMENT WHERE NAME LIKE "S%R%"')# like is not case sensitive
dbGetQuery(PSTAT10db, 'SELECT * FROM PRODUCT WHERE COLOR =="WHITE" AND NAME =="SOCKS"')
dbGetQuery(PSTAT10db, 'SELECT AGE FROM EMPLOYEE WHERE NAME == "BROWN"')
dbGetQuery(PSTAT10db, 'SELECT EMP_NO FROM EMPLOYEE WHERE NAME LIKE "%R%"')
dbGetQuery(PSTAT10db, 'SELECT NAME, AGE, EMP_NO FROM EMPLOYEE WHERE AGE !=21')
dbGetQuery(PSTAT10db, 'SELECT NAME FROM DEPARTMENT')

#join STOCK_TOTAL and INVOICES where the product numbers match
dbGetQuery(PSTAT10db, 'SELECT * FROM STOCK_TOTAL INNER JOIN INVOICES ON STOCK_TOTAL.PROD_NO = INVOICES.PROD_NO')

#retrieve the product names and product colors that have been ordered by ALEX or CAROL
dbGetQuery(PSTAT10db, 'SELECT C.CUST_NO, C.NAME AS Customer_Name, P.NAME AS Product_Name, COLOR AS Product_Color
           FROM CUSTOMER C, PRODUCT P, SALES_ORDER_LINE S, SALES_ORDER O 
           WHERE (C.NAME = "ALEX" OR C.NAME = "CAROL")
           AND C.CUST_NO = O.CUST_NO AND O.ORDER_NO = S.ORDER_NO AND S.PROD_NO = P.PROD_NO')

#retrieve the department number of the ACCOUNTS manager
dbGetQuery(PSTAT10db, 'SELECT DEPT_NO FROM DEPARTMENT WHERE NAME IS "Accounts"')

#write code to order SALES_ORDER_LINE
SALES_ORDER_LINE
dbGetQuery(PSTAT10db, 'SELECT PROD_NO, ORDER_NO, QUANTITY FROM SALES_ORDER_LINE ORDER BY ORDER_NO DESC')
