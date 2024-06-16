/*Exercício 1528 do LeetCode sobre embaralhamento de Strings
C O D E L E E T = s
0 1 2 3 4 5 6 7 = j

4 5 6 7 0 2 1 3 = indices

L E E T C O D E = b
0 1 2 3 4 5 6 7 = j
*/

char *restoreString(char *s, int *indices, int indicesSize)
{
    char b[indicesSize];
    int j;
    for (j = 0; j < indicesSize; j++)
    {
        b[indices[j]] = s[j];
    }

    for (j = 0; j < indicesSize; j++)
    {
        s[j] = b[j];
    }

    return s;
}
