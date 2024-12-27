//
//  NetworkManager.swift
//  BabyMoment
//
//  Created by July universe on 11/16/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private let defaults = UserDefaultsManager.shared
    private let apiUrl = "http://localhost:2271" // Replace with your API base URL
    private var isRefreshingToken = false
    private var pendingRequests: [(URLRequest) async throws -> Void] = []
    
    private init() {}
    
    // 기본 헤더 설정
    private var defaultHeaders: [String: String] {
        var headers: [String: String] = [
            "Authorization": "Bearer \(defaults.accessToken)",
            "Accept-Language": Locale.current.language.languageCode?.identifier ?? "en",
            "Timezone-Identifier": TimeZone.current.identifier,
            "Platform": "ios",
            "Datetime-Offset": datetimeOffset,
            "Device-Id": defaults.deviceId
        ]
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            headers["App-Version"] = appVersion
        }
        return headers
    }
    
    // Datetime-Offset 계산
    private var datetimeOffset: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current // 기기의 국가 시간대
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX" // ISO 8601 형식
        return formatter.string(from: Date()) // e.g., "2024-11-16T14:30:00+09:00"
    }
    
    func request<T: Decodable, U: Encodable>(
        endpoint: ApiEndpoint,
        parameters: U? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: "\(apiUrl)\(endpoint.path)") else {
            throw handleState(.ERROR(message: "Invalid URL"))
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        // Merge default headers with additional headers
        let mergedHeaders = defaultHeaders.merging(headers ?? [:]) { (_, new) in new }
        for (key, value) in mergedHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add parameters for POST/PUT requests
        if let parameters = parameters, endpoint.method != "GET" {
            do {
                let jsonData = try JSONEncoder().encode(parameters)
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw handleState(.ERROR(message: "Invalid Parameters"))
            }
        }
        return try await performRequest(request: request, responseType: responseType)
        
        //        do {
        //            let (data, response) = try await URLSession.shared.data(for: request)
        //            guard let httpResponse = response as? HTTPURLResponse,
        //                  (200...299).contains(httpResponse.statusCode) else {
        //                throw handleState(.ERROR(message: "Invalid Response"))
        //            }
        //            let serverResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: data)
        //            switch serverResponse.status.code {
        //            case "Success":
        //                return serverResponse.data
        //            case "State":
        //                throw handleState(.STATE(message: serverResponse.status.message))
        //            default:
        //                throw handleState(.ERROR(message: serverResponse.status.message))
        //            }
        //        } catch {
        //            throw error
        //        }
    }

    /// `parameters`가 없는 요청 (오버로딩)
    func request<T: Decodable>(
        endpoint: ApiEndpoint,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            parameters: EmptyParameters(), // 빈 구조체 전달
            headers: headers,
            responseType: responseType
        )
    }
    
    private func performRequest<T: Decodable>(
        request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw handleState(.ERROR(message: "Invalid Response"))
            }
            if httpResponse.statusCode == 401 {
                return try await handleTokenRefresh(request: request, responseType: responseType)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw handleState(.ERROR(message: "Invalid Response"))
            }
            let serverResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: data)
            switch serverResponse.status.code {
            case "Success":
                return serverResponse.data
            case "State":
                throw handleState(.STATE(message: serverResponse.status.message))
            default:
                throw handleState(.ERROR(message: serverResponse.status.message))
            }
        } catch {
            throw error
        }
    }
    
    private func handleTokenRefresh<T: Decodable>(
        request originalRequest: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        guard !isRefreshingToken else {
            return try await withCheckedThrowingContinuation { continuation in
                pendingRequests.append { request in
                    let result: T = try await self.performRequest(request: request, responseType: responseType)
                    continuation.resume(returning: result)
                }
            }
        }
        isRefreshingToken = true
        defer { isRefreshingToken = false }
        do {
            let tokenReissueRequest = TokenReissueRequest(refreshToken: defaults.refreshToken)
            let tokenResponse = try await request(
                endpoint: .REISSUE_TOKEN,
                parameters: tokenReissueRequest,
                headers: nil,
                responseType: TokenReissueResponse.self
            )
            defaults.accessToken = tokenResponse.token.accessToken
            defaults.refreshToken = tokenResponse.token.refreshToken
            let results = try await withThrowingTaskGroup(of: Void.self) { group in
                for pendingRequest in pendingRequests {
                    group.addTask {
                        try await pendingRequest(originalRequest)
                    }
                }
            }
            pendingRequests.removeAll()
            return try await performRequest(request: originalRequest, responseType: responseType)
        } catch {
            pendingRequests.removeAll()
            throw error
        }
    }
    
    @discardableResult
    private func handleState(_ state: NetworkResponseState) -> Error {
        switch state {
        case .SUCCESS:
            return NetworkError.GENERIC
        case .STATE(let message):
            StateManager.shared.showState(message)
            return NetworkError.GENERIC
        case .ERROR(let message):
            ErrorManager.shared.showError(message)
            return NetworkError.GENERIC
        }
    }
    
    enum NetworkError: Error {
        case GENERIC
    }
    
    struct StatusDto: Decodable {
        let code: String
        let message: String
    }
    
    struct ApiResponse<T: Decodable>: Decodable {
        let status: StatusDto
        let data: T
    }
}

enum NetworkResponseState {
    case SUCCESS
    case STATE(message: String)
    case ERROR(message: String)
}

struct EmptyParameters: Encodable {}
