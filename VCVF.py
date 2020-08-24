USERNAME =      'test@knowit.com'
PASSWORD =      'Knowit123_'   
POLLCALLS =     ['Create a pulse poll', 'Create a QWL poll', 'Create a 360 feedback poll']
PARAMETRIT =    {'apiKey': 0, 'limit': 5}

TRY1 =          [USERNAME, 'INVALID'] 
TRY2 =          ['INVALID', PASSWORD]  
TRY3 =          ['INVALID', 'INVALID']   
TRY4 =          ['', PASSWORD]   
TRY5 =          [USERNAME, '']  
TRY6 =          ['', '']    
INVALIDTRIES =  [TRY1, TRY2, TRY3, TRY4, TRY5, TRY6]

WORST =         ['worst', 1]        
BAD =           ['poor', 2]          
AVERAGE =       ['average', 3]       
GOOD =          ['good', 4]          
BEST =          ['best', 5]         
RATINGS =       [WORST, BAD, AVERAGE, GOOD, BEST]

GERMAN =        ['auf Deutsch', 'Linienverwaltung'] 
SPANISH =       ['en Español' , 'Supervisión directa']        
FINNISH =       ['suomeksi', 'Esimiestoiminta']   
FRENCH =        ['en français', 'Gestion de ligne']
POLISH =        ['po polsku', 'Przełożeni']
SWEDISH =       ['på Svenska', 'Linjeorganisation'] 
LANGUAGES =     [GERMAN, SPANISH, FINNISH, FRENCH, POLISH, SWEDISH]

TEXTSINTHEPOLL =        '//vibe-settings-advanced-button//div[contains(text(), "Texts in the poll form")]'
RETURNTOPOLLOVERVIEW =  '//span[text()="()"]//parent::a[@href="/"]'
NEXTBUTTON =            '//a[@class="nextButton ng-scope"]'
ADDQUESTIONS =          '//a[contains(text(),"Add questions")]'   
ADDPROJECT =            '//a[@class="btn add-project"]'   
SAVEANDCONTINUE =       '//a[@id="saveAndContinue"]' 
