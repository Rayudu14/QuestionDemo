

import Foundation
struct MainJson : Codable {
	
	let results : [Results]?

	enum CodingKeys: String, CodingKey {
		case results = "results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		results = try values.decodeIfPresent([Results].self, forKey: .results)
	}

}
