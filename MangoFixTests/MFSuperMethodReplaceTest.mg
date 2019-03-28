
class MFAnimal : NSObject {

- (NSString *)say{
    return @"Mango: MFAnimal::say";
}

}


class MFPerson : MFAnimal{

- (NSString *)say{
    return @"Mango: MFPerson::say" + "-" + super.say();
}

}
