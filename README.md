## Personal Library

<img
src="http://i67.tinypic.com/hrgffr.png" width = "170"> <img
src="http://i63.tinypic.com/1zxo7jm.png" width = "170"> <img
src="http://i67.tinypic.com/2prej9j.png" width = "170"> <img
src="http://i64.tinypic.com/idtc9d.png" width = "170"> <img
src="http://i66.tinypic.com/o01lix.png" width = "170">


Personal Library is an app where you have the ability to manage your library and track the status of each book. As the owner of your library, you have the ability to add, delete, edit, checkout a book, and clear all the books from the library. All changes will be reflected on the server and in the app instantly.

Personal Library was made in Swift 3.0 and Objective-C, runs on iOS 9+, is compatible with iPhone 4+ and uses Auto Layout.

Inside the actual code you will find comments that explain what each method functionality is. I have also included ‘TODO’ comments in the areas where the code can be further improved.

## Tools and 3rd Party Libraries

- SwiftDate
- IQKeyboardManager

## The Library

To use and test Personal Library open the SWAGLibrary.xcworkspace file on Xcode, and run the project.

## Instructions (View By View)

### Library View:
In the library view you will see various books stored in your library and have the ability to perform numerous actions. To add a book, tap on the ‘+’ button and this will segue into the add book screen modally. To view more details and check out a book, tap on the cell and it will segue into the detail view. To delete or edit a book, swipe left on the cell, and to refresh your library simply pull or swipe down.
To delete all the books from your library, tap the menu button on the bottom right hand corner and then tap the ‘Delete Library’ button. To close the menu button, tap on it again.

### Detail View:
In the detail view you will see the details that pertain to each book. To checkout a book, tap the ‘Checkout’ button. To share a book on facebook or twitter, click on the share icon on the top right corner of the screen and select the platform you would like to post on.

### Checkout View:
In the checkout view you will be prompted to type in your name in the name field in order to check out the book. To cancel, tap ‘Cancel’ and to checkout tap ‘Checkout’.

### Add Book View:
The add book view will present a number of fields to add details about the book you are trying to add. The title and author field must be filled or you will not be able to add a book. To add the book, tap ‘Submit’ and to cancel tap ‘Done’.

### Edit Book View:
In the edit view you will see a number of editable fields with information about the book. Type in any additional information in the field you would like to edit. To save your changes, tap ‘Save’ and to cancel tap ‘Cancel’.

## Technical Decisions

- The Personal Library app was architected in MVC.

- The p.list info is set for ‘Allow Arbitrary Loads’ so that the app can access insecure http servers, such as the server used for this project.

- The **APIClient** is an object that is used to interact with the API and make various HTTP requests.

- The **LibraryDataStore** is an object that stores any information that is needed from the server. 

- Both the **APIClient** and **LibraryDataStore** objects are singletons. These objects are marked `final` and have a private initializer to prevent this object from being instantiated in other areas of the app. In addition, these objects hold a `sharedInstance` property to allow other objects to easily retrieve and send data to this instance. 

- The object used to model the book and encapsulate data from the server is called `Book` and is written in Objective-C. In doing so, the `Book` object is always unwrapped and checked for NSNull values. 

- **Error** is a file, and type, that includes a protocol that responds to various errors throughout the app with an appropriate message based on the error type. 

- **Endpoint** is a file, and type, that generates the URL used to make API calls based on a particular endpoint.

- **SocialMedia**, is a file, and type that determines the service for any given platform.

- **Error**, **Endpoint**, and **SocialMedia** were written with the purpose of writing reusable code.

- **SwiftDate** and **IQKeyboard** are used to easily format dates and dismiss the keyboard.

## In Progress

- Scanning capabilities that allow you to import a book by scanning it's barcode
- Search functionality that allows you to easily search for books in your library
- Data persistence using Realm as opposed to the current server

