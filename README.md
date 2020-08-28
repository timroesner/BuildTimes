# Monitor Xcode Build Times

This repo contains a script that helps you to monitor your Xcode build times across multiple days and perform analysis on them. 
Especially if you work full time at a large codebase you may feel like builds only increase in time. It is easy to perform a clean build and measure performance that way, but most often you'll do incremental builds. In order to measure trends here we need more data, and that's what we're trying to collect here.

## Setup

To get started clone this repo locally and compile the Swift script in terminal as follows:
```bash
$ swiftc BuildTimes.swift
```

**Note:** By default the script will store the generated data within your `Documents` directory. This makes it easily accessible and can be the same across all machines. However if you prefere to store the generated `.json` somewhere else you can go into the `BuildTimes.swift` script and modify the `func fileURL()` helper function.

Finally you need to go into the Xcode behavior settings and select the scripts to run for the corresponding trigger. I choose the `endBuild.sh` script to run for both `Succeeds` and the `Fails` behavior.
<img width="912" alt="Starts Build Behavior" src="https://user-images.githubusercontent.com/13894518/91257933-f0500580-e71f-11ea-866c-37274ea746f0.png">
<img width="912" alt="Succeeds Build Behavior" src="https://user-images.githubusercontent.com/13894518/91257938-f2b25f80-e71f-11ea-8d59-cfc6c7390da7.png">
<img width="912" alt="Screen Shot 2020-08-25 at 10 09 18 PM" src="https://user-images.githubusercontent.com/13894518/91516032-557e3500-e89f-11ea-9044-51d18a88d49c.png">

## Usage
Once you're done with the setup, it is suggested you do a build and check your Documents directory that the output file is created without issues. If you do not see a file show up after building, double check that the path you entered was correct. You can also try to trigger the `Starts` behavior manually by calling: `./BuildTimes -start`,

Once you have collected some data, you can ask the script to print out daily stats:
```bash
$ ./BuildTimes -list
```

This will then output data in the following format:
```
Aug 17, 2020: 	 Total Build Time: 45m 23s 	 Average Build Time: 1m 12s
Aug 18, 2020: 	 Total Build Time: 37m 43s 	 Average Build Time: 59s
Aug 19, 2020: 	 Total Build Time: 28m 32s 	 Average Build Time: 45s
Aug 20, 2020: 	 Total Build Time: 42m 54s 	 Average Build Time: 1m 2s
Aug 21, 2020:	 Total Build Time: 33m 6s	 Average Build Time: 52s
```

## Data Format
The data is provided to you in a `JSON` format. By default it can be found in your `Documents` directory. This allows you to do more processing with the collected data.

The data model looks as follows:
```swift
date: String
lastStart: Date
totalBuildTime: TimeInterval
totalBuilds: Int
```

Here is an example of what the `JSON` format looks like:
```json
[
	{
		"date" : "Aug 24, 2020"
		"lastStart" : 620021178.24967599,
		"totalBuildTime" : 1542.219682931900024,
		"totalBuilds" : 21,
	},
	{
		"date" : "Aug 25, 2020"
		"lastStart" : 620112168.20791101,
		"totalBuildTime" : 104.5191808938980103,
		"totalBuilds" : 2,
	}
]
```
