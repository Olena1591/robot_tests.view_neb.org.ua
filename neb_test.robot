*** Settings ***
Documentation    Suite description
Library  Selenium2Library
Library  String
Library  DateTime
Library  scripts_for_initial_test.py


*** Variables ***
${host}=  http://neb.org.ua

*** Test Cases ***

Auctions view test

    Prepare environment
    Test tubs auctions
    Test elastic auction_id search
    Test elastic auction_name search
    Test elastic auction_company_name search
    Test view registration and authorization

Documents view test

    Test view participant agreement
    Test view regulation
    Test view tariffs


Privatization view test

    Test tubs privatization
    Test assets search
    Test contracting search
    Test lots search


*** Keywords ***

Prepare environment
    ${chromeOptions}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chromeOptions}    add_argument    --headless
    Create Webdriver  Chrome  chrome_options=${chromeOptions}
    Set Window Size  1024  10000
    Go To  ${host}
    Click Element	xpath=//*[@id="menu-item-1136"]/descendant::a[@href="#"]
    Wait and Click  xpath=//*[@id="menu-item-1261"]/descendant::a[@href="https://neb.org.ua/tenders/index"]
    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//input[@id="attribute-input"]


#------------------------------------Auctions view test---------------------------------------------------------

Test tubs auctions
    Go To  ${host}/tenders/index
    Click Element	xpath=(//a[@class="dropdown-toggle"])[2]
    ${type_index}=  Get Element Count  xpath=//ul[@id="w3"]/descendant::*[contains(@href,"http://neb.org.ua/tenders/")]
    ${type_index}=  Convert To Integer   ${type_index}
    :FOR  ${t_index}  IN RANGE  ${type_index}
    \    Wait and Click  xpath=//ul[@id="w3"]/descendant::*[contains(@href,"http://neb.org.ua/tenders/")][${t_index + 1}]
    \    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=(//div[@class="search-result_t"])[1]
    \    Test auction view
    \    Go To  ${host}/tenders/index
    \    Click Element	xpath=(//a[@class="dropdown-toggle"])[2]


Test auction view
    Go To  ${host}/tenders/index
    ${auction_index}=  Get Element Count  xpath=//a[@class="mk-btn mk-btn_default"]
    ${auction_index}=  Convert To Integer   ${auction_index}
    :FOR  ${a_index}  IN RANGE  ${auction_index}
    \    Scroll To Element  xpath=(//a[@class="mk-btn mk-btn_default"])[${a_index + 1}]
    \    Wait and Click  xpath=(//a[@class="mk-btn mk-btn_default"])[${a_index + 1}]
    \    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//a[@data-test-id="sidebar.questions"]
    \    Wait Until Keyword Succeeds  10 x  1 s  Run Keywords
    \    ...  Wait and Click  xpath=//a[@data-test-id="sidebar.questions"]
    \    ...  AND  Wait Until Keyword Succeeds  5 x  1 s  Element Should Be Visible  xpath=//a[@data-test-id="sidebar.info"]
    \    Go To  ${host}/tenders/index


Test elastic auction_id search
    Go To  ${host}/tenders/index
    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=(//div[@class="search-result_t"])[1]
    ${auction_id}=  Get Text  xpath=(//div[@class="search-result_t"])[1]
    Wait and Click  xpath=//span[@id="more-filter"]
    Wait Until Element Is Visible  xpath=//input[@id="attribute-input"]
    Input Text  xpath=//input[@id="attribute-input"]  ${auction_id}
    Click Element  xpath=//a[@id="search"]
    Wait and Click  xpath=//a[@class="mk-btn mk-btn_default"]
    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//a[@data-test-id="sidebar.questions"]


Test elastic auction_name search
    Go To  ${host}/tenders/index
    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=(//div[@class="search-result_article"])[1]
    ${auction_name}=  Get Text  xpath=(//div[@class="search-result_article"])[1]
    Wait and Click  xpath=//span[@id="more-filter"]
    Wait Until Element Is Visible  xpath=//input[@id="attribute-input"]
    Select From List By Value  xpath=//select[@id="attribute-select"]  title
    Input Text  xpath=//input[@id="attribute-input"]  ${auction_name}
    Click Element  xpath=//a[@id="search"]
    Wait and Click  xpath=//a[@class="mk-btn mk-btn_default"]
    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//a[@data-test-id="sidebar.questions"]


Test elastic auction_company_name search
    Go To  ${host}/tenders/index
    ${auction_company_name}=  Get Text  xpath=(//div[@class="search-result_article"])[1]
    ${auction_company_name}=  adapt_company_name  ${auction_company_name}
    Wait and Click  xpath=//span[@id="more-filter"]


#--------------------------------------Documents view test-------------------------------------------------------------


Test view participant agreement
    Go To  ${host}/tenders/index
    Wait and Click	xpath=(//a[@class="dropdown-toggle"])[1]
    Wait and Click  xpath=//a[@href="https://main.neb.org.ua/?page_id=1158"]
    Go TO  https://main.neb.org.ua/?page_id=1158
    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//*[@class="tg-page-header__title"]
    Wait and Click  xpath=//button[contains(text(),"View Fullscreen")]
    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//div[contains(text(),"ДОГОВІР ПРИЄДНАННЯ")]


Test view regulation
    Go To  ${host}/tenders/index
    Wait and Click  xpath=(//a[@class="dropdown-toggle"])[1]
    Wait and Click  xpath=//a[@href="https://main.neb.org.ua/?page_id=1160"]
    Go TO  https://main.neb.org.ua/?page_id=1160
    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//*[@class="tg-page-header__title"]
    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//div[@class="elementor-text-editor elementor-clearfix"]/descendant::a[contains(@href,"torgi")]
#    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//*[@title="інформаційний портал Фонду гарантування вкладів"]


Test view tariffs
    Go To  ${host}/tenders/index
    Wait and Click  xpath=(//a[@class="dropdown-toggle"])[1]
    Wait and Click  xpath=//a[@href="https://main.neb.org.ua/?page_id=1162"]
    Go TO  https://main.neb.org.ua/?page_id=1162
    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//*[@class="tg-page-header__title"]
    Element Should Be Visible  xpath=//span[@class="elementor-toggle-icon elementor-toggle-icon-left"]
    Wait and Click  xpath=(//span[@class="elementor-toggle-icon elementor-toggle-icon-left"])[1]
    Wait Until Keyword Succeeds  5 x  1 s  Element Should Be Visible  xpath=//*[@class="row-1 odd"]


#Test view privacy policy
#    Go To  ${host}/tenders/index
#    Wait and Click  xpath=(//a[@class="dropdown-toggle"])[1]
#    Wait and Click  xpath=//a[@href="https://main.neb.org.ua/?page_id=1160"]
#    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//*[@class="tg-page-header__title"]


#--------------------------------------Privatization view test---------------------------------------------------


Test tubs privatization
    Go To  ${host}/tenders/index
    Click Element	xpath=(//a[@class="dropdown-toggle"])[3]
    ${tab_index}=  Get Element Count  xpath=//ul[@id="w4"]/descendant::*[contains(@href,"http://neb.org.ua/")]
    ${tab_index}=  Convert To Integer   ${tab_index}
    :FOR  ${t_index}  IN RANGE  ${tab_index}
    \    Wait and Click  xpath=(//ul[@id="w4"]/descendant::*[contains(@href,"http://neb.org.ua/")])[${t_index + 1}]
    \    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//a[@class="mk-btn mk-btn_default"]
    \    Test privatization view
    \    Go To  ${host}/tenders/index
    \    Click Element	xpath=(//a[@class="dropdown-toggle"])[3]

Test privatization view
    Go To  ${host}/tenders/index
    ${mp_index}=  Get Element Count  xpath=//a[@class="mk-btn mk-btn_default"]
    ${mp_index}=  Convert To Integer   ${mp_index}
    :FOR  ${a_index}  IN RANGE  ${mp_index}
    \    Scroll To Element  xpath=(//a[@class="mk-btn mk-btn_default"])[${a_index + 1}]
    \    Wait and Click  xpath=(//a[@class="mk-btn mk-btn_default"])[${a_index + 1}]
    \    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//*[@data-test-id="title"]
    \    Go To  ${host}/tenders/index


Test assets search
    Go To  ${host}/assets/index
    ${asset_id}=  Get Text  xpath=(//*[@class="search-result_t"])[1]
    Wait and Click  xpath=//*[@id="slide-more-filter"]
    Wait Until Keyword Succeeds  5 x  1 s  Element Should Be Visible  xpath=//*[@id="assetssearch-minamount"]
    Input Text  xpath=//*[@id="assetssearch-asset_cbd_id"]  ${asset_id}
    Click Element  xpath=//*[@data-test-id="search"]
#    Wait and Click  xpath=//a[@class="mk-btn mk-btn_default"]
    Wait Until Keyword Succeeds  10 x  3 s  Run Keywords
    ...  Wait Until Keyword Succeeds  5x  1s   Page Should Contain Element  xpath=//a[@class="mk-btn mk-btn_default"]
    ...  AND  Wait and Click  xpath=//a[@class="mk-btn mk-btn_default"]
    ...  AND  Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//*[@data-test-id="title"]
    Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//*[@data-test-id="title"]


Test contracting search
    Go To  ${host}/contracting
    ${contract_id}=  Get Text  xpath=(//*[@class="search-result_article"])[1]
    Input Text  xpath=//*[@id="contractingsearch-contract_cbd_id"]  ${contract_id}
    Click Element  xpath=//*[@data-test-id="search"]
    Wait Until Keyword Succeeds  10 x  3 s  Run Keywords
    ...  Wait Until Keyword Succeeds  5x  1s   Page Should Contain Element  xpath=//a[@class="mk-btn mk-btn_default"]
    ...  AND  Wait and Click  xpath=//a[@class="mk-btn mk-btn_default"]
    ...  AND  Wait Until Keyword Succeeds  10 x  1 s  Element Should Be Visible  xpath=//*[@data-test-id="title"]
    Wait Until Keyword Succeeds  5 x  1 s  Element Should Be Visible  xpath=//*[@data-test-id="title"]


Test lots search
    Go To  ${host}/lots/index
    ${lot_id}=  Get Text  xpath=(//*[@class="search-result_article"])[1]
    Input Text  xpath=//*[@id="lotssearch-lot_cbd_id"]  ${lot_id}
    Click Element  xpath=//*[@data-test-id="search"]
    Wait and Click  xpath=//a[@class="mk-btn mk-btn_default"]
    Wait Until Keyword Succeeds  5 x  1 s  Element Should Be Visible  xpath=//*[@data-test-id="title"]


Test view registration and authorization
    Go To  ${host}/register
    Element Should Be Visible  xpath=//button[@id="btn-submitform"]
    Go To  ${host}/login
    Element Should Be Visible  xpath=//button[@name="login-button"]


Wait and Click
  [Arguments]  ${locator}
  Wait Until Element Is Visible  ${locator}
  Scroll To Element  ${locator}
  Click Element  ${locator}


Scroll To Element
  [Arguments]  ${locator}
  Wait Until Page Contains Element  ${locator}  10
  ${elem_vert_pos}=  Get Vertical Position  ${locator}
  ${elem_gor_pos}=  Get Horizontal Position  ${locator}
  Execute Javascript  window.scrollTo(0,${elem_vert_pos - 300});
