# CupertinoJWT Example

This example app shows how to use CupertinoJWT in iOS and watchOS targets. You need to install CupertinoJWT with CocoaPods or Carthage.

## CocoaPods

To use CupertinoJWT with CocoaPods, use the example app or copy the content of `Podfile` to your project, then follow the steps below:

1. Run `pod install`.

2. Open the generated Workspace file.

3. Build and run the app to make sure everything works. You should see printed log about the generated token.

## Carthage

To use CupertinoJWT with Carthage, use the example app or copy the content of `Cartfile` to your project, then follow the steps below:

1. Run `carthage update`.

2. On your application targets’ **General** settings tab, in the **Linked Frameworks and Libraries** section, drag and drop the framework from the `Carthage/Build` folder on disk.

3. On your iOS target’s **Build Phases** settings tab, click the + icon and choose **New Run Script Phase**. Create a **Run Script** and add the following contents to the script area below the shell:

 `/usr/local/bin/carthage copy-frameworks`

4. Add the path to the framework under **Input Files**:

 `$(SRCROOT)/Carthage/Build/iOS/CupertinoJWT.framework`

5. Add the path to the copied frameworks to the **Output Files**:

 `$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/CupertinoJWT.framework`

6. Follow step 3 to 5 for other platforms’ targets if necessary. Change the path in step 4 to the corresponding platform.

7. Build and run the app to make sure everything works. You should see printed log about the generated token.