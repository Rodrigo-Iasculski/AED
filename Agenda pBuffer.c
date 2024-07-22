#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAM_NOME 1000
#define TAM_IDADE sizeof( int )
#define TAM_EMAIL 1000
#define TAM_VARIAVEIS ( TAM_NOME + TAM_IDADE + TAM_EMAIL + 2 * sizeof(void *) )

void *cabeca = NULL;

void AdicionarPessoas( void* pBuffer );
void BuscarPessoas( void* pBuffer );
void RemoverPessoas( void* pBuffer );
void ListarPessoas( void );

int main() {
    void* pBuffer = malloc(TAM_VARIAVEIS);
    if (pBuffer == NULL) {
        printf("====================");
        printf("\nNao foi possivel alocar memoria\n");
        printf("====================");
        return EXIT_FAILURE;
    }

    int* opcao = (int*)pBuffer;
    *opcao = 0;

    do {
        printf("\nEscolha qual opcao voce deseja:\n");
        printf("1 - Adicionar Pessoa\n2 - Remover Pessoa\n3 - Buscar Pessoa\n4 - Listar Pessoas\n5 - Sair\n\n");
        scanf("%d", opcao);
        getchar();

        switch ( *opcao ) {
            case 1:
                AdicionarPessoas(pBuffer);
                break;

            case 2:
                RemoverPessoas(pBuffer);
                break;

            case 3:
                BuscarPessoas(pBuffer);
                break;

            case 4:
                ListarPessoas();
                break;

            case 5:
                printf("\nSaindo\n");
                break;

            default:
                printf("\nOpcao nao encontrada\n");
                break;
        }
    } while ( *opcao != 5 );

    void* atual = cabeca;
    while ( atual != NULL ) {
        void* proximo = *(void**)(atual + TAM_NOME + TAM_IDADE + TAM_EMAIL);
        free(atual);
        atual = proximo;
    }

    free(pBuffer);
    return 0;
}

void AdicionarPessoas( void* pBuffer ) {
    void *nome = pBuffer;
    void *idade = nome + TAM_NOME;
    void *email = idade + TAM_IDADE;

    printf("\nNome: ");
    fgets((char *)nome, TAM_NOME, stdin);
    ((char *)nome)[strcspn((char *)nome, "\n")] = 0;

    printf("\nIdade: ");
    scanf("%d", (int *)idade);
    getchar();

    printf("\nEmail: ");
    fgets((char *)email, TAM_EMAIL, stdin);
    ((char *)email)[strcspn((char *)email, "\n")] = 0;

    void* novo_pBuffer = malloc(TAM_VARIAVEIS);
    if (novo_pBuffer == NULL) {
        printf("====================");
        printf("\nNao foi possivel alocar memoria\n");
        printf("====================");
        exit(EXIT_FAILURE);
    }

    void *novoNomeNo = novo_pBuffer;
    void *novoIdadeNo = novoNomeNo + TAM_NOME;
    void *novoEmailNo = novoIdadeNo + TAM_IDADE;
    void **prox = (void**)(novoEmailNo + TAM_EMAIL);
    void **ante = prox + 1;
    *prox = NULL;
    *ante = NULL;
    strcpy((char *)novoNomeNo, (char *)nome);
    strcpy((char *)novoEmailNo, (char *)email);
    *(int *)novoIdadeNo = *(int *)idade;

    if (cabeca == NULL) {
        cabeca = novo_pBuffer;
    } else {
        void *atual = cabeca;
        void *anterior = NULL;

        while (atual != NULL && strcmp((char *)atual, (char *)nome) < 0) {
            anterior = atual;
            atual = *(void **)(atual + TAM_NOME + TAM_IDADE + TAM_EMAIL);
        }

        if (anterior == NULL) {
            *prox = cabeca;
            *(void **)(cabeca + TAM_NOME + TAM_IDADE + TAM_EMAIL + sizeof(void *)) = novo_pBuffer;
            cabeca = novo_pBuffer;
        } else {
            *prox = atual;
            *ante = anterior;
            *(void **)(anterior + TAM_NOME + TAM_IDADE + TAM_EMAIL) = novo_pBuffer;
            if (atual != NULL) {
                *(void **)(atual + TAM_NOME + TAM_IDADE + TAM_EMAIL + sizeof(void *)) = novo_pBuffer;
            }
        }
    }
}

void BuscarPessoas( void* pBuffer ) {
    void *nome = pBuffer;

    printf("Nome: ");
    fgets((char *)nome, TAM_NOME, stdin);
    ((char *)nome)[strcspn((char *)nome, "\n")] = 0;

    void *atual = cabeca;
    while (atual != NULL && strcmp((char *)atual, (char *)nome) != 0) {
        atual = *(void **)(atual + TAM_NOME + TAM_IDADE + TAM_EMAIL);
    }

    if (atual == NULL) {
        printf("====================");
        printf("\nPessoa nao encontrada.\n");
        printf("====================");
    } else {
		printf("====================");
        printf("\nNome: %s\n", (char *)atual);
        printf("Idade: %d\n", *(int *)(atual + TAM_NOME));
        printf("Email: %s\n", (char *)(atual + TAM_NOME + TAM_IDADE));
		printf("====================");
    }
}

void RemoverPessoas( void* pBuffer ) {
    void *nome = pBuffer;

    printf("Nome: ");
    fgets((char *)nome, TAM_NOME, stdin);
    ((char *)nome)[strcspn((char *)nome, "\n")] = 0;

    void *atual = cabeca;
    void *anterior = NULL;

    while ( atual != NULL && strcmp((char *)atual, (char *)nome) != 0 ) {
        anterior = atual;
        atual = *(void **)(atual + TAM_NOME + TAM_IDADE + TAM_EMAIL);
    }

    if ( atual == NULL ) {
        printf("====================");
        printf("\nPessoa nao encontrada.\n");
        printf("====================");
    } else {
        if ( anterior == NULL ) {
            cabeca = *(void **)(atual + TAM_NOME + TAM_IDADE + TAM_EMAIL);
            if (cabeca != NULL) {
                *(void **)(cabeca + TAM_NOME + TAM_IDADE + TAM_EMAIL + sizeof(void *)) = NULL;
            }
        } else {
            *(void **)(anterior + TAM_NOME + TAM_IDADE + TAM_EMAIL) = *(void **)(atual + TAM_NOME + TAM_IDADE + TAM_EMAIL);
            if (*(void **)(atual + TAM_NOME + TAM_IDADE + TAM_EMAIL) != NULL) {
                *(void **)(*(void **)(atual + TAM_NOME + TAM_IDADE + TAM_EMAIL) + TAM_NOME + TAM_IDADE + TAM_EMAIL + sizeof(void *)) = anterior;
            }
        }
        free(atual);
        printf("====================");
        printf("\nPessoa removida com sucesso.\n");
        printf("====================");
    }
}

void ListarPessoas( void ) {
    void *atual = cabeca;
    if ( atual == NULL ) {
        printf("====================");
        printf("\nSem dados na agenda\n");
        printf("====================\n");
        return;
    }

    while ( atual != NULL ) {
        printf("====================\n");
        printf("Nome: %s\n", (char *)atual);
        printf("Idade: %d\n", *(int *)(atual + TAM_NOME));
        printf("Email: %s\n", (char *)(atual + TAM_NOME + TAM_IDADE));
        printf("====================\n");
        atual = *(void **)(atual + TAM_NOME + TAM_IDADE + TAM_EMAIL);
    }
}
