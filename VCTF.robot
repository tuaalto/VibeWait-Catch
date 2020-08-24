*** Settings ***
Library         SeleniumLibrary
Library         String
Library         PulsePollKW.py
Variables       VCVF.py
Resource        VCRF.resource
Suite Setup     Initiate Test
Suite Teardown  Close Browser    


###  THE TESTS ARE RUN FROM THIS FILE ###

*** Keywords *** 

Login With Invalid Credentials Should Fail
    [Arguments]    ${username}    ${password}
    Login User    ${username}    ${password}
    Verify Invalid Login                          

*** Test Cases ***
Testejä
    ${tulos}    Average Rate     23    4
    Log To Console    ${tulos}
    ${tulosta}    New Average Rate     29    5    4
    Log To Console    ${tulosta}

Login Valid User
    [Tags]    Logins
    [Documentation]    Tries the login function with valid input values        
    Login User    ${username}   ${password}
    Logout

Login Invalid User
    [Tags]    Logins
    [Documentation]    Tries the login function with a combination of invalid input values.  
    [Template]    Login With Invalid Credentials Should Fail    
    FOR    ${invalidTry}    IN    @{invalidTries}
        ${invalidTry[0]}    ${invalidTry[1]} 
    END
     

Create and Delete Polls
    [Tags]    Polls
    [Documentation]    Creates all three different poll types using a variable list of the types, assigning random names to each. Consequently deletes the created polls and closes browser.
    Login User    ${username}   ${password}
    FOR    ${poll}    IN     @{pollcalls}
        ${randomtext}=       Generate Random String    8 
        Create a Poll    ${randomtext}    ${poll} 
        Delete a Poll    ${randomtext}
    END
    Logout
    

Verify Pulse Poll Functions
    [Tags]    Pulse
    [Documentation]    Verifies various pulse poll funtions: add question, add recipient, feedback, text modification.
    Login User    ${username}   ${password}
    ${randomtext}=       Generate Random String    8 
    Create a Poll    ${randomtext}    Create a pulse poll
    Verify Pulse Poll Add Question Function    ${randomtext}
    Verify Add Recipient Function    ${randomtext}
    Create A Random List Of Feedbacks    ${randomtext}
    Give Feedback According To Random List    ${randomtext}
    Calculate The Average Rating
    Verify Feedbacks Are Saved And The Average Is Correct    ${randomtext}
    Delete A Feedback And Verify Update Of Average Rating
    Verify Modifications to the Texts in the Pulse Poll Form    ${randomtext}
    Delete a Poll    ${randomtext}
    Logout


Verify Pulse Poll API 
    [Tags]    API
    [Documentation]    Verifies API stores the information correctly by calculating the average feedback with API response.
    Login User    ${username}   ${password}
    ${randomtext}=       Generate Random String    8 
    Create a Poll    ${randomtext}    Create a pulse poll
    Verify Pulse Poll Add Question Function    ${randomtext}
    Create A Random List Of Feedbacks    ${randomtext}
    Give Feedback According To Random List    ${randomtext}
    Look for API key    ${randomtext} 
    Create new session
    Calculate The Average Rating With API
    Verify Feedbacks Are Saved And The Average Is Correct    ${randomtext}
    Delete a Poll    ${randomtext}
    Logout
    

Verify QWL Poll Functions
    [Tags]    QWL
    [Documentation]    Verifies various QWL poll funtions: add questions, add recipient, feedback, analysis language change.
    Login User    ${username}   ${password}
    ${randomtext}=       Generate Random String    8 
    Create a Poll    ${randomtext}    Create a QWL poll
    Verify QWL Poll Question and Feedback Functions    ${randomtext}
    Verify Add Recipient Function    ${randomtext}
    Verify QWL Analysis Language Change    ${randomtext}
    Delete a Poll    ${randomtext}
    Logout


Verify 360 Feedback Poll Functions
    [Tags]    360
    [Documentation]    Verifies various 360 Feedback poll funtions: add questions, add recipient, feedback.
    Login User    ${username}   ${password}
    ${randomtext}=       Generate Random String    8 
    Create a Poll    ${randomtext}    Create a 360 feedback poll
    Verify 360 Feedback Poll Question Functions    ${randomtext}
    Verify Add Recipient Function    ${randomtext}
    Verify 360 Feedback Poll Feedback Functions    ${randomtext}
    Delete a Poll    ${randomtext}
    Logout