
//
//  AppError.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation

enum AppError: Error {
    case auth(String)
    case network(String)
    case realtime(String)
    case unknown(String)
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .auth(let msg):      return msg
        case .network(let msg):   return msg
        case .realtime(let msg):  return msg
        case .unknown(let msg):   return msg
        }
    }
}

extension AppError {
    static func from(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        return .unknown(error.localizedDescription)
    }
}
