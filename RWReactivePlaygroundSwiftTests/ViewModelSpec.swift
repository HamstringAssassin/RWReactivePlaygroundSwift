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
            var passwordSignal: Signal<String?, NoError>?
            var usernameSignal: Signal<String?, NoError>?
            var testScheduler: TestScheduler!

            beforeEach {
                testScheduler = TestScheduler()
            }

            context("Given passsord is nil", {
                it("Should return false for validPasswordSignal", closure: {
                    passwordSignal = Signal { observer in
                        testScheduler.schedule {
                            observer.send(value: nil)
                            observer.sendCompleted()
                        }
                        return nil
                    }
                    var testValue = false

                    viewModel.validPasswordSignal(passwordSignal: passwordSignal!)
                        .observeValues({ (value) in
                            testValue = value
                        })

                    expect(testValue).to(equal(false))
                    testScheduler.run()
                    expect(testValue).to(equal(false))
                })

                it("Should return the correct background Color", closure: {
                    passwordSignal = Signal { observer in
                        testScheduler.schedule {
                            observer.send(value: nil)
                            observer.sendCompleted()
                        }
                        return nil
                    }
                    var testValue = UIColor.black

                    viewModel.passwordTextFieldBackgroundColor(passwordSignal: passwordSignal!)
                        .observeValues({
                            testValue = $0
                        })

                    expect(testValue).to(equal(UIColor.black))
                    testScheduler.run()
                    expect(testValue).to(equal(UIColor.yellow))
                })
            })

            context("given a valid password and invalid useranme", {
                beforeEach {
                    passwordSignal = Signal { observer in
                        testScheduler.schedule {
                            observer.send(value: "valid")
                            observer.sendCompleted()
                        }
                        return nil
                    }

                    usernameSignal = Signal { observer in
                        testScheduler.schedule {
                            observer.send(value: "12")
                            observer.sendCompleted()
                        }
                        return nil
                    }
                }

                it("Should return true for passwordSignal", closure: {
                    var testPasswordValue = false
                    viewModel.validPasswordSignal(passwordSignal: passwordSignal!)
                        .observeValues({ (value) in
                            testPasswordValue = value
                        })

                    expect(testPasswordValue).to(equal(false))
                    testScheduler.run()
                    expect(testPasswordValue).to(equal(true))
                })

                it("Should return false for usernameSignal", closure: {
                    var testvalue = true
                    viewModel.validUsernameSignal(usernameSignal: usernameSignal!)
                        .observeValues({
                            testvalue = $0
                        })

                    expect(testvalue).to(equal(true))
                    testScheduler.run()
                    expect(testvalue).to(equal(false))
                })

                it("Should have the correct password text field background color", closure: {
                    var testColor = UIColor.black
                    viewModel.passwordTextFieldBackgroundColor(passwordSignal: passwordSignal!)
                        .observeValues({
                            testColor = $0
                        })
                    expect(testColor).to(equal(UIColor.black))
                    testScheduler.run()
                    expect(testColor).to(equal(UIColor.clear))
                })

                it("Should return the correct value for all valid fields", closure: {
                    var testValue = false
                    viewModel.allValidFields(usernameSignal: usernameSignal!, passwordSignal: passwordSignal!)
                        .observeValues({
                            testValue = $0
                        })
                    expect(testValue).to(equal(false))
                    testScheduler.run()
                    expect(testValue).to(equal(false))
                })
            })

            context("Given username is nil", {
                it("Should return false for validUsername", closure: {
                    usernameSignal = Signal { observer in
                        testScheduler.schedule {
                            observer.send(value: nil)
                            observer.sendCompleted()
                        }
                        return nil
                    }
                    var testValue = false

                    viewModel.validUsernameSignal(usernameSignal: usernameSignal!)
                        .observeValues({ (value) in
                            testValue = value
                        })

                    expect(testValue).to(equal(false))
                    testScheduler.run()
                    expect(testValue).to(equal(false))
                })

                it("Should return the correct background Color", closure: {
                    usernameSignal = Signal { observer in
                        testScheduler.schedule {
                            observer.send(value: nil)
                            observer.sendCompleted()
                        }
                        return nil
                    }
                    var testValue = UIColor.black

                    viewModel.userNameTextFieldBackgroundColor(usernameSignal: usernameSignal!)
                        .observeValues({
                            testValue = $0
                        })

                    expect(testValue).to(equal(UIColor.black))
                    testScheduler.run()
                    expect(testValue).to(equal(UIColor.yellow))
                })
            })

            context("Given a valid username and invalid password", {
                beforeEach {
                    passwordSignal = Signal { observer in
                        testScheduler.schedule {
                            observer.send(value: "va")
                            observer.sendCompleted()
                        }
                        return nil
                    }

                    usernameSignal = Signal { observer in
                        testScheduler.schedule {
                            observer.send(value: "1234")
                            observer.sendCompleted()
                        }
                        return nil
                    }
                }

                it("Should return true for usernameSignal", closure: {
                    var testValue = false
                    viewModel.validUsernameSignal(usernameSignal: usernameSignal!)
                        .observeValues({
                            testValue = $0
                        })
                    expect(testValue).to(equal(false))
                    testScheduler.run()
                    expect(testValue).to(equal(true))
                })

                it("Should return false for passwordSignal", closure: {
                    var testvalue = false
                    viewModel.validPasswordSignal(passwordSignal: passwordSignal!)
                        .observeValues({
                            testvalue = $0
                        })

                    expect(testvalue).to(equal(false))
                    testScheduler.run()
                    expect(testvalue).to(equal(false))
                })

                it("Should have the correct username text field background color", closure: {
                    var testColor = UIColor.black
                    viewModel.userNameTextFieldBackgroundColor(usernameSignal: usernameSignal!)
                        .observeValues({
                            testColor = $0
                        })
                    expect(testColor).to(equal(UIColor.black))
                    testScheduler.run()
                    expect(testColor).to(equal(UIColor.clear))
                })

                it("Should return the correct value for all valid fields", closure: {
                    var testValue = false
                    viewModel.allValidFields(usernameSignal: usernameSignal!, passwordSignal: passwordSignal!)
                        .observeValues({
                            testValue = $0
                        })
                    expect(testValue).to(equal(false))
                    testScheduler.run()
                    expect(testValue).to(equal(false))
                })
            })

            context("Given a valid password and username", {

                beforeEach {
                    passwordSignal = Signal { observer in
                        testScheduler.schedule {
                            observer.send(value: "1234")
                            observer.sendCompleted()
                        }
                        return nil
                    }

                    usernameSignal = Signal { observer in
                        testScheduler.schedule {
                            observer.send(value: "1234")
                            observer.sendCompleted()
                        }
                        return nil
                    }
                }

                it("Should return the correct value for all valid fields", closure: {
                    var testValue = false
                    viewModel.allValidFields(usernameSignal: usernameSignal!, passwordSignal: passwordSignal!)
                        .observeValues({
                            testValue = $0
                        })
                    expect(testValue).to(equal(false))
                    testScheduler.run()
                    expect(testValue).to(equal(true))
                })

            })

        }

    }
}
