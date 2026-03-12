//
//  Countries_Data_AppTests.swift
//  Countries Data AppTests
//
//  Created by Muhammad Saif on 11/03/26.
//

import XCTest
@testable import Countries_Data_App

// MARK: - HomeViewModel Tests
@MainActor
final class HomeViewModelTests: XCTestCase {
    
    func testFetchCountriesPopulatesDataAndCallsDidFetchData() async {

        let countries = [TestData.france, TestData.japan]
        let useCase = MockFetchCountriesUseCase(result: .success(countries))
        let sut = HomeViewModel(fetchCountriesUseCase: useCase)

        await sut.fetchCountries()

        XCTAssertEqual(sut.numberOfCountries, 2)
        XCTAssertEqual(sut.dataByIndex(index: 0)?.name.common, "France")
        XCTAssertEqual(sut.dataByIndex(index: 1)?.name.common, "Japan")
    }
    
    func testDataByIndexOutOfBoundsReturnsNil() async {

        let useCase = MockFetchCountriesUseCase(result: .success([TestData.france]))
        let sut = HomeViewModel(fetchCountriesUseCase: useCase)

        await sut.fetchCountries()

        XCTAssertNil(sut.dataByIndex(index: -1))
        XCTAssertNil(sut.dataByIndex(index: 5))
    }
}


// MARK: - CountryHomeViewModel Tests

@MainActor
final class CountryHomeViewModelTests: XCTestCase {
    
    func testFetchDataSuccessUpdatesCountries() async {
        
        let expected = [TestData.france, TestData.japan]
        let useCase = MockFetchCountriesUseCase(result: .success(expected))
        let sut = CountryHomeViewModel(fetchCountriesUseCase: useCase)
        
        await sut.fetchData()
        
        XCTAssertEqual(sut.countries, expected)
    }
    
    func testFetchDataFailureKeepsCountriesUnchanged() async {
        
        let useCase = MockFetchCountriesUseCase(result: .failure(MockError.sample))
        let sut = CountryHomeViewModel(fetchCountriesUseCase: useCase)
        
        sut.countries = [TestData.france]
        
        await sut.fetchData()
        
        XCTAssertEqual(sut.countries, [TestData.france])
    }
}


// MARK: - URLSessionNetworkClient Tests

final class URLSessionNetworkClientTests: XCTestCase {
    
    private func makeMockSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }
    
    func testFetchDecodesResponseBody() async throws {
        
        MockURLProtocol.requestHandler = { request in
            
            let data = """
            {"name":"France"}
            """.data(using: .utf8)!
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, data)
        }
        
        let session = makeMockSession()
        let sut = await URLSessionNetworkClient(session: session)
        
        let url = try XCTUnwrap(URL(string: "https://example.com/country"))
        
        let result: TestPayload = try await sut.fetch(from: url)
        
        XCTAssertEqual(result.name, "France")
    }
    
    func testFetchThrowsWhenDecodingFails() async {
        
        MockURLProtocol.requestHandler = { request in
            
            let data = """
            {"invalid":1}
            """.data(using: .utf8)!
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, data)
        }
        
        let session = makeMockSession()
        let sut = await URLSessionNetworkClient(session: session)
        
        let url = URL(string: "https://example.com/country")!
        
        do {
            let _: TestPayload = try await sut.fetch(from: url)
            XCTFail("Expected decoding to throw")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
}


// MARK: - Test Data

private enum TestData {
    
    static let france = Country(
        name: CountryName(common: "France", official: "French Republic"),
        capital: ["Paris"],
        languages: ["fra": "French"],
        flag: "🇫🇷"
    )
    
    static let japan = Country(
        name: CountryName(common: "Japan", official: "Japan"),
        capital: ["Tokyo"],
        languages: ["jpn": "Japanese"],
        flag: "🇯🇵"
    )
}


// MARK: - Mock Payload

private struct TestPayload: Codable {
    let name: String
}


// MARK: - Mock Error

private enum MockError: Error {
    case sample
}


// MARK: - Mock UseCase

private final class MockFetchCountriesUseCase: FetchCountriesUseCase {
    
    private let result: Result<[Country], Error>
    
    init(result: Result<[Country], Error>) {
        self.result = result
    }
    
    func execute() async throws -> [Country] {
        try result.get()
    }
}


// MARK: - Mock URL Protocol

private final class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        
        guard let handler = Self.requestHandler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        
        do {
            
            let (response, data) = try handler(request)
            
            client?.urlProtocol(self,
                                didReceive: response,
                                cacheStoragePolicy: .notAllowed)
            
            client?.urlProtocol(self, didLoad: data)
            
            client?.urlProtocolDidFinishLoading(self)
            
        } catch {
            
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
