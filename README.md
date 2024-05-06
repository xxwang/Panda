# Panda

```swift
// MARK: - 使用方法

// 要扩展的类型需要先遵守协议
extension [类型]: Pandaable {}

// 添加方法列表
public extension PandaEx where Base: [类型] {
    //TODO: - 具体方法
}

// 调用方法
类型实例.pd.方法名() //实例方法
类型.pd.方法名() //类型方法


// MARK: - 演示
class Person {
    var name: String = "..."
}

extension Person: Pandaable {}
extension PandaEx where Base: Person {
   func printName() {
       print(self.base.name)
   }
}

let person = Person()
person.pd.printName()

```
