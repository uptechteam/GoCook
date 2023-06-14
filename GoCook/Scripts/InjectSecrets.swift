//
//  InjectSecrets.swift
//  GoCook
//
//  Created by Oleksii Andriushchenko on 13.06.2023.
//

import Foundation

@main
enum InjectSecrets {
    static func main() {
        guard
            let infoFile = ProcessInfo.processInfo.environment["INFOPLIST_FILE"],
            let projectDir = ProcessInfo.processInfo.environment["SRCROOT"]
        else {
            print("Can't get plist file or project directory.")
            return
        }

        let secrets = Self.getSecrets(projectDir: projectDir)
        guard !secrets.isEmpty else {
            print("Secrets are empty.")
            return
        }

        guard var dict = NSDictionary(contentsOfFile: projectDir + "/" + infoFile) as? [String: Any] else {
            print("Can't get plist.")
            return
        }

        for secret in secrets {
            dict[secret.key] = secret.value
        }

        (dict as NSDictionary).write(toFile: projectDir + "/" + infoFile, atomically: true)
    }

    private static func getSecrets(projectDir: String) -> [(key: String, value: String)] {
        let fileManager = FileManager.default
        guard let data = fileManager.contents(atPath: projectDir + "/" + ".env.default") else {
            print("Can't open env class.")
            return []
        }

        guard let secrets = String(data: data, encoding: .utf8) else {
            print("Can't decode data to text.")
            return []
        }

        return secrets
            .split(separator: "\n")
            .filter { secret in secret.hasPrefix("XCODE") }
            .compactMap { secret in
                let components = secret.split(separator: "=")
                guard components.count == 2 else {
                    return nil
                }

                return (
                    key: String(components[0]),
                    value: String(components[1]).replacingOccurrences(of: "\"", with: "")
                )
            }
    }
}
