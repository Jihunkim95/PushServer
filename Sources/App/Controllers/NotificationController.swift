import Vapor

struct NotificationPayload: Content {
    let message: Message
}

struct Message: Content {
    let token: String
    let notification: Notification
}

struct Notification: Content {
    let title: String
    let body: String
}

func sendFCMNotification(to token: String, title: String, body: String, on req: Request) throws -> EventLoopFuture<ClientResponse> {
    let url = URI(string: "https://fcm.googleapis.com/v1/projects/bookbridge-a9403/messages:send")
    let payload = NotificationPayload(
        message: Message(
            token: token,
            notification: Notification(title: title, body: body)
        )
    )

    // Firebase 서버 키를 환경 변수에서 로드 (이 방법은 보안적으로 권장됩니다)
    guard let firebaseServerKey = Environment.get("FIREBASE_SERVER_KEY") else {
        throw Abort(.internalServerError, reason: "Firebase 서버 키가 설정되지 않았습니다.")
    }
    
    let headers = HTTPHeaders([
        ("Authorization","Bearer \(firebaseServerKey)"),
        ("Content-Type", "application/json"),
    ])
    print(firebaseServerKey)
    
    return req.client.post(url, headers: headers) { req in
        try req.content.encode(payload)
    }
}
