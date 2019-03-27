#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
static FILE *f;
static int ch;
static unsigned int val = 0;
static unsigned int sum;
enum
{
    plus,
    minus,
    times,
    divide,
    mod,
    lparen,
    rparen,
    number,
    eof,
    illegal
};
typedef struct NodeDesc *Node;
typedef struct NodeDesc
{
    char kind;
    // plus, minus, times, divide, number
    int val;
    // number: value
    Node left, right; // plus, minus, times, divide: children
} NodeDesc;

static void SInit(char *filename)
{
    ch = EOF;
    f = fopen(filename, "r+t");
    if (f != NULL)
        ch = getc(f);
}
static void Number()
{
    val = 0;
    while (('0' <= ch) && (ch <= '9'))
    {
        val = val * 10 + ch - '0';
        ch = getc(f);
    }
}
static int SGet()
{
    register int sym;
    while ((ch != EOF) && (ch <= ' '))
        ch = getc(f);
    switch (ch)
    {
    case EOF:
        sym = eof;
        break;
    case '+':
        sym = plus;
        ch = getc(f);
        break;
    case '-':
        sym = minus;
        ch = getc(f);
        break;
    case '*':
        sym = times;
        ch = getc(f);
        break;
    case '/':
        sym = divide;
        ch = getc(f);
        break;
    case '%':
        sym = mod;
        ch = getc(f);
        break;
    case '(':
        sym = lparen;
        ch = getc(f);
        break;
    case ')':
        sym = rparen;
        ch = getc(f);
        break;
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9':
        sym = number;
        Number();
        break;
    default:
        sym = illegal;
    }
    return sym;
}
static int sym;
static Node Expr();
static Node Factor()
{
    register Node result;
    assert((sym == number) || (sym == lparen));
    if (sym == number)
    {
        sym = SGet();
        result = malloc(sizeof(NodeDesc));
        result->kind = number;
        result->val = val;
        result->left = NULL;
        result->right = NULL;
    }
    else
    {
        sym = SGet();
        result = Expr();
        assert(sym == rparen);
        sym = SGet();
    }
    return result;
}
static Node Term()
{
    register Node left = Factor();

    register Node result = left;

    while ((sym == times) || (sym == divide) || (sym == mod))
    {
        result = malloc(sizeof(NodeDesc));

        result->kind = sym;
        sym = SGet();

        register Node right = Factor();
        result->left = left;
        result->right = right;

        left = result;
    }
    return result;
}
static Node Expr()
{
    register Node left = Term();
    register Node result = left;

    while ((sym == plus) || (sym == minus))
    {
        result = malloc(sizeof(NodeDesc));
        result->kind = sym;
        sym = SGet();

        register Node right = Term();
        result->left = left;
        result->right = right;

        left = result;
    }
    return result;
}
static void MIPSTraversal(Node root)
{
    /**
     * isLeft = 0 root->left
     * isRight = 0 root->right
     **/

    if (root != NULL)
    {
        switch (root->kind)
        {
        case number:
            printf("li $a0, %d #acc <- %d\n", root->val, root->val);
            break;

        case plus:
            MIPSTraversal(root->left);
            printf("sw $a0, 0($sp) #push acc\n");
            printf("addiu $sp, $sp, -4\n");
            MIPSTraversal(root->right);
            printf("lw $t1, 4($sp)\n");
            printf("add $a0, $t1, $a0 #acc <- top_of_stack + acc\n");
            printf("addiu $sp, $sp, 4 #pop\n");
            break;

        case minus:
            MIPSTraversal(root->left);
            printf("sw $a0, 0($sp) #push acc\n");
            printf("addiu $sp, $sp, -4\n");
            MIPSTraversal(root->right);
            printf("lw $t1, 4($sp)\n");
            printf("sub $a0, $t1, $a0 #acc <- top_of_stack - acc\n");
            printf("addiu $sp, $sp, 4 #pop\n");
            break;

        case times:
            MIPSTraversal(root->left);
            printf("sw $a0, 0($sp) #push acc\n");
            printf("addiu $sp, $sp, -4\n");
            MIPSTraversal(root->right);
            printf("lw $t1, 4($sp)\n");
            printf("mult $t1, $a0 #acc <- top_of_stack * acc\n");
            printf("mflo $a0 #move from register low\n");
            printf("addiu $sp, $sp, 4 #pop\n");
            break;

        case divide:
            MIPSTraversal(root->left);
            printf("sw $a0, 0($sp) #push acc\n");
            printf("addiu $sp, $sp, -4\n");
            MIPSTraversal(root->right);
            printf("lw $t1, 4($sp) #load top_of_stack\n");
            printf("div $t1, $a0 #acc <- acc / top_of_stack\n");
            printf("mflo $a0 #move from register low\n");
            printf("addiu $sp, $sp, 4 #pop\n");
            break;

        case mod:
            MIPSTraversal(root->left);
            printf("sw $a0, 0($sp) #push acc\n");
            printf("addiu $sp, $sp, -4\n");
            MIPSTraversal(root->right);
            printf("lw $t1, 4($sp)\n");
            printf("div $t1, $a0 #acc <- acc %% top_of_stack\n");
            printf("mfhi $a0 #move from register high\n");
            printf("addiu $sp, $sp, 4 #pop\n");
            break;
        }
    }
}

int main(int argc, char *argv[])
{
    register Node result;
    if (argc == 2)
    {
        SInit(argv[1]);
        sym = SGet();
        result = Expr();
        assert(sym == eof);
        // Print(result, 0);
        MIPSTraversal(result);
        printf("li $v0, 1 #for printing an integer result\n");
        printf("syscall #for printing an integer result\n");
        printf("li $v0, 10 #for correct exit (or temrination)\n");
        printf("syscall #for correct exit (or temrination)\n");
    }
    else
    {
        printf("usage: expreval <filename>\n");
    }
    return 0;
}
