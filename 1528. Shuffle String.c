#include <stdio.h>

char *restoreString( char *s, int *indices, int indicesSize );

int main()
{
    char s[] = "codeleet";
    int indices[] = { 4, 5, 6, 7, 0, 2, 1, 3 };
    int indicesSize = sizeof(indices) / sizeof(indices[0]);
    restoreString(s, indices, indicesSize);
    printf("%s\n", s);
}

char *restoreString( char *s, int *indices, int indicesSize )
{
    char b[indicesSize];
    int i;
    for ( i = 0; i < indicesSize; i++ ) {
        b[indices[i]] = s[i];
    }
    
    for ( i = 0; i < indicesSize; i++ ) {
        s[i] = b[i];
    }
    return s;
}
