//
//  SwiftDate
//  Parse, validate, manipulate, and display dates, time and timezones in Swift
//
//  Created by Daniele Margutti
//   - Web: https://www.danielemargutti.com
//   - Twitter: https://twitter.com/danielemargutti
//   - Mail: hello@danielemargutti.com
//
//  Copyright © 2019 Daniele Margutti. Licensed under MIT License.
//

import Foundation

public struct SwiftDate {

	private init() { }

	private static let _defaultRegion = OSUnfairLocked<Region>(Region.UTC)

	/// The default region is used to manipulate and work with plain `Date` object and
	/// wherever a region parameter is optional. By default region is the to GMT timezone
	/// along with the default device's locale and calendar (both autoupdating).
	/// Access is synchronized and can be safely performed by concurrent threads.
	public static var defaultRegion: Region {
		get { _defaultRegion.value }
		set { _defaultRegion.value = newValue }
	}

	/// This is the ordered list of all formats SwiftDate can use in order to attempt parsing a passaed
	/// date expressed as string. Evaluation is made in order; you can add or remove new formats as you wish.
	/// In order to reset the list call `resetAutoFormats()` function.
	public static var autoFormats: [String] {
		set { DateFormats.autoFormats = newValue }
		get { return DateFormats.autoFormats }
	}

	/// Reset the list of all built-in auto formats patterns.
	public static func resetAutoFormats() {
		DateFormats.resetAutoFormats()
	}
}
