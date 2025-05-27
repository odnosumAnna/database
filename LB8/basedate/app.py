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
