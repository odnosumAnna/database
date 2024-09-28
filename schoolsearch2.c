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
} Student;

// Структура інформації для викладача
typedef struct {
    char TLastName[MAX_LENGTH];
    char TFirstName[MAX_LENGTH];
    int Classroom;
} Teacher;

// Прототипи функцій
void loadStudents();
void loadTeachers();
void saveStudents();
void searchByStudentName(char *lastName, int showBus);
void searchByTeacherName(char *lastName);
void searchByClassroom(int classroom);
void searchByBus(int bus);
void searchStudentsByGrade(int grade);
void searchTeachersByGrade(int grade);
void addStudent();
void addTeacher();
void showStatistics();
void handleUserInput();
void searchTeachersByClassroom(int classroom);

// глобальні змінні
Student *students = NULL;
Teacher *teachers = NULL;
int studentCount = 0;
int teacherCount = 0;
int studentCapacity = 1000;
int teacherCapacity = 100;

// для зчитування даних
void loadStudents() {
    FILE *file = fopen("list.txt", "r");
    if (!file) {
        printf("Error: cannot open list.txt\n");
        exit(1);
    }

    students = malloc(studentCapacity * sizeof(Student));
    if (!students) {
        printf("Error: memory allocation failed\n");
        fclose(file);
        exit(1);
    }

    while (fscanf(file, "%[^,], %[^,], %d, %d, %d\n",
                  students[studentCount].StLastName,
                  students[studentCount].StFirstName,
                  &students[studentCount].Grade,
                  &students[studentCount].Classroom,
                  &students[studentCount].Bus) != EOF) {
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

// для зчитування даних викладачів
void loadTeachers() {
    FILE *file = fopen("teachers.txt", "r");
    if (!file) {
        printf("Error: cannot open teachers.txt\n");
        exit(1);
    }

    teachers = malloc(teacherCapacity * sizeof(Teacher));
    if (!teachers) {
        printf("Error: memory allocation failed\n");
        fclose(file);
        exit(1);
    }

    while (fscanf(file, "%[^,], %[^,], %d\n",
                  teachers[teacherCount].TLastName,
                  teachers[teacherCount].TFirstName,
                  &teachers[teacherCount].Classroom) != EOF) {
        teacherCount++;
        if (teacherCount >= teacherCapacity) {
            teacherCapacity *= 2;
            teachers = realloc(teachers, teacherCapacity * sizeof(Teacher));
            if (!teachers) {
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
    FILE *file = fopen("list.txt", "w");
    if (!file) {
        printf("Error: cannot open list.txt for writing\n");
        return;
    }

    for (int i = 0; i < studentCount; i++) {
        fprintf(file, "%s, %s, %d, %d, %d\n",
                students[i].StLastName,
                students[i].StFirstName,
                students[i].Grade,
                students[i].Classroom,
                students[i].Bus);
    }

    fclose(file);
}

// для пошуку студентів за прізвищем
void searchByStudentName(char *lastName, int showBus) {
    int found = 0;
    clock_t start = clock();
    for (int i = 0; i < studentCount; i++) {
        if (strcmp(students[i].StLastName, lastName) == 0) {
            found = 1;
            if (showBus) {
                printf("%s, %s, Bus Route: %d\n", students[i].StLastName, students[i].StFirstName, students[i].Bus);
            } else {
                printf("%s, %s, Grade: %d, Classroom: %d\n",
                       students[i].StLastName, students[i].StFirstName,
                       students[i].Grade, students[i].Classroom);
            }
        }
    }
    if (!found) {
        printf("No students found with last name: %s\n", lastName);
    }
    clock_t end = clock();
    printf("Search Time: %.4f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);
}

// для пошуку викладачів за прізвищем
void searchByTeacherName(char *lastName) {
    int found = 0;
    clock_t start = clock();
    for (int i = 0; i < teacherCount; i++) {
        if (strcmp(teachers[i].TLastName, lastName) == 0) {
            found = 1;
            printf("%s, %s, Classroom: %d\n", teachers[i].TLastName, teachers[i].TFirstName, teachers[i].Classroom);
        }
    }
    if (!found) {
        printf("No teachers found with last name: %s\n", lastName);
    }
    clock_t end = clock();
    printf("Search Time: %.4f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);
}

// для пошуку студентів за класом
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

    studentCount++;
    printf("Student added successfully!\n");

    // збереження даних в файл
    saveStudents();
}

// для додавання викладача
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
    printf("Enter teacher's classroom: ");
    scanf("%d", &teachers[teacherCount].Classroom);

    teacherCount++;
    printf("Teacher added successfully!\n");

    FILE *file = fopen("teachers.txt", "a");
    if (!file) {
        printf("Error: cannot open teacher.txt for writing\n");
        return;
    }
    fprintf(file, "%s, %s, %d\n", teachers[teacherCount - 1].TLastName,
            teachers[teacherCount - 1].TFirstName,
            teachers[teacherCount - 1].Classroom);
    fclose(file);
}

void showStatistics() {
    printf("Total Students: %d\n", studentCount);
    printf("Total Teachers: %d\n", teacherCount);
}
// для пошуку студентів за номером класу (Grade)
void searchStudentsByGrade(int grade) {
    int found = 0;
    clock_t start = clock();
    for (int i = 0; i < studentCount; i++) {
        if (students[i].Grade == grade) {
            found = 1;
            printf("%s, %s, Classroom: %d, Bus: %d\n",
                   students[i].StLastName, students[i].StFirstName,
                   students[i].Classroom, students[i].Bus);
        }
    }
    if (!found) {
        printf("No students found in grade: %d\n", grade);
    }
    clock_t end = clock();
    printf("Search Time: %.4f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);
}

// для пошуку викладачів за класом (Classroom)
void searchTeachersByClassroom(int classroom) {
    int found = 0;
    clock_t start = clock();
    for (int i = 0; i < teacherCount; i++) {
        if (teachers[i].Classroom == classroom) {
            found = 1;
            printf("%s, %s\n", teachers[i].TLastName, teachers[i].TFirstName);
        }
    }
    if (!found) {
        printf("No teachers found for classroom: %d\n", classroom);
    }
    clock_t end = clock();
    printf("Search Time: %.4f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);
}

// для пошуку викладачів, які викладають певний клас (Grade)
void searchTeachersByGrade(int grade) {
    int found = 0;
    clock_t start = clock();
    for (int i = 0; i < teacherCount; i++) {
        for (int j = 0; j < studentCount; j++) {
            if (students[j].Grade == grade && teachers[i].Classroom == students[j].Classroom) {
                found = 1;
                printf("%s, %s\n", teachers[i].TLastName, teachers[i].TFirstName);
            }
        }
    }
    if (!found) {
        printf("No teachers found for grade: %d\n", grade);
    }
    clock_t end = clock();
    printf("Search Time: %.4f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);
}

void handleUserInput() {
    char command[100];

    while (1) {
        printf("Enter a command (S[Student]: <lastname>, T[Teacher]: <lastname>, C[Classroom]: <number>, B[Bus]: <number>, G[Grade]: +<number>, G[Grade]: <number+ T[eacher], C[Classroom]: <number> T[eacher], A[dd student], AT[dd teacher], ST[ats], Q[uit]): ");
        fgets(command, sizeof(command), stdin);
        command[strcspn(command, "\n")] = 0;  

        if (strcmp(command, "Q") == 0) {
            printf("goodbye!!!\n");
            break;
        } else if (strcmp(command, "A") == 0) {
            addStudent();
        } else if (strcmp(command, "AT") == 0) {
            addTeacher();
        } else if (strncmp(command, "S ", 2) == 0) {
            searchByStudentName(command + 2, 0);
        } else if (strncmp(command, "T ", 2) == 0) {
            searchByTeacherName(command + 2);
        } else if (strncmp(command, "C ", 2) == 0) {
            int classroom;
            sscanf(command + 2, "%d", &classroom);
            searchByClassroom(classroom);
        } else if (strncmp(command, "B ", 2) == 0) {
            int bus;
            sscanf(command + 2, "%d", &bus);
            searchByBus(bus);
        } else if (strncmp(command, "G+ ", 3) == 0) {
            int grade;
            sscanf(command + 3, "%d", &grade);
            searchStudentsByGrade(grade);
        } else if (strncmp(command, "G< ", 3) == 0) {
            int grade;
            sscanf(command + 3, "%d", &grade);
            searchTeachersByGrade(grade);
        } else if (strncmp(command, "C ", 2) == 0 && strstr(command, " T") != NULL) {
            int classroom;
            sscanf(command + 2, "%d", &classroom);
            searchTeachersByClassroom(classroom);
        } else if (strcmp(command, "ST") == 0) {
            showStatistics();
        } else {
            printf("Unknown command\n");
        }
    }
}


int main() {
    loadStudents();
    loadTeachers();
    handleUserInput();

    free(students);
    free(teachers);
    return 0;
}
