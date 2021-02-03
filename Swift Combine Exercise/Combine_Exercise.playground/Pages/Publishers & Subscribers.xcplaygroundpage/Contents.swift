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


//let x = Just(1) as Publisher //error cast:Just就是一個Publisher

/*:
 
 AnyPublisher 是 Publisher 的具體實現，其本身沒有任何重要的屬性，並且會傳遞來自其上游發布者的元素和完成值
 */
//可以使用Combine中的eraseToAnyPublisher()方法將其轉為AnyPublisher包裝發佈者

func a() -> AnyPublisher<(a: Int, b: String), Never> {
    return Just((a: 1, b: "two")).eraseToAnyPublisher()
}

func b() -> AnyPublisher<String, Never> {
    return a().map(\.b).eraseToAnyPublisher()
}
a().sink(receiveValue: {
    let x = $0 // (a: 1, b: "two)
})

b().sink(receiveValue: {
    let x = $0 // "two"
})


//: [下一頁](@next)
