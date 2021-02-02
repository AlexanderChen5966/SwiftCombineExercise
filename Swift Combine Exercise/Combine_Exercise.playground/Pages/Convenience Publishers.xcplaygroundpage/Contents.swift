//: [上一頁](@previous)

import Foundation
import Combine

/*:
 Combine有提供比較方便能夠產生Publisher的Convenience Publishers方法
 像是:
 - Just
 - Future
 - Deferred
 - Empty
 - Fail
 - Record
 
 */

/*:
 Just
 可以很簡單的建立一個publish ，這個publish 只會向subscriber發佈一次，然後結束
 */
//建立Publish
let simplePublisher1 = Just(50)

//使用sink來接收資料
let simpleSubscription1 = simplePublisher1.sink { (value) in
    print("從simplePublisher1收到的: \(value)")
}

//可以放陣列、物件的格式
let simplePublisher2 = Just([25,99,87])

/*:
 Future
 最終會發布一個結束或失敗數值的publish
 */
enum MyError: Error {
    case custom
}


let futurePublisher = Future<Bool,MyError>({ promise in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            return promise(.success(true))
//            return promise(.success(false))
//            return promise(.failure(.custom))
            //分別解開註解觀察狀態的變化
        }
    }).sink { (completion) in
        print("從futurePublisher收到completion: \(completion)")
    } receiveValue: { (value) in
        print("從futurePublisher收到的: \(value)")
    }


/*:
 Record
 一個publish允許紀錄其輸入與完成事件資料，等收到subscriber後在發送資料
 */
//:三種初始化方式
//:----
//:1. 使用 _record: (inout Record<Output, Failure>.Recording) -> Void_ ，Closure初始化
let recordPublisher1 = Record<String,MyError> {
  recording in
    recording.receive("Hi")
    recording.receive("Hello")
    recording.receive("你好嗎")
    recording.receive(completion: Subscribers.Completion.finished)
}

recordPublisher1.sink { (completion) in
    print("從recordPublisher1收到completion: \(completion)")
} receiveValue: { (value) in
    print("從recordPublisher1收到的: \(value)")
}

//:2. 使用 _recording: Record<Output, Failure>.Recording_ ，初始化，也就是傳入一個Recording類別的實體

var recording = Record<String, MyError>.Recording()

recording.receive("Hi Again")
recording.receive("Hello Again")
recording.receive("你好嗎 Again")
recording.receive(completion: Subscribers.Completion.finished)



let recordPublisher2 = Record<String, MyError>(recording: recording)

recordPublisher2.sink { (completion) in
    print("從recordPublisher2收到completion: \(completion)")
} receiveValue: { (value) in
    print("從recordPublisher2收到的: \(value)")
}

//:3. 使用 _output: [Output], completion: Subscribers.Completion<Failure>_ ，參數初始化
let recordPublisher3 = Record<String, MyError>(output: ["Hi Hi Hi ", "Hello Hello Hello", "哈囉你好嗎"], completion: Subscribers.Completion.finished)
recordPublisher3.sink { (completion) in
    print("從recordPublisher3收到completion: \(completion)")
} receiveValue: { (value) in
    print("從recordPublisher3收到的: \(value)")
}
// 上面3種初始化方式結果是一樣的，可以選擇一種自己喜歡的來使用


/*:
 Deferred
有subscriber訂閱之後才建立的publish
 */
let deferredPublisher = Deferred {
    return Future<Bool, MyError> { promise in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            return promise(.success(true))
        }
    }
}
.sink(receiveCompletion: { (completion) in
    print("從deferredPublisher收到completion: \(completion)")
}, receiveValue: { (value) in
    print("從deferredPublisher收到的: \(value)")
})

//Deferred與Future通常會一起使用，Future不管有沒有subscriber都會立刻執行，配合Deferred可以簡單的處理非同步的事件

/*:
 Empty
 不發佈任何數值的publish ，並可選擇是否立即結束
 */

let emptyPublisher = Empty<Int, MyError>(completeImmediately: true) //改成true 或false觀察變化


emptyPublisher.sink { (completion) in
    print("從emptyPublisher收到completion: \(completion)")

} receiveValue: { (value) in
    print("從emptyPublisher收到的: \(value)")

}

/*:
 Fail
 會根據特定錯誤而立即終止的publish
 */
let failPublisher = Fail<Int,MyError>(error: .custom)


failPublisher.sink { (completion) in
    print("從failPublisher收到error: \(completion)")

} receiveValue: { (value) in
    print("從failPublisher收到的: \(value)")

}

/*
 參考資料
 https://medium.com/jeremy-xue-s-blog/swift-combine-publishers-299a5b0e2860
 https://juejin.cn/post/6911859875014246407
 */

//: [下一頁](@next)
