#include <stdint.h>
extern int lab3(void);
extern int serial_init(void);


int main()
{
   serial_init();
   lab3();
}
