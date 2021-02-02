import UIKit
/*
 在註解第一格要加:(分號)
 勾選Playground Setting裡的"Render Documentation"就能看到效果
 # 井字號是字體大小 # ## ###
 - 分開項目的標示
 */

//:這是個人的一點學習心得記錄，不代表觀念一定是正確的，如果看到錯誤的地方歡迎指正
/*:
 ## Combine是什麼？
 - 如果對RxSwift有一定熟悉度，那麼對Combine的觀念應該會很清楚
 - Combine 是Apple推出的"響應式程式設計 _Functional Reactive Programming_ (FRP)"框架，用來處理隨著時間變化的"非同步"事件
 - 響應式程式設計是一種宣告式或是聲明式(Declarative)的程式設計方式，比命令式程式設計 (Imperative Programming) ，更難以了解，剛接觸時會無法理解是很正常的
 */

/*:
 ### Combine有幾個很重要的參數
 - Publisher(發佈者):資料的提供者
 - Subscriber(訂閱者):接收資料的接收者
 - Operator:在送出與接收資料之間進行處理的用途
 - Subject:
 */

/*
 參考資料
 https://www.appcoda.com.tw/functional-reactive-programming/
 https://juejin.cn/post/6911489863204700167
 */
import Combine

//:[下一頁](@next)
