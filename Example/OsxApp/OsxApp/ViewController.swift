//
//  ViewController.swift
//  OsxApp
//
//  Created by burt on 2018. 11. 4..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import SnapKit

class ViewController: NSViewController {

    private lazy var label1: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.stringValue = "A"
        label.backgroundColor = .red
        label.isEditable = false
        label.usesSingleLineMode = true
        return label
    }()
    
    private lazy var label2: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.stringValue = "Hello, World"
        label.backgroundColor = .blue
        label.isEditable = false
        label.usesSingleLineMode = true
        return label
    }()
    
    private lazy var label3: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.stringValue = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout"
        label.maximumNumberOfLines = 3
        label.backgroundColor = .yellow
        label.isEditable = false
        label.usesSingleLineMode = false
        return label
    }()
    
    private lazy var label4: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.stringValue = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
        label.textColor = .white
        label.backgroundColor = .gray
        label.isEditable = false
        label.usesSingleLineMode = true
        return label
    }()
    
    private lazy var layout: StackLayout = {
        return StackLayout.vertical {
            $0.vertical {
                $0.add(views: [
                    self.label1,
                    $0.fixed(h: 100, bgColor: .green),
                    self.label2,
                    $0.fixed(h: 20, bgColor: .magenta)
                    ]).align(horizontal: .center).distribute(.fill).spacing(20)
            }
            
            $0.horizontal {
                $0.add(views: [$0.flex(), $0.wrap(self.label4, w: 200), $0.flex(), $0.fixed(w: 100, bgColor: .red)])
                $0.align(vertial: .top)
                $0.spacing(10)
                $0.distribute(.fill)
            }
            
            $0.horizontal {
                $0.add(views: [self.label3]).distribute(.fill)
            }
            
            $0.align(horizontal: .right)
            $0.distribute(.fill)
            $0.spacing(30)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(layout)
        layout.wantsLayer = true
        layout.layer?.backgroundColor = .black
        layout.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        
    }
}

