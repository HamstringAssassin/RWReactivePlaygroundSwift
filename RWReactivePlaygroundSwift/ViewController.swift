//
//  ViewController.swift
//  RWReactivePlaygroundSwift
//
//  Created by Alan O'Connor on 02/02/2017.
//  Copyright © 2017 codebiscuits. All rights reserved.
//

import UIKit
import PureLayout
import ReactiveSwift
import ReactiveCocoa
import enum Result.NoError

fileprivate extension Selector {
    fileprivate static let _signInButtonPressed = #selector(ViewController._signInButtonPressed(sender:))
}

class ViewController: UIViewController {
    
    override var title: String? {
        get {
            return "Reactive Sign In"
        }
        set {
            self.title = newValue
        }
    }
    
    fileprivate var _usernameTextField: UITextField! {
        didSet {
            _usernameTextField.placeholder = "Username"
            _usernameTextField.borderStyle = .roundedRect
            _usernameTextField.autocapitalizationType = .none
        }
    }
    
    fileprivate var _passwordTextField: UITextField! {
        didSet {
            _passwordTextField.placeholder = "Password"
            _passwordTextField.borderStyle = .roundedRect
            _passwordTextField.autocapitalizationType = .none
        }
    }
    
    fileprivate var _signInButton: UIButton! {
        didSet {
            _signInButton.setTitleColor(UIColor.black, for: .normal)
            _signInButton.setTitle("Sign In", for: .normal)
            _signInButton.addTarget(self, action: ._signInButtonPressed, for: .touchUpInside)
            
            //TODO: View Logic that can be moved to VM
            _signInButton.isHidden = true
            _signInButton.isEnabled = false
        }
    }
    
    fileprivate var _errorLabel: UILabel! {
        didSet {
            _errorLabel.text = "Invalid Credentials"
            _errorLabel.textColor = UIColor.red
            
            //TODO: View Logic that can be moved to VM
            _errorLabel.isHidden = true
        }
    }
    
    let signInService = SignInService()
    
    var printableValue = MutableProperty("")
    
    var viewModel: ViewModel = ViewModel()
    
    private var _disposable = CompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _createUI()
        _layoutUI()
        _skinUI()
        _bindUI(viewModel: viewModel)
    }
    
    fileprivate func _bindUI(viewModel: ViewModel) {
        // Step 1: Break this out into a private func that takes a signal, does something, and returns another signal
        // Step 2: Move the private func to the viewModel.
        // Step 3: Test ViewModel!
        // Way more Testable :)
        // Step 4: Profit!!!
        //        let validUsernameSignal = _usernameTextField.reactive.continuousTextValues
        //            .map({ [weak self] (text) in
        //                return self?.isValidUsername(username: text ?? "")
        //            })
        //        .skipNil()
        
        let usernameTextFieldSignal = _usernameTextField.reactive.continuousTextValues
        let passwordTextfieldSignal = _passwordTextField.reactive.continuousTextValues
        
        _usernameTextField.reactive.backgroundColor <~ viewModel.userNameTextFieldBackgroundColor(usernameSignal: usernameTextFieldSignal)
        
        _passwordTextField.reactive.backgroundColor <~ viewModel.passwordTextFieldBackgroundColor(passwordSignal: passwordTextfieldSignal)
        
        let signUpActiveSignal = viewModel.allValidFields(usernameSignal: usernameTextFieldSignal, passwordSignal: passwordTextfieldSignal)
        
        _signInButton.reactive.isEnabled <~ signUpActiveSignal
        _signInButton.reactive.isHidden <~ signUpActiveSignal.map({ return !$0 })
    }
}

extension ViewController {
    fileprivate func _createUI() {
        _usernameTextField = UITextField(forAutoLayout: ())
        _passwordTextField = UITextField(forAutoLayout: ())
        _signInButton = UIButton(forAutoLayout: ())
        _errorLabel = UILabel(forAutoLayout: ())
    }
    
    fileprivate func _layoutUI() {
        self.view.addSubview(_passwordTextField)
        _passwordTextField.autoSetDimension(.height, toSize: Layout.ElementHeight.CTAButton)
        _passwordTextField.autoSetDimension(.width, toSize: Layout.columns(cols: 4))
        _passwordTextField.autoCenterInSuperview()
        
        self.view.addSubview(_usernameTextField)
        _usernameTextField.autoPinEdge(.bottom, to: .top, of: _passwordTextField, withOffset: -20)
        _usernameTextField.autoSetDimension(.height, toSize: Layout.ElementHeight.CTAButton)
        _usernameTextField.autoSetDimension(.width, toSize: Layout.columns(cols: 4))
        _usernameTextField.autoAlignAxis(toSuperviewAxis: .vertical)
        
        self.view.addSubview(_signInButton)
        _signInButton.autoSetDimension(.height, toSize: Layout.ElementHeight.TabButton)
        _signInButton.autoConstrainAttribute(.right, to: .right, of: _usernameTextField)
        _signInButton.autoSetDimension(.width, toSize: Layout.columns(cols: 2))
        _signInButton.autoPinEdge(.top, to: .bottom, of: _passwordTextField, withOffset: 20)
        
        self.view.addSubview(_errorLabel)
        _errorLabel.autoSetDimension(.height, toSize: Layout.ElementHeight.TabButton)
        _errorLabel.autoConstrainAttribute(.left, to: .left, of: _usernameTextField)
        _errorLabel.autoSetDimension(.width, toSize: Layout.columns(cols: 2))
        _errorLabel.autoPinEdge(.top, to: .bottom, of: _passwordTextField, withOffset: 20)
    }
    
    fileprivate func _skinUI() {
        self.view.backgroundColor = UIColor.white
    }
}

extension ViewController {
    @objc fileprivate func _signInButtonPressed(sender: UIButton) {
        guard let username = _usernameTextField.text, let password = _passwordTextField.text else { return }
        
        signInService.signIn(username: username, password: password)
            .on(value: { [weak self] (success) in
                self?._errorLabel.isHidden = success
                if success {
                    let kittenViewController = KittenViewController()
                    self?.navigationController?.show(kittenViewController, sender: self)
                }
            })
            .start()
    }
}

