import Foundation
import Mocker
import XCTest
@testable import Merchant

class LoggerTests: XCTestCase {

    func testNothingLevelLog() {
        makeRequest(logLevel: .nothing) {
            XCTAssertEqual($0, [])
        }
    }

    func testBodyLevelRequestTimeIsLogged() {
        makeRequest(logLevel: .body) {
            XCTAssertTrue(self.matches($0[0], regex: .REGEX_TIME))
        }
    }

    func testBodyLevelRequestMethodIsLogged() {
        makeRequest(logLevel: .body) {
            XCTAssertEqual($0[1], "➡️ POST /hello")
        }
    }

    func testBodyLevelRequestHeadersIsLogged() {
        makeRequest(logLevel: .body) {
            XCTAssertEqual($0[2], "Content-Type: text/plain")
        }
    }

    func testBodyLevelRequestBodyIsLogged() {
        makeRequest(logLevel: .body) {
            XCTAssertEqual($0[3], "name=John&surname=Snow")
        }
    }

    func testBodyLevelRequestEndSymbolIsLogged() {
        makeRequest(logLevel: .body) {
            XCTAssertEqual($0[4], "➡️ END HTTP")
        }
    }

    func testBodyLevelResponseTimeIsLogged() {
        makeRequest(logLevel: .body) {
            XCTAssertTrue(self.matches($0[5], regex: .REGEX_REPONSE_TIME))
        }
    }

    func testBodyLevelResponseContentTypeIsLogged() {
        makeRequest(logLevel: .body) {
            XCTAssertEqual($0[6], "Content-Type: application/json; charset=utf-8")
        }
    }

    func testBodyLevelResponseBodyIsLogged() {
        makeRequest(logLevel: .body) {
            XCTAssertEqual($0[7], "{\"name\":\"John\",\"surname\":\"Snow\"}")
        }
    }

    func testBodyLevelResponseEndSymbolIsLogged() {
        makeRequest(logLevel: .body) {
            XCTAssertEqual($0[8], "⬅️ END HTTP")
        }
    }

    func testBodyLevelResponseCount() {
        makeRequest(logLevel: .body) {
            XCTAssertEqual($0.count, 9)
        }
    }

    // MARK: - BASIC log level

    func testBasicLevelRequestTimeIsLogged() {
        makeRequest(logLevel: .basic) {
            XCTAssertTrue(self.matches($0[0], regex: .REGEX_TIME))
        }
    }

    func testBasicLevelRequestMethodIsLogged() {
        makeRequest(logLevel: .basic) {
            XCTAssertEqual($0[1], "➡️ POST /hello")
        }
    }

    func testBasicLevelResponseStatusCodeIsLogged() {
        makeRequest(logLevel: .basic) {
            XCTAssertTrue(self.matches($0[2], regex: .REGEX_REPONSE_TIME))
        }
    }

    func testBasicLevelLogsCount() {
        makeRequest(logLevel: .basic) {
            XCTAssertEqual($0.count, 3)
        }
    }

    // MARK: - Headers Log level

    func testHeaderLevelRequestTimeIsLogged() {
        makeRequest(logLevel: .headers) {
            XCTAssertTrue(self.matches($0[0], regex: .REGEX_TIME))
        }
    }

    func testHeaderLevelRequestMethodIsLogged() {
        makeRequest(logLevel: .headers) {
            XCTAssertEqual($0[1], "➡️ POST /hello")
        }
    }

    func testHeaderLevelRequestIsLogged() {
        makeRequest(logLevel: .headers) {
            XCTAssertEqual($0[2], "Content-Type: text/plain")
        }
    }

    func testHeaderLevelRequestEndSymbolIsLogged() {
        makeRequest(logLevel: .headers) {
            XCTAssertEqual($0[3], "➡️ END HTTP")
        }
    }

    func testHeaderLevelResponseStatusCodeIsLogged() {
        makeRequest(logLevel: .headers) {
            XCTAssertTrue(self.matches($0[4], regex: .REGEX_REPONSE_TIME))
        }
    }

    func testHeaderLevelResponseIsLogged() {
        makeRequest(logLevel: .headers) {
            XCTAssertEqual($0[5], "Content-Type: application/json; charset=utf-8")
        }
    }

    func testHeaderLevelResponseEndSymbolIsLogged() {
        makeRequest(logLevel: .headers) {
            XCTAssertEqual($0[6], "⬅️ END HTTP")
        }
    }
}

extension String {
    static var REGEX_TIME: String { "\\d{2}-\\d{2}-\\d{2}\\s\\d{2}:\\d{2}:\\d{2}.\\d{3}" }
    static var REGEX_REPONSE_TIME: String { "⬅️\\s200\\s\\(\\d{1,2}\\.\\d{2}ms\\)" }
}

extension XCTestCase {
    func makeRequest(logLevel: LogLevel, logResponse: @escaping (_ message: [String]) -> Void) {
        let logger = MockMerchantLogger(logLevel)
        stubPostAlamofire(mockTestURL: baseURL,
                          method: .post,
                          data: userMock,
                          logger: logger)

        let exp = expectation(description: #function)

        let post = POST<UserMock, UserMock>(body: UserMock.self,
                                            formURLEncoded: true,
                                            headers: ["Content-Type": "text/plain"])

        post(body: userMock) { _ in

            logResponse(logger.message)

            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }

    func matches(_ string: String, regex: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: regex)
        return regex.firstMatch(in: string, range: NSRange(location: 0, length: string.utf16.count)) != nil
    }
}
