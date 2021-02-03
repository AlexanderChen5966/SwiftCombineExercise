//: [上一頁](@previous)

import Foundation
import Combine

/*:
 ## Cancellable
 - 發佈者
 - 與發佈者不同的地方在於，有支援取消活動或事件的方法
 - 執行 cancel()可以釋放被分配的資源，像是計時器、網路訪問、硬體的I/O等等
 - 為protocol
 */

//let timePublish = Timer.publish(every: 1, on: .main, in: .default)
//
//var cancellable: Cancellable? = timePublish.print().sink { (data) in
//}
//
//timePublish.connect()


//var cancellable: Cancellable?
//cancellable = Timer.publish(every: 1, on: .main, in: .default).autoconnect().print().sink(receiveValue: { (time) in
//    print(time)
//
//})
//
//DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//    cancellable?.cancel()
//}


/*:
 ## AnyCancellable
 - 發佈者
 - 與發佈者不同的地方在於，有支援取消活動或事件的方法
 - 執行 cancel()可以釋放被分配的資源，像是計時器、網路訪問、硬體的I/O等等
 - 在deinitialized的時候會自動呼叫cancel()，Cancellable需要手動取消
 - 為class
 - 不能使用Subscription物件
 */


var anyCancellable:AnyCancellable?
anyCancellable = Timer.publish(every: 1, on: .main, in: .default).autoconnect().sink(receiveValue: { (time) in
    print(time)
})


DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        anyCancellable?.cancel()
}

//Timer.publish(every: 1, on: .main, in: .default) 與 Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)是一樣的沒有差異

let intervalPublisher = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
let intervalPublisher1 = Timer.publish(every: 1, on: .main, in: .default)

//手動控制連結與終止連結
var cancellable: AnyCancellable?
var timerPublisher = Timer.publish(every: 1.0, on: .main, in: .common)
var connectable: Cancellable?
var count: Int = 1

func startTimer() {
    cancellable = timerPublisher
        .sink(receiveCompletion: {
            print($0)
        }, receiveValue: { _ in
            count += 1
        })
    
    connectable = timerPublisher
        .connect()
}

func stopTimer() {
    connectable?.cancel()
}

startTimer()
DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    stopTimer()
}

//: [下一頁](@next)
