//
//  ViewController.swift
//  MangoFixSwfitDemo
//
//  Created by Tianyu Xia on 2022/3/8.
//

import UIKit
import MangoFixSwiftDylibTest


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let titles = ["顺序语句示例", "if语句示例", "switch语句示例", "for语句示例", "forEach语句示例", "while语句示例", "dowhile语句示例",
                  "block语句示例", "参数传递示例", "结构体传参示例", "返回值示例", "创建自定义ViewController","替换类方式示例", "调用原始实现示例",
                  "条件注解示例","GCD示例", "静态变量和取地址运算符示例", "C函数变量示例", "teypedef 示例"]
    
    let cellReuseIdentifier = "cellReuseIdentifier"
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var resultView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        testRuntie()
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
        case 1: //if语句示例
            ifStatementExample()
            break;

        case 2: //switch语句示例
            switchStatementExample()

        case 3: //for语句示例
            forStatementExample()

        case 4: //forEach语句示例
            forEachStatementExample()

        case 5: //while语句示例
            whileStatementExample()

        case 6: //do while语句示例
            doWhileStatementExample()

        case 7: //block语句示例
            blockStatementExample()

        case 8: //参数传递示例
            let a = 1
            swiftMethodParamPassingExample(BOOLArg: true, intArg: -20, uintArg: 10,  blockArg: { (str1, str2) -> Any in
                return NSString.init(format: "%%@-%@-%d", str1, str2, a)
            }, objArg: "string object")
            

        case 9: //结构体传参示例
            let ret = paramPassingExampleWithStrut(rect: CGRect.init(x: 10, y: 20, width: 30, height: 40))
            self.resultView.text = String.init(format: "return CFRect %f - %f - %f - %f", ret.origin.x, ret.origin.y, ret.size.width, ret.size.height)

        case 10: //返回值示例
            let block = returnBlockExample()
            let result = block("swift  hello", " jerry!")
            self.resultView.text = String.init(result)

        case 11: //创建自定义ViewController
            createAndOpenNewViewControllerExample()

        case 12: //替换类方式示例
            ViewController.classMethodExapleWithInstance()
        case 13://调用原始实现示例
            callOriginalImp()
        case 14://条件注解示例
            conditionsAnnotationExample()
        case 15://CGD示例
            gcdExample()
        case 16://静态变量示例
            staticVarAndGetVarAddressOperExample();
        case 17://C函数变量示例
            cfuntionVarExample()
        case 18://typedef 示例C
            typedefExaple()
            
        default:
            return
        }
    }
    
    
    
    @objc
    dynamic
    static func classMethodExapleWithInstance() {
        
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
    func switchStatementExample() {
        
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
    func swiftMethodParamPassingExample(BOOLArg: Bool, intArg: Int, uintArg: UInt, blockArg:(NSString, NSString )->Any, objArg:Any) {
        
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
    func returnBlockExample() -> (NSString, NSString) -> NSString  {
        return { _,_  in ""}
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


