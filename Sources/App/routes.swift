import Vapor

// 애플리케이션의 라우트를 정의합니다.
func routes(_ app: Application) throws {
    app.get { req in
        return "Welcome to the Vapor server!"
    }
    
//     '/send-notification' 경로로 POST 요청을 받을 때 처리할 로직
    app.post("send-notification") { req -> EventLoopFuture<ClientResponse> in
        // 요청 본문을 디코딩하여 알림 데이터를 받기
        let notificationData = try req.content.decode(NotificationData.self)
        
        //함수를 호출하여 푸시 알림보내기
        return try sendFCMNotification(
            to: notificationData.token,
            title: notificationData.title,
            body: notificationData.body,
            on: req
        )
    }
    //Test용
    app.post("test-notification") { req -> EventLoopFuture<ClientResponse> in
        let testData = try req.content.decode(NotificationData.self)
        return try sendFCMNotification(
            to: testData.token,
            title: "Test Title",
            body: "This is a test notification body.",
            on: req
        )
    }
}

// 요청 본문에서 사용할 데이터 구조를 정의합니다.
struct NotificationData: Content {
    let token: String
    let title: String
    let body: String
}
