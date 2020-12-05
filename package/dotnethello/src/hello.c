#include <stdio.h>
int func01()
{
       char *str;
       str="HAHA";
       *(str+1) = 'n';
       return 0;
}

int main(void) {
    puts("hello");
    func01();
}
