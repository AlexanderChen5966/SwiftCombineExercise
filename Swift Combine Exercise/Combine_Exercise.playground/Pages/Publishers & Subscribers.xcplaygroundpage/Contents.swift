//: [上一頁](@previous)
/*:
 ## Publisher
 - 發佈者，作為發送訊息傳遞資料的角色
 - 發佈者可以傳遞元素到一個或多個訂閱者
 
 
 
 ---

 ## Subscriber
 - 訂閱者，作為接收資料的角色

 
 ---
 有很多種類的Publishers
 - Publisher
 - Publishers
 - AnyPublisher
 - Published
 - Cancellable
 - AnyCancellabe
 - Convenience Publisher
 - ConnectablePublisher

 ---
 Publisher和Subscriber 通常會成對出現
 應該是說只有發佈卻沒有訂閱，整個事件沒辦法運作
 
 */
import Combine

/*:
 使用Just簡單的先建立Publisher
 */

//建立Publish
let simplePublisher1 = Just(25)

//使用sink來接收資料
let simpleSubscription1 = simplePublisher1.sink { (value) in
    print("從simplePublisher1收到的: \(value)")
}

//let arrayPublisher = Just([99,20,63])
//let arraySubscription = arrayPublisher.sink { (value) in
//    print("從arrayPublisher收到的: \(value)")
//}


//或是可以針對序列資料資料使用"publish"關鍵字，就可以讓資料轉換成publish
let simplePublisher2 = [10,20,30].publisher
let simpleSubscription2 = simplePublisher2.sink { (value) in
    print("從simplePublisher2收到的: \(value)")
}
//Dictionary資料也可以
["AAA":123,"BBB":456,"CCC":789].publisher

//Set也可以
let someInts: Set = [1, 2, 3]
someInts.publisher

//字串
"XYZ".publisher
//: [下一頁](@next)
