Import-Module ExchangeOnlineManagement

$RT = "MailOutFrom-ChrisAndNancyTo-HpeAndHarrisHealth-20201018-20201118" # ReportTitle
$RA = @("jeffery.c.hill@hpe.com","jin.lee@harrishealth.org") # RecipientAddress
$SA = @("chris.case@sequeldata.com","nancy.ward@sequeldata.com") # SenderAddress
$SD = "9/18/2020" # StartDate
$ED = "11/18/2020" # EndDate
$RTy = "MessageTraceDetail" # ReportType
$NA = "cloudservices@sequeldata.com" # NotifyAddress

Start-HistoricalSearch -ReportTitle $RT –RecipientAddress $RA -SenderAddress $SA -StartDate $SD -EndDate $ED -ReportType $RTy -NotifyAddress $NA