//
//  Extensions.swift
//  MarketCoins
//
//  Created by Robson Moreira on 06/11/22.
//

import UIKit

extension URL {
    
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }
        
        var items: [String: String] = [:]
        
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        
        return items
    }
    
    func appendingQueryParameters(path: String, parameters: [String: String]? = nil) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        
        guard let parameters = parameters else {
            guard let url = urlComponents.url else { return nil }
            return url.appendingPathComponent(path)
        }
        
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters.map { URLQueryItem(name: $0, value: $1) }
        guard let url = urlComponents.url else { return nil }
        return url.appendingPathComponent(path)
    }
}

extension Error {
    
    var errorCode: Int? {
        return (self as NSError).code
    }
}

extension Double {
    
    func toCurrency(from coin: CoinsFilterEnum) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: coin.locale)

        guard let value = numberFormatter.string(from: NSNumber(value: self)) else {
            return String(self)
        }
        
        return value
    }
    
    func toPercentage() -> String {
        let value = String(format: "%.1f", self).replacingOccurrences(of: "-", with: "")
        
        if self.sign == .minus {
            return "\u{2193} \(value)%"
        } else {
            return "\u{2191} \(value)%"
        }
    }
    
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self
        let truncated = Double(Int(newDecimal))
        let originalDecimal = truncated / multiplier
        return originalDecimal
    }
    
    func formatNumber() -> String {
        let num = abs(self)
        let sign = (Int(self) < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted) bilhoões"
            
        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted) milhões"
            
        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted) mil"
            
        case 0...:
            return "\(self)"
            
        default:
            return "\(sign)\(self)"
        }
    }
}

extension UIImageView {
    
    func loadImage(from url: String) {
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            } catch {}
        }
    }
}

extension UIView {
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
    
    func addGradient(colors: CGColor...) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension Formatter {
    
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

extension Date {
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func formatter(to dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR_POSIX")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func differenceDays(to date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        guard let difference = components.day else { return 0 }
        return difference
    }
}
