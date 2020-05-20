import Foundation
import Mocker
import Alamofire
@testable import Merchant

let baseURL = "http://localhost/hello"
let userMock = UserMock(name: "John", surname: "Snow")
let postUserMock = UserMock(name: "Post", surname: "User")
    
func stubAlamofire(mockTestURL: String = "http://localhost/hello",
                   statusCode: Int = 200,
                   method: Mock.HTTPMethod = .get
) {
    
    let mockedData = try! JSONEncoder().encode(userMock)
    let mock = Mock(url: URL(string: mockTestURL)!, dataType: .json, statusCode: statusCode, data: [method: mockedData])
    mock.register()
    
    let config = URLSessionConfiguration.af.default
    config.protocolClasses = [MockingURLProtocol.self] + (config.protocolClasses ?? [])
    let session = Session(configuration: config)
    let builder = Merchant.Builder()
        .baseUrl(baseURL)
        .logger(.nothing)
        .session(session)
        .build()
    
    Merchant(builder: builder)
}

func stubPostAlamofire<T: Encodable>(mockTestURL: String = "http://localhost/hello/new_user",
                                     statusCode: Int = 200,
                                     method: Mock.HTTPMethod = .post,
                                     data: T,
                                     globalQuery: Bool = false,
                                     logger: MerchantLogger = .nothing
) {
    let mockedData = try! JSONEncoder().encode(data)
    
    let mock = Mock(url: URL(string: mockTestURL)!,
                    ignoreQuery: true,
                    dataType: .json,
                    statusCode: statusCode,
                    data: [method: mockedData])
    mock.register()
    
    let config = URLSessionConfiguration.af.default
    config.protocolClasses = [MockingURLProtocol.self] + (config.protocolClasses ?? [])
    let session = Session(configuration: config)
    let builder = Merchant.Builder()
        .baseUrl(baseURL)
        .logger(logger)
        .session(session)
    
    if globalQuery {
        builder.query(["api_key": "1234567890_XYZ"])
    }
    
    Merchant(builder: builder.build())
}



