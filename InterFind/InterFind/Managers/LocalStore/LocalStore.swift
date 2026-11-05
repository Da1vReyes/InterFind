//
//  LocalStore.swift
//  InterFind
//
//  Almacenamiento 100% local: reemplaza al servidor remoto de la versión original.
//  - Pasantías: JSON en Documents (se siembra desde internships.json del bundle).
//  - Imágenes: archivos JPG en Documents/Images.
//  - Cuentas: UserDefaults (datos) + hash SHA-256 con sal (contraseña).
//

import UIKit
import CryptoKit

final class LocalStore {

    static let shared = LocalStore()

    private let fileManager = FileManager.default
    private let cache = NSCache<NSString, UIImage>()
    private let accountsKey = "accounts"

    private init() { }

    // MARK: - Paths

    private var documentsURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var internshipsURL: URL {
        documentsURL.appendingPathComponent("internships.json")
    }

    private var imagesURL: URL {
        let url = documentsURL.appendingPathComponent("Images", isDirectory: true)
        if !fileManager.fileExists(atPath: url.path) {
            try? fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        }
        return url
    }

    // MARK: - Internships

    func loadInternships() -> [InternshipModel] {
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: internshipsURL),
           let stored = try? decoder.decode(InternshipData.self, from: data) {
            return stored.data
        }
        // Primera ejecución: copiar los datos de ejemplo incluidos en la app.
        guard let seedURL = Bundle.main.url(forResource: Constants.seedFileName, withExtension: "json"),
              let seedData = try? Data(contentsOf: seedURL),
              let seed = try? decoder.decode(InternshipData.self, from: seedData) else {
            return []
        }
        saveInternships(seed.data)
        return seed.data
    }

    func saveInternships(_ internships: [InternshipModel]) {
        do {
            let data = try JSONEncoder().encode(InternshipData(data: internships))
            try data.write(to: internshipsURL, options: .atomic)
        } catch {
            print("Error guardando pasantías: \(error.localizedDescription)")
        }
    }

    func addInternship(_ internship: InternshipModel) {
        var internships = loadInternships()
        internships.insert(internship, at: 0)
        saveInternships(internships)
    }

    func deleteInternship(id: String) {
        let internships = loadInternships()
        if let removed = internships.first(where: { $0.id == id }) {
            deleteImage(named: removed.imageUrl)
        }
        saveInternships(internships.filter { $0.id != id })
    }

    // MARK: - Images

    /// Guarda la imagen en disco y devuelve el nombre de archivo que se usa como `imageUrl`.
    func saveImage(_ image: UIImage) throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.8) else { throw LocalStoreError.invalidImage }
        let fileName = UUID().uuidString + ".jpg"
        try data.write(to: imagesURL.appendingPathComponent(fileName), options: .atomic)
        return fileName
    }

    /// Resuelve un `imageUrl` local: asset del catálogo, archivo en Documents/Images
    /// o, si no existe, un logo generado con las iniciales de la empresa.
    func image(for imageUrl: String, fallbackName: String? = nil) -> UIImage {
        let key = NSString(string: imageUrl + "|" + (fallbackName ?? ""))
        if let cached = cache.object(forKey: key) { return cached }

        let image: UIImage
        if !imageUrl.isEmpty, let asset = UIImage(named: imageUrl) {
            image = asset
        } else if !imageUrl.isEmpty,
                  let fileImage = UIImage(contentsOfFile: imagesURL.appendingPathComponent(imageUrl).path) {
            image = fileImage
        } else {
            image = Self.monogram(for: fallbackName ?? imageUrl)
        }
        cache.setObject(image, forKey: key)
        return image
    }

    private func deleteImage(named fileName: String) {
        let url = imagesURL.appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: url.path) {
            try? fileManager.removeItem(at: url)
        }
    }

    /// Logo simple con iniciales, para no depender de imágenes de marcas.
    static func monogram(for name: String) -> UIImage {
        let words = name.split(separator: " ").prefix(2)
        let initials = words.compactMap { $0.first }.map(String.init).joined().uppercased()
        let palette: [UIColor] = [.systemBlue, .systemIndigo, .systemTeal, .systemPurple, .systemOrange, .systemGreen, .systemPink]
        let color = palette[abs(name.hashValue) % palette.count]
        let size = CGSize(width: 200, height: 200)

        return UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 80, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let text = (initials.isEmpty ? "?" : initials) as NSString
            let textSize = text.size(withAttributes: attributes)
            text.draw(at: CGPoint(x: (size.width - textSize.width) / 2,
                                  y: (size.height - textSize.height) / 2),
                      withAttributes: attributes)
        }
    }

    // MARK: - Accounts

    private struct StoredAccount: Codable {
        let user: User
        let salt: String
        let passwordHash: String
    }

    private func loadAccounts() -> [String: StoredAccount] {
        guard let data = UserDefaults.standard.data(forKey: accountsKey),
              let accounts = try? JSONDecoder().decode([String: StoredAccount].self, from: data) else { return [:] }
        return accounts
    }

    private func saveAccounts(_ accounts: [String: StoredAccount]) {
        if let data = try? JSONEncoder().encode(accounts) {
            UserDefaults.standard.set(data, forKey: accountsKey)
        }
    }

    private static func hash(_ password: String, salt: String) -> String {
        SHA256.hash(data: Data((salt + password).utf8)).map { String(format: "%02x", $0) }.joined()
    }

    func register(name: String, email: String, password: String) throws -> LoginResponse {
        let key = email.lowercased()
        var accounts = loadAccounts()
        guard accounts[key] == nil else { throw LocalStoreError.emailAlreadyExists }

        let salt = UUID().uuidString
        let user = User(id: UUID().uuidString, name: name, email: email)
        accounts[key] = StoredAccount(user: user, salt: salt, passwordHash: Self.hash(password, salt: salt))
        saveAccounts(accounts)
        return LoginResponse(token: UUID().uuidString, user: user)
    }

    func login(email: String, password: String) throws -> LoginResponse {
        guard let account = loadAccounts()[email.lowercased()],
              account.passwordHash == Self.hash(password, salt: account.salt) else {
            throw LocalStoreError.invalidCredentials
        }
        return LoginResponse(token: UUID().uuidString, user: account.user)
    }
}
