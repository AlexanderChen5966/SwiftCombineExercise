//: [上一頁](@previous)

import Foundation
import Combine

/*:
## Scheduler
- scheduler是用來幫助publisher在什麼時候以及什麼地方，發送或接收資料
- 例如：更新UI狀態，需要確保相關的操作執行是在“主線程”，就是說如果publisher是在背景線程執行，被訂閱後直到狀態改變，並且需要更新UI的時候，就需要從背景執行線程 -> 主線程
*/

/*:
## `receive(on:)`
- 可以定義在什麼型態的線程“接收”資料
- 只能改變downstream的線程狀態
- 常用的情境為在背景線程執行完成任務之後，接著將結果顯示在主線程的UI上
*/


//let receiveSubscription = Just(1)
//    .map { _ in
//        print("目前是否在主線程1:",Thread.isMainThread)
//        print("目前線程是1:",Thread.current)
//    }
//    .receive(on: DispatchQueue.global())//背景線程
//    .map {
//        print("目前是否在主線程1:",Thread.isMainThread)
//        print("目前線程是1:",Thread.current)
//    }
//    .receive(on: RunLoop.main)//回到主線程
//    .sink {
//        print("目前是否在主線程1:",Thread.isMainThread)
//        print("目前線程是1:",Thread.current)
//    }


/*:
## `subscribe(on:)`
- subscribe跟receive剛好相反，只能改變upstream的線程狀態
- 可以指定upstream執行訂閱、取消、請求操作的線程
*/

let subscribeSubscription1 = Just(1)
    .map { _ in
        print("目前是否在主線程3:",Thread.isMainThread)
        print("目前線程是3:",Thread.current)
    }
    .subscribe(on: DispatchQueue.global())//訂閱改成背景線程
    .map { _ in
        print("目前是否在主線程2:",Thread.isMainThread)
        print("目前線程是2:",Thread.current)
    }
    .subscribe(on: DispatchQueue.main)//再將訂閱改成主線程
    .sink {
        print("目前是否在主線程2:",Thread.isMainThread)
        print("目前線程是2:",Thread.current)
        /*
         會發現第一次subscribe改成背景線程後
         第二次subscribe再改回主線程
         最終結果並沒有回到主線程
         */
    }



let subscribeSubscription2 = Just(1)
    .map { _ in
        print("目前是否在主線程3:",Thread.isMainThread)
        print("目前線程是3:",Thread.current)
    }
    .subscribe(on: DispatchQueue.global())//訂閱改成背景線程
    .map { _ in
        print("目前是否在主線程3:",Thread.isMainThread)
        print("目前線程是3:",Thread.current)
    }
    .receive(on: DispatchQueue.main)
    .sink {
        print("目前是否在主線程3:",Thread.isMainThread)
        print("目前線程是3:",Thread.current)
        /*
         一開始在主線程
         會發現subscribe後，會改成背景線程
         再使用receive就會改回主線程
         */
    }



/*
 參考資料
 https://juejin.cn/post/6918909429882716168
 
 https://www.jianshu.com/p/f671b7acc2c2
 
 https://blog.ficowshen.com/page/post/28
 */
//: [下一頁](@next)
