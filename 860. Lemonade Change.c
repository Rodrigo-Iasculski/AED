bool lemonadeChange(int* bills, int billsSize) {
    int troco5 = 0;
    int troco10 = 0;
    int troco20 = 0;
    //int tamanho = strlen(bills);
    for (int i = 0; i < billsSize; i++) {
        if (bills[i] == 5) {
            troco5 = troco5 + 1;
        // 10
        } else if (bills[i] == 10 && troco5 >= 1) {
            troco5 -= 1;
            troco10++;
        } else if (bills[i] == 10 && troco5 == 0) {
            return false;   
        // 20
        } else if (bills[i] == 20 && troco5 >= 1 && troco10 >= 1) {
            troco5 = troco5 - 1;
            troco10 -= 1;
            troco20++;
        } else if (bills[i] == 20 && troco5 >= 3 && troco10 == 0) {
            troco5 = troco5 - 3;
            troco20++;
        }
        else if(bills[i] == 20 && troco5 == 1 && troco10 == 0){  
            return false;
        }else{
            return false;
        }
    }
    return true;
}


//Versão Mais Clean

#include <stdio.h>
#include <stdbool.h>

bool lemonadeChange( int *bills, int billsSize );

int main() {
    int bills[] = { 5, 5, 5, 10, 20, 5, 5, 5, 5 };          // Verdadeiro
    //int bills[] = { 5, 5, 10, 20, 5, 5, 5, 5, 20, 20 };   // Falso
    //int bills[] = { 20, 5, 5, 10, 20, 5, 5, 5, 5 };       // Falso
    int billsSize = sizeof(bills) / 4;

    if ( lemonadeChange(bills, billsSize) ) {
        printf("Verdadeiro\n");
    } else {
        printf("Falso\n");
    }
    return 0;
}

bool lemonadeChange( int *bills, int billsSize ) {
    int troco5 = 0;
    int troco10 = 0;
    for ( int i = 0; i < billsSize; i++ )
    {
        if ( bills[i] == 5 ) {
            troco5++;
        } else if ( bills[i] == 10 && troco5 >= 1 ) {
            troco5--;
            troco10++;
        } else if ( bills[i] == 20 && troco5 >= 1 && troco10 >= 1 ) {
            troco5--;
            troco10--;
        } else if ( bills[i] == 20 && troco5 >= 3 && troco10 == 0 ) {
            troco5 -= 3;
        } else {
            return false;
        }
    }
    return true;
}
