//: [上一頁](@previous)

import Foundation
import Combine
import UIKit
/*:
## Subjects
- subject也是一種publisher，但又比publisher多了一些功能，是一種比較特殊的publisher
- subject也可以是個subscriber並且可以使用`subscribe(_:)`方法
- 所以subject既可以是publisher也可以是subscriber
- 提供三種`send(_:)`方法:
 1. func send(_ value: Self.Output)
 2. func send(completion: Subscribers.Completion<Self.Failure>)
 3. func send(subscription: Subscription)
*/

/*:
## CurrentValueSubject
- 需要初始值
- 使用`send(_:)`方法時會更新目前的數值並發送給訂閱者
*/
var cancellable1: AnyCancellable?
var cancellable2: AnyCancellable?

let currentValueSubject = CurrentValueSubject<Int, Never>(5)

currentValueSubject.send(-1)
currentValueSubject.send(-2)
currentValueSubject.send(-3)


cancellable1 = currentValueSubject
    .sink(receiveValue: { print("cancellable1:",$0) })//可以持續取得最新的元素

currentValueSubject.send(1)
currentValueSubject.send(2)
currentValueSubject.send(3)

cancellable2 = currentValueSubject
    .sink(receiveValue: { print("cancellable2:",$0) })//從訂閱起目前最新的元素開始取得

cancellable1?.cancel()//cancellable1取消後就不會在收到任何數值

currentValueSubject.send(4)//cancellable2依然可以取得


/*:
## PassthroughSubject
- 不需要初始值
-
 
*/
let passthroughSubject = PassthroughSubject<String, Never>()
var cancellable3: AnyCancellable?


passthroughSubject.send("Hello!")
passthroughSubject.send("Hi!")

cancellable3 = passthroughSubject.sink(receiveValue: { print("cancellable3:",$0)})
passthroughSubject.send("Hello Again!")
passthroughSubject.send(completion: .finished)//.finished之後的訊息就不會出現
passthroughSubject.send("Hi Again!")




//:Subject作為publisher與subscriber
let passthroughSubject1 = PassthroughSubject<String, Never>()//subscriber
let passthroughSubject2 = PassthroughSubject<String, Never>()//publisher

passthroughSubject1.sink(receiveValue: { print("aaa:",$0)})//這裡的passthroughSubject1當作subscriber
passthroughSubject1.send("ABC!")
passthroughSubject1.send("DEF!")

passthroughSubject2.subscribe(passthroughSubject1)//passthroughSubject2作為publisher的角色去訂閱passthroughSubject1
passthroughSubject2.send("GHI!")
passthroughSubject2.send("JKL!")




/*
 參考資料
 https://medium.com/jeremy-xue-s-blog/swift-combine-subject-sink-assign-51af44b8006e
 https://juejin.cn/post/6917427878745358343
 */
//: [下一頁](@next)
