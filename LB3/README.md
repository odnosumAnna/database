                                                  Практична робота 3
                                                  
Мета роботи: Навчитись працювати з Docker-контейнерами для розгортання MS SQL Server, створювати власні образи (images), використовувати томи (volumes) для збереження даних між запусками контейнерів.

                                             Варіант №20 (ДАІ)
База даних повинна містити інформацію про дорожньо-транспортні
подіях (ДТП). Про ДТП має бути відомо вид ДТП, які транспортні засоби в ньому брали участь (можливо більше двох), їх державні номери, П.І.Б., домашні адреси водіїв цих транспортних засобів, а також номери посвідчень водія. Крімтого, необхідно знати кількість постраждалих у даній ДТП, вид травми, П.І.Б., домашня адреса та номер паспорта кожного потерпілого. Постраждалими можуть бути водії. У ДТП можуть брати участь і пішоходи, про які потрібно знати, чи не є вони постраждалими, а також їх П.І.Б., домашню адресу та номер паспорта. Про ДТП також мають бути відомі місце, дата, час, винуватець ДТП та які міліціонери (їх звання та П.І.Б.) виїжджали ДТП.
                          
                                Запити
        •	Вивести повний список ДТП, які виникли з вини пішоходів, за вказаний
        період з повними відомостями про них;
        •	Знайти місце, де сталася максимальна кількість ДТП;
        •	Вивести повний список ДТП, на які ВИЇжджали міліціонери із зазначеним
        званням за вказаний період часу, з повними відомостями про ДТП;
        •	Скласти список водіїв, які брали участь більше НІЖ В ОДНІЙ ДТП за
        зазначений період часу, З повними відомостями про цих водіїв;
        •	Скласти список постраждалих у ДТП за вказаний період часу з
        повними відомостями про ці ДТП, упорядковані за кількістю травм певного виду.
        •	Внести відомості про нову ДТП;
        •	Видалити відомості про ДТП, які сталися раніше вказаної дати.

                            
                        Логічна та фізична модель
![image](https://github.com/user-attachments/assets/f28b2ca6-c263-4cf1-8a6b-23382d8fbcb9)

![image](https://github.com/user-attachments/assets/96d46b57-0b9a-4983-97ca-c6d99bad622c)



Завдання 1: Встановлення Docker Desktop та виведення його версію в терміналі , скриншот з Docker Desktop:
 
 ![image](https://github.com/user-attachments/assets/24984908-469a-4578-96d1-e1c59cd5daaf)
![image](https://github.com/user-attachments/assets/e2fbd3ea-c679-4327-ac58-6002bf3f3663)

                              Рисунок 4 - Docker Desktop.

Завдання 2: образ MSSQL Server:

 ![image](https://github.com/user-attachments/assets/ce6effa3-ffcd-4909-9216-dfb3f4eab2ec)

                              Рисунок 5 – образ MSSQL Server


Завдання 3: запуск контейнера MS SQL:
![image](https://github.com/user-attachments/assets/b67d33e0-dcb7-4560-a137-99f393ff0c73)

 
                              Рисунок 6 – вивід версії докера та запуск контейнера.

Підключення до контейнера: 
•	Через термінал: 
docker exec -it mssql-study /bin/sh
•	Через Docker Desktop: Containers > mssql-study > Exec

Підʼєднання до бази даних за допомогою ms sql tools всередині контейнера та вивести версію MS SQL Server 

/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourStrongPassword1!' -C -Q "SELECT @@VERSION"

● зупинити контейнер 
● видалити контейнер
![image](https://github.com/user-attachments/assets/ae927c13-576a-469c-b16c-9a191deec91f)
![image](https://github.com/user-attachments/assets/3104d5e8-279c-4659-abc5-8cf4a9a3dd75)
![image](https://github.com/user-attachments/assets/dd9be7e9-af73-4046-9df7-224f233f3bdc)
 
                              Рисунок 7-8 – робота з контейнером.

Завдання 4:
 ![image](https://github.com/user-attachments/assets/a227648d-ca54-4bc3-9fc1-743948ec2b0b)

                              Рисунок 9 – том(volume) який буде зберігати інформацію БД ззовні контейнера.

Завдання 5:
 ![image](https://github.com/user-attachments/assets/bae98acd-9463-44d4-8987-6fd41b659cab)

                              Рисунок 10 – запуск контейнера MS SQL відкривши порт 1433*


Завдання 6: під’єднання до БД та виконання скриптів: 

  ![image](https://github.com/user-attachments/assets/f0e455c7-1542-44c6-be58-a023f1673ee1)
![image](https://github.com/user-attachments/assets/2c70bf70-4fa6-45a9-ae42-44fcfa084a57)
![image](https://github.com/user-attachments/assets/45325152-50f7-4003-b1fd-31737349cdf8)
![image](https://github.com/user-attachments/assets/2265e381-b84b-4916-83b9-c17d26503d1a)

                              Рисунок  11-14– під’єднання до БД та виконання скриптів ○ SETUP.sql ○ INSERT.sql ○ UPDATE.sql 

 ![image](https://github.com/user-attachments/assets/cdb2e1f9-fb05-4ae2-b4dc-94cdc9366754)
![image](https://github.com/user-attachments/assets/dd2923e6-519c-4cde-a52a-810fb1961950)
![image](https://github.com/user-attachments/assets/9585342c-d51a-405c-bb5a-d65743e1550c)

                              Рисунок 15 –  зупинка контейнера  та видалення контейнера




Завдання 7: mssql контейнер, змонтування вже створеного тома та відкриття порту:
  ![image](https://github.com/user-attachments/assets/f162cb99-266f-439c-8d0b-64f684bbb4e3)
![image](https://github.com/user-attachments/assets/33e030f1-0665-40f8-a606-314052fd52ab)
![image](https://github.com/user-attachments/assets/ca8f4fc2-2f16-44c9-8600-4b725fb84dad)
![image](https://github.com/user-attachments/assets/e3af364b-dbeb-4663-b585-a2b220822369)
![image](https://github.com/user-attachments/assets/38f9833f-144c-46e2-af54-c1d76202df0e)
![image](https://github.com/user-attachments/assets/ecd5390e-e2c5-4eda-8052-0cc12449d59a)

                              Рисунок  16-20– Підʼєднання до БД та виконання QUERY.sql
 ![image](https://github.com/user-attachments/assets/5afa2b5e-c649-486c-80a8-01a3656d9082)

                              Рисунок  21 – виконання QUERY.sql
Висновки: 
У ході виконання роботи я навчилася працювати з Docker-контейнерами для розгортання MS SQL Server, створювати власні образи (images), використовувати томи (volumes) для збереження даних між запусками контейнерів.

