//
//  ViewController.swift
//  BKStackLayoutApp
//
//  Created by burt on 2018. 11. 4..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import BKStackLayout
import SnapKit

class ViewController: UIViewController {
    
    private lazy var label1: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "A"
        label.backgroundColor = .red
        return label
    }()
    
    private lazy var label2: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Hello, World"
        label.backgroundColor = .blue
        return label
    }()
    
    private lazy var label3: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout"
        label.numberOfLines = 3
        label.backgroundColor = .yellow
        return label
    }()
    
    private lazy var label4: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
        label.textColor = .white
        label.backgroundColor = .gray
        label.numberOfLines = 0
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
                    ]).align(horizontal: .fill).distribute(.fill).spacing(20)
            }
            
            $0.horizontal {
                $0.add(views: [$0.flex(), $0.wrap(self.label4, w: 200), $0.flex(), $0.fixed(w: 100, bgColor: .red)])
                $0.align(vertical: .top)
                $0.spacing(10)
                $0.distribute(.fill)
            }
            
            $0.horizontal {
                $0.add(views: [self.label3]).distribute(.fill)
            }
            
            $0.align(horizontal: .fill)
            $0.spacing(30)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(layout)
        layout.backgroundColor = .black
        layout.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if label4.text == nil {
            label4.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
        } else {
            label4.text = nil
        }
        self.layout.update()
    }
}

