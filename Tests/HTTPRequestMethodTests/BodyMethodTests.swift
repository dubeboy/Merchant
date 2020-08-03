import XCTest
@testable import Merchant

class PostTests: XCTestCase {

    @Autowired
    var client: MockService

    func testSuccessfulPost() {
        client.stubPostAlamofire(mockTestURL: client.baseURL + "/new_user", data: UserMock(id: 1, name: "John", surname: "Snow"))

        let exp = expectation(description: "it should successfully return mock data")

        let post = POST<UserMock, UserMock>("/new_user", body: UserMock.self)

        XCTAssertNil(Const.userMock.id)

        post(body: Const.userMock) { response in
            XCTAssertEqual(try? response.get().body.id, 1)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }
    
    func testPostRequestBody() {
        client.stubPostAlamofire(mockTestURL: client.baseURL + "/new_user", data: UserMock(name: "John", surname: "Snow"))

        let exp = expectation(description: "it should successfully return mock data")

        let post = POST<UserMock, UserMock>("/new_user", body: UserMock.self)

        post(body: Const.userMock) { response in
            XCTAssertEqual(try! JSONDecoder().decode(UserMock.self, from: response.get().raw.request!.httpBody!), Const.userMock)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }

    func testPostContentType() {
        client.stubPostAlamofire(mockTestURL: client.baseURL + "/new_user", data: Const.userMock)
        let exp = expectation(description: "it should successfully return mock data")

        let post = POST<UserMock, String>("/new_user", body: String.self, headers: ["Content-Type": "text/plain"])

        post(body: "Hello There") { response in
            XCTAssertEqual(try! response.get().raw.request!.allHTTPHeaderFields!, ["Content-Type": "text/plain"])
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }

    func testPostFormURLEncodedBody() {
        client.stubPostAlamofire(mockTestURL: client.baseURL + "/new_user", data: Const.userMock)
        let exp = expectation(description: "it should successfully return mock data")

        let post = POST<UserMock, UserMock>("/new_user", body: UserMock.self, formURLEncoded: true)

        post(body: UserMock(id: 1, name: "J Ann", surname: "Wa")) { response in
            XCTAssertEqual(String(data: try! response.get().raw.request!.httpBody!, encoding: .utf8), "id=1&name=J%20Ann&surname=Wa")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }

    func testPostNormalBody() {

        let postBody = UserMock(id: 1, name: "J Ann", surname: "Wa")
        client.stubPostAlamofire(mockTestURL: client.baseURL + "/new_user", data: postBody)

        let exp = expectation(description: "it should successfully return mock data")

        let post = POST<UserMock, UserMock>("/new_user", body: UserMock.self)

        post(body: postBody) { response in
            XCTAssertEqual( try! response.get().raw.request!.httpBody!, try! JSONEncoder().encode(postBody))
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }


    func testSuccessfulPostWithBasicBodyType() {
        client.stubPostAlamofire(mockTestURL: client.baseURL + "/new_user", data: Const.userMock)
        let exp = expectation(description: "it should successfully return mock data")

        let post = POST<UserMock, String>("/new_user", body: String.self)

        post(body: "Hello text") { response in
            XCTAssertEqual(try! JSONDecoder().decode(String.self, from: response.get().raw.request!.httpBody!), "Hello text")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }

    // test to see if the body has Something

    func testCorrectPostPathWithPath() {

        client.stubPostAlamofire(mockTestURL: client.baseURL + "/some/random/path", data: Const.userMock)

        let exp = expectation(description: "custom path should be injected as part of the URL")

        let post = POST<UserMock, UserMock>("/some/random/path", body: UserMock.self)

        post(body: UserMock(name: "Some", surname: "Name")) { response in
            let rawResponse = try! response.get().raw
            XCTAssertEqual(rawResponse.request!.url!.path, "/hello/some/random/path")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }

    func testCorrectPostPathWithNoPath() {

        client.stubPostAlamofire(mockTestURL: client.baseURL, data: Const.userMock)

        let exp = expectation(description: "custom path should be injected as part of the URL")

        let post = POST<UserMock, UserMock>(body: UserMock.self)

        post(body: Const.postUserMock) { response in
            let rawResponse = try! response.get().raw
            XCTAssertEqual(rawResponse.request!.url!.absoluteString, self.client.baseURL)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }



    func testCorrectPostPathValuesInjection() {
        client.stubPostAlamofire(mockTestURL: client.baseURL + "/users/56/profile/45", data: Const.userMock)

        let exp = expectation(description: "custom path values should be injected as part of the URL")

        let post = POST<UserMock, UserMock>("/users/{user_id}/profile/{comment_id}", body: UserMock.self)

        post(["user_id": "56", "comment_id": "45"], body: Const.postUserMock) { response in
            let rawResponse = try! response.get().raw
            XCTAssertEqual(rawResponse.request!.url!.path, "/hello/users/56/profile/45")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }

    func testSystemWideQueryIsApplied() {
        client.stubPostAlamofire(mockTestURL: client.baseURL + "/new_user", data: UserMock(id: 1, name: "John", surname: "Snow"))

        let exp = expectation(description: "request headers should contain the global query paramters")

        let post = POST<UserMock, UserMock>("/new_user", body: UserMock.self)

        post(body: Const.userMock) { response in
            XCTAssertEqual(try? response.get().body.id, 1)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }

    func testCorrectQueryPath() {
        client.stubPostAlamofire(mockTestURL: client.baseURL + "/new_user", data: Const.userMock)

        let exp = expectation(description: "testCorrectQueryPath")

        let post = POST<UserMock, UserMock>("/new_user", body: UserMock.self)

        let query = ["a": "Hello world", "q":"Hi"]
        post(query: query,  body: Const.userMock) { response in

            let urlString = try? response.get().raw.request!.url!.absoluteString

            XCTAssertTrue(urlString!.contains("/new_user?"))
            XCTAssertTrue(urlString!.contains("a=Hello%20world"))
            XCTAssertTrue(urlString!.contains("q=Hi"))

            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }

    func testGlobalQuery() {
        client.stubPostAlamofire(mockTestURL: client.baseURL + "/new_user", data: Const.userMock, globalQuery: true)

        let exp = expectation(description: "request headers should contain the global query paramters")

        let post = POST<UserMock, UserMock>("/new_user", body: UserMock.self)

        post(body: Const.userMock) { response in

            let urlString = try? response.get().raw.request!.url!.absoluteString

            XCTAssertEqual(urlString, "\(self.client.baseURL)/new_user?api_key=1234567890_XYZ")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }
}
