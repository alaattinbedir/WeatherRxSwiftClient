//
//  BaseAPI.swift
//  WeatherToday
//
//  Created by alaattib on 27.07.2023.
//

import Foundation
import Alamofire

struct ErrorMessage: Codable {
    var code: Int?
    var title: String?
    var message: String?
    var httpStatus: Int?

    init(code: Int? = nil, title: String? = nil, message: String? = nil, httpStatus: Int? = nil) {
        self.code = code
        self.title = title
        self.message = message
        self.httpStatus = httpStatus
    }

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case title = "Title"
        case message = "Message"
        case httpStatus = "HttpStatus"
    }
}

enum MimeType: String {
    case applicationJson = "application/json"
    case textHtml = "text/html"
    case textJavascript = "text/javascript"
    case applicationPdf = "application/pdf"
    case formUrlEncoded = "application/x-www-form-urlencoded; charset=utf-8"
    case imagePNG = "image/png"
    case empty = ""
    case base64ForHTML = "base64"
}

class BaseAPI: SessionDelegate {
    static let shared = BaseAPI()
    var xtoken = String()
    private var uniqueDeviceID = UUIDHelper.getUniqueDeviceID()
    private var session: Session?
    private let timeoutIntervalForRequest: Double = 300

    private init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        if #available(iOS 13.0, *) {
            configuration.tlsMinimumSupportedProtocolVersion = .TLSv12
        } else {
            configuration.tlsMinimumSupportedProtocol = SSLProtocol.tlsProtocol12
        }

        let trustManager = ServerTrustManager(evaluators: [AppUrl.dev: DisabledTrustEvaluator(),
                                                           AppUrl.uat: DisabledTrustEvaluator(),
                                                           AppUrl.prep: DisabledTrustEvaluator()])

        session = Session(configuration: configuration,
                          delegate: self,
                          startRequestsImmediately: true,
                          serverTrustManager: trustManager)
    }

    func request<S: Codable, F: Codable>(methotType: HTTPMethod,
                                         endPoint: String,
                                         params: [String: Any]?,
                                         lockScreen: Bool,
                                         willResumeProgress: Bool = false,
                                         stubFileName: String = StubFileName.noStubFile,
                                         useMockData: Bool = false,
                                         headerParams: [String: String]? = nil,
                                         controlChecksum: Bool = true,
                                         succeed: @escaping (S) -> Void,
                                         failed: @escaping (F) -> Void) {
        if SessionKeeper.shared.useMockData || useMockData {
            StubFileManager.loadStub(filename: stubFileName, succeed: succeed, failed: failed)
            return
        }
        guard let session = session else { return }
        let contentType: String = MimeType.applicationJson.rawValue
        let hasToken: Bool = endPoint != Endpoints.token
        let baseURL: String = AppUrl.baseUrl

        guard networkIsReachable() else {
            stopAnimating()
            if let error = ErrorMessage(code: Alert.networkIsNotReachable.rawValue,
                                        title: ResourceKey.generalWarningHeader.value,
                                        message: ResourceKey.generalNoInternet.value) as? F {
                failed(error)
            }
            return
        }
        if lockScreen && !ScreenActivityIndicator.shared.isAnimating() {
            DispatchQueue.main.async {
                ScreenActivityIndicator.shared.startAnimating()
            }
        }
        var url = baseURL + endPoint
        var bodyParams: [String: Any]?
        if let params = params {
            if methotType == .get {
                url.append(URLQueryBuilder(params: params).build())
            } else {
                bodyParams = params
            }
        }

        let headerParams = prepareHeaderForSession(endPoint,
                                                   methotType,
                                                   bodyParams,
                                                   headerParams,
                                                   hasToken,
                                                   controlChecksum,
                                                   contentType)
        printRequest(url: url, methodType: methotType, body: bodyParams, headerParams: headerParams)

        clearUrlSessionCache()

        let networkRequest = session.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)~,
                                             method: methotType,
                                             parameters: bodyParams,
                                             encoding: JSONEncoding.default,
                                             headers: HTTPHeaders(headerParams))
            .validate(contentType: [contentType])
            .validate(statusCode: 200 ..< 600)

        validateResponse(dataRequest: networkRequest, controlChecksum: controlChecksum) { [weak self] isValid in
            guard isValid else {
                if lockScreen {
                    self?.stopAnimating()
                }
                self?.handleFailureResponseObject(dataRequest: networkRequest, failed: failed)
                return
            }
            self?.handleJsonResponse(dataRequest: networkRequest,
                                     lockScreen: lockScreen,
                                     willResumeProgress: willResumeProgress,
                                     controlChecksum: controlChecksum,
                                     succeed: succeed,
                                     failed: failed)
        }
    }

    private func validateResponse(dataRequest: DataRequest,
                                  controlChecksum: Bool,
                                  completionHandler: @escaping (Bool) -> Void) {
        guard controlChecksum else {
            completionHandler(true)
            return
        }

        dataRequest.responseString(encoding: String.Encoding.utf8) { response in
            let responseString = response.value~
            let allHeaders = response.response?.allHeaderFields as? [String: String]
            let responseCheckSum: String? = allHeaders?[caseInsensitive: "X-CheckSum"]
            let responseCheckSumCreated = SweetHMAC(message: responseString,
                                                    secret: SessionKeeper.shared.encryptionKey)
                .HMAC(algorithm: HMACAlgorithm.sha256)

            guard responseCheckSum != nil, responseCheckSum == responseCheckSumCreated else {
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }

    // MARK: Handle Default Json Response

    private func handleJsonResponse<S: Codable, F: Codable>(dataRequest: DataRequest,
                                                            lockScreen: Bool,
                                                            willResumeProgress: Bool = false,
                                                            controlChecksum _: Bool,
                                                            succeed: @escaping (S) -> Void,
                                                            failed: @escaping (F) -> Void) {
        dataRequest.responseDecodable(of: S.self) { [weak self] response in
            guard let self = self else { return }
            let allHeaders = response.response?.allHeaderFields as? [String: String]
            self.setXtoken(xtoken: allHeaders?[caseInsensitive: "X-Token"])
            self.printResponse(request: dataRequest, statusCode: response.response?.statusCode, url: response.request?.description)
            if lockScreen, !willResumeProgress {
                self.stopAnimating()
            }
            switch response.result {
            case .success:
                handleSuccessResponse(response, self)
            case .failure:
                self.handleFailureResponseObject(dataRequest: dataRequest, failed: failed)
            }
            func handleSuccessResponse(_ response: DataResponse<S, AFError>, _: BaseAPI) {
                switch StatusCodeType.toStatusType(httpStatusCode: response.response?.statusCode) {
                case .success:
                    self.handleSuccessfulResponseObject(dataRequest: dataRequest, succeed: succeed)
                case .error:
                    self.handleFailureResponseObject(dataRequest: dataRequest, failed: failed)
                default:
                    print("default")
                }
            }
        }
    }

    func setXtoken(xtoken: String?) {
        if let xtoken = xtoken {
            self.xtoken = xtoken
        }
    }

    private func handleSuccessfulResponseObject<S: Codable>(dataRequest: DataRequest,
                                                            succeed: @escaping (S) -> Void) {
        var isHandled = false
        dataRequest.responseDecodable(of: S.self) { (response: DataResponse<S, AFError>) in
            if let responseObject = response.value, !isHandled {
                isHandled = true
                succeed(responseObject)
            }
        }
    }

    private func handleFailureResponseObject<F: Codable>(dataRequest: DataRequest,
                                                         failed: @escaping (F) -> Void) {
        var isHandled = false
        dataRequest.responseDecodable(of: F.self) { (response: DataResponse<F, AFError>) in
            if let responseObject = response.value, !isHandled {
                isHandled = true
                if var errorMessage = responseObject as? ErrorMessage {
                    errorMessage.httpStatus = response.response?.statusCode
                }
                failed(responseObject)
            }
        }
    }

    private func stopAnimating() {
        DispatchQueue.main.async {
            if ScreenActivityIndicator.shared.isAnimating() {
                ScreenActivityIndicator.shared.stopAnimating()
            }
        }
    }

    func clearUrlSessionCache() {
        URLCache.shared.removeAllCachedResponses()
    }

    private func prepareHeaderForSession(_: String,
                                         _: HTTPMethod,
                                         _ bodyParams: [String: Any]?,
                                         _ extraHeaderParams: [String: String]?,
                                         _ hasToken: Bool,
                                         _ controlChecksum: Bool,
                                         _ contentType: String) -> [String: String] {
        var allHeaderFields: [String: String] = [:]
        allHeaderFields["Content-Type"] = contentType
        allHeaderFields["x-new-encryption"] = "true"
        allHeaderFields["Accept-Language"] = "TR"
        allHeaderFields["X-Connection-Type"] = ReachabilityManager.connectionType()
        allHeaderFields["User-Agent"] = UABuilder.uaString()
        allHeaderFields["X-Client-Id"] = uniqueDeviceID
        if KeychainKeeper.shared.userId != nil {
            allHeaderFields["App-UserId"] = KeychainKeeper.shared.userId?.encrypt()
        }

        if let extraHeaderParams = extraHeaderParams, !extraHeaderParams.isEmpty {
            allHeaderFields.merge(extraHeaderParams) { _, new in new }
        }

        if let bodyParams = bodyParams, controlChecksum {
            allHeaderFields["X-CheckSum"] = createCheckSum(bodyParams)
        }

        if hasToken {
            allHeaderFields["X-Token"] = xtoken
        }

        if isGeoLocationEnabled() {
            FPLocationManager.shared.startUpdatingLocation { location in
                if let location = location {
                    let latitude = String(describing: location.coordinate.latitude).replacingOccurrences(of: ".", with: ",")
                    let longitude = String(describing: location.coordinate.longitude).replacingOccurrences(of: ".", with: ",")
                    allHeaderFields["X-Location-Latitude"] = latitude
                    allHeaderFields["X-Location-Longitude"] = longitude
                }
            }
        }
        return allHeaderFields
    }

    func isGeoLocationEnabled() -> Bool {
        let locationStatus = CLLocationManager.authorizationStatus()
        if locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse {
            return true
        }
        return false
    }

    private func createCheckSum(_ bodyParams: [String: Any]) -> String {
        let jsonStr = bodyParams.toJsonStr()
        let hmac = SweetHMAC(message: jsonStr, secret: SessionKeeper.shared.encryptionKey)
            .HMAC(algorithm: HMACAlgorithm.sha256)
#if DEBUG
        print("Request Body Json", jsonStr)
        print("Request Body Json HMAC_SHA256", hmac)
#endif
        return hmac
    }

    // MARK: Reachability for connection

    private func networkIsReachable() -> Bool {
        let networkManager = NetworkReachabilityManager()
        let result = networkManager?.isReachable
        return result ?? false
    }

    private func printRequest(url: String?,
                              methodType: HTTPMethod?,
                              body: [String: Any]?,
                              headerParams: [String: String]) {
        let header = headerParams.reduce("\n   ") { $0 + $1.key + ":" + $1.value + "\n      " }
        print("""
        --------------------------------------------------
        Request Url: \(url ?? "")
        Request Type: \(String(describing: methodType))
        Request Parameters: \(String(describing: body))
        Request Headers: \(header)
        """)
    }

    private func printResponse(request: DataRequest,
                               statusCode: Int?,
                               url: String?) {
        print("--------------------------------------------------")

        request.prettyPrintedJsonResponse()

        print("""
        --------------------------------------------------
        Response Url: \(String(describing: url))
        Response StatusCode: \(String(describing: statusCode))
        """)
    }
}

