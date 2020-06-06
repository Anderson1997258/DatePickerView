//
//  DatePickerView.swift
//  DatePickerView
//
//  Created by 嚴安生 on 2020/5/30.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

protocol DatePickerViewDelegate: class {
    func done(_ result: String)
    func cancel()
}

class DatePickerView: UIView {
    
    var viewNavagation: UIView!
    var svPickerView: UIScrollView!
    var picDatePicker: UIDatePicker!
    var picTimerPicker: UIDatePicker!
    var btnDone: UIButton!
    var btnCancel: UIButton!
    var page: UIPageControl!
    
    weak var delegate: DatePickerViewDelegate?
    
    enum PageType: Int, CaseIterable {
        case dateTime
        case time
    }
    
    var currentPage: PageType = .dateTime
    var dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    private var currentDate: DateComponents {
        return Calendar.current.dateComponents(in: .autoupdatingCurrent, from: Date())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initView()
    }
    
//  MARK: Init Method
    func initView() {
        viewNavagation = UIView(frame: .zero)
        viewNavagation.translatesAutoresizingMaskIntoConstraints = false
        addSubview(viewNavagation)
        viewNavagation.topAnchor.constraint(equalTo: topAnchor).isActive = true
        viewNavagation.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        viewNavagation.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        viewNavagation.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        svPickerView = UIScrollView(frame: .zero)
        svPickerView.delegate = self
        svPickerView.isScrollEnabled = true
        svPickerView.isPagingEnabled = true
        svPickerView.showsVerticalScrollIndicator = false
        svPickerView.showsHorizontalScrollIndicator = false
        svPickerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(svPickerView)
        svPickerView.topAnchor.constraint(equalTo: viewNavagation.bottomAnchor).isActive = true
        svPickerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        svPickerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        picDatePicker = UIDatePicker(frame: .zero)
        picDatePicker.backgroundColor = .clear
        picDatePicker.datePickerMode = .dateAndTime
        picDatePicker.locale = .current
        picDatePicker.date = currentDate.date ?? Date()
        
        picTimerPicker = UIDatePicker(frame: .zero)
        picTimerPicker.backgroundColor = .clear
        picTimerPicker.datePickerMode = .countDownTimer
        picTimerPicker.locale = .current
        
        let sk = UIStackView(arrangedSubviews: [picDatePicker, picTimerPicker])
        sk.translatesAutoresizingMaskIntoConstraints = false
        sk.alignment = .fill
        sk.axis = .horizontal
        sk.distribution = .fillEqually
        svPickerView.addSubview(sk)
        sk.topAnchor.constraint(equalTo: svPickerView.topAnchor).isActive = true
        sk.bottomAnchor.constraint(equalTo: svPickerView.bottomAnchor).isActive = true
        sk.trailingAnchor.constraint(equalTo: svPickerView.trailingAnchor).isActive = true
        sk.leadingAnchor.constraint(equalTo: svPickerView.leadingAnchor).isActive = true
        sk.centerYAnchor.constraint(equalTo: svPickerView.centerYAnchor).isActive = true
        
        picDatePicker.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        
        btnDone = UIButton(type: .system)
        btnDone.translatesAutoresizingMaskIntoConstraints = false
        btnDone.setTitle("Done", for: .normal)
        btnDone.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
        viewNavagation.addSubview(btnDone)
        btnDone.centerYAnchor.constraint(equalTo: viewNavagation.centerYAnchor).isActive = true
        btnDone.trailingAnchor.constraint(equalTo: viewNavagation.trailingAnchor, constant: -30).isActive = true
        
        btnCancel = UIButton(type: .system)
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.addTarget(self, action: #selector(cancelButton), for: .touchUpInside)
        viewNavagation.addSubview(btnCancel)
        btnCancel.centerYAnchor.constraint(equalTo: viewNavagation.centerYAnchor).isActive = true
        btnCancel.leadingAnchor.constraint(equalTo: viewNavagation.leadingAnchor, constant: 30).isActive = true
        
        page = UIPageControl()
        page.translatesAutoresizingMaskIntoConstraints = false
        page.addTarget(self, action: #selector(pageValueChange), for: .valueChanged)
        page.numberOfPages = PageType.allCases.count
        page.currentPage = 0
        addSubview(page)
        page.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        page.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        page.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        page.topAnchor.constraint(equalTo: svPickerView.bottomAnchor).isActive = true
        page.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
//  MARK: Private Method
    private func result() -> String {
        switch currentPage {
        case .dateTime:
            return picDatePicker.date.toString(format: dateFormat)
        case .time:
            let time = picTimerPicker.countDownDuration.toTime()
            var resultDate: Date! = currentDate.date
            
            resultDate = resultDate.add(.hour, time.hr)
            resultDate = resultDate.add(.minute, time.min)
            
            return resultDate.toString(format: dateFormat)
        }
    }
    
//  MARK: Action Method
    @objc func doneButton(_ sender: UIButton) {
        delegate?.done(result())
    }
    
    @objc func cancelButton(_ sender: UIButton) {
        delegate?.cancel()
    }
    
    @objc func pageValueChange(_ sender: UIPageControl) {
        svPickerView.scrollTo(withPage: sender.currentPage)
    }
}

//  MARK: Scroll View Delegate
extension DatePickerView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        page.currentPage = scrollView.currentPage
        currentPage = PageType(rawValue: scrollView.currentPage) ?? .dateTime
    }
    
}

//  MARK: Extension Element
extension CGRect {
    
    static var `default`: CGRect {
        return CGRect(origin: .zero,
                      size: CGSize(width: UIScreen.main.bounds.width, height: 300))
    }
    
}

fileprivate extension UIScrollView {
    
    var currentPage: Int {
        return Int(round(self.contentOffset.x/self.bounds.width))
    }
    
    func scrollTo(withPage page: Int) {
        self.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * CGFloat(page),
                                      y: self.contentOffset.y),
                              animated: true)
    }
    
}

fileprivate extension Date {
    
    func toString (format:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func add(_ component: Calendar.Component, _ value: Int) -> Date? {
        return Calendar.current.date(byAdding: component, value: value, to: self)
    }
    
}

fileprivate extension TimeInterval {
    
    func toTime() -> (hr: Int, min: Int, sec: Int, strTime: String) {
        func calculate(sec: Int) -> (Int, Int, Int) {
            return (sec / 3600, (sec % 3600 / 60), (sec % 3600) % 60)
        }
        
        let (hr, min, sec) = calculate(sec: Int(self))
        let strTime = String(format: "%02d:%02d:%05.2f", hr, min, sec)
        
        return (hr: hr, min: min, sec: sec, strTime: strTime)
    }
    
}
