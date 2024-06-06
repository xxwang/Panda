import UIKit

public enum DecimalNumberHandlerOperator: String {
    case add
    case sub
    case mul
    case div
}

public extension NSDecimalNumberHandler {
    static func sk_calculation(operator: DecimalNumberHandlerOperator,
                               valueA: Any,
                               valueB: Any) -> NSDecimalNumber
    {
        return sk_decimalNumberCalculate(valueA: valueA,
                                         valueB: valueB,
                                         operator: `operator`,
                                         roundingMode: .down,
                                         scale: 30)
    }

    static func sk_intFloor(valueA: Any, valueB: Any) -> Int {
        return sk_decimalNumberCalculate(valueA: valueA,
                                         valueB: valueB,
                                         operator: .div,
                                         roundingMode: .down,
                                         scale: 0).intValue
    }

    static func sk_isDivisible(valueA: Any, valueB: Any) -> Bool {
        let value = sk_decimalNumberCalculate(valueA: valueA,
                                              valueB: valueB,
                                              operator: .div,
                                              roundingMode: .down,
                                              scale: 3).stringValue
        let values = value.sk_split(with: ".")
        guard values.count > 1 else { return true }
        let decimalValue = values[1]
        guard decimalValue.count == 1, decimalValue == "0" else { return false }
        return true
    }

    static func sk_decimalNumberCalculate(valueA: Any,
                                          valueB: Any,
                                          operator: DecimalNumberHandlerOperator,
                                          roundingMode: NSDecimalNumber.RoundingMode,
                                          scale: Int16,
                                          raiseOnExactness exact: Bool = false,
                                          raiseOnOverflow overflow: Bool = false,
                                          raiseOnUnderflow underflow: Bool = false,
                                          raiseOnDivideByZero divideByZero: Bool = false) -> NSDecimalNumber
    {
        let amountHandler = NSDecimalNumberHandler(
            roundingMode: roundingMode,
            scale: scale,
            raiseOnExactness: exact,
            raiseOnOverflow: overflow,
            raiseOnUnderflow: underflow,
            raiseOnDivideByZero: divideByZero
        )
        let numberA = NSDecimalNumber(string: "\(valueA)")
        let numberB = NSDecimalNumber(string: "\(valueB)")

        switch `operator` {
        case .add:
            return numberA.adding(numberB, withBehavior: amountHandler)
        case .sub:
            return numberA.subtracting(numberB, withBehavior: amountHandler)
        case .mul:
            return numberA.multiplying(by: numberB, withBehavior: amountHandler)
        case .div:
            return numberA.dividing(by: numberB, withBehavior: amountHandler)
        }
    }
}
