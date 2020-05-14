import XCTest
@testable import RetroSwift

final class MethodTests: XCTestCase  {
    
    // MARK: - GET
    
    override func setUp() {
        super.setUp()
        stubAlamofire()
    }
    
    func testSuccessfulGet() {
        
        let exp = expectation(description: "it should successfully return mock data")

        let get = GET<UserMock>()
                
        get { response in
            XCTAssertEqual(try? response.get().body, userMock)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10)
    }
    
    func testCorrectPath() {
        
        stubAlamofire(mockTestURL: baseURL + "/some/random/path")
        
        let exp = expectation(description: "custom path should be injected as part of the URL")
        
        let get = GET<UserMock>("/some/random/path")
        
        get { response in
            let rawResponse = try! response.get().raw
            XCTAssertEqual(rawResponse.request!.url!.path, "/hello/some/random/path")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10)
    }
    
    
    func testCorrectPathValuesInjection() {
        stubAlamofire(mockTestURL: baseURL + "/users/56/profile/45")
        
        let exp = expectation(description: "custom path values should be injected as part of the URL")
        
        let get = GET<UserMock>("/users/{user_id}/profile/{comment_id}")
        
        get(["user_id": "56", "comment_id": "45"]) { response in
            let rawResponse = try! response.get().raw
            XCTAssertEqual(rawResponse.request!.url!.path, "/hello/users/56/profile/45")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10)
    }
    
    
    // ===----------------------------------------------------------------===
    // Same test for the other request methods; should use GYB in the future
    // ===----------------------------------------------------------------===
    
    // MARK: - POST
    
    
    // MARK: - PUT
    
    
//    func testSuccessful_PUT() {
//        let exp = expectation(description: "it should successfully return mock data")
//        
//        let get = PUT<UserMock, String>(body: String.self)
//        
//        get { response in
//            XCTAssertEqual(try? response.get().body, self.userMock)
//            exp.fulfill()
//        }
//        
//        wait(for: [exp], timeout: 10)
//    }
//    
//    func testCorrectPath_PUT() {
//        
//        stubAlamofire(mockTestURL: basePath + "/some/random/path")
//        
//        let exp = expectation(description: "custom path should be injected as part of the URL")
//        
//        let get = PUT<UserMock, UserMock>("/some/random/path", body: UserMock.self)
//        
//        get { response in
//            let rawResponse = try! response.get().raw
//            XCTAssertEqual(rawResponse.request!.url!.path, "/hello/some/random/path")
//            exp.fulfill()
//        }
//        
//        wait(for: [exp], timeout: 10)
//    }
//    
//    
//    func testCorrectPathValuesInjection_PUT() {
//        stubAlamofire(mockTestURL: basePath + "/users/56/profile/45")
//        
//        let exp = expectation(description: "custom path values should be injected as part of the URL")
//        
//        let get = PUT<UserMock, UserMock>("/users/{user_id}/profile/{comment_id}", body: UserMock.self)
//        
//        get(["user_id": "56", "comment_id": "45"]) { response in
//            let rawResponse = try! response.get().raw
//            XCTAssertEqual(rawResponse.request!.url!.path, "/hello/users/56/profile/45")
//            exp.fulfill()
//        }
//        
//        wait(for: [exp], timeout: 10)
//    }
    
    // MARK: PATCH
}


