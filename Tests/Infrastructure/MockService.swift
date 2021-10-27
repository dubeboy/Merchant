import Foundation
import Mocker
import Alamofire
@testable import Merchant

struct MockService: Service {
    let baseURL: String = "http://localhost:8080/hello"
    let query: [String: StringRepresentable]? = ["api_key": "1234567890_XYZ"]
    var logger: LogLevel? = .nothing
    let session: Alamofire.Session? = {
        let config = URLSessionConfiguration.af.default
        config.protocolClasses = [MockingURLProtocol.self] + (config.protocolClasses ?? [])
        return Session(configuration: config)
    }()
}

// MARK: HTTP Method helper functions
extension MockService {
    func stubAlamofire(mockTestURL: String? = nil,
                       statusCode: Int = 200,
                       method: Mock.HTTPMethod = .get) {

        let mockedData = try! JSONEncoder().encode(Const.userMock)
        let mock = Mock(url: URL(string: mockTestURL ?? baseURL)!, dataType: .json, statusCode: statusCode, data: [method: mockedData])
        mock.register()

    }

    mutating func stubPostAlamofire<T: Encodable>(mockTestURL: String? = nil,
                                         statusCode: Int = 200,
                                         method: Mock.HTTPMethod = .post,
                                         data: T,
                                         globalQuery: Bool = false,
                                         logger: LogLevel?) {
        let mockedData = try! JSONEncoder().encode(data)

        self.logger = logger ?? .nothing
        let mock = Mock(url: URL(string: mockTestURL ?? baseURL)!,
                ignoreQuery: true,
                dataType: .json,
                statusCode: statusCode,
                data: [method: mockedData])
        mock.register()
    }
}


