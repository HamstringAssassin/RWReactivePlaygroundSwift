//
//  SignInService.swift
//  RWReactivePlaygroundSwift
//
//  Created by Alan O'Connor on 05/02/2017.
//  Copyright © 2017 codebiscuits. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError

class SignInService {
    func signIn(username: String, password: String) -> SignalProducer<Bool, NoError> {
        return SignalProducer { [weak self] observer, disposable in
            self?._signIn(username: username, password: password, complete: { (value) in
                observer.send(value: value)
            })
            disposable.add({
                observer.sendCompleted()
            })
            
        }
    }

    private func _signIn(username: String, password: String, complete: @escaping (Bool)->Void) {
        let delay = 2.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { 
            let success = username == "user" && password == "password"
            complete(success)
        }
    }
}
