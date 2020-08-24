*** Settings ***

Library           SeleniumLibrary
Library           Collections
Library           String
Library           RequestsLibrary
Library           PulsePollKW.py
Variables         VCVF.py

Documentation    Resourcefile for VCT.robot testsuite


*** Keywords ***

Initiate Test
    # Initiates test. Browser can be changed, to test functionality of different browsers.
    [Arguments]    ${URL}=https://env-5369504.paas.datacenter.fi/    ${BROWSER}=gc
    Set Selenium Timeout    20
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Delete All Cookies
    Click Element    //div[@id="adroll_allow"]


Login User
    [Arguments]    ${username}    ${password}
    Click Element                    xpath://div[@class="buttons"]//a[text()="Login"]
    Wait Until Element Is Visible    //*[@id='username']
    Input Text                       //*[@id='username']    ${username}
    Wait Until Element Is Visible    id:password
    Input Password                   id:password    ${password}
    Wait Until Element Is Visible    //input[@value="Login"]
    Click Element                    //input[@value="Login"]


Logout
    Wait Until Element Is Visible    //a[@href="/auth/logout"]
    Wait Until Element Is Enabled    //a[@href="/auth/logout"]
    Click Element                    //a[@href="/auth/logout"]
    Wait Until Element Is Visible    //a[text()="Login"]


Verify Invalid Login
    Page Should Contain Element      //div[@class="row"]//input[@value="Login"]
    click Link                       //div[@class="dialog-content"]//a[@class="dialog-close"]


Create a Poll  
    [Arguments]    ${randomtext}    ${poll}
    # creates a poll according to the random name and the given poll type.
    Set Selenium Speed    0.1 
    Wait Until Element Is Visible        ${addproject}  
    Click Link                           ${addproject}
    Input Text                           //input[@id="addProjectName"]    ${randomtext}
    Click Element                        //button[text()="${poll} "]
    Wait Until Element Is Visible        //a[@class="relativeLinkToForm"]
    Wait Until Page Contains Element     //span//a[@href="/"]//span      
    Click Element                        //span//a[@href="/"]//span


Delete a Poll
    [Arguments]    ${randomtext}
    # deletes a poll according to the given random name.
    Wait Until Element Is Visible        ${addproject}
    Wait Until Page Contains Element     //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Scroll Element Into View             //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Click Element                        //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Wait Until Page Contains Element     //div[@class="accordionTitle"]//i[@class="fa fa-fw fa-trash"]
    Scroll Element Into View             //div[@class="accordionTitle"]//i[@class="fa fa-fw fa-trash"]
    Wait Until Element Is Visible        //div[@class="accordionTitle"]//i[@class="fa fa-fw fa-trash"]
    Click Element                        //div[@class="accordionTitle"]//i[@class="fa fa-fw fa-trash"]
    Click Element                        //a[@class="btn btn-danger delete-project"]
    Click Element                        //button[text()="Delete now"]
    Wait Until Element Is Visible        ${addproject}
    Page Should Not Contain Element      //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]


Verify Add Recipient Function
    [Arguments]    ${randomtext}
    # Tries to add an invalid email address and verifies it is not accepted. 
    Wait Until Element Is Visible        ${addproject}
    Wait Until Page Contains Element     //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Scroll Element Into View             //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Click Element                        //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Wait Until Page Contains Element     //a[@class="btn add-recipient"]
    Scroll Element Into View             //vibe-settings-advanced-button[@text="Basic settings"]
    Click Element                        //a[@class="btn add-recipient"]
    Input Text                           //div[@class="addEmailModal"]//textarea    ${randomtext}
    Click Element                        //button[text()="Add"]
    Page Should Contain Element          //span[text()="No emails detected"]
    Clear Element Text                   //div[@class="addEmailModal"]//textarea
    # Adds a valid email address, verifies it is saved, and deletes it.
    Input Text                           //div[@class="addEmailModal"]//textarea    testi@testi.com
    Click Element                        //button[text()="Add"]
    Wait Until Element Is Enabled        ${saveandcontinue}
    Click Element                        ${saveandcontinue}
    Page Should Contain Element          //span[contains(text(), "testi@testi.com")]
    Click Element                        //span[contains(text(), "testi@testi.com")]//i[@class="fa fa-minus-circle"]
    # Returns to Polls overview.
    Wait Until Page Contains Element     ${returntopolloverview}
    Scroll Element Into View             ${returntopolloverview}
    Click Element                        ${returntopolloverview}


Verify Pulse Poll Add Question Function 
    [Arguments]    ${randomtext}
    # adds a question and verifies it is included in the poll.
    Wait Until Element Is Visible        ${addproject}
    Wait Until Page Contains Element     //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Scroll Element Into View             //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Click Element                        //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Wait Until Element Is Visible        ${addquestions}
    Wait Until Element Is Enabled        ${addquestions}
    Click Element                        ${addquestions}
    Wait Until Element Is Visible        //textarea[@id="customQuestionText"]
    Input Text                           //textarea[@id="customQuestionText"]    ${randomtext}
    Click Element                        //button[@class="btn btn-smaller"]
    Wait Until Element Is Enabled        ${saveandcontinue}
    Click Element                        ${saveandcontinue}
    Wait Until Page Contains Element     //a[text()=" ${randomtext}"]
    Wait Until Page Contains Element     ${returntopolloverview}
    Scroll Element Into View             ${returntopolloverview}
    Click Element                        ${returntopolloverview}


Create A Random List Of Feedbacks 
    [Arguments]    ${randomtext}   
    # Creates a random list of 2-5 feedbacks.
    @{randomRatings}=    Create List
    ${numberOfFeedbacks}=    Evaluate        random.randint(2, 5)    random
    Set Suite Variable                       ${numberOfFeedbacks}
    FOR    ${i}    IN RANGE    ${numberOfFeedbacks}
        ${randomRating}=     Evaluate        random.choice($ratings)  random
        Append To List                       ${randomRatings}    ${randomRating}
    END
    Set Suite Variable                       @{randomRatings}
    

Give Feedback According To Random List
    [Arguments]    ${randomtext}
    # Gives feedbacks through the list, and collects the numeric value of the feedbacks.
    ${rates}=    Create List
    Set Suite Variable                       ${rates}
    FOR     ${i}    ${rate}    IN ENUMERATE    @{randomRatings}
        Wait Until Element Is Visible        ${addproject}
        Wait Until Page Contains Element     //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
        Scroll Element Into View             //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
        Click Element                        //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
        Switch Window                        NEW
        Wait Until Element Is Visible        ${nextbutton}
        Click Element                        ${nextbutton}
        Wait Until Element Is Visible        //img[@src="/static/img/icon_${rate[0]}.png"]//parent::a
        Click Element                        //img[@src="/static/img/icon_${rate[0]}.png"]//parent::a
        Append To List                       ${rates}    ${rate[1]}
        Input Text                           //textarea    ${i}
        Click Element                        //a[text()="Send your feedback"]
        Wait Until Element Is Visible        //div[text()="Thank you for your feedback!"]
        Switch Window                        MAIN
    END


Calculate The Average Rating
    # Calculates the average rating.
    ${length}=    Get Length    ${rates}
    ${sum}=    Set Variable    0
    FOR    ${number}    IN   @{rates}
        ${sum}=    Evaluate    ${sum} + ${number}
    END
    ${averageRate}    Average Rate    ${sum}    ${length}
    Set Suite Variable                       ${averageRate}
    Set Suite Variable                       ${length}
    Set Suite Variable                       ${sum}


Verify Feedbacks Are Saved And The Average Is Correct
    [Arguments]    ${randomtext}
    # Picks a random feedback and verifies it is saved correctly.
    Wait Until Page Contains Element     //a[text()="${randomtext}"]
    Scroll Element Into View             //a[text()="${randomtext}"]
    Click Element                        //a[text()="${randomtext}"]
    Wait Until Page Contains Element     //div[@class="chartjs-size-monitor"]
    ${indexOfRandomFeedback}=    Evaluate    random.randint(0, ${numberOfFeedbacks} - 1)    random
    ${Feedback}=    Get From List    ${randomRatings}    ${indexOfRandomFeedback}
    # Needs to modify one rating because of difference in textual value (Poor = Bad)
    ${randomFeedback}=    Set Variable If    
    ...                   ${Feedback[1]} == 2    Bad
    ...                   2 > ${Feedback[1]}     ${Feedback[0]}
    ...                   2 < ${Feedback[1]}     ${Feedback[0]} 
    ${randomFeedback}=    Convert To Title Case    ${randomFeedback}
    Wait Until Page Contains Element     //div[text()=" ${randomFeedback} "]
    Wait Until Page Contains Element     
    ...    //div[text()=" ${randomFeedback} "]//parent::td//following-sibling::td[2]//span[text()="${indexOfRandomFeedback}"]
    # Verifies the average rating is correct.
    Wait Until Page Contains Element     //span[text()="(${averageRate[0]})"] | //span[text()="(${averageRate[1]})"]
    Click Element                        //a[contains(text(), " Polls ")]


Delete A Feedback And Verify Update Of Average Rating
    # Deletes one random feedback 
    ${Feedback}=       Evaluate          random.choice($randomRatings)  random
    ${randomFeedback}=    Set Variable If    
    ...                   ${Feedback[1]} == 2    Bad
    ...                   2 > ${Feedback[1]}     ${Feedback[0]}
    ...                   2 < ${Feedback[1]}     ${Feedback[0]}
    ${randomFeedback}=    Convert To Title Case    ${randomFeedback}
    Wait Until Page Contains Element     //a[text()="${randomtext}"]
    Scroll Element Into View             //a[text()="${randomtext}"]
    Click Element                        //a[text()="${randomtext}"]
    Wait Until Page Contains Element     //div[@class="chartjs-size-monitor"]
    Click Element                        //div[text()=" ${randomFeedback} "]//parent::td//following-sibling::td[3]//i[@class="fa fa-close fa-inverse fa-stack-1x"]
    Wait Until Page Contains Element     //a[text()="Remove text and rating"]
    Click Element                        //a[text()="Remove text and rating"]
    # Verifies the average rating is updated correctly.
    ${averageRate}   New Average Rate    ${sum}    ${length}    ${Feedback[1]}
    Wait Until Page Contains Element     //span[text()="(${averageRate[0]})"] | //span[text()="(${averageRate[1]})"]
    Click Element                        //a[contains(text(), " Polls ")]


Verify Modifications to the Texts in the Pulse Poll Form
    [Arguments]    ${randomtext}
    # Modifies the texts in the poll form.
    Wait Until Element Is Visible        ${addproject}
    Wait Until Page Contains Element     //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Scroll Element Into View             //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Click Element                        //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Wait Until Page Contains Element     ${textsinthepoll} 
    Scroll Element Into View             ${textsinthepoll} 
    Click Element                        ${textsinthepoll} 
    Scroll Element Into View             //label[text()="Send button text"]
    Input Text                           //input[@id="projectWebTitle"]    ${randomtext}
    Input Text                           //textarea[@id="projectWebIntro"]    ${randomtext}
    Input Text                           //textarea[@id="projectWebPlaceholder"]    ${randomtext} 
    Scroll Element Into View             //vibe-settings-advanced-button[@text="Connect poll to Yammer"]
    Input Text                           //input[@id="projectWebButton"]    ${randomtext}  
    Input Text                           //textarea[@id="projectWebThanks"]    ${randomtext} 
    Wait Until Element Is Enabled        ${saveandcontinue}
    Click Element                        ${saveandcontinue}
    Wait Until Page Contains Element     ${returntopolloverview}
    Scroll Element Into View             ${returntopolloverview}
    Click Element                        ${returntopolloverview}                   
    # Verifies the changes to the texts in the poll form are saved correctly.
    Wait Until Element Is Visible        ${addproject}
    Wait Until Page Contains Element     //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
    Scroll Element Into View             //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
    Click Element                        //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
    Switch Window                        NEW
    Wait Until Element Is Visible        ${nextbutton}
    Page Should Contain Element          //h1[text()="${randomtext}"]
    Page Should Contain Element          //div[text()="${randomtext}"]
    Click Element                        ${nextbutton}
    Wait Until Element Is Visible        //img[@src="/static/img/icon_good.png"]//parent::a
    Page Should Contain Element          //textarea[@placeholder="${randomtext}"]
    Click Element                        //a[text()="${randomtext}"]
    Wait Until Element Is Visible        //div[text()="${randomtext}"]
    Switch Window                        MAIN


Verify QWL Poll Question and Feedback Functions
    [Arguments]    ${randomtext}
    # Modifies QWL poll to include three questions.
    Wait Until Element Is Visible        ${addproject}
    Wait Until Page Contains Element     //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Scroll Element Into View             //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Click Element                        //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Wait Until Element Is Visible        //button[text()="3 "]
    Click Element                        //button[text()="3 "] 
    Wait Until Element Is Enabled        ${saveandcontinue} 
    Click Element                        ${saveandcontinue}
    Wait Until Page Contains Element     ${returntopolloverview}
    Scroll Element Into View             ${returntopolloverview}
    Click Element                        ${returntopolloverview}  
    # Gives feedback to the three questions.
    Wait Until Element Is Visible        ${addproject}
    Wait Until Page Contains Element     //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
    Scroll Element Into View             //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
    Click Element                        //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
    Switch Window                        NEW
    Wait Until Element Is Visible        ${nextbutton}
    Click Element                        ${nextbutton}
    FOR    ${toisto}    IN RANGE    2
        Wait Until Element Is Visible    //span[text()="4"]
        Click Element                    //span[text()="4"]
        Input Text                       //textarea    ${randomtext}
        Click Element                    //a[@class="pageButton roundPageButton nextPage ng-scope"]
    END
    Wait Until Element Is Visible        //span[text()="4"]
    Click Element                        //span[text()="4"]
    Input Text                           //textarea    ${randomtext}
    Click Element                        //a[@class="pageButton textPageButton nextPage ng-binding ng-scope"]
    Switch Window                        MAIN
    # Verifies the feedback is saved and the average rating is correct.
    Wait Until Page Contains Element     //a[text()="${randomtext}"]
    Scroll Element Into View             //a[text()="${randomtext}"]
    Click Element                        //a[text()="${randomtext}"]
    Wait Until Page Contains Element     //b[text()="QWL analysis"]
    Wait Until Page Contains Element     //div[contains(text(), "100.0%")]
    Click Element                        //a[contains(text(), " Polls ")]


Verify QWL Analysis Language Change
    [Arguments]    ${randomtext}
    # Changes through different language options in the analysis and verifies the language changes correctly. 
    Wait Until Page Contains Element     //a[text()="${randomtext}"]
    Scroll Element Into View             //a[text()="${randomtext}"]
    Click Element                        //a[text()="${randomtext}"]
    Wait Until Page Contains Element     //b[text()="QWL analysis"]
    Wait Until Page Contains Element     //div[@class="filter-bar printHidden"]
    FOR    ${language}    IN    @{languages} 
        Wait Until Page Contains Element     //div[contains(text(), "Viewing")]//select[@class="likeLink ng-untouched ng-pristine ng-valid"][2]
        Wait Until Element Is Enabled        //div[contains(text(), "Viewing")]//select[@class="likeLink ng-untouched ng-pristine ng-valid"][2] 
        Click Element                        //div[contains(text(), "Viewing")]//select[@class="likeLink ng-untouched ng-pristine ng-valid"][2]
        Click Element                        //option[text()="${language[0]}"]
        Wait Until Page Contains Element     //div[contains(text(), "${language[1]}")]
    END
    Click Element                        //a[contains(text(), " Polls ")]


Verify 360 Feedback Poll Question Functions
    [Arguments]    ${randomtext}
    # Adds a question to the poll.
    Wait Until Element Is Visible        ${addproject}
    Wait Until Page Contains Element     //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Scroll Element Into View             //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Click Element                        //a[text()="${randomtext}"]//parent::span//parent::div//following-sibling::div[4]//a[@class="btn action settings-button"]
    Wait Until Page Contains Element     ${addquestions}
    Scroll Element Into View             ${addquestions}
    Click Element                        ${addquestions}
    Input Text                           //textarea[@id="customQuestionText"]    ${randomtext}
    Click Element                        //button[@class="btn btn-smaller"]
    # Removes a question from the poll.
    Scroll Element Into View             //a[text()=" Gets things done"]//..//a[@class="resourceItem remove"]
    Click Element                        //a[text()=" Gets things done"]//..//a[@class="resourceItem remove"]
    Wait Until Page Contains Element     //button[text()="OK"]
    Click Element                        //button[text()="OK"]
    Wait Until Element Is Enabled        ${saveandcontinue}
    Click Element                        ${saveandcontinue}
    Wait Until Page Contains Element     ${returntopolloverview}
    Scroll Element Into View             ${returntopolloverview}
    Click Element                        ${returntopolloverview}


Verify 360 Feedback Poll Feedback Functions
    [Arguments]    ${randomtext}
    # Gives feedback to 24 questions.
    Wait Until Element Is Visible        ${addproject}
    Wait Until Page Contains Element     //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
    Scroll Element Into View             //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
    Click Element                        //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
    Switch Window                        NEW
    Wait Until Element Is Visible        //input[@placeholder="Enter your name here"]
    Input Text                           //input[@placeholder="Enter your name here"]    ${randomtext}
    Wait Until Element Is Visible        ${nextbutton}
    Click Element                        ${nextbutton}
    FOR    ${toisto}    IN RANGE    23
        Wait Until Element Is Visible        //span[text()="4"]
        Click Element                        //span[text()="4"]
        Click Element                        //a[@class="pageButton roundPageButton nextPage ng-scope"]
    END
    Wait Until Element Is Visible        //span[text()="4"]
    Click Element                        //span[text()="4"]
    Click Element                        //a[@class="pageButton textPageButton nextPage ng-binding ng-scope"]
    # Verifies the feedback is stored in the evaluation report correctly.
    Wait Until Element Is Visible        //h3[contains(text(), "evaluation report")]
    Wait Until Page Contains Element     //div[text()="${randomtext}"]
    Scroll Element Into View             //div[text()="${randomtext}"]
    Wait Until Page Contains Element     //div[text()="${randomtext}"]//following-sibling::div/div[1]//div[@class="col-xs-9"]//div//div[@class="mouseOver"]
    Mouse Over                           //div[text()="${randomtext}"]//following-sibling::div/div[1]//div[@class="col-xs-9"]//div//*[@preserveAspectRatio="xMidYMid meet"]//*[@r="4"]
    Wait Until Page Contains Element     //div[text()="${randomtext}"]//following-sibling::div//div[2]//div//div[contains(text(),"You rated 4")]
    Switch Window                        MAIN

Give One feedback
    [Arguments]    ${randomtext}
    Wait Until Element Is Visible        ${addproject}
    Wait Until Page Contains Element     //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
    Scroll Element Into View             //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
    Click Element                        //a[text()="${randomtext}"]//parent::span[@class="projectName"]//parent::div[@class="col-sm-3"]//following-sibling::div[4]//a[@tooltip="View feedback form"]
    Switch Window                        NEW
    Wait Until Element Is Visible        ${nextbutton}
    Click Element                        ${nextbutton}
    Wait Until Element Is Visible        //img[@src="/static/img/icon_average.png"]//parent::a
    Click Element                        //img[@src="/static/img/icon_average.png"]//parent::a
    Input Text                           //textarea    ${randomtext}
    Click Element                        //a[text()="Send your feedback"]
    Wait Until Element Is Visible        //div[text()="Thank you for your feedback!"]
    Switch Window                        MAIN

Look for API key 
    [Arguments]    ${randomtext}
    Wait Until Page Contains Element     //a[text()="${randomtext}"]
    Scroll Element Into View             //a[text()="${randomtext}"]
    Click Element                        //a[text()="${randomtext}"]
    Wait Until Page Contains Element     //a[@class="btn apiToggleButton"]
    Click Element                        //a[@class="btn apiToggleButton"]
    Wait Until Page Contains Element     //div[contains(text(), "Generate a poll-specific API")]//a
    Click Element                        //div[contains(text(), "Generate a poll-specific API")]//a
    Wait Until Page Contains Element     //div[contains(text(), " Your API")]//span
    Wait Until Element Is Visible        //div[contains(text(), " Your API")]//span
    ${api}    Get Text                   //div[contains(text(), " Your API")]//span    
    Set To Dictionary   ${parametrit}    apiKey=${api} 
    Wait Until Page Contains Element     //a[text()=" Polls "]
    Scroll Element Into View             //a[text()=" Polls "]
    Click Element                        //a[text()=" Polls "]

Create new session
    [Documentation]     Luo uuden istunnon
    Create Session     vibecatch     https://env-5369504.paas.datacenter.fi/api/v1     
    Session Exists    vibecatch
    ${tiedot}    Get Request    vibecatch    /feedbacks    params=${parametrit}
    Should Be True    "${tiedot.json()["qwl"]}" == "None"
    @{feedbacks}    Set Variable    ${tiedot.json()["feedback"]}
    Set Suite Variable    @{feedbacks} 
    #Should Be True    "${tiedot.json()["feedback"][0]["rating"]}" == "4"
    Delete All Sessions

Calculate The Average Rating With API
    ${length}=    Get Length    ${feedbacks}
    ${sum}=    Set Variable    0
    FOR    ${feedback}    IN    @{feedbacks}
        ${number}=    Get From Dictionary    ${feedback}    rating
        ${sum}=    Evaluate    ${sum} + ${number}
    END
    ${averageRate}    Average Rate    ${sum}    ${length}
    Set Suite Variable                       ${averageRate}
    Set Suite Variable                       ${length}
    Set Suite Variable                       ${sum}
    Log To Console                           ${averageRate}
        

