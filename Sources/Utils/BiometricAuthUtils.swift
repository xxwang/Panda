
import Foundation
import LocalAuthentication

class BiometricAuthUtils {

    public weak var delegate: BiometricAuthUtilsDelegate?
    private lazy var context: LAContext = {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Unlock with password"
        return context
    }()

    var localizedReason: String {
        if biometricMode == .touchID {
            return "Use fingerprint to unlock, if there are too many errors, you can use password to unlock"
        } else {
            return "Unlock using facial recognition. If there are too many errors, you can unlock using a password"
        }
    }

    public static let shared = BiometricAuthUtils()
    private init() {}
}

extension BiometricAuthUtils {
    public var isAvaliable: Bool {
        if #available(iOS 8.0, *) {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        } else {
            return false
        }
    }

    public var biometricMode: BiometricAuthMode {
        if #available(iOS 8.0, *) {
            if context.biometryType == .touchID {
                return .touchID
            } else if context.biometryType == .faceID {
                return .faceID
            } else {
                return .none
            }
        } else {
            return .none
        }
    }
}

extension BiometricAuthUtils {

    public func evokeAuth() {
        guard #available(iOS 8.0, *) else {
            delegate?.biometricAuthResult(result: .versionNotSupport, mode: biometricMode)
            return
        }

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            authErrorHandler(errorCode: error?.code ?? 0, context: context)
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { success, evaluateError in
            DispatchQueue.xx_async_execute_on_main {
                if success {
                    self.delegate?.biometricAuthResult(result: .success, mode: self.biometricMode)
                } else {
                    if let error = evaluateError as NSError? {
                        self.authErrorHandler(errorCode: error.code, context: self.context)
                    }
                }
            }
        }
    }

    private func authErrorHandler(errorCode: Int, context: LAContext) {
        if errorCode == LAError.authenticationFailed.rawValue {
            delegate?.biometricAuthResult(result: .authenticationFailed, mode: biometricMode)
        } else if errorCode == LAError.userCancel.rawValue {
            delegate?.biometricAuthResult(result: .userCancel, mode: biometricMode)
        } else if errorCode == LAError.userFallback.rawValue {
            delegate?.biometricAuthResult(result: .userFallback, mode: biometricMode)
        } else if errorCode == LAError.systemCancel.rawValue {
            delegate?.biometricAuthResult(result: .systemCancel, mode: biometricMode)
        } else if errorCode == LAError.passcodeNotSet.rawValue {
            delegate?.biometricAuthResult(result: .passcodeNotSet, mode: biometricMode)
        } else {
            if #available(iOS 11.0, *) {
                if errorCode == LAError.biometryNotAvailable.rawValue {
                    delegate?.biometricAuthResult(result: .biometryNotAvailable, mode: self.biometricMode)
                } else if errorCode == LAError.biometryNotEnrolled.rawValue {
                    delegate?.biometricAuthResult(result: .biometryNotEnrolled, mode: self.biometricMode)
                } else if errorCode == LAError.biometryLockout.rawValue {
                    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: localizedReason, reply: { success, evaluateError in
                        DispatchQueue.xx_async_execute_on_main {
                            if success {
                                self.delegate?.biometricAuthResult(result: .success, mode: self.biometricMode)
                            } else {
                                if let error = evaluateError as NSError? {
                                    self.authErrorHandler(errorCode: error.code, context: self.context)
                                }
                            }
                        }

                    })
                }
            }
        }
    }
}

public protocol BiometricAuthUtilsDelegate: NSObjectProtocol {
    func biometricAuthResult(result: BiometricAuthResult, mode: BiometricAuthMode)
}

public enum BiometricAuthMode {
    case touchID
    case faceID
    case none
}

public enum BiometricAuthResult {

    case success
    case versionNotSupport
    case deviceNotSupport
    case authenticationFailed
    case userCancel
    case userFallback
    case systemCancel
    case passcodeNotSet
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case touchIDLockout
    case appCancel
    case invalidContext
    case touchIdNotAvailable
    case touchIDNotEnrolled
}
