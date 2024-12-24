# RRMediaView

# **Media Framework Demo App**

This demo app demonstrates how to use the `MediaView` from the custom Media Framework to display various types of media, including images, videos, GIFs, and Lottie animations. It provides a SwiftUI-based interface with sections for each media type.

## **Features**

- **Image Support**
  - Local images.
  - Remote images via URL.
- **Video Support**
  - Local videos.
  - Remote videos via URL.
- **GIF Support**
  - Remote GIFs via URL.
- **Lottie Animation Support**
  - Local Lottie animations.

## **Prerequisites**

- iOS 15.0 or later.
- Swift 5.5 or later.

## **Installation**

1. Clone the repository containing this demo app and the Media Framework.
2. Integrate the Media Framework into your project using your preferred method (SPM, CocoaPods, etc.).

## **Usage**

### **MediaView**

`MediaView` is the core view component used to display different types of media. It requires a `mediaType` parameter to specify the type of media being displayed.

### **Supported Media Types**

#### **1. Images**

- **Local Images**
  ```swift
  MediaView(
      mediaType: .image(.name("pizza", nil))
  )
  ```
- **Remote Images**
  ```swift
  MediaView(
      mediaType: .image(
          .remote(URL(string: "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U")!)
      )
  )
  ```

#### **2. Videos**

- **Remote Videos**
  ```swift
  MediaView(
      mediaType: .video(
          .remote(URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
      )
  )
  .frame(height: 400)
  ```
- **Local Videos**
  ```swift
  MediaView(
      mediaType: .video(.name("ForBiggerBlazes", .main))
  )
  .frame(height: 400)
  ```

#### **3. GIFs**

- **Remote GIFs**
  ```swift
  MediaView(
      mediaType: .gif(
          .remote(URL(string: "https://media1.tenor.com/m/Ps_NnXFTyRYAAAAd/send-link-send.gif")!)
      )
  )
  ```

#### **4. Lottie Animations**

- **Local Lottie Files**
  ```swift
  MediaView(mediaType: .lottie(.name("lottie-sample", nil)))
      .frame(height: 400)
  ```

https://github.com/user-attachments/assets/a4d42453-ca0a-4d90-9496-91d5fe622a9f


## **Notes**

- Ensure all resources (images, videos, Lottie files) are added to your project or accessible via the provided URLs.
- This app is a demonstration and should be adapted as needed for production use.

## **License**

This project is available under the [MIT License](LICENSE).





