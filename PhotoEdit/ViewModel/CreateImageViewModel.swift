//
//  CreateImageViewModel.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 16.12.2022.
//

import Foundation
import OpenAIKit
import UIKit

final class CreateImageViewModel: ObservableObject {
    private var openai: OpenAI?
    
    func setup() {
        openai = OpenAI(Configuration(organization: "Personal", apiKey: "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"))
    }
    
    func generateImage(prompt: String) async -> UIImage? {
        guard let openai = openai else { return nil }
        do {
            let params = ImageParameters(prompt: prompt, resolution: .medium, responseFormat:.base64Json)
            let result = try await openai.createImage(parameters: params)
            let data = result.data[0].image
            let image = try openai.decodeBase64Image(data)
            return image
        }
        catch {
            print(String(describing: error))
            return nil
        }
    }
}
