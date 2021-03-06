//
//  RWReactivePlaygroundSwiftTests.swift
//  RWReactivePlaygroundSwiftTests
//
//  Created by Alan O'Connor on 19/02/2017.
//  Copyright © 2017 codebiscuits. All rights reserved.
//

import Quick
import Nimble
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError
@testable import RWReactivePlaygroundSwift

class ViewModelSpec: QuickSpec {
    override func spec() {
        describe("ViewModel functions") {

            let viewModel = ViewModel()
            var passwordSignal: Signal<String?, NoError>!
            var passwordObserver: Signal<String?, NoError>.Observer!
            
            var usernameSignal: Signal<String?, NoError>!
            var usernameObserver: Signal<String?, NoError>.Observer!

            context("Given passsord is nil", {
                beforeEach {
                    let (signalTemp, observerTemp) = Signal<String?, NoError>.pipe()
                    passwordSignal = signalTemp
                    passwordObserver = observerTemp
                }
                
                it("Should return false for validPasswordSignal", closure: {
                    var testValue = true

                    viewModel.validPasswordSignal(passwordSignal: passwordSignal)
                        .observeValues({ (value) in
                            testValue = value
                        })
                    
                    expect(testValue).to(equal(true))
                    passwordObserver.send(value: nil)
                    expect(testValue).to(equal(false))
                })

                it("Should return the correct background Color", closure: {
                    var testValue = UIColor.black

                    viewModel.passwordTextFieldBackgroundColor(passwordSignal: passwordSignal)
                        .observeValues({
                            testValue = $0
                        })

                    expect(testValue).to(equal(UIColor.black))
                    passwordObserver.send(value: nil)
                    expect(testValue).to(equal(UIColor.yellow))
                })
            })

            context("given a valid password and invalid useranme", {
                beforeEach {
                    let (signalTemp, observerTemp) = Signal<String?, NoError>.pipe()
                    passwordSignal = signalTemp
                    passwordObserver = observerTemp
                    
                    let (userSignal, userObserver) = Signal<String?, NoError>.pipe()
                    usernameSignal = userSignal
                    usernameObserver = userObserver
                }

                it("Should return true for passwordSignal", closure: {
                    var testPasswordValue = false
                    
                    viewModel.validPasswordSignal(passwordSignal: passwordSignal!)
                        .observeValues({ (value) in
                            testPasswordValue = value
                        })

                    expect(testPasswordValue).to(equal(false))
                    passwordObserver.send(value: "valid")
                    expect(testPasswordValue).to(equal(true))
                })

                it("Should return false for usernameSignal", closure: {
                    var testvalue = true
                    viewModel.validUsernameSignal(usernameSignal: usernameSignal!)
                        .observeValues({
                            testvalue = $0
                        })

                    expect(testvalue).to(equal(true))
                    usernameObserver.send(value: "12")
                    expect(testvalue).to(equal(false))
                })

                it("Should have the correct password text field background color", closure: {
                    var testColor = UIColor.black
                    viewModel.passwordTextFieldBackgroundColor(passwordSignal: passwordSignal!)
                        .observeValues({
                            testColor = $0
                        })
                    expect(testColor).to(equal(UIColor.black))
                    passwordObserver.send(value: "valid")
                    expect(testColor).to(equal(UIColor.clear))
                })

                it("Should return the correct value for all valid fields", closure: {
                    var testValue = false
                    viewModel.allValidFields(usernameSignal: usernameSignal!, passwordSignal: passwordSignal!)
                        .observeValues({
                            testValue = $0
                        })
                    expect(testValue).to(equal(false))
                    usernameObserver.send(value: "12")
                    passwordObserver.send(value: "valid")
                    expect(testValue).to(equal(false))
                })
            })

            context("Given username is nil", {
                beforeEach {
                    let (userSignal, userObserver) = Signal<String?, NoError>.pipe()
                    usernameSignal = userSignal
                    usernameObserver = userObserver
                }
                it("Should return false for validUsername", closure: {
                    var testValue = false

                    viewModel.validUsernameSignal(usernameSignal: usernameSignal!)
                        .observeValues({ (value) in
                            testValue = value
                        })

                    expect(testValue).to(equal(false))
                    usernameObserver.send(value: nil)
                    expect(testValue).to(equal(false))
                })

                it("Should return the correct background Color", closure: {
                    var testValue = UIColor.black

                    viewModel.userNameTextFieldBackgroundColor(usernameSignal: usernameSignal!)
                        .observeValues({
                            testValue = $0
                        })

                    expect(testValue).to(equal(UIColor.black))
                    usernameObserver.send(value: nil)
                    expect(testValue).to(equal(UIColor.yellow))
                })
            })

            context("Given a valid username and invalid password", {
                beforeEach {
                    let (signalTemp, observerTemp) = Signal<String?, NoError>.pipe()
                    passwordSignal = signalTemp
                    passwordObserver = observerTemp
                    
                    let (userSignal, userObserver) = Signal<String?, NoError>.pipe()
                    usernameSignal = userSignal
                    usernameObserver = userObserver
                }

                it("Should return true for usernameSignal", closure: {
                    var testValue = false
                    viewModel.validUsernameSignal(usernameSignal: usernameSignal!)
                        .observeValues({
                            testValue = $0
                        })
                    expect(testValue).to(equal(false))
                    usernameObserver.send(value: "1234")
                    expect(testValue).to(equal(true))
                })

                it("Should return false for passwordSignal", closure: {
                    var testvalue = false
                    viewModel.validPasswordSignal(passwordSignal: passwordSignal!)
                        .observeValues({
                            testvalue = $0
                        })

                    expect(testvalue).to(equal(false))
                    passwordObserver.send(value: "12")
                    expect(testvalue).to(equal(false))
                })

                it("Should have the correct username text field background color", closure: {
                    var testColor = UIColor.black
                    viewModel.userNameTextFieldBackgroundColor(usernameSignal: usernameSignal!)
                        .observeValues({
                            testColor = $0
                        })
                    expect(testColor).to(equal(UIColor.black))
                    usernameObserver.send(value: "1234")
                    expect(testColor).to(equal(UIColor.clear))
                })

                it("Should return the correct value for all valid fields", closure: {
                    var testValue = false
                    viewModel.allValidFields(usernameSignal: usernameSignal!, passwordSignal: passwordSignal!)
                        .observeValues({
                            testValue = $0
                        })
                    expect(testValue).to(equal(false))
                    usernameObserver.send(value: "1234")
                    passwordObserver.send(value: "12")
                    expect(testValue).to(equal(false))
                })
            })

            context("Given a valid password and username", {
                beforeEach {
                    let (signalTemp, observerTemp) = Signal<String?, NoError>.pipe()
                    passwordSignal = signalTemp
                    passwordObserver = observerTemp
                    
                    let (userSignal, userObserver) = Signal<String?, NoError>.pipe()
                    usernameSignal = userSignal
                    usernameObserver = userObserver
                }

                it("Should return the correct value for all valid fields", closure: {
                    var testValue = false
                    viewModel.allValidFields(usernameSignal: usernameSignal!, passwordSignal: passwordSignal!)
                        .observeValues({
                            testValue = $0
                        })
                    expect(testValue).to(equal(false))
                    usernameObserver.send(value: "1234")
                    passwordObserver.send(value: "1234")
                    expect(testValue).to(equal(true))
                })
            })
        }
    }
}
