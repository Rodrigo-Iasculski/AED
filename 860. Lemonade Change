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

bool lemonadeChange(int* bills, int billsSize) {
    int troco5 = 0;
    int troco10 = 0;
    for (int i = 0; i < billsSize; i++) {
        if (bills[i] == 5) {
            troco5++;
        } else if (bills[i] == 10 && troco5 >= 1) {
            troco5--;
            troco10++;
        } else if (bills[i] == 20 && troco5 >= 1 && troco10 >= 1) {
            troco5 -= 1;
            troco10 -= 1;
        } else if (bills[i] == 20 && troco5 >= 3 && troco10 == 0) {
            troco5 -= 3;
        } else {
            return false;
        }
    }
    return true;
}
