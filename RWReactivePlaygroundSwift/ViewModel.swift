//
//  ViewModel.swift
//  RWReactivePlaygroundSwift
//
//  Created by Alan O'Connor on 19/02/2017.
//  Copyright © 2017 codebiscuits. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError

class ViewModel {

    func allValidFields(usernameSignal: Signal<String?, NoError>, passwordSignal: Signal<String?, NoError>) -> Signal<Bool, NoError> {
        return _validPasswordSignal(passwordSignal: passwordSignal).combineLatest(with: _validUsernameSignal(usernameSignal: usernameSignal))
            .map({ (validPassword, validUsername) in
                return validPassword && validUsername
            })
    }

    func userNameTextFieldBackgroundColor(usernameSignal: Signal<String?, NoError>) -> Signal<UIColor, NoError> {
        return _validUsernameSignal(usernameSignal: usernameSignal)
            .map({
                return $0 ? UIColor.clear : UIColor.yellow
            })
    }

    func passwordTextFieldBackgroundColor(passwordSignal: Signal<String?, NoError>) -> Signal<UIColor, NoError> {
        return _validPasswordSignal(passwordSignal: passwordSignal)
            .map({
                return $0 ? UIColor.clear : UIColor.yellow
            })
    }
}

// Private funcs
extension ViewModel {
    fileprivate func _validPasswordSignal(passwordSignal: Signal<String?, NoError>) -> Signal<Bool, NoError> {
        return passwordSignal.map({ [weak self] (text) in
            return self?._isValidPassword(password: text ?? "")
        })
            .skipNil()
    }

    fileprivate func _validUsernameSignal(usernameSignal: Signal<String?, NoError>) -> Signal<Bool, NoError> {
        return usernameSignal.map({ [weak self] (text) in
            return self?._isValidUsername(username: text ?? "")
        })
            .skipNil()
    }

    fileprivate func _isValidUsername(username: String) -> Bool {
        return username.characters.count > 3
    }

    fileprivate func _isValidPassword(password: String) -> Bool {
        return password.characters.count > 3
    }
}
