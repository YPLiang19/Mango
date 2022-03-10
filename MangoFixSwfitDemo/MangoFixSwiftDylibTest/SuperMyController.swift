//
//  SomeViewController.swift
//  MangoFixSwiftDylibTest
//
//  Created by 雍鹏亮 on 2022/3/9.
//

import UIKit
public class SuperMyController: UIViewController {
    
    @objc
    var block: Any? = nil
    
    public override
    func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
    }
    
}
