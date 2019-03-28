
class MFBranchStatementTest : NSObject{
    
- (BOOL)tsetBranchStatement{
    int i = 9;
    
    if (i <= 0){
        i = 0;
    }else if(i <= 10){
        i = 10; // i = 10
    }else{
        i = 100;
    }
    
    if (i >=  5){
        i++; //i = 11
    }else{
        i--;
    }
    
    if(i == 100){
        i++;
    }else{
        i--; //i = 10
    }
    
    switch(i){
        case 1:{
            break;
        }
        case 10:{
            i += 5; // i = 15
        }
        case 11:{
            i -= 20; //i = -5
            break;
        }
        default:{
            
        }
    }
    return i == -5;
}
    
}
