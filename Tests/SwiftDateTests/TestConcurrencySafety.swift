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

import SwiftDate
import XCTest

class TestConcurrencySafety: XCTestCase {

	override func tearDown() {
		SwiftDate.defaultRegion = Region.UTC
		SwiftDate.resetAutoFormats()
		super.tearDown()
	}

	/// `SwiftDate.defaultRegion` is documented as safe for concurrent
	/// access: hammer it with parallel reads and writes while dates are
	/// being created and formatted through it.
	func testConcurrentDefaultRegionAccess() {
		let regions = [Region.UTC, Region.local, Region.ISO,
					   Region(calendar: Calendars.gregorian, zone: Zones.europeRome, locale: Locales.italian)]
		DispatchQueue.concurrentPerform(iterations: 1000) { iteration in
			if iteration.isMultiple(of: 3) {
				SwiftDate.defaultRegion = regions[iteration % regions.count]
			} else {
				// Readers must always observe a fully-formed region.
				let region = SwiftDate.defaultRegion
				XCTAssertFalse(region.timeZone.identifier.isEmpty)
				_ = DateInRegion(Date(), region: region).toISO()
				_ = Region() // fills every attribute from a single defaultRegion snapshot
				// Paths resolving the default region internally (plain `Date`).
				_ = Date().toFormat("yyyy-MM-dd HH:mm", locale: Locales.english)
				_ = WeekDay.friday.name()
				_ = Month.january.name()
			}
		}
		SwiftDate.defaultRegion = Region.UTC
	}

	/// Same treatment for the `autoFormats` parsing list.
	func testConcurrentAutoFormatsAccess() {
		let builtInFormats = SwiftDate.autoFormats
		DispatchQueue.concurrentPerform(iterations: 1000) { iteration in
			switch iteration % 4 {
			case 0:
				SwiftDate.autoFormats = builtInFormats
			case 1:
				SwiftDate.resetAutoFormats()
			default:
				XCTAssertFalse(SwiftDate.autoFormats.isEmpty)
				_ = "2015-01-05T22:10:55".toDate(region: Region.UTC)
			}
		}
		SwiftDate.resetAutoFormats()
	}

}
