//
//  NSDecimalNumberHandler+.swift
//
//
//  Created by xxwang on 2023/5/27.
//

import UIKit

import Foundation

// MARK: - NSDecimalNumberHandler操作符
public enum DecimalNumberHandlerOperator: String {
    case add // 加法
    case sub // 减法
    case mul // 乘法
    case div // 除法
}

// MARK: - 静态方法
public extension NSDecimalNumberHandler {
    /// 数字计算操作
    /// - Parameters:
    ///   - operator:操作符
    ///   - valueA:要进入计算的数字
    ///   - valueB:要进入计算的数字
    ///   - roundingMode:传入模式
    ///   - scale:小数点后舍入值的位数
    ///   - exact:精度错误处理
    ///   - overflow:溢出错误处理
    ///   - underflow:下溢错误处理
    ///   - divideByZero:除以0的错误处理
    /// - Returns:计算结果`NSDecimalNumber`
    static func decimalNumberCalculate(operator: DecimalNumberHandlerOperator,
                                       valueA: Any,
                                       valueB: Any,
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

// MARK: - 静态方法
public extension NSDecimalNumberHandler {
    /// 简化数字计算操作
    /// - Parameters:
    ///   - operator:操作符
    ///   - valueA:要进入计算的数字
    ///   - valueB:要进入计算的数字
    /// - Returns:计算结果`NSDecimalNumber`
    static func calculation(operator: DecimalNumberHandlerOperator,
                            valueA: Any,
                            valueB: Any) -> NSDecimalNumber
    {
        decimalNumberCalculate(operator: `operator`,
                               valueA: valueA,
                               valueB: valueB,
                               roundingMode: .down,
                               scale: 30)
    }

    /// 向下取整
    /// - Parameters:
    ///   - valueA:被除数
    ///   - valueB:除数
    /// - Returns:`Int`类型值
    static func intFloor(valueA: Any, valueB: Any) -> Int {
        decimalNumberCalculate(operator: .div,
                               valueA: valueA,
                               valueB: valueB,
                               roundingMode: .down,
                               scale: 0).intValue
    }

    /// 判断一个数字是否可以被另一个数字整除
    /// - Parameters:
    ///   - valueA:被除数
    ///   - valueB:除数
    /// - Returns:`Bool`
    static func isDivisible(valueA: Any, valueB: Any) -> Bool {
        let value = decimalNumberCalculate(operator: .div,
                                           valueA: valueA,
                                           valueB: valueB,
                                           roundingMode: .down,
                                           scale: 3).stringValue
        let values = value.split(with: ".")
        guard values.count > 1 else { return true }
        let decimalValue = values[1]
        guard decimalValue.count == 1, decimalValue == "0" else { return false }
        return true
    }
}
