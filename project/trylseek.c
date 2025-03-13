#include "user.h"
#include "fcntl.h"

int main() {
    int fd = open("testfile", O_CREATE | O_RDWR);
    if (fd < 0) {
        printf(1, "Error opening file\n");
        exit();
    }

    write(fd, "hello", 5);
    lseek(fd, 2, SEEK_SET);  // Move to 2nd byte
    write(fd, "X", 1);       // Overwrite 3rd byte

    close(fd);
    exit();
}

