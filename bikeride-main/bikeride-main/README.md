# bikeride: Documents And MapKit


## Goals
Learn to use:
- MapKit
- Core Location
- FileManager

You will build a biking or running GPS tracker app that saves and displays tracks
by browsing the application directory. We have posted a demo video of the app titled "assign4.mov" on Canvas. 

## Tasks

The following is a suggested series of steps for you to take, together
with approximate points that each step will be worth. You can ignore
all this and just emulate the demo video. Doing that gets you
full points. However, the following set of steps is a good approach to
building this app methodically.

## Task 1: Showing a Map

Go through the videos for Core Location and MapKit.
Display the static location of the user on a map.

## Task 2: Tracking the Rider

 * Set up location updating to get location updates.
 * Keep the user centered in the middle of the screen in a region with
   an appropriate zoom level. Do this by choosing the *last* point given in
   each location update (there may be many), and creating a
   `MKCoordinateRegion` with that point as the center, and a radius of
   300 meters. 

## Task 3: Drawing the Path Trajectory

 * At each call of your `locationManager(manager:, didUpdateLocations:)`,
   you will be given an array of one or more `CLLocation`s. Draw the trajectory
   of all the points given in this call. 
 * In the demo video, we implemented this using annotations. Feel free to use
   any method you deem appropriate. You will receive credit as long as the
   view indicates the taken path and looks decent.


## Task 4: Saving the File and Viewing Saved Files

Write important information to the file. Define a `GPXTrack` that
contains information about the track, including but not limited to the
set of GPS points received from Core Location.

You will need to have routines to serialize to and from JSON, which is
cast as a `Data`, which is then written/read to/from the file.

## Hints:

- You can use the simple format specified below to store each track.

```
struct GPXPoint: Codable {
    var latitude: Double
    var longitude: Double
    var altitude: Double
    var time: Date
}

struct GPXSegment: Codable {
    var coords : [GPXPoint]
}

struct GPXTrack : Codable {
    var name : String
    var link : String
    var time : String
    var segments : [GPXSegment] = []
    var distance = "-"
    var feetClimbed = "-"
}
```

 * In order to store the location information in a document,you may
   have to access location data from outside the view. It might be
   helpful to read up on the `sink()` function of `@Published`
   values. There is no compulsion to use this function and you can use
   any other equivalent method/function. As long as your app does
   everything shown in the video, it should be fine.
 * Make sure you have added all required entries to the Info.plist
   file. Your app will require entries for accessing location data,
   browsing documents and opening documents in place. If you have not
   provided the required entries to your Info.plist file, your app may
   not function as expected.

## Notes:

**Important**: Please avoid the usage of UIKit or any wrappers for
UIKit views such as UIViewRepresentable.  Using such packages would
result in an automatic 0 in the respective task.

## Grading

 * **Excellent:** All 4 tasks work correctly.
 * **Meets Expectations:** One of the tasks is missing some piece of
     functionality.
 * **Requires Resubmission:** One task is not implemented, or multiple tasks
     are missing some piece of funtionality.
 * **Not Assessible:** Multiple tasks are not implemented.
