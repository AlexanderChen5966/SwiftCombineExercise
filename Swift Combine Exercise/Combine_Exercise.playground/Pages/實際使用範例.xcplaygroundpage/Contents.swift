//: [上一頁](@previous)

import Foundation
import Combine

/*:
 ### 接著會以URL發出請求當作範例
 ### 會比較貼近實際開發的狀況
 ---
 接下來會以下面的網址當作測試資料
 https://jsonplaceholder.typicode.com/posts
 用來測試http statusCode
 https://httpstat.us/404
 */


let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
//let url = URL(string: "https://httpstat.us/404")!

var request = URLRequest(url: url)

enum HTTPError: Error {
    case statusCode
    case post
}

/*:
 ### 為了比較未使用Combine，與使用Combine的差異所以兩種方式都會寫
 
 ### 一般使用URLSession的方法
 */

let sessionTask1 = URLSession.shared.dataTask(with: request){
    (data, response, error) in
    
    if let error = error {
        print("Error: \(error.localizedDescription)")
    }
    guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
        print("Error: 非正常的HTTP狀態碼1")
        return
    }
    guard let data = data else {
        print("Error: missing data")
        return
    }
    print(data)
    //接著就可以進行Json Parser

}
sessionTask1.resume()

/*:
 ### 使用Combine的dataTaskPublisher方法
 */

//:如果StatusCode為非200時，receiveValue不會收到數值，但是receiveCompletion會運作，但不會進入回報錯誤，在實務上不符合期望
let sessionTaskPublisher1 = URLSession.shared.dataTaskPublisher(for: request)
    .map{$0.data}
    .sink { (completeStatus) in
        print("completeStatus1:\(completeStatus)")

    } receiveValue: { (value) in
        print("data1:\(value)")
    }

//:所以為了解決StatusCode為非200，需要進入Error處理，
//:1.用tryMap 透過try catch 用throw回傳Error，
let sessionTaskPublisher2 = URLSession.shared.dataTaskPublisher(for: request)
    .tryMap{ data,response -> Data in
        guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
            print("Error: 非正常的HTTP狀態碼2")
            throw HTTPError.statusCode
        }
        
        return data

    }
    .sink { (completeStatus) in
        print("completeStatus2:\(completeStatus)")

    } receiveValue: { (value) in
        print("data2:\(value)")
    }

//:2.用map並加入回傳Result的回傳值
let sessionTaskPublisher3 = URLSession.shared.dataTaskPublisher(for: request)
    .map{ data,response -> Result<Data,HTTPError> in
        guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
            print("Error: 非正常的HTTP狀態碼3")
            return .failure(.statusCode)
        }
        print("success3:",data)

        return .success(data)
    }
    .sink { (completeStatus) in
    print("completeStatus3:\(completeStatus)")

    } receiveValue: { (value) in
        print("data3:\(value)")
    }


/*:
 上面是說明URL Request發出之後的例子
 
 接著會繼續說明收到response，接著如何進行JSON Parser
 */

/*
 https://jsonplaceholder.typicode.com/posts
所回傳的JSON格式如下：
 [
   {
     "userId": 1,
     "id": 1,
     "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
     "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
   },
   {
     "userId": 1,
     "id": 2,
     "title": "qui est esse",
     "body": "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla"
   },
   {
     "userId": 1,
     "id": 3,
     "title": "ea molestias quasi exercitationem repellat qui ipsa sit aut",
     "body": "et iusto sed quo iure\nvoluptatem occaecati omnis eligendi aut ad\nvoluptatem doloribus vel accusantium quis pariatur\nmolestiae porro eius odio et labore et velit aut"
   },
   {
     "userId": 1,
     "id": 4,
     "title": "eum et est occaecati",
     "body": "ullam et saepe reiciendis voluptatem adipisci\nsit amet autem assumenda provident rerum culpa\nquis hic commodi nesciunt rem tenetur doloremque ipsam iure\nquis sunt voluptatem rerum illo velit"
   },
    .....
 ]
 */


//使用Codable協助JSON的解析
struct TestDataModel: Codable {
    public let userId:Int
    public let id:Int
    public let title:String
    public let body:String

}


/*:
 ### 一般使用URLSession的方法取得回傳資訊並進行JSON Parser
 */
let sessionTask2 = URLSession.shared.dataTask(with: request){
    (data, response, error) in
    
    if let error = error {
        print("Error: \(error.localizedDescription)")
    }
    guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
        print("Error: 非正常的HTTP狀態碼1")
        return
    }
    guard let data = data else {
        print("Error: missing data")
        return
    }
    print(data)
    //接著就可以進行Json Parser
    jsonParser(jsonData: data)
}
sessionTask2.resume()


func jsonParser(jsonData: Data) {
    
    do {
        let decoder = JSONDecoder()
        let posts = try decoder.decode([TestDataModel].self, from: jsonData)
        print("---sessionTask2 JSON---")
        print("sessionTask2 JSON:", posts.first)
        
        print("---title---")
        print("sessionTask2 JSON title:", posts.first!.title)

    }
    catch {
        print("Error: \(error.localizedDescription)")
    }
}


/*:
 ### 使用Combine的dataTaskPublisher方法取得回傳資訊並進行JSON Parser
 ---
 這裡繼續使用上面的tryMap版本的方法
 tryMap之後使用decode方法將需要的解析資訊放入
 */


let sessionTaskPublisher4 = URLSession.shared.dataTaskPublisher(for: request)
    .tryMap{ data,response -> Data in
        guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
            print("---error---")
            print("Error: 非正常的HTTP狀態碼4")
            throw HTTPError.statusCode
        }
        return data
    }
    .decode(type: [TestDataModel].self, decoder: JSONDecoder())
    

let sessionTaskSubscripter = sessionTaskPublisher4
    .sink { (completeStatus) in
    print("---completeStatus4---")
    print("completeStatus4:\(completeStatus)")

    } receiveValue: { (jsonValue) in
        print("---jsonValue---")
        print("jsonValue:\(jsonValue.first)")
    }

//: [下一頁](@next)
