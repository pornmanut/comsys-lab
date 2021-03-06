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
static void Print(Node root, int level)
{
    register int i;
    if (root != NULL)
    {
        Print(root->right, level + 1);
        for (i = 0; i < level; i++)
            printf(" ");
        switch (root->kind)
        {
        case plus:
            printf("+\n");
            break;
        case minus:
            printf("-\n");
            break;
        case times:
            printf("*\n");
            break;
        case divide:
            printf("/\n");
            break;
        case number:
            printf("%d\n", root->val);
            break;
        }
        Print(root->left, level + 1);
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
        Print(result, 0);
    }
    else
    {
        printf("usage: expreval <filename>\n");
    }
    return 0;
}
