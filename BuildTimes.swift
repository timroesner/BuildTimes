#!/usr/bin/swift

import Foundation

private let fileName =  "BuildTimes.json"

private let documentationString =
"""
Incorrect argument passed.
The following arguments are available:
	-start	Signals the start of a build.
	-end	Signals the end of a build.
	-list	Lists all stored build times in a readable format.
"""

func main() {
	guard CommandLine.argc >= 2 else {
		print(documentationString)
		return
	}
	
	switch CommandLine.arguments[1] {
	case "-start":
		startBuild()
	case "-end":
		endBuild()
	case "-list":
		listBuildTimes()
	case "-path":
		print(fileURL().path)
	default:
		print(documentationString)
	}
}

func startBuild() {
	let startDate = Date()
	let dateKey = dateString(for: startDate)
	
	var buildData = getBuildData() ?? []
	if let index = buildData.firstIndex(where: { $0.date == dateKey }) {
		buildData[index].lastStart = startDate
	} else {
		buildData.append(BuildData(date: dateKey, totalBuildTime: 0, lastStart: startDate, totalBuilds: 0))
	}
	write(buildData)
}

func endBuild() {
	let endDate = Date()
	let dateKey = dateString(for: endDate)
	
	var buildData = getBuildData() ?? []
	if let index = buildData.firstIndex(where: { $0.date == dateKey }) {
		let buildDuration = buildData[index].lastStart.distance(to: endDate)
		buildData[index].totalBuildTime += buildDuration
		buildData[index].totalBuilds += 1
	}
	write(buildData)
}

func listBuildTimes() {
	guard let buildData = getBuildData() else {
		print("Did not find any build data")
		return
	}
	
	for buildTime in buildData {
		let totalBuildTime = buildTime.totalBuildTime.asReadableTime()
		let averageBuildTime = (buildTime.totalBuildTime / Double(buildTime.totalBuilds)).asReadableTime()
		print("\(buildTime.date): \t Total Build Time: \(totalBuildTime) \t Average Build Time: \(averageBuildTime)")
	}
}

// MARK: - Helper Functions

private func fileURL() -> URL {
	let documentURLs = FileManager().urls(for: .documentDirectory, in: .userDomainMask)
	return documentURLs.first!.appendingPathComponent(fileName)
}

private func getBuildData() -> [BuildData]? {
	let fileManager = FileManager()
	guard let data = fileManager.contents(atPath: fileURL().path) else { return nil }
	return try! JSONDecoder().decode([BuildData].self, from: data)
}

private func write(_ buildData: [BuildData]) {
	let encoder = JSONEncoder()
	encoder.outputFormatting = .prettyPrinted
	let fileData = try! encoder.encode(buildData)
	let fileManager = FileManager()
	fileManager.createFile(atPath: fileURL().path, contents: fileData, attributes: nil)
}

private func dateString(for date: Date) -> String {
	let dateFormatter = DateFormatter()
	dateFormatter.dateStyle = .medium
	dateFormatter.timeStyle = .none
	return dateFormatter.string(from: date)
}

private extension TimeInterval {
	func asReadableTime() -> String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.day, .hour, .minute, .second]
		formatter.unitsStyle = .abbreviated
		return formatter.string(from: self)!
	}
}

private struct BuildData: Codable {
	let date: String
	var totalBuildTime: TimeInterval
	var lastStart: Date
	var totalBuilds: Int
}

main()
