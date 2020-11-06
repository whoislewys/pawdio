# Pawdio

The best podcast and audiobook player in town

## Running locally

##### Dev Mode
To debug the local sqlite instance with `Stetho`, run with
`flutter run -t lib/main_dev.dart`

and visit the url: `chrome://inspect/#devices`

##### Release Mode
To run locally without any dev dependencies, run
`flutter run -t lib/main_prod.dart`

#### Debugging
To use the debugger in IntelliJ I had to go to my IDEA folder and run the binary from there (`~/idea-IU-202.7660.26/bin/idea.sh`)

Otherwise, it didn't see my Android emulator. Then I was able to debug as usual

#### Format
