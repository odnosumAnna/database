                                                ЛАБОРАТОРНА РОБОТА №8
          	                    на тему: «Створення додатка мовою C# з базою даних MSSQL.»
                                 
Мета роботи: Ознайомитися з принципами побудови клієнт-серверних додатків мовою програмування C# з використанням системи керування базами даних Microsoft SQL Server. Вивчити способи підключення до бази даних за допомогою ADO.NET, роботу з рядком підключення (Connection String), а також використання елемента DataGridView для відображення та редагування даних. Навчитися створювати прості додатки Windows Forms для реалізації базових операцій над даними (вставка, оновлення, видалення, відображення) та забезпечення взаємодії з SQL Server у межах багаторівневої архітектури.

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


Завдання 3-6 
У рамках виконання завдання 3-6 створила графічний інтерфейс користувача за допомогою бібліотеки Tkinter, який є аналогом Windows Forms у Python. У вікні реалізувала компонент Treeview для виводу вмісту таблиць бази даних, а також кнопки для завантаження, додавання, редагування та видалення записів.
Було додано файл конфігурації config.ini, у якому зберігається рядок підключення до бази даних. Це є аналогом використання App.config у середовищі .NET.
Доступ до бази даних реалізовано з використанням бібліотеки SQLAlchemy, яка виконує роль альтернативи ADO.NET. Запити до бази, зокрема вибірка, додавання, оновлення та видалення даних, виконуються через підключення, створене за допомогою engine.begin().
Функціональність програми повністю відповідає умовам завдання: реалізовано додавання нових записів, редагування збережених даних із можливістю оновлення інформації, а також видалення записів. Передбачено обробку первинних ключів, підтримку автоінкрементних полів та базову валідацію введених значень. Форма редагування будується динамічно відповідно до обраної таблиці.
Лістинг коду :
from sqlalchemy import create_engine, inspect, text
import tkinter as tk
from tkinter import ttk, messagebox
import pandas as pd
import configparser

# --- Зчитування налаштувань ---
config = configparser.ConfigParser()
config.read("config.ini")
connection_string = config.get("database", "connection_string")

# --- Підключення до SQL Server через SQLAlchemy ---
engine = create_engine(connection_string)

# === GUI ===
root = tk.Tk()
root.title("Система DAI (Односум Анна КС31)")
root.geometry("1100x700")
root.configure(bg="#f0f0f0")

style = ttk.Style()
style.theme_use("clam")

style.configure("Treeview",
    background="#ffffff",
    foreground="black",
    rowheight=22,
    fieldbackground="#f9f9f9",
    font=("Segoe UI", 9)
)
style.configure("Treeview.Heading",
    background="#4a6984",
    foreground="white",
    font=("Segoe UI", 9, "bold")
)
style.map("Treeview", background=[("selected", "#cce6ff")])

# Кадри
table_frame = tk.Frame(root, bg="#f0f0f0")
table_frame.pack(padx=10, pady=10)

search_frame = tk.Frame(root, bg="#f0f0f0")
search_frame.pack(padx=10, pady=5, fill=tk.X)

# Глобальні змінні
current_columns = []
current_table = None
entries = {}
edit_mode = False
edited_pk_value = None
full_df = pd.DataFrame()

# ====== ФУНКЦІЇ ======

def load_table_names():
    inspector = inspect(engine)
    table_names = inspector.get_table_names()
    combo_tables["values"] = table_names
    if table_names:
        combo_tables.current(0)
        load_table()

def load_table():
    global current_columns, current_table, edit_mode, edited_pk_value, full_df
    current_table = combo_tables.get()
    edit_mode = False
    edited_pk_value = None
    btn_edit.config(text="Редагувати запис")

    try:
        full_df = pd.read_sql(f"SELECT * FROM {current_table}", engine)
        current_columns = list(full_df.columns)
        update_treeview(full_df)

        for widget in form_frame.winfo_children():
            widget.destroy()

        global entries
        entries = {}

        # Налаштовуємо колонки
        form_frame.columnconfigure(0, weight=1)
        form_frame.columnconfigure(1, weight=3)

        for i, col in enumerate(current_columns):
            tk.Label(form_frame, text=col + ":", anchor="center", width=15, bg="#f8f8f8", font=("Segoe UI", 9)).grid(row=i, column=0, sticky="ew", pady=2, padx=5)
            entry = tk.Entry(form_frame, width=40, font=("Segoe UI", 9))
            entry.grid(row=i, column=1, sticky="ew", pady=2, padx=5)
            entries[col] = entry

    except Exception as e:
        messagebox.showerror("Помилка завантаження", str(e))

def update_treeview(df):
    for row in tree.get_children():
        tree.delete(row)
    tree["columns"] = list(df.columns)
    tree["show"] = "headings"
    for col in df.columns:
        tree.heading(col, text=col)
        tree.column(col, width=100, anchor="center")
    for _, row in df.iterrows():
        tree.insert("", "end", values=list(row))

def search_records(event=None):
    query = search_entry.get().strip().lower()
    if not query:
        update_treeview(full_df)
        return
    try:
        filtered_df = full_df[full_df.apply(lambda row: row.astype(str).str.lower().str.contains(query).any(), axis=1)]
        update_treeview(filtered_df)
    except Exception as e:
        messagebox.showerror("Помилка пошуку", str(e))

def add_row():
    try:
        values = {}
        for col in current_columns:
            val = entries[col].get().strip()
            if val:
                values[col] = val

        identity_cols = get_identity_columns(current_table)
        insert_cols = [col for col in values if col not in identity_cols]
        insert_vals = [values[col] for col in insert_cols]

        if not insert_cols:
            messagebox.showwarning("Додати запис", "Немає значень для вставки (можливо, всі поля - автоінкремент).")
            return

        placeholders = ", ".join([f":{col}" for col in insert_cols])
        columns_str = ", ".join(insert_cols)

        with engine.begin() as conn:
            conn.execute(
                text(f"INSERT INTO {current_table} ({columns_str}) VALUES ({placeholders})"),
                dict(zip(insert_cols, insert_vals))
            )
        load_table()
        messagebox.showinfo("Успіх", "Запис додано")
    except Exception as e:
        messagebox.showerror("Помилка додавання", str(e))

def delete_row():
    selected = tree.selection()
    if not selected:
        messagebox.showwarning("Видалити запис", "Оберіть запис для видалення.")
        return

    selected_values = tree.item(selected[0])["values"]
    pk_col = get_primary_key(current_table)
    if not pk_col:
        messagebox.showerror("Немає PK", "Таблиця не має первинного ключа")
        return

    try:
        pk_value = selected_values[current_columns.index(pk_col)]
        with engine.begin() as conn:
            conn.execute(text(f"DELETE FROM {current_table} WHERE {pk_col} = :val"), {"val": pk_value})
        load_table()
        messagebox.showinfo("Успіх", "Запис видалено")
    except Exception as e:
        messagebox.showerror("Помилка видалення", str(e))

def edit_row():
    global edit_mode, edited_pk_value

    selected = tree.selection()
    if not selected:
        messagebox.showwarning("Редагувати запис", "Будь ласка, виберіть запис для редагування.")
        return

    if not edit_mode:
        selected_values = tree.item(selected[0])["values"]
        pk_col = get_primary_key(current_table)
        if not pk_col:
            messagebox.showerror("Немає PK", "Таблиця не має первинного ключа")
            return

        for col, val in zip(current_columns, selected_values):
            entries[col].delete(0, tk.END)
            entries[col].insert(0, str(val))

        edited_pk_value = selected_values[current_columns.index(pk_col)]
        btn_edit.config(text="Зберегти зміни")
        edit_mode = True
    else:
        try:
            pk_col = get_primary_key(current_table)
            if not pk_col:
                messagebox.showerror("Немає PK", "Таблиця не має первинного ключа")
                return

            values = {col: entries[col].get().strip() for col in current_columns}
            set_clause = ", ".join([f"{col} = :{col}" for col in current_columns if col != pk_col])

            with engine.begin() as conn:
                conn.execute(
                    text(f"UPDATE {current_table} SET {set_clause} WHERE {pk_col} = :pk_value"),
                    {**{col: values[col] for col in current_columns if col != pk_col}, "pk_value": edited_pk_value}
                )

            load_table()
            messagebox.showinfo("Успіх", "Запис оновлено успішно")

            btn_edit.config(text="Редагувати запис")
            edit_mode = False
            edited_pk_value = None
        except Exception as e:
            messagebox.showerror("Помилка оновлення", str(e))

def get_primary_key(table):
    inspector = inspect(engine)
    pk = inspector.get_pk_constraint(table)
    return pk["constrained_columns"][0] if pk["constrained_columns"] else None

def get_identity_columns(table):
    with engine.connect() as conn:
        result = conn.execute(text(f"""
            SELECT name FROM sys.columns
            WHERE object_id = OBJECT_ID(:table)
            AND is_identity = 1
        """), {"table": table})
        return [row[0] for row in result]

# ====== GUI Елементи ======
tk.Label(table_frame, text="Виберіть таблицю:", bg="#f0f0f0", font=("Segoe UI", 9)).grid(row=0, column=0, sticky="w", padx=5)
combo_tables = ttk.Combobox(table_frame, state="readonly", width=40, font=("Segoe UI", 9))
combo_tables.grid(row=0, column=1, padx=5)
tk.Button(table_frame, text="Завантажити", command=load_table, font=("Segoe UI", 9)).grid(row=0, column=2, padx=5)

tk.Label(search_frame, text="Пошук:", bg="#f0f0f0", font=("Segoe UI", 9)).pack(side=tk.LEFT, padx=5)
search_entry = tk.Entry(search_frame, width=40, font=("Segoe UI", 9))
search_entry.pack(side=tk.LEFT, padx=5)
search_entry.bind("<KeyRelease>", search_records)

# Таблиця
tree = ttk.Treeview(root)
tree.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)

# Кнопки
btn_frame = tk.Frame(root, bg="#f0f0f0")
btn_frame.pack(pady=5)
tk.Button(btn_frame, text="Додати запис", width=20, command=add_row, font=("Segoe UI", 9)).grid(row=0, column=0, padx=10)
tk.Button(btn_frame, text="Видалити запис", width=20, command=delete_row, font=("Segoe UI", 9)).grid(row=0, column=1, padx=10)
btn_edit = tk.Button(btn_frame, text="Редагувати запис", width=20, command=edit_row, font=("Segoe UI", 9))
btn_edit.grid(row=0, column=2, padx=10)

# Форма
form_frame = tk.LabelFrame(root, text="Дані запису", padx=10, pady=10, bg="#f8f8f8", font=("Segoe UI", 9))
form_frame.pack(padx=10, pady=10, fill=tk.X)

load_table_names()

root.mainloop()

config.ini:
[database]
connection_string = mssql+pyodbc://sa:YourStrongPassword1!@localhost:1433/DAI?driver=ODBC+Driver+17+for+SQL+Server
Пояснення до коду:
Я реалізувала повноцінну графічну програму на Python для роботи з базою даних через інтерфейс SQLAlchemy та бібліотеку Tkinter. Програма дозволяє переглядати таблиці з бази даних, шукати по записах, додавати, редагувати та видаляти рядки. Нижче подано пояснення, як працює код:
1. Підключення бібліотек:
•	sqlalchemy: для з'єднання з базою даних та виконання SQL-запитів.
•	tkinter, ttk, messagebox: для створення графічного інтерфейсу.
•	pandas: для зручної обробки таблиць і фільтрації записів.
•	configparser: для читання конфігураційного файлу config.ini, в якому зберігається рядок підключення до бази даних.
2. З'єднання з базою даних:
•	Зчитується рядок підключення з файлу config.ini.
•	Створюється об'єкт engine для підключення до SQL Server за допомогою SQLAlchemy.
3. Створення GUI:
•	Вікно Tkinter має заголовок і розміри.
•	Стиль таблиці (Treeview) налаштований для кращого вигляду: шрифт, кольори, висота рядків.
4. Основні частини інтерфейсу:
•	combo_tables: випадаючий список для вибору таблиці з бази.
•	search_entry: поле для пошуку.
•	tree: основне дерево для відображення записів таблиці.
•	form_frame: форма з полями вводу для редагування чи додавання записів.
•	Кнопки для додавання, видалення і редагування записів.
5. Глобальні змінні:
•	current_columns: список назв колонок поточної таблиці.
•	current_table: назва активної таблиці.
•	entries: словник полів вводу для кожного стовпця.
•	edit_mode: чи активований режим редагування.
•	edited_pk_value: значення первинного ключа редагованого запису.
•	full_df: повний DataFrame для вибраної таблиці.
6. Основні функції:
•	load_table_names(): отримує список усіх таблиць у базі даних і показує їх у випадаючому списку.
•	load_table(): завантажує вибрану таблицю, створює поля для вводу даних згідно з її стовпцями.
•	update_treeview(df): оновлює вміст таблиці в інтерфейсі, використовуючи DataFrame.
•	search_records(): виконує пошук за рядками, де зустрічається введений текст.
•	add_row(): зчитує значення з полів, формує SQL-запит INSERT, додає новий запис у таблицю.
•	delete_row(): видаляє вибраний рядок з таблиці, шукає значення за первинним ключем.
•	edit_row(): у двох режимах:
o	Якщо edit_mode = False — заповнює форму даними з вибраного рядка.
o	Якщо edit_mode = True — оновлює дані через SQL UPDATE.
•	get_primary_key(table): повертає назву стовпця первинного ключа для заданої таблиці.
•	get_identity_columns(table): визначає, які поля є автоінкрементними (наприклад, ID).
7. Завершення роботи:
•	load_table_names() запускається при старті програми, щоб одразу завантажити список таблиць.
•	root.mainloop() запускає цикл обробки подій Tkinter.

Підсумок:
Це інтерфейсна програма для взаємодії з базою даних: перегляд таблиць, пошук записів, додавання, редагування та видалення. Вона автоматично підлаштовується під структуру таблиці й виконує SQL-запити через безпечний механізм text() з SQLAlchemy. Усе зроблено у зручному GUI, придатному для користувачів без знання SQL.

 ![image](https://github.com/user-attachments/assets/73aec06e-3450-4010-80d8-9368cb46f8d7)

![image](https://github.com/user-attachments/assets/0b1b4274-a865-4aca-9f32-b503129a779b)

![image](https://github.com/user-attachments/assets/053d1169-52bf-4c7d-a314-c7f6a11bb0e7)

  Рисунок 4-6 – виконання завдання 3-6. Створення додатка мовою Python з базою даних MSSQL.
Висновки:
Під час виконання завдання я ознайомилася з основними принципами побудови клієнт-серверних додатків, реалізованих мовою програмування Python з використанням бібліотеки Tkinter для створення графічного інтерфейсу користувача. Хоча початково завдання було орієнтоване на використання C# та Windows Forms, я застосувала аналогічні підходи у середовищі Python.
Вивчила способи підключення до бази даних за допомогою бібліотеки SQLAlchemy, яка є потужним інструментом для роботи з реляційними базами даних і виконує роль альтернативи ADO.NET. Навчилася працювати з рядком підключення (Connection String), який зберігається у конфігураційному файлі config.ini, що відповідає функціоналу App.config у середовищі .NET.
Реалізувала відображення, додавання, редагування та видалення записів у базі даних через компонент Treeview, що є аналогом DataGridView у Windows Forms. Забезпечила підтримку базових операцій над даними у межах багаторівневої архітектури клієнт-серверного додатку.
Отже, завдання було виконано повністю з використанням засобів мови Python, що дозволило на практиці засвоїти концепції роботи з базами даних та створення GUI-додатків, аналогічних за функціоналом до Windows Forms.

Посилання на конспект: https://docs.google.com/document/d/1cQ80CNWDVrDLPALv9pUK2ATEX58BABgg/edit?usp=drive_link&ouid=106130475242017779182&rtpof=true&sd=true

