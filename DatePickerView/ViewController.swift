//
//  ViewController.swift
//  DatePickerView
//
//  Created by 嚴安生 on 2020/5/30.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var edt: UITextField!
    
    var viewDatePicker: DatePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }

//  MARK: Init Method
    func initView() {
        viewDatePicker = DatePickerView(frame: .default)
        viewDatePicker.delegate = self
        
        edt.inputView = viewDatePicker
    }
    
}

extension ViewController: DatePickerViewDelegate {
    
    func done(_ result: String) {
        edt.text = result
        edt.endEditing(true)
    }
    
    func cancel() {
        edt.endEditing(true)
    }
}
