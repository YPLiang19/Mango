
class MFOperatorTest : NSObject {

- (BOOL)testOperator{
    int a = 10;
    int b = 20;
    BOOL c = NO;
    a = a + b;
    if (a != 30) {
        return NO;
    }

    a = a - b;
    if (a != 10) {
        return NO;
    }

    a = a * b;
    if (a != 200) {
        return NO;
    }

    a = a/b;
    if (a != 10) {
        return 10;
    }

    a = a % 3;
    if (a != 1) {
        return  NO;
    }

    a = -a;
    if (a != -1) {
        return NO;
    }

    a += 11;
    if (a != 10) {
        return NO;
    }

    a -= 5;
    if (a != 5) {
        return NO;
    }

    a *= 10;
    if (a != 50) {
        return NO;
    }

    a /= 3;
    if (a != 16) {
        return NO;
    }

    a %= 5;
    if (a != 1) {
        return NO;
    }

    a++;
    if (a != 2) {
        return NO;
    }

    a--;
    if (a != 1) {
        return NO;
    }

    c = a == 1;
    if (!c) {
        return NO;
    }

    c = !c;
    if (c) {
        return NO;
    }

    c = c || YES;
    if (!c) {
        return NO;
    }

    c = c && NO;
    if (c) {
        return NO;
    }

    return YES;
}

}
