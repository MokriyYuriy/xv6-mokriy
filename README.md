# XV6-MOKRIY

- Студент: Юрий Мокрий
- Группа: 141
---

###### Выполненные цели:
1.  0-й коммит, являющийся копией исходного проекта xv6-public.
2.  Hello, world!
3.  README
4.  Расширены возможности системного вызова exec:  
Может выполнять скрипты (интерпритатор может быть тоже скриптом и принимать собственные аргументы).  
Пример:  
    ```sh
    $ cat > 1  
    #!echo 5 6  
    $ cat > 2  
    #!1 3 4  
    $ 2  
    5 6 1 3 4 2
    ```
5. Реализованы fifo файлы: 
    1. Добавлен системный вызов mkfifo, создающий fifo файл.
    2. При открытии fifo файла на запись, open блокируется до открытия на запись, и наоборот.
    3. Добавлен флаг O_NBLOCK, который при открытии fifo файла, не даёт создать pipe и делать блокировку, и вместо FD_PIPE дескриптора создаёт FD_NODE. Это помогает ls не зависать на fifo файлах.  
Примеры:  
        ```bash
        $ mkfifo fifo
        $ echo 123 > fifo &
        $ cat fifo
        zombie!
        123
        $
        ```
        ```bash
        $ mkfifo f1
        $ mkfifo f2
        $ cat f1 > f2 &
        $ cat f2 &
        $ echo 123 > f1
        123
        zombie!
        zombie!
        $
        ```