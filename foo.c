#include <stdio.h>

#define MAXLINE  1000   /* максимальная длина строки */

/* запрашивает строку и символ, определяя количество его вхождений */
int main()
{
  unsigned char line[MAXLINE], *p;
  unsigned int alphabet[128];

  for(unsigned int i = 0; i < 128; i++){
    alphabet[i]=0;
  }
  alphabet[10] = -1;

  fgets(line, MAXLINE, stdin);

  for (p = line; *p != '\0'; p++){
    if((int)*p > 127)
      printf("Incorrect value %c, ASCII: %d", *p, (int)*p);
    alphabet[(int)*p]++;
  }

  for (unsigned int i = 0; i < 128; i++){
    if(alphabet[i]!=0){
      printf("ASCII:%d CHAR:%c COUNT:%d\n", i, i, alphabet[i]);
    }
  }

  return 0;
}
