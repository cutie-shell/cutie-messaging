#include <messaging.h>

int main(int argc, char *argv[]) {
    Messaging app(argc, argv);
    return app.isPrimary() ? app.exec() : 0;
}
