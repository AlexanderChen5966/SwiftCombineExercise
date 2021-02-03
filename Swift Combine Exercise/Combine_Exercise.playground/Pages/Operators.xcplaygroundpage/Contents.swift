//: [上一頁](@previous)

import Foundation
import Combine

/*:
## Operators(運算符)
 - 事件流中往往最初的對象和最後產生的對象會不一致，這時就需要Operators的協助幫忙轉換
 - Combine中operators是將一個publisherA當作輸入的對象，轉換成另一個publisherB
 - 舉例說明就是：發URL Request時Publisher為dataPublisher，透過map(_:)的運算符將Publisher轉換成，能符合response的型別
*/

//Combine中提供很多Operators可以使用
//不過這裡只會簡單的使用一些Operators

enum MyError: Error {
    case custom
}

/*:
## map、tryMap
*/


let mapPublisher = [1,2,3].publisher
    
let mapSubscription = mapPublisher
    .map{ value -> Int in
        //map如果碰到錯誤碼，像是Http狀態碼非200時沒辦法使用try catch拋出異常
//        if value == 3 {
//            return MyError.custom
//        }

        value * 10
    }
    .sink { _ in
        print("map finished")
    } receiveValue: { (value) in
        print("map後的資料：\(value)")
    }
    

//接著用同一個資料來源不過改使用tryMap
//tryMap就能夠使用try catch拋出異常

let tryMapSubscription = mapPublisher.tryMap { value -> Int in
    if value == 3 {
        throw MyError.custom
    }
    return value * 10
}.sink { _ in
    print("tryMap finished")
} receiveValue: { (value) in
    print("tryMap後的資料：\(value)")
}
    

/*:
## filter
*/

let filterPublisher = [1,2,3,6,7,8,51,70].publisher
let filterSubscription = filterPublisher.filter { (value) -> Bool in
    value % 2 == 0
}.sink { _ in
    print("filter finished")
} receiveValue: { (value) in
    print("filter後的資料：\(value)")
}


/*:
## merge
*/
let mergePublisher1 = [5,10,15,20].publisher
let mergePublisher2 = [777,888,999].publisher
let mergePublishersSubscription1 = mergePublisher1
    .merge(with: mergePublisher2)
    .sink { _ in
    print("merge1 finished")
} receiveValue: { (value) in
    print("merge1後的資料：\(value)")
}

//或是
let mergePublishersSubscription2 = Publishers.Merge(mergePublisher1,mergePublisher2)
    .sink { _ in
    print("merge2 finished")
} receiveValue: { (value) in
    print("merge2後的資料：\(value)")
}

/*:
## combineLatest
 下面會模擬類似輸入完帳號、密碼後確認是否有資訊沒有填寫的例子
*/

let usernamePublisher = PassthroughSubject<String, Never>()
let passwordPublisher = PassthroughSubject<String, Never>()

let validatedCredentialsSubscription1 = usernamePublisher.combineLatest(passwordPublisher)
    .map({
    (username,password) -> Bool in
    !username.isEmpty && !password.isEmpty && password.count >  12
    })
    .sink { _ in
        print("combineLatest1 finished")
    } receiveValue: { (value) in
        print("帳號、密碼是否完整填寫1：\(value)")
    }

//另一種寫法
let validatedCredentialsSubscription2 =
    Publishers.CombineLatest(usernamePublisher,passwordPublisher)
    .map({
    (username,password) -> Bool in
    !username.isEmpty && !password.isEmpty && password.count >  12
    })
    .sink { _ in
        print("combineLatest2 finished")
    } receiveValue: { (value) in
        print("帳號、密碼是否完整填寫2：\(value)")
    }

usernamePublisher.send("Alexander")
passwordPublisher.send("沒有大於12個字")
passwordPublisher.send("大於12個字的密碼才會過關")

/*
 參考資料
 https://heckj.github.io/swiftui-notes/#coreconcepts-operators
 
 https://medium.com/better-programming/6-combining-operators-you-should-know-from-swift-combine-17ea69d9dad7
 
 https://www.infoq.cn/article/eaq01u5jevuvqfghlqbs
 
 https://codingnote.cc/zh-tw/p/235672/
 
 */

//: [下一頁](@next)
