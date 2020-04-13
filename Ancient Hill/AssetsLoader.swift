import SpriteKit

enum AtlasName: String, CaseIterable {
    case finnachu
}

class AssetsLoader {
    
    private static var assets = [AtlasName: [Direction: [SKTexture]]]()
    
    static func loadAtlases() {
        for atlasName in AtlasName.allCases {
            let atlas = SKTextureAtlas(named: atlasName.rawValue)
            let textureNames = atlas.textureNames
            var textures = [Direction: [SKTexture]]()
            for textureName in textureNames {
                let texture = atlas.textureNamed(textureName)
                let direction = String(textureName.split(separator: "-").last ?? "unknown")
                textures[Direction(rawValue: direction) ?? .unknown, default: []].append(texture)
            }
            Self.assets[atlasName] = textures
        }
    }
    
    static func textures(for atlasName: AtlasName, direction: Direction) -> [SKTexture] {
        if Self.assets.count == 0 {
            Self.loadAtlases()
        }
        return Self.assets[atlasName]![direction]!
    }
}
