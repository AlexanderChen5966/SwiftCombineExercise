//: [上一頁](@previous)

import Foundation
import Combine
import UIKit
/*:
 ## Subscriber
 - 訂閱者
 - 作為接收資料的角色
 */

/*:
 Combine有提供
 - _public func assign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable_ : 透過keypath的方式寫入參數
 - _public func sink(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable_ : 接收到完成信號以及每次接收到新元素時執行的方法
 
 ----
 兩種方法作為訂閱的參數
 */

//:使用assign，透過keypath的方式寫入Label
let ageLabel = UILabel()
Just("25").map{ "Age is \($0)" }.assign(to: \.text, on: ageLabel)
ageLabel.text


class MyClass {
    var ageLabelStrig: String = "" {
        didSet {
            print("Did set property to \(ageLabelStrig)")
        }
    }
}
let object = MyClass()

Just("99").map{ "Age is \($0)" }.assign(to: \.ageLabelStrig, on: object)

//:使用sink接收publish送來的資訊

Just("888").sink(
    receiveCompletion: {
    print($0)
}, receiveValue: {
    print($0)
})

/*
 參考資料
 https://medium.com/jeremy-xue-s-blog/swift-combine-subscribers-3c31106f76e9
 
 https://juejin.cn/post/6919652912734535693
 */


//: [下一頁](@next)
