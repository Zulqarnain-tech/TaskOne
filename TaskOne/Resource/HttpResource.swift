//
//  HttpResource.swift
//  TaskOne
//
//  Created by Zulqarnain on 19/02/2022.
//

import Foundation

struct ImageResource
{
    func fetchImages(completionHandler: @escaping (ImagesResponse?) -> ()) {

        let animalApiUrl = URL(string: "https://api-dev-scus-demo.azurewebsites.net/api/Animal/GetAnimals")!

        URLSession.shared.dataTask(with: animalApiUrl) { (data, response, error) in

            if(error == nil && data != nil)
            {
                do {
                    let result = try JSONDecoder().decode(ImagesResponse.self, from: data!)

                    completionHandler(result)

                } catch let error {
                    debugPrint(error)
                }
            }

        }.resume()


    }
}
