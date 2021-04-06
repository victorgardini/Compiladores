%INICIO_PROGRAMA%
    // Programa exemplo utilizando estruturas de
    // repetição e de condição
    int var1 = 1;
    int var2 = 5;
    int var3;
    float var4;

    if (var1 >= var2){
        display("O valor de var1 é maior que o de var2.");
    } else {
        display("O valor de var1 é menor que o de var2.");
    }

    // Exemplo utilizando o laço for
    for (int i=0; i!=10; i=i+1) {
        if (i < 5) {
            var3 = var1 / i;
        }
        else {
            var2 = var1 / i;
        }
    }

    // Exemplo utilizando o laço while
    while (var3 < 10) {
        var3 = var3 + 1;
        if (var1 != 4 or var2 <= 8) {
            teste = var1 + (var2 * var3);
        } else {
            teste = (var1 - var3) / var2;
        }
    }
%FIM_PROGRAMA%