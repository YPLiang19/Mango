//
//  ViewController.swift
//  MangoFixSwfitDemo
//
//  Created by Tianyu Xia on 2022/3/8.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let titles = ["顺序语句示例", "if语句示例", "switch语句示例", "for语句示例", "forEach语句示例", "while语句示例", "dowhile语句示例",
                  "block语句示例", "参数传递示例", "结构体传参示例", "返回值示例", "创建自定义ViewController","替换类方式示例", "调用原始实现示例",
                  "条件注解示例","GCD示例", "静态变量和取地址运算符示例", "C函数变量示例", "teypedef 示例"]

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var resultView: UITextView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        testRuntie();
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            sequentialStatementExample()
//        case 1://if语句示例
//            [self ifStatementExample];
//            break;
//
//        case 2://switch语句示例
//            [self switchStatementExample];
//            break;
//
//        case 3://for语句示例
//            [self forStatementExample];
//            break;
//
//        case 4://forEach语句示例
//            [self forEachStatementExample];
//            break;
//
//        case 5://while语句示例
//            [self whileStatementExample];
//            break;
//
//        case 6://do while语句示例
//            [self doWhileStatementExample];
//            break;
//
//        case 7://block语句示例
//            [self blockStatementExample];
//            break;
//
//        case 8://参数传递示例
//        {
//
//            int a = 1;
//            [self paramPassingExampleWithBOOLArg:YES intArg:1 uintArg:2  blockArg:^id(NSString *str1, NSString *str2) {
//                return [NSString stringWithFormat:@"%@-%@-%d",str1,str2,a];
//            } objArg:@"string object"];
//
//            break;
//        }
//
//        case 9:{//结构体传参示例
//             MyStruct myStruct = [self paramPassingExampleWithStrut:CGRectMake(1, 2, 3, 3)];
//            self.resultView.text = [NSString stringWithFormat:@"myStruct.x = %@,\n myStruct.y = %@", @(myStruct.x),@(myStruct.y)];
//            break;
//        }
//
//        case 10:{//返回值示例
//            NSString * (^retBlcok)(NSString *str1,NSString *str2) = [self returnBlockExample];
//            NSString *result = retBlcok(@"hello ",@"jerry!");
//            self.resultView.text = result;
//            break;
//        }
//
//        case 11://创建自定义ViewController
//            [self createAndOpenNewViewControllerExample];
//            break;
//
//        case 12://替换类方式示例
//            [self.class classMethodExapleWithInstance:self];
//            break;
//
//        case 13://调用原始实现示例
//            [self callOriginalImp];
//            break;
//
//        case 14://条件注解示例
//            [self conditionsAnnotationExample];
//            break;
//
//        case 15://CGD示例
//            [self gcdExample];
//            break;
//        case 16://静态变量示例
//            [self staticVarAndGetVarAddressOperExample];
//            break;
//        case 17://C函数变量示例
//            load_function(NSSearchPathForDirectoriesInDomains);
//            load_function(write);
//            [self cfuntionVarExample];
//            break;
//        case 18://typedef 示例C
//            [self typedefExaple];
//            break;
            
        default:
            return
        }
        
        
    }
    
    
    
    
    @objc
    dynamic
    func sequentialStatementExample() {
      self.resultView.text = "replace sequentialStatementExample faild"
    }
    @objc
    dynamic
    func ifStatementExample() {
        self.resultView.text = "replace ifStatementExample faild"
    }
    


    @objc
    dynamic
    func forStatementExample() {
        
    }

    @objc
    dynamic
    func forEachStatementExample() {
        
    }

    @objc
    dynamic
    func whileStatementExample() {
        
    }

     @objc
    dynamic
    func doWhileStatementExample() {
        
    }

     @objc
    dynamic
    func blockStatementExample() {
    }


    
    @objc
    dynamic
    func paramPassingExampleWith(BOOLArg: Bool, intArg: NSInteger, blockArg:(NSString, NSString )->Any, objArg:Any) {
    }
    
    
    @objc
    dynamic
    func paramPassingExampleWithStrut(rect: CGRect) -> CGRect{
        let x = CGRect.init()
        return x
    }

    @objc
    dynamic
    func passStackBlock() {
    }
    
    @objc
    dynamic
    func preturnBlockExample() {
    }

    @objc
    dynamic
    func callOriginalImp() {
        self.resultView.text = "in original IMP";
    }

     @objc
    dynamic
    func createAndOpenNewViewControllerExample() {
        
    }


    @objc
    dynamic
    func conditionsAnnotationExample() {
        self.resultView.text = "here is OC method";
    }


    @objc
    dynamic
    func gcdExample() {
        
    }

    @objc
    dynamic
    func staticVarAndGetVarAddressOperExample() {
        
    }

    @objc
    dynamic
    func cfuntionVarExample() {
        
    }

    @objc
    dynamic
    func typedefExaple() {
        
    }


}

