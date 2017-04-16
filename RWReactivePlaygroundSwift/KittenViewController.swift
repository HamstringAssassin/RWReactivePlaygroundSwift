//
//  KittenViewController.swift
//  RWReactivePlaygroundSwift
//
//  Created by Alan O'Connor on 02/02/2017.
//  Copyright © 2017 codebiscuits. All rights reserved.
//

import UIKit

class KittenViewController: UIViewController {

    override var title: String? {
        get { return "Kitten!" }
        set { self.title = newValue }
    }

    fileprivate var _kittenImage: UIImageView! {
        didSet {
            _kittenImage.contentMode = .scaleAspectFill
            _kittenImage.image = UIImage(named: "kitten")
        }
    }

    fileprivate var _creditLabel: UILabel! {
        didSet {
            _creditLabel.font = UIFont.systemFont(ofSize: 9)
            _creditLabel.text = "http://www.flickr.com/photos/50362297@N07"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _createUI()
        _layoutUI()
        _skinUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension KittenViewController {
    fileprivate func _createUI() {
        _kittenImage = UIImageView(forAutoLayout: ())
        _creditLabel = UILabel(forAutoLayout: ())
    }

    fileprivate func _layoutUI() {
        self.view.addSubview(_kittenImage)
        _kittenImage.autoPinEdgesToSuperviewEdges()
        self.view.addSubview(_creditLabel)
        _creditLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        _creditLabel.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -20)

    }

    fileprivate func _skinUI() {
        self.view.backgroundColor = UIColor.white
    }
}
