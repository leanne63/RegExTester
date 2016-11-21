## RegExTester

### *Tech Used*
* Xcode 7.3.1  
* Swift 2.2  
* iOS 9.3  

Frameworks:  
- Foundation  
- UIKit  


### *Description*
The user enters a regular expression and a string to test for matches. 

![Startup view](README_images/1_RegExTester.png)
![Successful emoji match](README_images/2_RegExTester.png)



### *Interesting Twists*
- *RegExTester* uses NSRegularExpression, so it is appropriate for testing OS X and iOS expressions vs other regular expression engines.
- *RegExTester* accounts for underlying unicode inconsistencies between Swift String and NSString. Emojis can be included and successfully matched in the expression and match string.


### *Setup Requirements*
Just clone and go!
