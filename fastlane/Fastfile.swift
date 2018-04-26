// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
	func screenshotsLane() {
	desc("Generate new localized screenshots")
		captureScreenshots(workspace: "BlockChain-Coin.xcworkspace", scheme: "BlockChain-Coin")
		uploadToAppStore(username: "steve.furiousteam@gmail.com", app: "co.blockchain-coin.ios", skipBinaryUpload: true, skipMetadata: true)
	}
}
