#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAX_LENGTH 50

// Структура інформації для студента
typedef struct {
    char StLastName[MAX_LENGTH];
    char StFirstName[MAX_LENGTH];
    int Grade;
    int Classroom;
    int Bus;
    char TLastName[MAX_LENGTH];
    char TFirstName[MAX_LENGTH];
} Student;

// Структура інформації для викладача
typedef struct {
    char TLastName[MAX_LENGTH];
    char TFirstName[MAX_LENGTH];
} Teacher;

// Прототипи функцій
void loadStudents();
void saveStudents();
void searchByStudentName(char *lastName, int showBus);
void searchByTeacherName(char *lastName);
void searchByClassroom(int classroom);
void searchByBus(int bus);
void addStudent();
void addTeacher();
void showStatistics();
int countUniqueTeachers();
int countUniqueStudents();
void handleUserInput();

// Глобальні змінні
Student *students = NULL;
Teacher *teachers = NULL;
int studentCount = 0;
int teacherCount = 0;
int studentCapacity = 1000;
int teacherCapacity = 100;

// для зчитування даних
void loadStudents() {
    FILE *file = fopen("students.txt", "r");
    if (!file) {
        printf("Error: cannot open students.txt\n");
        exit(1);
    }

    students = malloc(studentCapacity * sizeof(Student));
    if (!students) {
        printf("Error: memory allocation failed\n");
        fclose(file);
        exit(1);
    }

    while (fscanf(file, "%[^,], %[^,], %d, %d, %d, %[^,], %[^\n]\n",
                  students[studentCount].StLastName,
                  students[studentCount].StFirstName,
                  &students[studentCount].Grade,
                  &students[studentCount].Classroom,
                  &students[studentCount].Bus,
                  students[studentCount].TLastName,
                  students[studentCount].TFirstName) != EOF) {
        studentCount++;
        if (studentCount >= studentCapacity) {
            studentCapacity *= 2;
            students = realloc(students, studentCapacity * sizeof(Student));
            if (!students) {
                printf("Error: memory reallocation failed\n");
                fclose(file);
                exit(1);
            }
        }
    }

    fclose(file);
}

// для збереження студентів у файл
void saveStudents() {
    FILE *file = fopen("students.txt", "w");
    if (!file) {
        printf("Error: cannot open students.txt for writing\n");
        return;
    }

    for (int i = 0; i < studentCount; i++) {
        fprintf(file, "%s, %s, %d, %d, %d, %s, %s\n",
                students[i].StLastName,
                students[i].StFirstName,
                students[i].Grade,
                students[i].Classroom,
                students[i].Bus,
                students[i].TLastName,
                students[i].TFirstName);
    }

    fclose(file);
}

//для пошуку студентів за прізвищем
void searchByStudentName(char *lastName, int showBus) {
    int found = 0;
    clock_t start = clock();
    for (int i = 0; i < studentCount; i++) {
        if (strcmp(students[i].StLastName, lastName) == 0) {
            found = 1;
            if (showBus) {
                printf("%s, %s, Bus Route: %d\n", students[i].StLastName, students[i].StFirstName, students[i].Bus);
            } else {
                printf("%s, %s, Grade: %d, Classroom: %d, Teacher: %s, %s\n",
                       students[i].StLastName, students[i].StFirstName,
                       students[i].Grade, students[i].Classroom,
                       students[i].TLastName, students[i].TFirstName);
            }
        }
    }
    if (!found) {
        printf("No students found with last name: %s\n", lastName);
    }
    clock_t end = clock();
    printf("Search Time: %.4f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);
}

// для пошуку студентів за прізвищем викладача
void searchByTeacherName(char *lastName) {
    int found = 0;
    clock_t start = clock();
    for (int i = 0; i < studentCount; i++) {
        if (strcmp(students[i].TLastName, lastName) == 0) {
            found = 1;
            printf("%s, %s\n", students[i].StLastName, students[i].StFirstName);
        }
    }
    if (!found) {
        printf("No students found for teacher: %s\n", lastName);
    }
    clock_t end = clock();
    printf("Search Time: %.4f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);
}

//для пошуку студентів за класом
void searchByClassroom(int classroom) {
    int found = 0;
    clock_t start = clock();
    for (int i = 0; i < studentCount; i++) {
        if (students[i].Classroom == classroom) {
            found = 1;
            printf("%s, %s\n", students[i].StLastName, students[i].StFirstName);
        }
    }
    if (!found) {
        printf("No students found in classroom: %d\n", classroom);
    }
    clock_t end = clock();
    printf("Search Time: %.4f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);
}

// для пошуку студентів за номером автобуса
void searchByBus(int bus) {
    int found = 0;
    clock_t start = clock();
    for (int i = 0; i < studentCount; i++) {
        if (students[i].Bus == bus) {
            found = 1;
            printf("%s, %s, Grade: %d, Classroom: %d\n",
                   students[i].StLastName, students[i].StFirstName,
                   students[i].Grade, students[i].Classroom);
        }
    }
    if (!found) {
        printf("No students found on bus route: %d\n", bus);
    }
    clock_t end = clock();
    printf("Search Time: %.4f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);
}

// для додавання студента
void addStudent() {
    if (studentCount >= studentCapacity) {
        studentCapacity *= 2;
        students = realloc(students, studentCapacity * sizeof(Student));
        if (!students) {
            printf("Error: memory reallocation failed\n");
            exit(1);
        }
    }

    printf("Enter student's last name: ");
    scanf("%s", students[studentCount].StLastName);
    printf("Enter student's first name: ");
    scanf("%s", students[studentCount].StFirstName);
    printf("Enter student's grade: ");
    scanf("%d", &students[studentCount].Grade);
    printf("Enter student's classroom: ");
    scanf("%d", &students[studentCount].Classroom);
    printf("Enter student's bus route: ");
    scanf("%d", &students[studentCount].Bus);
    printf("Enter teacher's last name: ");
    scanf("%s", students[studentCount].TLastName);
    printf("Enter teacher's first name: ");
    scanf("%s", students[studentCount].TFirstName);

    studentCount++;
    printf("Student added successfully!\n");

    // збереження  даних в файл
    saveStudents();
}

//  для додавання викладача
void addTeacher() {
    if (teacherCount >= teacherCapacity) {
        teacherCapacity *= 2;
        teachers = realloc(teachers, teacherCapacity * sizeof(Teacher));
        if (!teachers) {
            printf("Error: memory reallocation failed\n");
            exit(1);
        }
    }

    printf("Enter teacher's last name: ");
    scanf("%s", teachers[teacherCount].TLastName);
    printf("Enter teacher's first name: ");
    scanf("%s", teachers[teacherCount].TFirstName);

    teacherCount++;
    printf("Teacher added successfully!\n");
}

// для підрахунку унікальних викладачів
int countUniqueTeachers() {
    int uniqueTeachers = 0;
    for (int i = 0; i < studentCount; i++) {
        int isUnique = 1;
        for (int j = 0; j < i; j++) {
            if (strcmp(students[i].TLastName, students[j].TLastName) == 0) {
                isUnique = 0;
                break;
            }
        }
        if (isUnique) {
            uniqueTeachers++;
        }
    }
    return uniqueTeachers;
}

// для підрахунку унікальних студентів
int countUniqueStudents() {
    int uniqueStudents = 0;
    for (int i = 0; i < studentCount; i++) {
        int isUnique = 1;
        for (int j = 0; j < i; j++) {
            if (strcmp(students[i].StLastName, students[j].StLastName) == 0 &&
                strcmp(students[i].StFirstName, students[j].StFirstName) == 0) {
                isUnique = 0;
                break;
            }
        }
        if (isUnique) {
            uniqueStudents++;
        }
    }
    return uniqueStudents;
}

// для відображення статистики
void showStatistics() {
    int uniqueTeachers = countUniqueTeachers();
    int uniqueStudents = countUniqueStudents();
    printf("Total students: %d\n", studentCount);
    printf("Total unique students: %d\n", uniqueStudents);
    printf("Total unique teachers: %d\n", uniqueTeachers);
}
// для обробки введення користувача
void handleUserInput() {
    char command[MAX_LENGTH];
    while (1) {
        printf("Enter a command (S[Student]: <lastname>, T[Teacher]: <lastname>, C[Classroom]: <number>, B[Bus]: <number>, A[dd student], AT[dd teacher], ST[ats], Q[uit]): ");
        fgets(command, MAX_LENGTH, stdin);

        if (strncmp(command, "Q", 1) == 0) {
            break;
        } else if (strncmp(command, "A", 1) == 0) {
            addStudent();
        } else if (strncmp(command, "AT", 2) == 0) {
            addTeacher();
        } else if (strncmp(command, "ST", 2) == 0) {
            showStatistics();
        } else if (strncmp(command, "S ", 2) == 0) {
            char lastName[MAX_LENGTH];
            int showBus = 0;
            if (sscanf(command, "S %s B", lastName) == 1) {
                showBus = 1;
            } else {
                sscanf(command, "S %s", lastName);
            }
            searchByStudentName(lastName, showBus);
        } else if (strncmp(command, "T ", 2) == 0) {
            char lastName[MAX_LENGTH];
            sscanf(command, "T %s", lastName);
            searchByTeacherName(lastName);
        } else if (strncmp(command, "C ", 2) == 0) {
            int classroom;
            sscanf(command, "C %d", &classroom);
            searchByClassroom(classroom);
        } else if (strncmp(command, "B ", 2) == 0) {
            int bus;
            sscanf(command, "B %d", &bus);
            searchByBus(bus);
        } else {
            printf("Invalid command. Please try again.\n");
        }
    }
}

int main() {
    loadStudents();
    handleUserInput();

    free(students);
    free(teachers);
    return 0;
}